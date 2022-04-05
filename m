Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 600454F274E
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233268AbiDEIFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233967AbiDEH5y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:57:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 387B593990;
        Tue,  5 Apr 2022 00:51:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 260A6B81B14;
        Tue,  5 Apr 2022 07:51:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E7DC340EE;
        Tue,  5 Apr 2022 07:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145093;
        bh=DAqiT5fbEGmGnuHSi20a1pRvj1HdznkOlj3MSEFwgEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=06Pdlx8vE7sj5ri+qw9GAEVReN22YZZBnxc3P1zC7diIPoGR17K2b2YiVWhpRvgjG
         Qr8yTWfytHN6xi/eL/99FnbrMq2RHoUm39oipDCcilEHGluL9ITk0zlib4joYAjyZE
         fRgdCyJORyOhb/9Ui7CWVZrrm1V4ejMw7xq16B6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhiguo Niu <zhiguo.niu@unisoc.com>,
        Jing Xia <jing.xia@unisoc.com>, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0282/1126] f2fs: fix to avoid potential deadlock
Date:   Tue,  5 Apr 2022 09:17:09 +0200
Message-Id: <20220405070415.887878964@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
index 8c417864c66a..e1ef925be60c 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -3163,8 +3163,12 @@ static int __f2fs_write_data_pages(struct address_space *mapping,
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
index 50b2874e758c..4ff7dfb54250 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -2111,8 +2111,12 @@ static int f2fs_write_node_pages(struct address_space *mapping,
 
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



