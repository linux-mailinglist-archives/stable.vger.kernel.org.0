Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8380E4A4377
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359714AbiAaLVe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:21:34 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49728 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359110AbiAaLQR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:16:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55A3E61219;
        Mon, 31 Jan 2022 11:16:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13902C340E8;
        Mon, 31 Jan 2022 11:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627776;
        bh=xh0gFh28Rx1Q6l/6NQeYJU83lOuzsBNddIkCO0QOZ0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lib6zk6oTOWkyQxID/XZ2Y9ZkHeznnb6uBTgGCWh7kNFq7QS8VamPviNOrYI06Y/K
         jeddOPc5echVA4LCFgrKTxlMd+RWBWfinvYWiWp5UThAAl0g3ddAhVWqJ25SzV5BX3
         lFvyAv0TloCvFXOsZDUTVe5kTocmDHM8GYH5W1Ig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anthony Ruhier <aruhier@mailbox.org>,
        Filipe Manana <fdmanana@suse.com>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.16 004/200] btrfs: defrag: fix wrong number of defragged sectors
Date:   Mon, 31 Jan 2022 11:54:27 +0100
Message-Id: <20220131105233.705806759@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 484167da77739a8d0e225008c48e697fd3f781ae upstream.

[BUG]
There are users using autodefrag mount option reporting obvious increase
in IO:

> If I compare the write average (in total, I don't have it per process)
> when taking idle periods on the same machine:
>     Linux 5.16:
>         without autodefrag: ~ 10KiB/s
>         with autodefrag: between 1 and 2MiB/s.
>
>     Linux 5.15:
>         with autodefrag:~ 10KiB/s (around the same as without
> autodefrag on 5.16)

[CAUSE]
When autodefrag mount option is enabled, btrfs_defrag_file() will be
called with @max_sectors = BTRFS_DEFRAG_BATCH (1024) to limit how many
sectors we can defrag in one try.

And then use the number of sectors defragged to determine if we need to
re-defrag.

But commit b18c3ab2343d ("btrfs: defrag: introduce helper to defrag one
cluster") uses wrong unit to increase @sectors_defragged, which should
be in unit of sector, not byte.

This means, if we have defragged any sector, then @sectors_defragged
will be >= sectorsize (normally 4096), which is larger than
BTRFS_DEFRAG_BATCH.

This makes the @max_sectors check in defrag_one_cluster() to underflow,
rendering the whole @max_sectors check useless.

Thus causing way more IO for autodefrag mount options, as now there is
no limit on how many sectors can really be defragged.

[FIX]
Fix the problems by:

- Use sector as unit when increasing @sectors_defragged

- Include @sectors_defragged > @max_sectors case to break the loop

- Add extra comment on the return value of btrfs_defrag_file()

Reported-by: Anthony Ruhier <aruhier@mailbox.org>
Fixes: b18c3ab2343d ("btrfs: defrag: introduce helper to defrag one cluster")
Link: https://lore.kernel.org/linux-btrfs/0a269612-e43f-da22-c5bc-b34b1b56ebe8@mailbox.org/
CC: stable@vger.kernel.org # 5.16
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1416,8 +1416,8 @@ static int defrag_one_cluster(struct btr
 	list_for_each_entry(entry, &target_list, list) {
 		u32 range_len = entry->len;
 
-		/* Reached the limit */
-		if (max_sectors && max_sectors == *sectors_defragged)
+		/* Reached or beyond the limit */
+		if (max_sectors && *sectors_defragged >= max_sectors)
 			break;
 
 		if (max_sectors)
@@ -1439,7 +1439,8 @@ static int defrag_one_cluster(struct btr
 				       extent_thresh, newer_than, do_compress);
 		if (ret < 0)
 			break;
-		*sectors_defragged += range_len;
+		*sectors_defragged += range_len >>
+				      inode->root->fs_info->sectorsize_bits;
 	}
 out:
 	list_for_each_entry_safe(entry, tmp, &target_list, list) {
@@ -1458,6 +1459,9 @@ out:
  * @newer_than:	   minimum transid to defrag
  * @max_to_defrag: max number of sectors to be defragged, if 0, the whole inode
  *		   will be defragged.
+ *
+ * Return <0 for error.
+ * Return >=0 for the number of sectors defragged.
  */
 int btrfs_defrag_file(struct inode *inode, struct file_ra_state *ra,
 		      struct btrfs_ioctl_defrag_range_args *range,


