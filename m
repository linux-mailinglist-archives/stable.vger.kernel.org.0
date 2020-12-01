Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 963912C9BF1
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390113AbgLAJNd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:13:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:51926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389205AbgLAJNc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:13:32 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92A412222A;
        Tue,  1 Dec 2020 09:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813966;
        bh=JtMhhAy4hy8eQXgny1H9MCcW5Ki7l+Ee4v7zUivDbjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lIKtle4bdI8rtplA2UynfrhRzweUtFD18Dn7X3oYkmzIkKW3eLCnMMLBtcNuCJO/n
         Xe/4m3UUJ0C7GdILC04PdQFGwOAK5TEqxFhLev4pVUgY5Hj/+uPpdALk2HDxj74Y1L
         mcE9KytgjfDNuIXflJr9lizw89S6ev/RUJ+Bag+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>,
        David Laight <David.Laight@aculab.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 121/152] efivarfs: revert "fix memory leak in efivarfs_create()"
Date:   Tue,  1 Dec 2020 09:53:56 +0100
Message-Id: <20201201084727.640687824@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit ff04f3b6f2e27f8ae28a498416af2a8dd5072b43 ]

The memory leak addressed by commit fe5186cf12e3 is a false positive:
all allocations are recorded in a linked list, and freed when the
filesystem is unmounted. This leads to double frees, and as reported
by David, leads to crashes if SLUB is configured to self destruct when
double frees occur.

So drop the redundant kfree() again, and instead, mark the offending
pointer variable so the allocation is ignored by kmemleak.

Cc: Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>
Fixes: fe5186cf12e3 ("efivarfs: fix memory leak in efivarfs_create()")
Reported-by: David Laight <David.Laight@aculab.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/efivarfs/inode.c | 2 ++
 fs/efivarfs/super.c | 1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/efivarfs/inode.c b/fs/efivarfs/inode.c
index 96c0c86f3fffe..0297ad95eb5cc 100644
--- a/fs/efivarfs/inode.c
+++ b/fs/efivarfs/inode.c
@@ -7,6 +7,7 @@
 #include <linux/efi.h>
 #include <linux/fs.h>
 #include <linux/ctype.h>
+#include <linux/kmemleak.h>
 #include <linux/slab.h>
 #include <linux/uuid.h>
 
@@ -103,6 +104,7 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
 	var->var.VariableName[i] = '\0';
 
 	inode->i_private = var;
+	kmemleak_ignore(var);
 
 	err = efivar_entry_add(var, &efivarfs_list);
 	if (err)
diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index f943fd0b0699c..15880a68faadc 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -21,7 +21,6 @@ LIST_HEAD(efivarfs_list);
 static void efivarfs_evict_inode(struct inode *inode)
 {
 	clear_inode(inode);
-	kfree(inode->i_private);
 }
 
 static const struct super_operations efivarfs_ops = {
-- 
2.27.0



