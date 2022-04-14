Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0937501154
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245145AbiDNNry (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343904AbiDNNj3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:39:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530D370079;
        Thu, 14 Apr 2022 06:35:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15CD4B8296A;
        Thu, 14 Apr 2022 13:35:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E928C385A5;
        Thu, 14 Apr 2022 13:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943317;
        bh=PaaOdIznsXfUpK/AM7p7giJmI1mKr0xa1VOsdXg0rmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m53bdjGQ7gqNWx32dRRsghv2J2TwUsFE+Idkl3BaeUfYsed4U9uYMjNbMIyuWKw8q
         zF42j9EDsyH6HhFKmctvD+zJkYbUsSWKUW5l3rGzKYvJ24UA7Ln8/rrv3OovoyKSFQ
         MmO5WslrFMIW2T0udqXB6aTTT38TkhoJRyVUXaIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 112/475] f2fs: fix to avoid potential deadlock
Date:   Thu, 14 Apr 2022 15:08:17 +0200
Message-Id: <20220414110858.287814558@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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

[ Upstream commit df77fbd8c5b222c680444801ffd20e8bbc90a56e ]

Using f2fs_trylock_op() in f2fs_write_compressed_pages() to avoid potential
deadlock like we did in f2fs_write_single_data_page().

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 6 +++++-
 fs/f2fs/node.c | 6 +++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 1679f9c0b63b..773028921c48 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2467,8 +2467,12 @@ static int __f2fs_write_data_pages(struct address_space *mapping,
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
index 0cd1d51dde06..3dc7cc3d6ac6 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1995,8 +1995,12 @@ static int f2fs_write_node_pages(struct address_space *mapping,
 
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



