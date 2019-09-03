Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAEAA6F4B
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731228AbfICQbt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:31:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:54856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730010AbfICQbo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:31:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1335238D0;
        Tue,  3 Sep 2019 16:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528303;
        bh=MEDwmnHyT+j4wPSUrobOsrWKdcqz2wDWmQRnkf9QL14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OCXFW2Q+TVdgPQnf3AV+8TjFRYg51gjyy7Oe/mm2yFjxrba+gMaAhdPhTuWzW8efK
         GQIWODWrA327U8ge8vg876rA66SF5twR81QbkZ+cqoJ9HdKro9xqhXbHJPmvkQiiep
         sDB/5LR8ZCtHU0PrhqJKxJKxKvb+WHdHXk+R0GTM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Norbert Manthey <nmanthey@amazon.de>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 145/167] pstore: Fix double-free in pstore_mkfile() failure path
Date:   Tue,  3 Sep 2019 12:24:57 -0400
Message-Id: <20190903162519.7136-145-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Norbert Manthey <nmanthey@amazon.de>

[ Upstream commit 4c6d80e1144bdf48cae6b602ae30d41f3e5c76a9 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pstore/inode.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 8cf2218b46a75..6f90d91a8733a 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -330,10 +330,6 @@ int pstore_mkfile(struct dentry *root, struct pstore_record *record)
 		goto fail;
 	inode->i_mode = S_IFREG | 0444;
 	inode->i_fop = &pstore_file_operations;
-	private = kzalloc(sizeof(*private), GFP_KERNEL);
-	if (!private)
-		goto fail_alloc;
-	private->record = record;
 
 	switch (record->type) {
 	case PSTORE_TYPE_DMESG:
@@ -383,12 +379,16 @@ int pstore_mkfile(struct dentry *root, struct pstore_record *record)
 		break;
 	}
 
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
@@ -404,7 +404,7 @@ int pstore_mkfile(struct dentry *root, struct pstore_record *record)
 
 fail_private:
 	free_pstore_private(private);
-fail_alloc:
+fail_inode:
 	iput(inode);
 
 fail:
-- 
2.20.1

