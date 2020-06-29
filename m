Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A895320D17E
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 20:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbgF2SmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 14:42:01 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:35197 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729052AbgF2Sl7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jun 2020 14:41:59 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 3D84B853;
        Mon, 29 Jun 2020 07:05:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 29 Jun 2020 07:05:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=A+IORO
        273MM5xbKGtjksBScCCROgQC8K/K5H9tUqwow=; b=lebYqebQPCZrcASBkFZAdO
        ckV62Lig4anhv4Icig0HCkB5ygQxYdi7qb8/z+M1NsE0GI1XgBBnbGLVydFXele2
        C9RvVjaEjC5NRhS57Omw8ILRA9SdnzuDWSN+NVF8MjShcLakNpe/KuISYUuJ+P3K
        tEQmGRT3iV6koaFrkb16Pw3ejnaEP97aGmmMR0H6vZeHOFJF9nrrQRC1qG7/RxHj
        7uao6OSWw0hZtlGxjs11Ijc4Yt9+euDgbpHXpbu8HRf5pF4sZMNJUeXagkZNzs/r
        rbOY2kNwSH8GFWNtzZ2ad5n6mYZNIsaTjjjIPk6Yk1BVUqrMrezLn3TzCCkBtQ3g
        ==
X-ME-Sender: <xms:7cr5XiETo29-J51Vvf5KyK3W5Yl4wvw6eLSKtse5iyr_GJqj1L97AA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudelkedgfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:7cr5XjXnAJQZKeoT19gUKX7e3xn5DwNgIAdyI_NCJZZEKhjr8eyZdA>
    <xmx:7cr5XsJnWOZh52UUkix4GZlgw9d1kiWgvMCwZmaGwslRYhNMRodSCw>
    <xmx:7cr5XsHll6gRDFx3W6VW3WaogNkGl-ACKqdzCKGrcJm6qUNzpNvVCA>
    <xmx:7cr5XrDrJGkslqnw1uvG7zr9GhaTch-kJx_eapUjNRxQBu_8-TuosJkpoNM>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4CB453067C72;
        Mon, 29 Jun 2020 07:05:17 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: fix hang on snapshot creation after RWF_NOWAIT write" failed to apply to 4.14-stable tree
To:     fdmanana@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Jun 2020 13:05:08 +0200
Message-ID: <1593428708164195@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f2cb2f39ccc30fa13d3ac078d461031a63960e5b Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Mon, 15 Jun 2020 18:46:01 +0100
Subject: [PATCH] btrfs: fix hang on snapshot creation after RWF_NOWAIT write

If we do a successful RWF_NOWAIT write we end up locking the snapshot lock
of the inode, through a call to check_can_nocow(), but we never unlock it.

This means the next attempt to create a snapshot on the subvolume will
hang forever.

Trivial reproducer:

  $ mkfs.btrfs -f /dev/sdb
  $ mount /dev/sdb /mnt

  $ touch /mnt/foobar
  $ chattr +C /mnt/foobar
  $ xfs_io -d -c "pwrite -S 0xab 0 64K" /mnt/foobar
  $ xfs_io -d -c "pwrite -N -V 1 -S 0xfe 0 64K" /mnt/foobar

  $ btrfs subvolume snapshot -r /mnt /mnt/snap
    --> hangs

Fix this by unlocking the snapshot lock if check_can_nocow() returned
success.

Fixes: edf064e7c6fec3 ("btrfs: nowait aio support")
CC: stable@vger.kernel.org # 4.14+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 2c14312b05e8..04faa04fccd1 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1914,6 +1914,8 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 			inode_unlock(inode);
 			return -EAGAIN;
 		}
+		/* check_can_nocow() locks the snapshot lock on success */
+		btrfs_drew_write_unlock(&root->snapshot_lock);
 	}
 
 	current->backing_dev_info = inode_to_bdi(inode);

