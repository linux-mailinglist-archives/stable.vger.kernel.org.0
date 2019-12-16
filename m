Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A568121827
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728897AbfLPSlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:41:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:36518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729148AbfLPSB1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:01:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BC1621582;
        Mon, 16 Dec 2019 18:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519286;
        bh=As9WKSQ3y0nobEFshxT41+FxQfGhMWaUk8FiRIcy2cE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cFObJF1VoXcE8pzDvirWeMqzJFv8pcojmy3AywA15qrm7OwlpXbGCBtGRhvFCQgPo
         3Mlf79lNhK7yBrel3dA/W4VJ8VBWF0ccguunG4SwwPj6XfIqXEHeAkMb4Ba/x+iNw4
         Jg8Yu8i5qFUpKkBfmNkjxuNm4Dbp49haxNA2JpfU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.14 235/267] ext4: Fix credit estimate for final inode freeing
Date:   Mon, 16 Dec 2019 18:49:21 +0100
Message-Id: <20191216174915.429633953@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 65db869c754e7c271691dd5feabf884347e694f5 upstream.

Estimate for the number of credits needed for final freeing of inode in
ext4_evict_inode() was to small. We may modify 4 blocks (inode & sb for
orphan deletion, bitmap & group descriptor for inode freeing) and not
just 3.

[ Fixed minor whitespace nit. -- TYT ]

Fixes: e50e5129f384 ("ext4: xattr-in-inode support")
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20191105164437.32602-6-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/inode.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -195,7 +195,12 @@ void ext4_evict_inode(struct inode *inod
 {
 	handle_t *handle;
 	int err;
-	int extra_credits = 3;
+	/*
+	 * Credits for final inode cleanup and freeing:
+	 * sb + inode (ext4_orphan_del()), block bitmap, group descriptor
+	 * (xattr block freeing), bitmap, group descriptor (inode freeing)
+	 */
+	int extra_credits = 6;
 	struct ext4_xattr_inode_array *ea_inode_array = NULL;
 
 	trace_ext4_evict_inode(inode);
@@ -251,8 +256,12 @@ void ext4_evict_inode(struct inode *inod
 	if (!IS_NOQUOTA(inode))
 		extra_credits += EXT4_MAXQUOTAS_DEL_BLOCKS(inode->i_sb);
 
+	/*
+	 * Block bitmap, group descriptor, and inode are accounted in both
+	 * ext4_blocks_for_truncate() and extra_credits. So subtract 3.
+	 */
 	handle = ext4_journal_start(inode, EXT4_HT_TRUNCATE,
-				 ext4_blocks_for_truncate(inode)+extra_credits);
+			 ext4_blocks_for_truncate(inode) + extra_credits - 3);
 	if (IS_ERR(handle)) {
 		ext4_std_error(inode->i_sb, PTR_ERR(handle));
 		/*


