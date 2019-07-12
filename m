Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1204166DCD
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729637AbfGLMdk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:33:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:53040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729360AbfGLMdk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:33:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81ACD216C4;
        Fri, 12 Jul 2019 12:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934820;
        bh=NcZZzhaLzdat+yqaF8MIGu8GX/hbheQFPNJEoYo0n4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XY45cI0waQ4oQYokAt04odXToLGJHG0+kIs7e0rJk5qGIk2HB3mwTAjiJYMqtFFm8
         TEf0ErmUEHjQwr6Z28KPpcDGLDa/aXWSImqoFOChaNbK7qYJ28Uk1z7Nm+WDsujQEX
         jz18w4wm0FKvSDIr/kTKi+WPP6Q7CKS5ptsQqhpU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hongjie Fang <hongjiefang@asrmicro.com>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH 5.2 04/61] fscrypt: dont set policy for a dead directory
Date:   Fri, 12 Jul 2019 14:19:17 +0200
Message-Id: <20190712121620.843288952@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121620.632595223@linuxfoundation.org>
References: <20190712121620.632595223@linuxfoundation.org>
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
 fs/crypto/policy.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -81,6 +81,8 @@ int fscrypt_ioctl_set_policy(struct file
 	if (ret == -ENODATA) {
 		if (!S_ISDIR(inode->i_mode))
 			ret = -ENOTDIR;
+		else if (IS_DEADDIR(inode))
+			ret = -ENOENT;
 		else if (!inode->i_sb->s_cop->empty_dir(inode))
 			ret = -ENOTEMPTY;
 		else


