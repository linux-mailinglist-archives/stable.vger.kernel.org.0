Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0EA59E67C
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 18:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240533AbiHWQC0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 12:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244172AbiHWQA2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 12:00:28 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1514E23DF18;
        Tue, 23 Aug 2022 05:12:10 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id v7-20020a1cac07000000b003a6062a4f81so9455588wme.1;
        Tue, 23 Aug 2022 05:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=gbSayT4EtNiq0syTNIIlLCojXVFXd1TeIsCo+4i/G4I=;
        b=KDQOLrNkbPuciKMdeVWT8rUrIHPAgOFK9HS4HWlj8QYGLRxrp20dpuGMf2WpI9MgN6
         sE/1CV3u4jztacPwUpFfPtl7sGeWFgXx4mijyDiNtzRTLCcu11p5N6d/CCyT2EOw7Af/
         nLvm1Mtbp5VcvwzRRwKOfd/wQ8ekO1yaoV80lynOWsyi8cJe3iMhTebO5NNszFNjrnRL
         G8ERDoyx9+bZAkIPgTI9akXtfmfOYlVrKO/LWBhFEvzaTMp7+Zui6JpelEJzWS/hRrWb
         oe+Fxwl9l8eF1eFsemuDPYMXI1v+VeDIVrVrqVva5jpVopjK2l2XJHABhLiPSG6wSE+F
         73Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=gbSayT4EtNiq0syTNIIlLCojXVFXd1TeIsCo+4i/G4I=;
        b=6+FZPC6dus0kvEI5JpvocfH+0mor7Ib6lmh2HvoK09v+cNJqIPhGIsvye02bVjEHBX
         rteulBa84aLMxfsxGzBJ0ShOLzWoeJwY20aUNf6aKVEGb//+FR6i9vmHWzqUZMxlqC5p
         vAFWt26CnauIlAd/tYDF9dwVynCwHUV4jcfgfnMNIxf2vDMhY+g810dNsxRatE37PzUr
         1vc+w+b9plBVC1lQ8ggzboJr3B15aSRQ+z0mjdf17Gep6jhIKMY+zTblqyMUQ79N2Lay
         BYGveWsXxCth5tibDKkWTorvGSB54Muz0kO/NFntaLpfjgx9Z/aGhjB+IM5pRcOgjJsE
         FDeA==
X-Gm-Message-State: ACgBeo2iAKhIucy7GqUfF5e17CMRp6sm+hQGbITMXmsg5oMo3bgQJ8XR
        YYtZCg+6yxlBnmERq5Pfv0OuqUIKo60=
X-Google-Smtp-Source: AA6agR5d749vcbr7e/ElfSrikvgM2bDRN0p4ls5Xr8814lxtFP4Q4Y9KuYIgNNfSWSJQdOTOphAAsw==
X-Received: by 2002:a1c:44d7:0:b0:3a6:725:c0a7 with SMTP id r206-20020a1c44d7000000b003a60725c0a7mr2051873wma.137.1661256707083;
        Tue, 23 Aug 2022 05:11:47 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id g11-20020a05600c4ecb00b003a4c6e67f01sm24681879wmq.6.2022.08.23.05.11.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 05:11:46 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 v2 3/6] fs: remove __sync_filesystem
Date:   Tue, 23 Aug 2022 15:11:33 +0300
Message-Id: <20220823121136.1806820-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220823121136.1806820-1-amir73il@gmail.com>
References: <20220823121136.1806820-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 9a208ba5c9afa62c7b1e9c6f5e783066e84e2d3c upstream.

[backported for dependency]

There is no clear benefit in having this helper vs just open coding it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Link: https://lore.kernel.org/r/20211019062530.2174626-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
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
2.25.1

