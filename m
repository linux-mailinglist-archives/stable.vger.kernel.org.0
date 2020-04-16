Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 157E61ACAB6
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395350AbgDPPiI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:38:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:51428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897789AbgDPNjB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:39:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CA9822203;
        Thu, 16 Apr 2020 13:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044340;
        bh=ZrHzyFlGKUss73Jc+wNUE+fZkpYQLAwarN1zR6GzVN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N97JfX5VpLh9VroROYJjg5P+GfJAMbIf66KBijuCn+69PuB099ZLaN1X/0CQWuU8J
         ECpvcfJ160uQhMTlE4MrkJ5lfCVxJ4BPztyy10Do/Jk7wYhmhpol0FveLS+r/ISyjs
         oe9p2XY0V1vOQcn00gJJ7WuX3XQ6Jox7mhmO3ibQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.5 161/257] btrfs: set update the uuid generation as soon as possible
Date:   Thu, 16 Apr 2020 15:23:32 +0200
Message-Id: <20200416131346.690964572@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 75ec1db8717a8f0a9d9c8d033e542fdaa7b73898 upstream.

In my EIO stress testing I noticed I was getting forced to rescan the
uuid tree pretty often, which was weird.  This is because my error
injection stuff would sometimes inject an error after log replay but
before we loaded the UUID tree.  If log replay committed the transaction
it wouldn't have updated the uuid tree generation, but the tree was
valid and didn't change, so there's no reason to not update the
generation here.

Fix this by setting the BTRFS_FS_UPDATE_UUID_TREE_GEN bit immediately
after reading all the fs roots if the uuid tree generation matches the
fs generation.  Then any transaction commits that happen during mount
won't screw up our uuid tree state, forcing us to do needless uuid
rescans.

Fixes: 70f801754728 ("Btrfs: check UUID tree during mount if required")
CC: stable@vger.kernel.org # 4.19+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/disk-io.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3054,6 +3054,18 @@ int __cold open_ctree(struct super_block
 	if (ret)
 		goto fail_tree_roots;
 
+	/*
+	 * If we have a uuid root and we're not being told to rescan we need to
+	 * check the generation here so we can set the
+	 * BTRFS_FS_UPDATE_UUID_TREE_GEN bit.  Otherwise we could commit the
+	 * transaction during a balance or the log replay without updating the
+	 * uuid generation, and then if we crash we would rescan the uuid tree,
+	 * even though it was perfectly fine.
+	 */
+	if (fs_info->uuid_root && !btrfs_test_opt(fs_info, RESCAN_UUID_TREE) &&
+	    fs_info->generation == btrfs_super_uuid_tree_generation(disk_super))
+		set_bit(BTRFS_FS_UPDATE_UUID_TREE_GEN, &fs_info->flags);
+
 	ret = btrfs_verify_dev_extents(fs_info);
 	if (ret) {
 		btrfs_err(fs_info,
@@ -3284,8 +3296,6 @@ int __cold open_ctree(struct super_block
 			close_ctree(fs_info);
 			return ret;
 		}
-	} else {
-		set_bit(BTRFS_FS_UPDATE_UUID_TREE_GEN, &fs_info->flags);
 	}
 	set_bit(BTRFS_FS_OPEN, &fs_info->flags);
 


