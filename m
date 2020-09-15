Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A598826B40D
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgIOXPu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:15:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:48014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727226AbgIOOj2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:39:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C8352247F;
        Tue, 15 Sep 2020 14:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180148;
        bh=3tVEL9LVItzvKwZldSDlQxl6dlxncELWiN11WrGvPpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nPRmkghBKbH9Wgl4ZdoA3mgh90125zGYD4FcvvhPH1uJOdQ3liRxV68BmVs5gY8WZ
         rCtkOn1CO+Z/4cAC0TuC4nkT2mnn7c1YUgEKJaYAlrMSW+f7l8gXCN1R2jKp2D5ydS
         PkcbHeamqQ7wauI1iUctt/CeLMxGuE75E2VTQ7OM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.8 128/177] btrfs: free data reloc tree on failed mount
Date:   Tue, 15 Sep 2020 16:13:19 +0200
Message-Id: <20200915140659.783409162@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 9e3aa8054453d23d9f477f0cdae70a6a1ea6ec8a upstream.

While testing a weird problem with -o degraded, I noticed I was getting
leaked root errors

  BTRFS warning (device loop0): writable mount is not allowed due to too many missing devices
  BTRFS error (device loop0): open_ctree failed
  BTRFS error (device loop0): leaked root -9-0 refcount 1

This is the DATA_RELOC root, which gets read before the other fs roots,
but is included in the fs roots radix tree.  Handle this by adding a
btrfs_drop_and_free_fs_root() on the data reloc root if it exists.  This
is ok to do here if we fail further up because we will only drop the ref
if we delete the root from the radix tree, and all other cleanup won't
be duplicated.

CC: stable@vger.kernel.org # 5.8+
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/disk-io.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3446,6 +3446,8 @@ fail_block_groups:
 	btrfs_put_block_group_cache(fs_info);
 
 fail_tree_roots:
+	if (fs_info->data_reloc_root)
+		btrfs_drop_and_free_fs_root(fs_info, fs_info->data_reloc_root);
 	free_root_pointers(fs_info, true);
 	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
 


