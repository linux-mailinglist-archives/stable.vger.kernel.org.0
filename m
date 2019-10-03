Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8793CA44F
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389754AbfJCQXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:23:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388446AbfJCQXb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:23:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94CC02054F;
        Thu,  3 Oct 2019 16:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119810;
        bh=PBM67lVr9fxgDjwBm7PGqNRydI67/kFeiYDJNSAFoMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LyYc2ysNJv9ma754cfTFw8nnoZqcdX7Fy6noImiYRDwL6UvwWyzFbCWL+ZaTiP+tl
         6ugWeHJQelXOG0K8XIBgvt5fhzWf8CEAV7ZD+b65yAk0kgq4Vg5V8VWBoqOY3g+oih
         wdwea3doXc2xBI2jjTAMLXC/ui/aHTNdotBEfbEA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 194/211] btrfs: qgroup: Fix reserved data space leak if we have multiple reserve calls
Date:   Thu,  3 Oct 2019 17:54:20 +0200
Message-Id: <20191003154528.977887508@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit d4e204948fe3e0dc8e1fbf3f8f3290c9c2823be3 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/qgroup.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3067,6 +3067,9 @@ cleanup:
 	while ((unode = ulist_next(&reserved->range_changed, &uiter)))
 		clear_extent_bit(&BTRFS_I(inode)->io_tree, unode->val,
 				 unode->aux, EXTENT_QGROUP_RESERVED, 0, 0, NULL);
+	/* Also free data bytes of already reserved one */
+	btrfs_qgroup_free_refroot(root->fs_info, root->root_key.objectid,
+				  orig_reserved, BTRFS_QGROUP_RSV_DATA);
 	extent_changeset_release(reserved);
 	return ret;
 }


