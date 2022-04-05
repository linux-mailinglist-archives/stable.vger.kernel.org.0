Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 146D24F3EC6
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 22:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352114AbiDEMWO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356659AbiDEKYq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:24:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1E0BF000;
        Tue,  5 Apr 2022 03:08:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F91AB81C88;
        Tue,  5 Apr 2022 10:08:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB1CCC385A1;
        Tue,  5 Apr 2022 10:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153321;
        bh=+62UOCrEQHJW3+mqmQw8Gx2IGV/ruOwHv2oXrxxSxqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ai0cHxiJVVQXvDIZGjLr+UnU0Z8TF5JY70YTlk7AqqcQ6J0YjWFFsQ/7kagW3hvlV
         IMymiqKHys97HgYkuktz9j630+SBNGX9wn+najUTvH1qcpH4aoCGen7M5BIId43a5c
         BSSJFB4/gXUN9zQwWyIb38Q0BRuSuVc4/9apuO04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhiguo Niu <zhiguo.niu@unisoc.com>,
        Jing Xia <jing.xia@unisoc.com>, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 181/599] f2fs: fix to avoid potential deadlock
Date:   Tue,  5 Apr 2022 09:27:55 +0200
Message-Id: <20220405070304.227278821@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <chao@kernel.org>

[ Upstream commit 344150999b7fc88502a65bbb147a47503eca2033 ]

Quoted from Jing Xia's report, there is a potential deadlock may happen
between kworker and checkpoint as below:

[T:writeback]				[T:checkpoint]
- wb_writeback
 - blk_start_plug
bio contains NodeA was plugged in writeback threads
					- do_writepages  -- sync write inodeB, inc wb_sync_req[DATA]
					 - f2fs_write_data_pages
					  - f2fs_write_single_data_page -- write last dirty page
					   - f2fs_do_write_data_page
					    - set_page_writeback  -- clear page dirty flag and
					    PAGECACHE_TAG_DIRTY tag in radix tree
					    - f2fs_outplace_write_data
					     - f2fs_update_data_blkaddr
					      - f2fs_wait_on_page_writeback -- wait NodeA to writeback here
					   - inode_dec_dirty_pages
 - writeback_sb_inodes
  - writeback_single_inode
   - do_writepages
    - f2fs_write_data_pages -- skip writepages due to wb_sync_req[DATA]
     - wbc->pages_skipped += get_dirty_pages() -- PAGECACHE_TAG_DIRTY is not set but get_dirty_pages() returns one
  - requeue_inode -- requeue inode to wb->b_dirty queue due to non-zero.pages_skipped
 - blk_finish_plug

Let's try to avoid deadlock condition by forcing unplugging previous bio via
blk_finish_plug(current->plug) once we'v skipped writeback in writepages()
due to valid sbi->wb_sync_req[DATA/NODE].

Fixes: 687de7f1010c ("f2fs: avoid IO split due to mixed WB_SYNC_ALL and WB_SYNC_NONE")
Signed-off-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Signed-off-by: Jing Xia <jing.xia@unisoc.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 6 +++++-
 fs/f2fs/node.c | 6 +++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 1b11a42847c4..d27a92a54447 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -3264,8 +3264,12 @@ static int __f2fs_write_data_pages(struct address_space *mapping,
 	/* to avoid spliting IOs due to mixed WB_SYNC_ALL and WB_SYNC_NONE */
 	if (wbc->sync_mode == WB_SYNC_ALL)
 		atomic_inc(&sbi->wb_sync_req[DATA]);
-	else if (atomic_read(&sbi->wb_sync_req[DATA]))
+	else if (atomic_read(&sbi->wb_sync_req[DATA])) {
+		/* to avoid potential deadlock */
+		if (current->plug)
+			blk_finish_plug(current->plug);
 		goto skip_write;
+	}
 
 	if (__should_serialize_io(inode, wbc)) {
 		mutex_lock(&sbi->writepages);
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 7e625806bd4a..5fa10d0b0068 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -2055,8 +2055,12 @@ static int f2fs_write_node_pages(struct address_space *mapping,
 
 	if (wbc->sync_mode == WB_SYNC_ALL)
 		atomic_inc(&sbi->wb_sync_req[NODE]);
-	else if (atomic_read(&sbi->wb_sync_req[NODE]))
+	else if (atomic_read(&sbi->wb_sync_req[NODE])) {
+		/* to avoid potential deadlock */
+		if (current->plug)
+			blk_finish_plug(current->plug);
 		goto skip_write;
+	}
 
 	trace_f2fs_writepages(mapping->host, wbc, NODE);
 
-- 
2.34.1



