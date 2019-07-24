Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3265273C76
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388632AbfGXUJL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:09:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:49322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405298AbfGXUA4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 16:00:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7DE3205C9;
        Wed, 24 Jul 2019 20:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998455;
        bh=C3Ji68M2HvbT4xXP9wITpbyHdwCYmlngudHd4n2hFY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=arTfTNMQRaL71B+nH/jerY3IaUHGlBz260V23XYgFXafV+GkvJDTAWe2iiCHpeE22
         TLFrUSuZhsyMrzIendc1KJAfsjdzLN5dDmpZkJQZR1LaLMdSAji/etQvdiStCcjf57
         TSHwKXAjMXzlhShUZzx6zNx8DyDkMWKBqo0qqnzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Norbert Manthey <nmanthey@amazon.de>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.1 370/371] pstore: Fix double-free in pstore_mkfile() failure path
Date:   Wed, 24 Jul 2019 21:22:02 +0200
Message-Id: <20190724191752.233895887@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Norbert Manthey <nmanthey@amazon.de>

commit 4c6d80e1144bdf48cae6b602ae30d41f3e5c76a9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/pstore/inode.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -330,22 +330,21 @@ int pstore_mkfile(struct dentry *root, s
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
@@ -361,7 +360,7 @@ int pstore_mkfile(struct dentry *root, s
 
 fail_private:
 	free_pstore_private(private);
-fail_alloc:
+fail_inode:
 	iput(inode);
 
 fail:


