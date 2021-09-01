Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 165E83FD8CF
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 13:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243821AbhIALeY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 07:34:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:44522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243809AbhIALeY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 07:34:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2806160F6C;
        Wed,  1 Sep 2021 11:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630496007;
        bh=chFYPxx2Ypy44Md2ZNFMUmm1qWrvOLIgRVRPVoJK0Ac=;
        h=Subject:To:Cc:From:Date:From;
        b=OkBcd9/hm0rK8te7/63zAR0O7wAs7EefFdJbTOAt1ik3fUjtcMuWoFnhk5/wxuCVA
         dO/wI++gWtsDqjZXI/oK2gJhlFY34zRrMrM7+wWip7w7dhZjz8YxrTahixSsEPF/Ll
         JFrYta39lKzqDIrG3rAWyTFTw81KigIW/qbHOq6c=
Subject: FAILED: patch "[PATCH] ext4: report correct st_size for encrypted symlinks" failed to apply to 5.10-stable tree
To:     ebiggers@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 01 Sep 2021 13:33:25 +0200
Message-ID: <1630496005138242@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8c4bca10ceafc43b1ca0a9fab5fa27e13cbce99e Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Thu, 1 Jul 2021 23:53:47 -0700
Subject: [PATCH] ext4: report correct st_size for encrypted symlinks

The stat() family of syscalls report the wrong size for encrypted
symlinks, which has caused breakage in several userspace programs.

Fix this by calling fscrypt_symlink_getattr() after ext4_getattr() for
encrypted symlinks.  This function computes the correct size by reading
and decrypting the symlink target (if it's not already cached).

For more details, see the commit which added fscrypt_symlink_getattr().

Fixes: f348c252320b ("ext4 crypto: add symlink encryption")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210702065350.209646-3-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>

diff --git a/fs/ext4/symlink.c b/fs/ext4/symlink.c
index dd05af983092..69109746e6e2 100644
--- a/fs/ext4/symlink.c
+++ b/fs/ext4/symlink.c
@@ -52,10 +52,20 @@ static const char *ext4_encrypted_get_link(struct dentry *dentry,
 	return paddr;
 }
 
+static int ext4_encrypted_symlink_getattr(struct user_namespace *mnt_userns,
+					  const struct path *path,
+					  struct kstat *stat, u32 request_mask,
+					  unsigned int query_flags)
+{
+	ext4_getattr(mnt_userns, path, stat, request_mask, query_flags);
+
+	return fscrypt_symlink_getattr(path, stat);
+}
+
 const struct inode_operations ext4_encrypted_symlink_inode_operations = {
 	.get_link	= ext4_encrypted_get_link,
 	.setattr	= ext4_setattr,
-	.getattr	= ext4_getattr,
+	.getattr	= ext4_encrypted_symlink_getattr,
 	.listxattr	= ext4_listxattr,
 };
 

