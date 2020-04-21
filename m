Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE271B2DE9
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 19:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbgDUROi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 13:14:38 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:46201 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725990AbgDUROi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 13:14:38 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id DA2711940813;
        Tue, 21 Apr 2020 13:14:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 21 Apr 2020 13:14:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Dc5/M8
        oO2JoQCcp05rdH0nWYPPTxUszq34tXe5QdhHo=; b=V+/LRHS6l2OFFywgsqH+jY
        /gx90wES7i25+sURpqhst2dLWgAPzpSg2zjf1vdctN74Iz+tEKn9bvMZuUsU2lI7
        VVW6K6vzRdBHsHMN09FZe2fYVqOrm/DCovOZe3DMNNUoSyvHXP41aeCjwypqWfUw
        NmHlBHXGjx08r/iQR1W0cCRo6hHfnU2oQM8cmknJPIQytNxBFqsa7hmPeXLFbui6
        wjMD64EeGZA1dSYHnh/yZzLSwRP1STA7GesHQ/6MyU07B4QRy4gzLTIJAUz5yuPm
        nJ6e+kuEposakfayyEWdVIP8DujqclUcewmkNQpcD8Tcjty0LJe8GC2MDqbW6ZdA
        ==
X-ME-Sender: <xms:_CmfXnf6wOMJYJJwpTPR239e_90iWvxqyOM2jsFKnkJhwCC8fLhXNw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrgeehgddutdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedune
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:_CmfXkvm3CkPKzu_d08L2A27GfU0c1vszXXm1CpfooBOwDGtXH8GpA>
    <xmx:_CmfXmmGvSoXDOhu5D9wER1iHKA7czagpjLaIedFEQujta6bxVOnqg>
    <xmx:_CmfXnCa8b8zl3ubcoY4R2HIUyUYAoXawa8TF4GSRq2swNjL41nD3w>
    <xmx:_CmfXlwpvDenKtXbapOKxlqOJJN7Dilhlr0wS5fGYSpHOBnwYWrl_A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 35D8E3065C7C;
        Tue, 21 Apr 2020 13:14:36 -0400 (EDT)
Subject: FAILED: patch "[PATCH] afs: Fix afs_d_validate() to set the right directory version" failed to apply to 4.19-stable tree
To:     dhowells@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 21 Apr 2020 19:14:34 +0200
Message-ID: <1587489274218214@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 40fc81027f892284ce31f8b6de1e497f5b47e71f Mon Sep 17 00:00:00 2001
From: David Howells <dhowells@redhat.com>
Date: Sat, 11 Apr 2020 08:50:45 +0100
Subject: [PATCH] afs: Fix afs_d_validate() to set the right directory version

If a dentry's version is somewhere between invalid_before and the current
directory version, we should be setting it forward to the current version,
not backwards to the invalid_before version.  Note that we're only doing
this at all because dentry::d_fsdata isn't large enough on a 32-bit system.

Fix this by using a separate variable for invalid_before so that we don't
accidentally clobber the current dir version.

Fixes: a4ff7401fbfa ("afs: Keep track of invalid-before version for dentry coherency")
Signed-off-by: David Howells <dhowells@redhat.com>

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index d6278616fb88..d1e1caa23c8b 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -1032,7 +1032,7 @@ static int afs_d_revalidate(struct dentry *dentry, unsigned int flags)
 	struct dentry *parent;
 	struct inode *inode;
 	struct key *key;
-	afs_dataversion_t dir_version;
+	afs_dataversion_t dir_version, invalid_before;
 	long de_version;
 	int ret;
 
@@ -1084,8 +1084,8 @@ static int afs_d_revalidate(struct dentry *dentry, unsigned int flags)
 	if (de_version == (long)dir_version)
 		goto out_valid_noupdate;
 
-	dir_version = dir->invalid_before;
-	if (de_version - (long)dir_version >= 0)
+	invalid_before = dir->invalid_before;
+	if (de_version - (long)invalid_before >= 0)
 		goto out_valid;
 
 	_debug("dir modified");

