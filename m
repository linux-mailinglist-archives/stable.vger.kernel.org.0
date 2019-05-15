Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 984711ECFE
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728286AbfEOLD6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:03:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:33364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728305AbfEOLD6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:03:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9E6F2084F;
        Wed, 15 May 2019 11:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918237;
        bh=P5wTM4Qv6rj+5PsH6G2vRqzEjt0QpStGuZUFXmDsdC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MJVTIRS7rDRTuJb5lco6O7uN4tDlBzGSsNJltRegws7cl320uoAEJWpKXl9aZ/093
         Zn1TyTPglWbPP1w3RQpMEyt0660ryrk64T8lKI6bkORnh6LRmGpY9q7PV51mCHLNQj
         1/+UlBP4UZZbPsvWmXHNe17QZ37+8X5YxXPnXYVM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Neuling <mikey@neuling.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 056/266] powerpc: Avoid code patching freed init sections
Date:   Wed, 15 May 2019 12:52:43 +0200
Message-Id: <20190515090724.336990258@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Neuling <mikey@neuling.org>

commit 51c3c62b58b357e8d35e4cc32f7b4ec907426fe3 upstream.

This stops us from doing code patching in init sections after they've
been freed.

In this chain:
  kvm_guest_init() ->
    kvm_use_magic_page() ->
      fault_in_pages_readable() ->
	 __get_user() ->
	   __get_user_nocheck() ->
	     barrier_nospec();

We have a code patching location at barrier_nospec() and
kvm_guest_init() is an init function. This whole chain gets inlined,
so when we free the init section (hence kvm_guest_init()), this code
goes away and hence should no longer be patched.

We seen this as userspace memory corruption when using a memory
checker while doing partition migration testing on powervm (this
starts the code patching post migration via
/sys/kernel/mobility/migration). In theory, it could also happen when
using /sys/kernel/debug/powerpc/barrier_nospec.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/setup.h |    1 +
 arch/powerpc/lib/code-patching.c |   13 +++++++++++++
 arch/powerpc/mm/mem.c            |    2 ++
 3 files changed, 16 insertions(+)

--- a/arch/powerpc/include/asm/setup.h
+++ b/arch/powerpc/include/asm/setup.h
@@ -8,6 +8,7 @@ extern void ppc_printk_progress(char *s,
 
 extern unsigned int rtas_data;
 extern unsigned long long memory_limit;
+extern bool init_mem_is_free;
 extern unsigned long klimit;
 extern void *zalloc_maybe_bootmem(size_t size, gfp_t mask);
 
--- a/arch/powerpc/lib/code-patching.c
+++ b/arch/powerpc/lib/code-patching.c
@@ -14,12 +14,25 @@
 #include <asm/page.h>
 #include <asm/code-patching.h>
 #include <asm/uaccess.h>
+#include <asm/setup.h>
+#include <asm/sections.h>
 
 
+static inline bool is_init(unsigned int *addr)
+{
+	return addr >= (unsigned int *)__init_begin && addr < (unsigned int *)__init_end;
+}
+
 int patch_instruction(unsigned int *addr, unsigned int instr)
 {
 	int err;
 
+	/* Make sure we aren't patching a freed init section */
+	if (init_mem_is_free && is_init(addr)) {
+		pr_debug("Skipping init section patching addr: 0x%px\n", addr);
+		return 0;
+	}
+
 	__put_user_size(instr, addr, 4, err);
 	if (err)
 		return err;
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -62,6 +62,7 @@
 #endif
 
 unsigned long long memory_limit;
+bool init_mem_is_free;
 
 #ifdef CONFIG_HIGHMEM
 pte_t *kmap_pte;
@@ -381,6 +382,7 @@ void __init mem_init(void)
 void free_initmem(void)
 {
 	ppc_md.progress = ppc_printk_progress;
+	init_mem_is_free = true;
 	free_initmem_default(POISON_FREE_INITMEM);
 }
 


