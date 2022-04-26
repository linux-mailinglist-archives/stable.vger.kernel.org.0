Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B908E50F5F4
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344443AbiDZIrG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346886AbiDZIp2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:45:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4928C3CA6C;
        Tue, 26 Apr 2022 01:36:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1C02B81D09;
        Tue, 26 Apr 2022 08:36:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A861C385A0;
        Tue, 26 Apr 2022 08:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962168;
        bh=rxNYrynthAVSNFVZDDnxe1rUHGlVchAhwqVCmHm98Vs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=il94r3FZ40fImGZOiGAgJVGdeNxU0wtLVKAi5eBOGL1EDc13qsRHodplpS+SV9DWV
         N8q927g6YGlcL6i/TONBSQOoxQl76JIE2yOJ4o+Weo8MtAjIYc3Qhtz/Jq0MTcslmc
         VH463oK/15DV1eP036XvYhkr2RR9cklzEOBE8lhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 001/124] fs: remove __sync_filesystem
Date:   Tue, 26 Apr 2022 10:20:02 +0200
Message-Id: <20220426081747.332004348@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
References: <20220426081747.286685339@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 9a208ba5c9afa62c7b1e9c6f5e783066e84e2d3c ]

There is no clear benefit in having this helper vs just open coding it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Link: https://lore.kernel.org/r/20211019062530.2174626-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/sync.c | 38 +++++++++++++++++---------------------
 1 file changed, 17 insertions(+), 21 deletions(-)

diff --git a/fs/sync.c b/fs/sync.c
index 1373a610dc78..0d6cdc507cb9 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -21,25 +21,6 @@
 #define VALID_FLAGS (SYNC_FILE_RANGE_WAIT_BEFORE|SYNC_FILE_RANGE_WRITE| \
 			SYNC_FILE_RANGE_WAIT_AFTER)
 
-/*
- * Do the filesystem syncing work. For simple filesystems
- * writeback_inodes_sb(sb) just dirties buffers with inodes so we have to
- * submit IO for these buffers via __sync_blockdev(). This also speeds up the
- * wait == 1 case since in that case write_inode() functions do
- * sync_dirty_buffer() and thus effectively write one block at a time.
- */
-static int __sync_filesystem(struct super_block *sb, int wait)
-{
-	if (wait)
-		sync_inodes_sb(sb);
-	else
-		writeback_inodes_sb(sb, WB_REASON_SYNC);
-
-	if (sb->s_op->sync_fs)
-		sb->s_op->sync_fs(sb, wait);
-	return __sync_blockdev(sb->s_bdev, wait);
-}
-
 /*
  * Write out and wait upon all dirty data associated with this
  * superblock.  Filesystem data as well as the underlying block
@@ -61,10 +42,25 @@ int sync_filesystem(struct super_block *sb)
 	if (sb_rdonly(sb))
 		return 0;
 
-	ret = __sync_filesystem(sb, 0);
+	/*
+	 * Do the filesystem syncing work.  For simple filesystems
+	 * writeback_inodes_sb(sb) just dirties buffers with inodes so we have
+	 * to submit I/O for these buffers via __sync_blockdev().  This also
+	 * speeds up the wait == 1 case since in that case write_inode()
+	 * methods call sync_dirty_buffer() and thus effectively write one block
+	 * at a time.
+	 */
+	writeback_inodes_sb(sb, WB_REASON_SYNC);
+	if (sb->s_op->sync_fs)
+		sb->s_op->sync_fs(sb, 0);
+	ret = __sync_blockdev(sb->s_bdev, 0);
 	if (ret < 0)
 		return ret;
-	return __sync_filesystem(sb, 1);
+
+	sync_inodes_sb(sb);
+	if (sb->s_op->sync_fs)
+		sb->s_op->sync_fs(sb, 1);
+	return __sync_blockdev(sb->s_bdev, 1);
 }
 EXPORT_SYMBOL(sync_filesystem);
 
-- 
2.35.1



