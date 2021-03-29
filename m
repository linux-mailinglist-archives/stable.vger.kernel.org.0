Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED69334C6EE
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbhC2ILE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:11:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:54150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232605AbhC2IKO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:10:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB59A61601;
        Mon, 29 Mar 2021 08:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005414;
        bh=fY47xEmJQyx92oKopzN4a/8ixjqicGOjl0v9iKPX+eE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1D6nuBzMq8jZfgVAYAoqWUKvgVk2cHIIkiUZ/uzWOhLkoAjytcsDX3/U4Wu8BbJ6d
         XCD8b0XTvRoVCo3y2eWwvmDTYsZUJx1t7IWIMtmLoaUP8ZW/RGn84P088W2Nm1jPId
         qzOpN1q7joUqXZIpRoZ3HJOuOzM3DdZ5Nplzm/lM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.19 71/72] ext4: add reclaim checks to xattr code
Date:   Mon, 29 Mar 2021 09:58:47 +0200
Message-Id: <20210329075612.629606876@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075610.300795746@linuxfoundation.org>
References: <20210329075610.300795746@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 163f0ec1df33cf468509ff38cbcbb5eb0d7fac60 upstream.

Syzbot is reporting that ext4 can enter fs reclaim from kvmalloc() while
the transaction is started like:

  fs_reclaim_acquire+0x117/0x150 mm/page_alloc.c:4340
  might_alloc include/linux/sched/mm.h:193 [inline]
  slab_pre_alloc_hook mm/slab.h:493 [inline]
  slab_alloc_node mm/slub.c:2817 [inline]
  __kmalloc_node+0x5f/0x430 mm/slub.c:4015
  kmalloc_node include/linux/slab.h:575 [inline]
  kvmalloc_node+0x61/0xf0 mm/util.c:587
  kvmalloc include/linux/mm.h:781 [inline]
  ext4_xattr_inode_cache_find fs/ext4/xattr.c:1465 [inline]
  ext4_xattr_inode_lookup_create fs/ext4/xattr.c:1508 [inline]
  ext4_xattr_set_entry+0x1ce6/0x3780 fs/ext4/xattr.c:1649
  ext4_xattr_ibody_set+0x78/0x2b0 fs/ext4/xattr.c:2224
  ext4_xattr_set_handle+0x8f4/0x13e0 fs/ext4/xattr.c:2380
  ext4_xattr_set+0x13a/0x340 fs/ext4/xattr.c:2493

This should be impossible since transaction start sets PF_MEMALLOC_NOFS.
Add some assertions to the code to catch if something isn't working as
expected early.

Link: https://lore.kernel.org/linux-ext4/000000000000563a0205bafb7970@google.com/
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20210222171626.21884-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/xattr.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1480,6 +1480,9 @@ ext4_xattr_inode_cache_find(struct inode
 	if (!ce)
 		return NULL;
 
+	WARN_ON_ONCE(ext4_handle_valid(journal_current_handle()) &&
+		     !(current->flags & PF_MEMALLOC_NOFS));
+
 	ea_data = ext4_kvmalloc(value_len, GFP_NOFS);
 	if (!ea_data) {
 		mb_cache_entry_put(ea_inode_cache, ce);
@@ -2346,6 +2349,7 @@ ext4_xattr_set_handle(handle_t *handle,
 			error = -ENOSPC;
 			goto cleanup;
 		}
+		WARN_ON_ONCE(!(current->flags & PF_MEMALLOC_NOFS));
 	}
 
 	error = ext4_reserve_inode_write(handle, inode, &is.iloc);


