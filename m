Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 044F9731A4
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 16:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727339AbfGXO26 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 10:28:58 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34237 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727273AbfGXO26 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 10:28:58 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 5B21E21B2C;
        Wed, 24 Jul 2019 10:28:57 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 24 Jul 2019 10:28:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=vU8XLh
        kIK6puutfG3UYHmB5NbSObtTva192K3YQaWvk=; b=io4L8OctsIE7Ej+PQ8X4gU
        nWj31VK5hJeTrfSkvXTF99pSSG/S/e29VCGi9RocTwR2jD1H408XEPu5sdZ3luOs
        X9zPMNW6MQfWsX4v9ff0UniQut3tuGegwhcmIVIyxg+b4flboar3aUB633ZvxlX0
        SfMCzBy1qIv0TcU0D0uDu5FZHd0aeb6oJhJktP/EAkHRZPDmfu2axI8ZHzK5A1vj
        wkppajgH302k7ekaiMseuuZqpPVh/hH7cYpppOTGWuKUfD1Hjbuvkzco9FNxY4DY
        hExrn6Br7hS8FADeN5pX2ZTlXL2rwnMWPunQRBtUwZ5elcoL33bsY3Ny2pdUbJyw
        ==
X-ME-Sender: <xms:KWs4XUE5zBzPI9ZUx1ByQ9GhhLp7It-YsDVVIHwhzTXl8xst1aomiw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrkedtgdejudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:KWs4XRC6FoJzkqw_xSM_M60EKtJ69etX45c2ezjZzLInRqAEaqaQMg>
    <xmx:KWs4XWzmDv2kOVLbXPqi_5A8QW6YEBgdkC7aodXpcVNvA3qHGaJcKQ>
    <xmx:KWs4XXdrbWYRghluNxb9F4aPXRb-Bh84AxaYABEpEjMfyenub5Mc0w>
    <xmx:KWs4XfMqxu8Plz5iTKcqsEmyW8NvDIc9_yQBWKA7CLe24ewwR4pUHg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D00DD8005A;
        Wed, 24 Jul 2019 10:28:56 -0400 (EDT)
Subject: FAILED: patch "[PATCH] pstore: Fix double-free in pstore_mkfile() failure path" failed to apply to 4.14-stable tree
To:     nmanthey@amazon.de, keescook@chromium.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 24 Jul 2019 16:26:57 +0200
Message-ID: <1563978417255144@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4c6d80e1144bdf48cae6b602ae30d41f3e5c76a9 Mon Sep 17 00:00:00 2001
From: Norbert Manthey <nmanthey@amazon.de>
Date: Fri, 5 Jul 2019 15:06:00 +0200
Subject: [PATCH] pstore: Fix double-free in pstore_mkfile() failure path

The pstore_mkfile() function is passed a pointer to a struct
pstore_record. On success it consumes this 'record' pointer and
references it from the created inode.

On failure, however, it may or may not free the record. There are even
two different code paths which return -ENOMEM -- one of which does and
the other doesn't free the record.

Make the behaviour deterministic by never consuming and freeing the
record when returning failure, allowing the caller to do the cleanup
consistently.

Signed-off-by: Norbert Manthey <nmanthey@amazon.de>
Link: https://lore.kernel.org/r/1562331960-26198-1-git-send-email-nmanthey@amazon.de
Fixes: 83f70f0769ddd ("pstore: Do not duplicate record metadata")
Fixes: 1dfff7dd67d1a ("pstore: Pass record contents instead of copying")
Cc: stable@vger.kernel.org
[kees: also move "private" allocation location, rename inode cleanup label]
Signed-off-by: Kees Cook <keescook@chromium.org>

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 89a80b568a17..7fbe8f058220 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -318,22 +318,21 @@ int pstore_mkfile(struct dentry *root, struct pstore_record *record)
 		goto fail;
 	inode->i_mode = S_IFREG | 0444;
 	inode->i_fop = &pstore_file_operations;
-	private = kzalloc(sizeof(*private), GFP_KERNEL);
-	if (!private)
-		goto fail_alloc;
-	private->record = record;
-
 	scnprintf(name, sizeof(name), "%s-%s-%llu%s",
 			pstore_type_to_name(record->type),
 			record->psi->name, record->id,
 			record->compressed ? ".enc.z" : "");
 
+	private = kzalloc(sizeof(*private), GFP_KERNEL);
+	if (!private)
+		goto fail_inode;
+
 	dentry = d_alloc_name(root, name);
 	if (!dentry)
 		goto fail_private;
 
+	private->record = record;
 	inode->i_size = private->total_size = size;
-
 	inode->i_private = private;
 
 	if (record->time.tv_sec)
@@ -349,7 +348,7 @@ int pstore_mkfile(struct dentry *root, struct pstore_record *record)
 
 fail_private:
 	free_pstore_private(private);
-fail_alloc:
+fail_inode:
 	iput(inode);
 
 fail:

