Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A09499A17
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1456725AbiAXVjy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:39:54 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33588 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447866AbiAXVLg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:11:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D527B81142;
        Mon, 24 Jan 2022 21:11:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2934BC340E5;
        Mon, 24 Jan 2022 21:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058693;
        bh=/bLI7PY8b0pniFdtjS+4UE+h+UAG8zivzIo6Fo50J8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EcdGETPRddbF4Ls5vdL0+GWzsCy6nXbYbo+MTUd8zT8/HOMfdzCJyiI7cM6QSAxWv
         71zbag37xabMUJRkWm/aEu/LWhq3NaJ+b/EUWsG1nrEM2OyxS4vFgm+Fgv817ZFhlJ
         ZdYfUZACkAXoEYR0hAhT+h8rmBBm0jxsBhOoMv3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Johannes Berg <johannes.berg@intel.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0339/1039] lib/logic_iomem: Fix 32-bit build
Date:   Mon, 24 Jan 2022 19:35:28 +0100
Message-Id: <20220124184136.697599517@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 4e84139e14af5ea60772cc4f33d7059aec76e0eb ]

On a 32-bit build, the (unsigned long long) casts throw warnings
(or errors) due to being to a different integer size. Cast to
uintptr_t first (with the __force for sparse) and then further
to get the consistent print on 32 and 64-bit.

Fixes: ca2e334232b6 ("lib: add iomem emulation (logic_iomem)")
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/logic_iomem.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/lib/logic_iomem.c b/lib/logic_iomem.c
index 9bdfde0c0f86d..54fa601f3300b 100644
--- a/lib/logic_iomem.c
+++ b/lib/logic_iomem.c
@@ -79,7 +79,7 @@ static void __iomem *real_ioremap(phys_addr_t offset, size_t size)
 static void real_iounmap(void __iomem *addr)
 {
 	WARN(1, "invalid iounmap for addr 0x%llx\n",
-	     (unsigned long long __force)addr);
+	     (unsigned long long)(uintptr_t __force)addr);
 }
 #endif /* CONFIG_LOGIC_IOMEM_FALLBACK */
 
@@ -173,7 +173,7 @@ EXPORT_SYMBOL(iounmap);
 static u##sz real_raw_read ## op(const volatile void __iomem *addr)	\
 {									\
 	WARN(1, "Invalid read" #op " at address %llx\n",		\
-	     (unsigned long long __force)addr);				\
+	     (unsigned long long)(uintptr_t __force)addr);		\
 	return (u ## sz)~0ULL;						\
 }									\
 									\
@@ -181,7 +181,8 @@ static void real_raw_write ## op(u ## sz val,				\
 				 volatile void __iomem *addr)		\
 {									\
 	WARN(1, "Invalid writeq" #op " of 0x%llx at address %llx\n",	\
-	     (unsigned long long)val, (unsigned long long __force)addr);\
+	     (unsigned long long)val,					\
+	     (unsigned long long)(uintptr_t __force)addr);\
 }									\
 
 MAKE_FALLBACK(b, 8);
@@ -194,14 +195,14 @@ MAKE_FALLBACK(q, 64);
 static void real_memset_io(volatile void __iomem *addr, int value, size_t size)
 {
 	WARN(1, "Invalid memset_io at address 0x%llx\n",
-	     (unsigned long long __force)addr);
+	     (unsigned long long)(uintptr_t __force)addr);
 }
 
 static void real_memcpy_fromio(void *buffer, const volatile void __iomem *addr,
 			       size_t size)
 {
 	WARN(1, "Invalid memcpy_fromio at address 0x%llx\n",
-	     (unsigned long long __force)addr);
+	     (unsigned long long)(uintptr_t __force)addr);
 
 	memset(buffer, 0xff, size);
 }
@@ -210,7 +211,7 @@ static void real_memcpy_toio(volatile void __iomem *addr, const void *buffer,
 			     size_t size)
 {
 	WARN(1, "Invalid memcpy_toio at address 0x%llx\n",
-	     (unsigned long long __force)addr);
+	     (unsigned long long)(uintptr_t __force)addr);
 }
 #endif /* CONFIG_LOGIC_IOMEM_FALLBACK */
 
-- 
2.34.1



