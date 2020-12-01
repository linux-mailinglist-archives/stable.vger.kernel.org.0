Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F182C9A6D
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387816AbgLAI51 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 03:57:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:60746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729248AbgLAI5Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 03:57:25 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B0F0221FD;
        Tue,  1 Dec 2020 08:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813004;
        bh=H06m4XaXDEk9/hbe0x+PxElOB0uisivjggLwd6N0cWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o8h8wiPtSks/Rs6u5JTjR1jlrhc9MOW7+QfOoXpK9+8yPJ65WvpQUxBFh/dpGRxyN
         zi4/RTzcRqfM0fnVGi1bNKhTYDJQyja6dFK/OPZZi0lSMWt3yNikOFvOxWJSqH6lgG
         TXhYxfR/J5wist+Dy1OHbR+7R38abSapa03se8UI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>,
        David Laight <David.Laight@aculab.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 31/42] efivarfs: revert "fix memory leak in efivarfs_create()"
Date:   Tue,  1 Dec 2020 09:53:29 +0100
Message-Id: <20201201084644.780505975@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084642.194933793@linuxfoundation.org>
References: <20201201084642.194933793@linuxfoundation.org>
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
index 71fccccf317e8..5decb3e06563f 100644
--- a/fs/efivarfs/inode.c
+++ b/fs/efivarfs/inode.c
@@ -10,6 +10,7 @@
 #include <linux/efi.h>
 #include <linux/fs.h>
 #include <linux/ctype.h>
+#include <linux/kmemleak.h>
 #include <linux/slab.h>
 #include <linux/uuid.h>
 
@@ -104,6 +105,7 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
 	var->var.VariableName[i] = '\0';
 
 	inode->i_private = var;
+	kmemleak_ignore(var);
 
 	err = efivar_entry_add(var, &efivarfs_list);
 	if (err)
diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index bbf056191aaa4..b1e6acec53041 100644
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



