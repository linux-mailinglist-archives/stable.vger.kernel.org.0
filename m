Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18BA06C67C
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391874AbfGRDOm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:14:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391853AbfGRDOi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:14:38 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00A0C21851;
        Thu, 18 Jul 2019 03:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419677;
        bh=2bO7GwenRbsGWRcyCSnUjWse5RkLIAUpMEEIqGQFtrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JMz5fRzu7ZHmUUpxgoSulepLjoxQ/LQo4MJd5zCwogHCVHnuiF43+5ld9vvd3CHrB
         o0mDQVdqfPrq4nXLYnYN12z0zcwbfU28MOPToi+UQIdwkQZXkqg7BQcYICXj8aovyP
         m+5XWlElQgBO89c5Lp8pSC3GYIBwdY02ijw2pOCg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hongjie Fang <hongjiefang@asrmicro.com>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH 4.4 17/40] fscrypt: dont set policy for a dead directory
Date:   Thu, 18 Jul 2019 12:02:13 +0900
Message-Id: <20190718030045.019515227@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030039.676518610@linuxfoundation.org>
References: <20190718030039.676518610@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hongjie Fang <hongjiefang@asrmicro.com>

commit 5858bdad4d0d0fc18bf29f34c3ac836e0b59441f upstream.

The directory may have been removed when entering
fscrypt_ioctl_set_policy().  If so, the empty_dir() check will return
error for ext4 file system.

ext4_rmdir() sets i_size = 0, then ext4_empty_dir() reports an error
because 'inode->i_size < EXT4_DIR_REC_LEN(1) + EXT4_DIR_REC_LEN(2)'.  If
the fs is mounted with errors=panic, it will trigger a panic issue.

Add the check IS_DEADDIR() to fix this problem.

Fixes: 9bd8212f981e ("ext4 crypto: add encryption policy and password salt support")
Cc: <stable@vger.kernel.org> # v4.1+
Signed-off-by: Hongjie Fang <hongjiefang@asrmicro.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 fs/ext4/crypto_policy.c |    2 ++
 fs/f2fs/crypto_policy.c |    2 ++
 2 files changed, 4 insertions(+)

--- a/fs/ext4/crypto_policy.c
+++ b/fs/ext4/crypto_policy.c
@@ -111,6 +111,8 @@ int ext4_process_policy(const struct ext
 	if (!ext4_inode_has_encryption_context(inode)) {
 		if (!S_ISDIR(inode->i_mode))
 			return -EINVAL;
+		if (IS_DEADDIR(inode))
+			return -ENOENT;
 		if (!ext4_empty_dir(inode))
 			return -ENOTEMPTY;
 		return ext4_create_encryption_context_from_policy(inode,
--- a/fs/f2fs/crypto_policy.c
+++ b/fs/f2fs/crypto_policy.c
@@ -99,6 +99,8 @@ int f2fs_process_policy(const struct f2f
 		return -EINVAL;
 
 	if (!f2fs_inode_has_encryption_context(inode)) {
+		if (IS_DEADDIR(inode))
+			return -ENOENT;
 		if (!f2fs_empty_dir(inode))
 			return -ENOTEMPTY;
 		return f2fs_create_encryption_context_from_policy(inode,


