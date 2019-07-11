Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88A8F6559A
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 13:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728354AbfGKLbR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 07:31:17 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:43249 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728102AbfGKLbQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jul 2019 07:31:16 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id A1A924B5;
        Thu, 11 Jul 2019 07:31:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 11 Jul 2019 07:31:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=CxCn5o
        FsAV4PwZgyV77WxPFsXqJt6xFz51Addt7AM/Q=; b=YeIZPIDiqRyLj7yMRbK2o4
        4xEKqZUtldi6TSyH7BxUeQ0TMlyG1EF2wJSKMYuVH51Rpkdz5fBK+mbsovBrtE80
        dPNlj07TVH10y7zSdhzK/CZIJIVscWJnDDY7RFqzbaIt7Di2qxxIc9n8KDjrUrws
        SWFoYVK7xczoEfRl3AXGHmMNmAhAyH8ZjmyxskG3yA4qShQm7rtNTKlRcKc//X97
        fFnIAJyxUPsqa6iTH8alWLwi2ly2DnH5mwo0BOLC2xhtdeb/tv0t48wit/k1ZnwX
        10L9nBjHcbuHtLMpvCtDs2cB2fDieb3Gfre+OsDj7h6QNUanv/duU2Ri+NxGo7Gg
        ==
X-ME-Sender: <xms:Ax4nXcLQlUrjV-Gfq1FSn9VmptiqD2sMunwea99tmT9q7GNt01w94w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrgeekgdegfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:Ax4nXU89i1oFXpnppeRRbmkqIlZF58KQyU4sKTyCrhJ03mMvOlkoUg>
    <xmx:Ax4nXTQCWT3n3193nclCmM9iaqDppx0hh_6X-DpR_6m4KINwu3icuw>
    <xmx:Ax4nXWw91CZjy5Cv37LZXKFYTTBPbYFShi5ONqZIOZiBICSAChuwxA>
    <xmx:Ax4nXZrALkX-vBHw6OHStwQ_jpik8_Amzg-s6jQ78u-CqQfSEHqrEw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D8B0D80064;
        Thu, 11 Jul 2019 07:31:14 -0400 (EDT)
Subject: FAILED: patch "[PATCH] fscrypt: don't set policy for a dead directory" failed to apply to 4.4-stable tree
To:     hongjiefang@asrmicro.com, ebiggers@google.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Jul 2019 13:31:04 +0200
Message-ID: <1562844664145128@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5858bdad4d0d0fc18bf29f34c3ac836e0b59441f Mon Sep 17 00:00:00 2001
From: Hongjie Fang <hongjiefang@asrmicro.com>
Date: Wed, 22 May 2019 10:02:53 +0800
Subject: [PATCH] fscrypt: don't set policy for a dead directory

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

diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index d536889ac31b..4941fe8471ce 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -81,6 +81,8 @@ int fscrypt_ioctl_set_policy(struct file *filp, const void __user *arg)
 	if (ret == -ENODATA) {
 		if (!S_ISDIR(inode->i_mode))
 			ret = -ENOTDIR;
+		else if (IS_DEADDIR(inode))
+			ret = -ENOENT;
 		else if (!inode->i_sb->s_cop->empty_dir(inode))
 			ret = -ENOTEMPTY;
 		else

