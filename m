Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F21DC9DD1
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 13:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729580AbfJCLwT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 07:52:19 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:34529 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729578AbfJCLwS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 07:52:18 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id C17D52026A;
        Thu,  3 Oct 2019 07:52:17 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 03 Oct 2019 07:52:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=FCRAc7
        DqSZuB9HyhcHDkoccfIg8v1uspVKw9OU1TlK4=; b=Ssy0kIY//rjiiWQpL4Xjc2
        uJeJ5lpUriK5Iv9+c6GjLdQWZni6q+fQ2eTk2wcGiGeXtsXWR4D7jZsKXO4q+osa
        JMD5eT+g5NJKxY/u2T3V1Mr4UrVbcTEYRfJim5U3QnYqqx5T6fXvSb39eOpTk5UZ
        x/pYU+xU5hmqjxGLervNe5JP/40DCKXnfavWiOKsMF1BoVVVL/U0S5rImtrb+FZb
        6vR0nt1eitzTlp+aveLXBHcBkK0tfIoJFqKkdECSyKn5naRlspgHFFHhLOD9tJfU
        0kViI8YtPRPy9FUCWOKUNGlH/Xy4ZyxKyEzRdjUPDx5xf6cqmIoSP3abop9cnLrg
        ==
X-ME-Sender: <xms:8eCVXdhqaaNqNIw-l2j1zKS-wAWS-cteDH8FeUgXJMufue6dDPGBQg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeekgdegiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:8eCVXRtQe6KcQGyyrwoZfZWlYjHKSck-rNvWrpo2gxCPcZE_H8FLbA>
    <xmx:8eCVXYvj1Z2Ouu_8czJn9S83kKPE6_cM13wOmbndXoFL-QtuFGQKeA>
    <xmx:8eCVXeEH86MZd6RKvtV8xr6Y7oBilfBfebC99rFTPRzJVmoXq_vY6g>
    <xmx:8eCVXabWfz_NhGAcKiWB5ojGK57oVUm3SUvVPjTzorfFY-4WfODtbA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3B4468005B;
        Thu,  3 Oct 2019 07:52:17 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: qgroup: Fix reserved data space leak if we have" failed to apply to 4.9-stable tree
To:     wqu@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 03 Oct 2019 13:52:07 +0200
Message-ID: <1570103527255251@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d4e204948fe3e0dc8e1fbf3f8f3290c9c2823be3 Mon Sep 17 00:00:00 2001
From: Qu Wenruo <wqu@suse.com>
Date: Mon, 16 Sep 2019 20:02:39 +0800
Subject: [PATCH] btrfs: qgroup: Fix reserved data space leak if we have
 multiple reserve calls

[BUG]
The following script can cause btrfs qgroup data space leak:

  mkfs.btrfs -f $dev
  mount $dev -o nospace_cache $mnt

  btrfs subv create $mnt/subv
  btrfs quota en $mnt
  btrfs quota rescan -w $mnt
  btrfs qgroup limit 128m $mnt/subv

  for (( i = 0; i < 3; i++)); do
          # Create 3 64M holes for latter fallocate to fail
          truncate -s 192m $mnt/subv/file
          xfs_io -c "pwrite 64m 4k" $mnt/subv/file > /dev/null
          xfs_io -c "pwrite 128m 4k" $mnt/subv/file > /dev/null
          sync

          # it's supposed to fail, and each failure will leak at least 64M
          # data space
          xfs_io -f -c "falloc 0 192m" $mnt/subv/file &> /dev/null
          rm $mnt/subv/file
          sync
  done

  # Shouldn't fail after we removed the file
  xfs_io -f -c "falloc 0 64m" $mnt/subv/file

[CAUSE]
Btrfs qgroup data reserve code allow multiple reservations to happen on
a single extent_changeset:
E.g:
	btrfs_qgroup_reserve_data(inode, &data_reserved, 0, SZ_1M);
	btrfs_qgroup_reserve_data(inode, &data_reserved, SZ_1M, SZ_2M);
	btrfs_qgroup_reserve_data(inode, &data_reserved, 0, SZ_4M);

Btrfs qgroup code has its internal tracking to make sure we don't
double-reserve in above example.

The only pattern utilizing this feature is in the main while loop of
btrfs_fallocate() function.

However btrfs_qgroup_reserve_data()'s error handling has a bug in that
on error it clears all ranges in the io_tree with EXTENT_QGROUP_RESERVED
flag but doesn't free previously reserved bytes.

This bug has a two fold effect:
- Clearing EXTENT_QGROUP_RESERVED ranges
  This is the correct behavior, but it prevents
  btrfs_qgroup_check_reserved_leak() to catch the leakage as the
  detector is purely EXTENT_QGROUP_RESERVED flag based.

- Leak the previously reserved data bytes.

The bug manifests when N calls to btrfs_qgroup_reserve_data are made and
the last one fails, leaking space reserved in the previous ones.

[FIX]
Also free previously reserved data bytes when btrfs_qgroup_reserve_data
fails.

Fixes: 524725537023 ("btrfs: qgroup: Introduce btrfs_qgroup_reserve_data function")
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 4ab85555a947..c4bb69941c77 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3442,6 +3442,9 @@ int btrfs_qgroup_reserve_data(struct inode *inode,
 	while ((unode = ulist_next(&reserved->range_changed, &uiter)))
 		clear_extent_bit(&BTRFS_I(inode)->io_tree, unode->val,
 				 unode->aux, EXTENT_QGROUP_RESERVED, 0, 0, NULL);
+	/* Also free data bytes of already reserved one */
+	btrfs_qgroup_free_refroot(root->fs_info, root->root_key.objectid,
+				  orig_reserved, BTRFS_QGROUP_RSV_DATA);
 	extent_changeset_release(reserved);
 	return ret;
 }

