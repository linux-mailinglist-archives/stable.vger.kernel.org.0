Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEC2823569
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391035AbfETMfC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:35:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:52764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391029AbfETMfA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:35:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8DDC20815;
        Mon, 20 May 2019 12:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355699;
        bh=wMysaQ3mcpJRBkYBdixKwbCLRInR2XMkVP2NpRpAiyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2VdC1qhdMiW5yNRetaFeBqz2B0NYWfFfnckQonandyPPfLXItmUhKtDC5nbIQ+zUA
         dNgjQsU7CL0yAnvVj+DbPufPGQA+X9O0mpbaJGivgJ+PooX4lb1kZS4kp+EKd4rsiG
         glYvWvVUnSy4uDsHbry9xuPNYiMDY36z84vkgmeE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jungyeon <jungyeon@gatech.edu>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.1 093/128] btrfs: Correctly free extent buffer in case btree_read_extent_buffer_pages fails
Date:   Mon, 20 May 2019 14:14:40 +0200
Message-Id: <20190520115255.602959893@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115249.449077487@linuxfoundation.org>
References: <20190520115249.449077487@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Borisov <nborisov@suse.com>

commit 537f38f019fa0b762dbb4c0fc95d7fcce9db8e2d upstream.

If a an eb fails to be read for whatever reason - it's corrupted on disk
and parent transid/key validations fail or IO for eb pages fail then
this buffer must be removed from the buffer cache. Currently the code
calls free_extent_buffer if an error occurs. Unfortunately this doesn't
achieve the desired behavior since btrfs_find_create_tree_block returns
with eb->refs == 2.

On the other hand free_extent_buffer will only decrement the refs once
leaving it added to the buffer cache radix tree.  This enables later
code to look up the buffer from the cache and utilize it potentially
leading to a crash.

The correct way to free the buffer is call free_extent_buffer_stale.
This function will correctly call atomic_dec explicitly for the buffer
and subsequently call release_extent_buffer which will decrement the
final reference thus correctly remove the invalid buffer from buffer
cache. This change affects only newly allocated buffers since they have
eb->refs == 2.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=202755
Reported-by: Jungyeon <jungyeon@gatech.edu>
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/disk-io.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1018,13 +1018,18 @@ void readahead_tree_block(struct btrfs_f
 {
 	struct extent_buffer *buf = NULL;
 	struct inode *btree_inode = fs_info->btree_inode;
+	int ret;
 
 	buf = btrfs_find_create_tree_block(fs_info, bytenr);
 	if (IS_ERR(buf))
 		return;
-	read_extent_buffer_pages(&BTRFS_I(btree_inode)->io_tree,
-				 buf, WAIT_NONE, 0);
-	free_extent_buffer(buf);
+
+	ret = read_extent_buffer_pages(&BTRFS_I(btree_inode)->io_tree, buf,
+			WAIT_NONE, 0);
+	if (ret < 0)
+		free_extent_buffer_stale(buf);
+	else
+		free_extent_buffer(buf);
 }
 
 int reada_tree_block_flagged(struct btrfs_fs_info *fs_info, u64 bytenr,
@@ -1044,12 +1049,12 @@ int reada_tree_block_flagged(struct btrf
 	ret = read_extent_buffer_pages(io_tree, buf, WAIT_PAGE_LOCK,
 				       mirror_num);
 	if (ret) {
-		free_extent_buffer(buf);
+		free_extent_buffer_stale(buf);
 		return ret;
 	}
 
 	if (test_bit(EXTENT_BUFFER_CORRUPT, &buf->bflags)) {
-		free_extent_buffer(buf);
+		free_extent_buffer_stale(buf);
 		return -EIO;
 	} else if (extent_buffer_uptodate(buf)) {
 		*eb = buf;
@@ -1103,7 +1108,7 @@ struct extent_buffer *read_tree_block(st
 	ret = btree_read_extent_buffer_pages(fs_info, buf, parent_transid,
 					     level, first_key);
 	if (ret) {
-		free_extent_buffer(buf);
+		free_extent_buffer_stale(buf);
 		return ERR_PTR(ret);
 	}
 	return buf;


