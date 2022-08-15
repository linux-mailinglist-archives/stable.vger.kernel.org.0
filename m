Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27C8D594DCA
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242816AbiHPA73 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347465AbiHPA5R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:57:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A851DB046;
        Mon, 15 Aug 2022 13:48:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5F1AB811A1;
        Mon, 15 Aug 2022 20:48:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58142C43148;
        Mon, 15 Aug 2022 20:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596534;
        bh=eGIk33ETJU0N/9AykTe9YPBR4KmXAPQ+uEq+UtVzrQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TsuWStw0IXSbI8bSdVrwpdXEux/0mDrNNZTiqjMWpk1Ruas3Rrn/3t0NTnKL1yMav
         STPEh0CQFs+9dicV4DJhL4ZosRP/0LTT+H1ocFGEyScEwuVIT9HYCfeTwQUNY+OwIr
         3IW46Y2VxL23kNHisiLL/vbqcRM4CbbogQ2I0jK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 1083/1157] btrfs: properly flag filesystem with BTRFS_FEATURE_INCOMPAT_BIG_METADATA
Date:   Mon, 15 Aug 2022 20:07:19 +0200
Message-Id: <20220815180523.492938427@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Nikolay Borisov <nborisov@suse.com>

[ Upstream commit e26b04c4c91925dba57324db177a24e18e2d0013 ]

Commit 6f93e834fa7c seemingly inadvertently moved the code responsible
for flagging the filesystem as having BIG_METADATA to a place where
setting the flag was essentially lost. This means that
filesystems created with kernels containing this bug (starting with 5.15)
can potentially be mounted by older (pre-3.4) kernels. In reality
chances for this happening are low because there are other incompat
flags introduced in the mean time. Still the correct behavior is to set
INCOMPAT_BIG_METADATA flag and persist this in the superblock.

Fixes: 6f93e834fa7c ("btrfs: fix upper limit for max_inline for page size 64K")
CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8daa5bb93a4c..e33f2fa50b0f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3593,16 +3593,6 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	 */
 	fs_info->compress_type = BTRFS_COMPRESS_ZLIB;
 
-	/*
-	 * Flag our filesystem as having big metadata blocks if they are bigger
-	 * than the page size.
-	 */
-	if (btrfs_super_nodesize(disk_super) > PAGE_SIZE) {
-		if (!(features & BTRFS_FEATURE_INCOMPAT_BIG_METADATA))
-			btrfs_info(fs_info,
-				"flagging fs with big metadata feature");
-		features |= BTRFS_FEATURE_INCOMPAT_BIG_METADATA;
-	}
 
 	/* Set up fs_info before parsing mount options */
 	nodesize = btrfs_super_nodesize(disk_super);
@@ -3643,6 +3633,17 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	if (features & BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA)
 		btrfs_info(fs_info, "has skinny extents");
 
+	/*
+	 * Flag our filesystem as having big metadata blocks if they are bigger
+	 * than the page size.
+	 */
+	if (btrfs_super_nodesize(disk_super) > PAGE_SIZE) {
+		if (!(features & BTRFS_FEATURE_INCOMPAT_BIG_METADATA))
+			btrfs_info(fs_info,
+				"flagging fs with big metadata feature");
+		features |= BTRFS_FEATURE_INCOMPAT_BIG_METADATA;
+	}
+
 	/*
 	 * mixed block groups end up with duplicate but slightly offset
 	 * extent buffers for the same range.  It leads to corruptions
-- 
2.35.1



