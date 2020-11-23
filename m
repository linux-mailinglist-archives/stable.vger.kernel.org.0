Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A41A12C0AA2
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729423AbgKWMXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:23:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:60516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726529AbgKWMX1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:23:27 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E0D6208C3;
        Mon, 23 Nov 2020 12:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134206;
        bh=cIzDVHwSJvGivYly1xFLrVko9+GWcVrG2cO7U+O2F04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gXKCFj5Z0coFYOJqZmlUyTHhPdAdyGU6fhtdBnWeXEj9sBPKYVoKFa7pQCBVWNdlP
         YY+FQIH/CS/porvS/yjkmFjnGHDv3jY/ZuC41cx1IViup4ZEYwkCpd1kYr7/dOQQBb
         +CU1IaR/eg7kr9lUAfH9G+naEBGN7wmNyT5kCp+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, dja@axtens.net,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.4 26/38] [PATCH v4.4] powerpc/uaccess-flush: fix corenet64_smp_defconfig build
Date:   Mon, 23 Nov 2020 13:22:12 +0100
Message-Id: <20201123121805.554244530@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121804.306030358@linuxfoundation.org>
References: <20201123121804.306030358@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Axtens <dja@axtens.net>

Gunter reports problems with the corenet64_smp_defconfig:

In file included from arch/powerpc/kernel/ppc_ksyms.c:10:0:
arch/powerpc/include/asm/book3s/64/kup-radix.h:11:29: error: redefinition of ‘allow_user_access’
 static __always_inline void allow_user_access(void __user *to, const void __user *from,
			     ^~~~~~~~~~~~~~~~~
In file included from arch/powerpc/include/asm/uaccess.h:12:0,
		 from arch/powerpc/kernel/ppc_ksyms.c:8:
arch/powerpc/include/asm/kup.h:12:20: note: previous definition of ‘allow_user_access’ was here
 static inline void allow_user_access(void __user *to, const void __user *from,
		    ^~~~~~~~~~~~~~~~~

This is because ppc_ksyms.c imports asm/book3s/64/kup-radix.h guarded by
CONFIG_PPC64, rather than CONFIG_PPC_BOOK3S_64 which it should do.

Fix it.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/ppc_ksyms.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/ppc_ksyms.c
+++ b/arch/powerpc/kernel/ppc_ksyms.c
@@ -6,7 +6,7 @@
 #include <asm/cacheflush.h>
 #include <asm/epapr_hcalls.h>
 #include <asm/uaccess.h>
-#ifdef CONFIG_PPC64
+#ifdef CONFIG_PPC_BOOK3S_64
 #include <asm/book3s/64/kup-radix.h>
 #endif
 
@@ -50,6 +50,6 @@ EXPORT_SYMBOL(current_stack_pointer);
 
 EXPORT_SYMBOL(__arch_clear_user);
 
-#ifdef CONFIG_PPC64
+#ifdef CONFIG_PPC_BOOK3S_64
 EXPORT_SYMBOL(do_uaccess_flush);
 #endif


