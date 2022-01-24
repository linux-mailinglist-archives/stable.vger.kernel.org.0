Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3EE649A358
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365152AbiAXXuU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:50:20 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54920 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348012AbiAXVgU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:36:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72129612E5;
        Mon, 24 Jan 2022 21:36:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0CEC340E4;
        Mon, 24 Jan 2022 21:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060178;
        bh=YljHBSu8U7fYgPuBxiqBxuJLS3a+IyXUlt9fCs6zb+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jhdVyAGHnYKXW+kAhEHKAXx7nmvKruB8Tph6SxwiYUsxSax1a4SonaGZDLkdDdG1o
         TVwWEWmAtr8eOfMDgk0GPE3cLMJa9hxZp8gLqN6yay2nEKwPQwOhFWq9M3lzCoz4TO
         pZWy2J+hycw03cwwntdc9qxpmG7GAHwtreoU+j9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.16 0864/1039] parisc: Fix lpa and lpa_user defines
Date:   Mon, 24 Jan 2022 19:44:13 +0100
Message-Id: <20220124184154.337574400@linuxfoundation.org>
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

From: John David Anglin <dave.anglin@bell.net>

commit db19c6f1a2a353cc8dec35b4789733a3cf6e2838 upstream.

While working on the rewrite to the light-weight syscall and futex code, I
experimented with using a hash index based on the user physical address of
atomic variable. This exposed two problems with the lpa and lpa_user defines.

Because of the copy instruction, the pa argument needs to be an early clobber
argument. This prevents gcc from allocating the va and pa arguments to the same
register.

Secondly, the lpa instruction can cause a page fault so we need to catch
exceptions.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Fixes: 116d753308cf ("parisc: Use lpa instruction to load physical addresses in driver code")
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/include/asm/special_insns.h |   44 +++++++++++++++++---------------
 1 file changed, 24 insertions(+), 20 deletions(-)

--- a/arch/parisc/include/asm/special_insns.h
+++ b/arch/parisc/include/asm/special_insns.h
@@ -2,28 +2,32 @@
 #ifndef __PARISC_SPECIAL_INSNS_H
 #define __PARISC_SPECIAL_INSNS_H
 
-#define lpa(va)	({			\
-	unsigned long pa;		\
-	__asm__ __volatile__(		\
-		"copy %%r0,%0\n\t"	\
-		"lpa %%r0(%1),%0"	\
-		: "=r" (pa)		\
-		: "r" (va)		\
-		: "memory"		\
-	);				\
-	pa;				\
+#define lpa(va)	({					\
+	unsigned long pa;				\
+	__asm__ __volatile__(				\
+		"copy %%r0,%0\n"			\
+		"8:\tlpa %%r0(%1),%0\n"			\
+		"9:\n"					\
+		ASM_EXCEPTIONTABLE_ENTRY(8b, 9b)	\
+		: "=&r" (pa)				\
+		: "r" (va)				\
+		: "memory"				\
+	);						\
+	pa;						\
 })
 
-#define lpa_user(va)	({		\
-	unsigned long pa;		\
-	__asm__ __volatile__(		\
-		"copy %%r0,%0\n\t"	\
-		"lpa %%r0(%%sr3,%1),%0"	\
-		: "=r" (pa)		\
-		: "r" (va)		\
-		: "memory"		\
-	);				\
-	pa;				\
+#define lpa_user(va)	({				\
+	unsigned long pa;				\
+	__asm__ __volatile__(				\
+		"copy %%r0,%0\n"			\
+		"8:\tlpa %%r0(%%sr3,%1),%0\n"		\
+		"9:\n"					\
+		ASM_EXCEPTIONTABLE_ENTRY(8b, 9b)	\
+		: "=&r" (pa)				\
+		: "r" (va)				\
+		: "memory"				\
+	);						\
+	pa;						\
 })
 
 #define mfctl(reg)	({		\


