Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78A313443B3
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbhCVMxg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:53:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:45650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231859AbhCVMvO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:51:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3FDA619F8;
        Mon, 22 Mar 2021 12:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417149;
        bh=miuYuv8x/RclV8csCE/IHKBZe6fNoHNyAMWT38U3CsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oPZZmjiwjDlCzvccrzEnzco3Box47BcPtyfmgEzkbz9H5hgpPlLxGfHeBJSecvxqg
         6TKOIeGiBKylQHuXnEcz5rjBvpif7kZCRI59Az3qnbRG+oM7vFmdeSp+9yujLTgB+Z
         t4EBNECI2jde+1zya27k1D8VcFw0erMwjxh4LIUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 12/43] btrfs: fix slab cache flags for free space tree bitmap
Date:   Mon, 22 Mar 2021 13:28:26 +0100
Message-Id: <20210322121920.326860594@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121919.936671417@linuxfoundation.org>
References: <20210322121919.936671417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Sterba <dsterba@suse.com>

commit 34e49994d0dcdb2d31d4d2908d04f4e9ce57e4d7 upstream.

The free space tree bitmap slab cache is created with SLAB_RED_ZONE but
that's a debugging flag and not always enabled. Also the other slabs are
created with at least SLAB_MEM_SPREAD that we want as well to average
the memory placement cost.

Reported-by: Vlastimil Babka <vbabka@suse.cz>
Fixes: 3acd48507dc4 ("btrfs: fix allocation of free space cache v1 bitmap pages")
CC: stable@vger.kernel.org # 5.4+
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9472,7 +9472,7 @@ int __init btrfs_init_cachep(void)
 
 	btrfs_free_space_bitmap_cachep = kmem_cache_create("btrfs_free_space_bitmap",
 							PAGE_SIZE, PAGE_SIZE,
-							SLAB_RED_ZONE, NULL);
+							SLAB_MEM_SPREAD, NULL);
 	if (!btrfs_free_space_bitmap_cachep)
 		goto fail;
 


