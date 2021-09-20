Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B51EA4123A6
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352423AbhITS03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:26:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:44480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378351AbhITSY0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:24:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1306E632CB;
        Mon, 20 Sep 2021 17:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158708;
        bh=mLj/+yzWOxkFMwfGyT0BP/0G+Nmcz7Ta+Cu40WIDkzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cP7aLxDNyBggG5I2DKdaOMXJqqDkAKrAdkevsjTHMaw5tgQP2Zsd3CGF8OSiUWHci
         jW8Yf+X9gEOElOuE4GA2h9t+LyAMJk62rehiTeneyiBDWv2LOeMEHijOrCnLDi12CQ
         tK779YmeQSTfH1o1wJW+Fl1qzkrPbsgrKjLqFvuw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Tsvetkov <alexander.tsvetkov@oracle.com>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 002/122] btrfs: fix upper limit for max_inline for page size 64K
Date:   Mon, 20 Sep 2021 18:42:54 +0200
Message-Id: <20210920163915.840707523@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anand Jain <anand.jain@oracle.com>

commit 6f93e834fa7c5faa0372e46828b4b2a966ac61d7 upstream.

The mount option max_inline ranges from 0 to the sectorsize (which is
now equal to page size). But we parse the mount options too early and
before the actual sectorsize is read from the superblock. So the upper
limit of max_inline is unaware of the actual sectorsize and is limited
by the temporary sectorsize 4096, even on a system where the default
sectorsize is 64K.

Fix this by reading the superblock sectorsize before the mount option
parse.

Reported-by: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>
CC: stable@vger.kernel.org # 5.4+
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/disk-io.c |   45 +++++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3019,6 +3019,29 @@ int __cold open_ctree(struct super_block
 	 */
 	fs_info->compress_type = BTRFS_COMPRESS_ZLIB;
 
+	/*
+	 * Flag our filesystem as having big metadata blocks if they are bigger
+	 * than the page size
+	 */
+	if (btrfs_super_nodesize(disk_super) > PAGE_SIZE) {
+		if (!(features & BTRFS_FEATURE_INCOMPAT_BIG_METADATA))
+			btrfs_info(fs_info,
+				"flagging fs with big metadata feature");
+		features |= BTRFS_FEATURE_INCOMPAT_BIG_METADATA;
+	}
+
+	/* Set up fs_info before parsing mount options */
+	nodesize = btrfs_super_nodesize(disk_super);
+	sectorsize = btrfs_super_sectorsize(disk_super);
+	stripesize = sectorsize;
+	fs_info->dirty_metadata_batch = nodesize * (1 + ilog2(nr_cpu_ids));
+	fs_info->delalloc_batch = sectorsize * 512 * (1 + ilog2(nr_cpu_ids));
+
+	/* Cache block sizes */
+	fs_info->nodesize = nodesize;
+	fs_info->sectorsize = sectorsize;
+	fs_info->stripesize = stripesize;
+
 	ret = btrfs_parse_options(fs_info, options, sb->s_flags);
 	if (ret) {
 		err = ret;
@@ -3046,28 +3069,6 @@ int __cold open_ctree(struct super_block
 		btrfs_info(fs_info, "has skinny extents");
 
 	/*
-	 * flag our filesystem as having big metadata blocks if
-	 * they are bigger than the page size
-	 */
-	if (btrfs_super_nodesize(disk_super) > PAGE_SIZE) {
-		if (!(features & BTRFS_FEATURE_INCOMPAT_BIG_METADATA))
-			btrfs_info(fs_info,
-				"flagging fs with big metadata feature");
-		features |= BTRFS_FEATURE_INCOMPAT_BIG_METADATA;
-	}
-
-	nodesize = btrfs_super_nodesize(disk_super);
-	sectorsize = btrfs_super_sectorsize(disk_super);
-	stripesize = sectorsize;
-	fs_info->dirty_metadata_batch = nodesize * (1 + ilog2(nr_cpu_ids));
-	fs_info->delalloc_batch = sectorsize * 512 * (1 + ilog2(nr_cpu_ids));
-
-	/* Cache block sizes */
-	fs_info->nodesize = nodesize;
-	fs_info->sectorsize = sectorsize;
-	fs_info->stripesize = stripesize;
-
-	/*
 	 * mixed block groups end up with duplicate but slightly offset
 	 * extent buffers for the same range.  It leads to corruptions
 	 */


