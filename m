Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9545E172037
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731448AbgB0Okq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:40:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:52376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731573AbgB0Nwp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:52:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF17620578;
        Thu, 27 Feb 2020 13:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811564;
        bh=5286eevWITp8+y0vqIAGvvwa9C0bYt6V5V9tA5tp6fQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MD1ij3PXhDE1vkNBdXhgPfLWEKsamsugFNA0rwvSlFh0tEIlkvy6NiC76jg8Jea+p
         4tHdoF9CXz8pb+PLVNAGBLPDyH5FZ0S9+6osbNOiEmBREn2M4a//gd/uAkaHSbqqdf
         x1Pn8nsp7bo1bbd6pzjuP+hsdhhIZQfiSp6Fl4l8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herbert Poetzl <herbert@13thfloor.at>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 4.14 016/237] ext4: fix support for inode sizes > 1024 bytes
Date:   Thu, 27 Feb 2020 14:33:50 +0100
Message-Id: <20200227132257.253001986@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

commit 4f97a68192bd33b9963b400759cef0ca5963af00 upstream.

A recent commit, 9803387c55f7 ("ext4: validate the
debug_want_extra_isize mount option at parse time"), moved mount-time
checks around.  One of those changes moved the inode size check before
the blocksize variable was set to the blocksize of the file system.
After 9803387c55f7 was set to the minimum allowable blocksize, which
in practice on most systems would be 1024 bytes.  This cuased file
systems with inode sizes larger than 1024 bytes to be rejected with a
message:

EXT4-fs (sdXX): unsupported inode size: 4096

Fixes: 9803387c55f7 ("ext4: validate the debug_want_extra_isize mount option at parse time")
Link: https://lore.kernel.org/r/20200206225252.GA3673@mit.edu
Reported-by: Herbert Poetzl <herbert@13thfloor.at>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/super.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3668,6 +3668,15 @@ static int ext4_fill_super(struct super_
 	 */
 	sbi->s_li_wait_mult = EXT4_DEF_LI_WAIT_MULT;
 
+	blocksize = BLOCK_SIZE << le32_to_cpu(es->s_log_block_size);
+	if (blocksize < EXT4_MIN_BLOCK_SIZE ||
+	    blocksize > EXT4_MAX_BLOCK_SIZE) {
+		ext4_msg(sb, KERN_ERR,
+		       "Unsupported filesystem blocksize %d (%d log_block_size)",
+			 blocksize, le32_to_cpu(es->s_log_block_size));
+		goto failed_mount;
+	}
+
 	if (le32_to_cpu(es->s_rev_level) == EXT4_GOOD_OLD_REV) {
 		sbi->s_inode_size = EXT4_GOOD_OLD_INODE_SIZE;
 		sbi->s_first_ino = EXT4_GOOD_OLD_FIRST_INO;
@@ -3685,6 +3694,7 @@ static int ext4_fill_super(struct super_
 			ext4_msg(sb, KERN_ERR,
 			       "unsupported inode size: %d",
 			       sbi->s_inode_size);
+			ext4_msg(sb, KERN_ERR, "blocksize: %d", blocksize);
 			goto failed_mount;
 		}
 		/*
@@ -3848,14 +3858,6 @@ static int ext4_fill_super(struct super_
 	if (!ext4_feature_set_ok(sb, (sb_rdonly(sb))))
 		goto failed_mount;
 
-	blocksize = BLOCK_SIZE << le32_to_cpu(es->s_log_block_size);
-	if (blocksize < EXT4_MIN_BLOCK_SIZE ||
-	    blocksize > EXT4_MAX_BLOCK_SIZE) {
-		ext4_msg(sb, KERN_ERR,
-		       "Unsupported filesystem blocksize %d (%d log_block_size)",
-			 blocksize, le32_to_cpu(es->s_log_block_size));
-		goto failed_mount;
-	}
 	if (le32_to_cpu(es->s_log_block_size) >
 	    (EXT4_MAX_BLOCK_LOG_SIZE - EXT4_MIN_BLOCK_LOG_SIZE)) {
 		ext4_msg(sb, KERN_ERR,


