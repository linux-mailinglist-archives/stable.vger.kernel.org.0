Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0305C6576C6
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 14:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiL1NJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 08:09:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbiL1NJj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 08:09:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1E210B72
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 05:09:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF64AB816A7
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 13:09:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8DEC433EF;
        Wed, 28 Dec 2022 13:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672232964;
        bh=7DbwFnqJX9g225aT6K9ggMAhq4QFa9iQLWu5mPZB+3g=;
        h=Subject:To:Cc:From:Date:From;
        b=yKs+cOxCO/o2CKrLqU09iovc+TcpiT6EIFWcdtVYVEtK6y+Q11C/xX/gktyOGMk6V
         jodXa8veNSfZ2n+e2QRd6qqvYgi8eF9SiTUZJTeT5cQonbTNiJBjymwnXK/z0uE5hT
         JiHRjl6IaOoXyeE5hAmkIZS+eBpAsAr9dOICv/F8=
Subject: FAILED: patch "[PATCH] btrfs: do not BUG_ON() on ENOMEM when dropping extent items" failed to apply to 5.10-stable tree
To:     fdmanana@suse.com, dsterba@suse.com, josef@toxicpanda.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 28 Dec 2022 14:09:20 +0100
Message-ID: <1672232960103130@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

162d053e15fe ("btrfs: do not BUG_ON() on ENOMEM when dropping extent items for a range")
2766ff61762c ("btrfs: update the number of bytes used by an inode atomically")
5893dfb98f25 ("btrfs: refactor btrfs_drop_extents() to make it easier to extend")
ac5887c8e013 ("btrfs: locking: remove all the blocking helpers")
a14b78ad06ab ("btrfs: introduce btrfs_inode_lock()/unlock()")
b8d8e1fd570a ("btrfs: introduce btrfs_write_check()")
c86537a42f86 ("btrfs: check FS error state bit early during write")
5e8b9ef30392 ("btrfs: move pos increment and pagecache extension to btrfs_buffered_write")
4e4cabece9f9 ("btrfs: split btrfs_direct_IO to read and write")
196d59ab9ccc ("btrfs: switch extent buffer tree lock to rw_semaphore")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 162d053e15fe985f754ef495a96eb3db970c43ed Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Mon, 28 Nov 2022 15:07:30 +0000
Subject: [PATCH] btrfs: do not BUG_ON() on ENOMEM when dropping extent items
 for a range

If we get -ENOMEM while dropping file extent items in a given range, at
btrfs_drop_extents(), due to failure to allocate memory when attempting to
increment the reference count for an extent or drop the reference count,
we handle it with a BUG_ON(). This is excessive, instead we can simply
abort the transaction and return the error to the caller. In fact most
callers of btrfs_drop_extents(), directly or indirectly, already abort
the transaction if btrfs_drop_extents() returns any error.

Also, we already have error paths at btrfs_drop_extents() that may return
-ENOMEM and in those cases we abort the transaction, like for example
anything that changes the b+tree may return -ENOMEM due to a failure to
allocate a new extent buffer when COWing an existing extent buffer, such
as a call to btrfs_duplicate_item() for example.

So replace the BUG_ON() calls with proper logic to abort the transaction
and return the error.

Reported-by: syzbot+0b1fb6b0108c27419f9f@syzkaller.appspotmail.com
Link: https://lore.kernel.org/linux-btrfs/00000000000089773e05ee4b9cb4@google.com/
CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 448b143a5cb2..91b00eb2440e 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -380,7 +380,10 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans,
 						args->start - extent_offset,
 						0, false);
 				ret = btrfs_inc_extent_ref(trans, &ref);
-				BUG_ON(ret); /* -ENOMEM */
+				if (ret) {
+					btrfs_abort_transaction(trans, ret);
+					break;
+				}
 			}
 			key.offset = args->start;
 		}
@@ -467,7 +470,10 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans,
 						key.offset - extent_offset, 0,
 						false);
 				ret = btrfs_free_extent(trans, &ref);
-				BUG_ON(ret); /* -ENOMEM */
+				if (ret) {
+					btrfs_abort_transaction(trans, ret);
+					break;
+				}
 				args->bytes_found += extent_end - key.offset;
 			}
 

