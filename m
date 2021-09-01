Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 881A93FDCCE
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345026AbhIAMxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:53:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344358AbhIAMvb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:51:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50F2A6124B;
        Wed,  1 Sep 2021 12:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630500173;
        bh=/pLkaAzxLPeQgFtazJGfitNiL9WHUUeiGkAVCAoL3cE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=loGxqTdov0nV15FZmMbYBJ+BHEby66IiQxoKiA79uPHAOzdo+Bo7iV98T4VgKOvn9
         OG1HMVcKNBVNejjvTF3z3RRgiUni4/LX4TX73xc3ZcESC/GuRgdPKG6jR8341IOsDs
         Cc28HUR0gudjiVnsTjR9EowdCYUPmvw5ktkRPXb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>
Subject: [PATCH 5.14 08/11] f2fs: report correct st_size for encrypted symlinks
Date:   Wed,  1 Sep 2021 14:29:16 +0200
Message-Id: <20210901122249.791582679@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122249.520249736@linuxfoundation.org>
References: <20210901122249.520249736@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 461b43a8f92e68e96c4424b31e15f2b35f1bbfa9 upstream.

The stat() family of syscalls report the wrong size for encrypted
symlinks, which has caused breakage in several userspace programs.

Fix this by calling fscrypt_symlink_getattr() after f2fs_getattr() for
encrypted symlinks.  This function computes the correct size by reading
and decrypting the symlink target (if it's not already cached).

For more details, see the commit which added fscrypt_symlink_getattr().

Fixes: cbaf042a3cc6 ("f2fs crypto: add symlink encryption")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210702065350.209646-4-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/namei.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -1323,9 +1323,19 @@ static const char *f2fs_encrypted_get_li
 	return target;
 }
 
+static int f2fs_encrypted_symlink_getattr(struct user_namespace *mnt_userns,
+					  const struct path *path,
+					  struct kstat *stat, u32 request_mask,
+					  unsigned int query_flags)
+{
+	f2fs_getattr(mnt_userns, path, stat, request_mask, query_flags);
+
+	return fscrypt_symlink_getattr(path, stat);
+}
+
 const struct inode_operations f2fs_encrypted_symlink_inode_operations = {
 	.get_link	= f2fs_encrypted_get_link,
-	.getattr	= f2fs_getattr,
+	.getattr	= f2fs_encrypted_symlink_getattr,
 	.setattr	= f2fs_setattr,
 	.listxattr	= f2fs_listxattr,
 };


