Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 744242FA9E8
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 20:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437017AbhARTQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 14:16:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:34098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390484AbhARLip (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:38:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 618CF229C7;
        Mon, 18 Jan 2021 11:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969877;
        bh=QdrHdxDcnNbHa7UKDtXtAf1YQE8pYdy59+VlUTsDhVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pL1VxafcfnWDy92v7R2+ZiXnA4GdA2FA/LiHhWQ0kaCu6062AL3YG1ej8nep7z2TQ
         bovs9DWdxxJx+wf90GCUuXXFiEy7vm0C0pp/6xtZDtjDeOaIeZ9jJkM9bH4N0i2xkc
         tJbDnfjdS9u4Y7TLktesPJC3lv0gMziMpx3JlMq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anand Jain <anand.jain@oracle.com>,
        Su Yue <l@damenly.su>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 02/76] btrfs: prevent NULL pointer dereference in extent_io_tree_panic
Date:   Mon, 18 Jan 2021 12:34:02 +0100
Message-Id: <20210118113341.109604676@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113340.984217512@linuxfoundation.org>
References: <20210118113340.984217512@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Su Yue <l@damenly.su>

commit 29b665cc51e8b602bf2a275734349494776e3dbc upstream.

Some extent io trees are initialized with NULL private member (e.g.
btrfs_device::alloc_state and btrfs_fs_info::excluded_extents).
Dereference of a NULL tree->private as inode pointer will cause panic.

Pass tree->fs_info as it's known to be valid in all cases.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=208929
Fixes: 05912a3c04eb ("btrfs: drop extent_io_ops::tree_fs_info callback")
CC: stable@vger.kernel.org # 4.19+
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Su Yue <l@damenly.su>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/extent_io.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -647,9 +647,7 @@ alloc_extent_state_atomic(struct extent_
 
 static void extent_io_tree_panic(struct extent_io_tree *tree, int err)
 {
-	struct inode *inode = tree->private_data;
-
-	btrfs_panic(btrfs_sb(inode->i_sb), err,
+	btrfs_panic(tree->fs_info, err,
 	"locking error: extent tree was modified by another thread while locked");
 }
 


