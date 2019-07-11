Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C95C65599
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 13:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbfGKLbM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 07:31:12 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:60053 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728205AbfGKLbM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jul 2019 07:31:12 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 0EE154FE;
        Thu, 11 Jul 2019 07:31:09 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 11 Jul 2019 07:31:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=TzQ4Lm
        IoZUPaoMMOPZ52lNEnNLxOD1cQ+E5VQ4DyqA4=; b=ybSS/MtD5VNtjLFWGBILG7
        kPmNdI4KixHixfnRDyG+neEKA/MImi4Ik+qXYlGJsluw5k3K9Oim5b8DT+c/vZ/k
        wuflgQRaLS5dWdV7DlXYqkq9EqF+fqL/jRkLjyvneOoSq/DHO86f0cZ3bvXAo8TV
        /FpvGOUtdfFRD5LHEwZNwa+MduPoJymzmJ6+vUlgR19pf9eKBiWwD8juixOKJpqq
        5fb6cj7X99mKuFDG3OZS2u6qUt2vdIbAj3CXfQEsv4sUKrDVtTNr892lV6jCufHE
        JzDD+KNmUcLLhvvlF7Lg60L/fVgldom8Rb2gTL5vggN0zfduIT+w0O4C9mbnIzIQ
        ==
X-ME-Sender: <xms:_B0nXfrVt6cbfX377CI2SI1YW4gyJt8sy-Kq7Pnw9yTrbbybrvBGOg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrgeekgdegfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:_B0nXaYV05x77OnlKD2cLSeg9PYe0QTBGAU1jznU1GwWg_HAWyWDZQ>
    <xmx:_B0nXQCbUOggw-FfbcD8LzZjSopDNuqNqvf0idDLdfFH5o15tJ7QNg>
    <xmx:_B0nXUetrZN6W0o7i1pUX6k59qrd8RmrCrE9q1Kav2xIKoXXi1fLig>
    <xmx:_B0nXbiMLQCfzgT8wJW-w8OA0MNLoun00i98DgLwC7n_ReQ3JVc-PQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 298133800B9;
        Thu, 11 Jul 2019 07:31:06 -0400 (EDT)
Subject: FAILED: patch "[PATCH] fscrypt: don't set policy for a dead directory" failed to apply to 4.9-stable tree
To:     hongjiefang@asrmicro.com, ebiggers@google.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Jul 2019 13:31:04 +0200
Message-ID: <15628446641298@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

