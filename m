Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A2E2C9C9E
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729018AbgLAIzG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 03:55:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:57748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728965AbgLAIzF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 03:55:05 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E654E2222C;
        Tue,  1 Dec 2020 08:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606812837;
        bh=RhMxrXaQglKe7p18zzosxorZXKKDBSr6PbsUM8x8qLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CjLKcS7plNKVejoGqtvqcRK7Fcc9CwlS4rCO4MjPB33Nf3zTJYOdH3fPMGq3v6E3N
         j3AjDD3q7A4cQwYKSycAmUe0vHz22ihRaTHdmEp5dWbIaOPmauda4RHhuUYmLIcUJW
         JvWAcQQU5Bcvojrbhr4mkORAUizt98WyqPaklCYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>,
        David Laight <David.Laight@aculab.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 18/24] efivarfs: revert "fix memory leak in efivarfs_create()"
Date:   Tue,  1 Dec 2020 09:53:24 +0100
Message-Id: <20201201084638.661650900@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084637.754785180@linuxfoundation.org>
References: <20201201084637.754785180@linuxfoundation.org>
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
index e2ab6d0497f2b..151884b95ee2f 100644
--- a/fs/efivarfs/inode.c
+++ b/fs/efivarfs/inode.c
@@ -10,6 +10,7 @@
 #include <linux/efi.h>
 #include <linux/fs.h>
 #include <linux/ctype.h>
+#include <linux/kmemleak.h>
 #include <linux/slab.h>
 
 #include "internal.h"
@@ -138,6 +139,7 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
 	var->var.VariableName[i] = '\0';
 
 	inode->i_private = var;
+	kmemleak_ignore(var);
 
 	efivar_entry_add(var, &efivarfs_list);
 	d_instantiate(dentry, inode);
diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index 0e4f20377d196..fca235020312d 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -23,7 +23,6 @@ LIST_HEAD(efivarfs_list);
 static void efivarfs_evict_inode(struct inode *inode)
 {
 	clear_inode(inode);
-	kfree(inode->i_private);
 }
 
 static const struct super_operations efivarfs_ops = {
-- 
2.27.0



