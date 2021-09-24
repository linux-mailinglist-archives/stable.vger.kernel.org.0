Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 740544172DF
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344174AbhIXMwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:52:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344307AbhIXMup (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:50:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1830D61242;
        Fri, 24 Sep 2021 12:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487711;
        bh=97BEcLR+uG1fxriTA6b7SfiP+EezFE1mzZSvFQB8v44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oxGgrkg4EtOrYkLymyFixdVfonTObM16g3unJERopZsJHt3UCIbTdNJScRfUL8j7s
         4VXxwIq4SMjZrzJ/x/Gy6inAECHlRyYG9cFbZtzbc6z0bJPCcYumIvC7TyEn4iGA9d
         4CdvWFxatjoLyUbgS0ILJtFhyGHwktznzqlTWi2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 18/34] drivers: base: cacheinfo: Get rid of DEFINE_SMP_CALL_CACHE_FUNCTION()
Date:   Fri, 24 Sep 2021 14:44:12 +0200
Message-Id: <20210924124330.560223475@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124329.965218583@linuxfoundation.org>
References: <20210924124329.965218583@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 4b92d4add5f6dcf21275185c997d6ecb800054cd ]

DEFINE_SMP_CALL_CACHE_FUNCTION() was usefel before the CPU hotplug rework
to ensure that the cache related functions are called on the upcoming CPU
because the notifier itself could run on any online CPU.

The hotplug state machine guarantees that the callbacks are invoked on the
upcoming CPU. So there is no need to have this SMP function call
obfuscation. That indirection was missed when the hotplug notifiers were
converted.

This also solves the problem of ARM64 init_cache_level() invoking ACPI
functions which take a semaphore in that context. That's invalid as SMP
function calls run with interrupts disabled. Running it just from the
callback in context of the CPU hotplug thread solves this.

Fixes: 8571890e1513 ("arm64: Add support for ACPI based firmware tables")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Will Deacon <will@kernel.org>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/871r69ersb.ffs@tglx
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/cacheinfo.c   |  7 ++-----
 arch/mips/kernel/cacheinfo.c    |  7 ++-----
 arch/riscv/kernel/cacheinfo.c   |  7 ++-----
 arch/x86/kernel/cpu/cacheinfo.c |  7 ++-----
 include/linux/cacheinfo.h       | 18 ------------------
 5 files changed, 8 insertions(+), 38 deletions(-)

diff --git a/arch/arm64/kernel/cacheinfo.c b/arch/arm64/kernel/cacheinfo.c
index 0bf0a835122f..d17414cbb89a 100644
--- a/arch/arm64/kernel/cacheinfo.c
+++ b/arch/arm64/kernel/cacheinfo.c
@@ -45,7 +45,7 @@ static void ci_leaf_init(struct cacheinfo *this_leaf,
 	this_leaf->type = type;
 }
 
-static int __init_cache_level(unsigned int cpu)
+int init_cache_level(unsigned int cpu)
 {
 	unsigned int ctype, level, leaves, fw_level;
 	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
@@ -80,7 +80,7 @@ static int __init_cache_level(unsigned int cpu)
 	return 0;
 }
 
-static int __populate_cache_leaves(unsigned int cpu)
+int populate_cache_leaves(unsigned int cpu)
 {
 	unsigned int level, idx;
 	enum cache_type type;
@@ -99,6 +99,3 @@ static int __populate_cache_leaves(unsigned int cpu)
 	}
 	return 0;
 }
-
-DEFINE_SMP_CALL_CACHE_FUNCTION(init_cache_level)
-DEFINE_SMP_CALL_CACHE_FUNCTION(populate_cache_leaves)
diff --git a/arch/mips/kernel/cacheinfo.c b/arch/mips/kernel/cacheinfo.c
index 3ea95568ece4..1c19a0698308 100644
--- a/arch/mips/kernel/cacheinfo.c
+++ b/arch/mips/kernel/cacheinfo.c
@@ -28,7 +28,7 @@ do {								\
 	leaf++;							\
 } while (0)
 
-static int __init_cache_level(unsigned int cpu)
+int init_cache_level(unsigned int cpu)
 {
 	struct cpuinfo_mips *c = &current_cpu_data;
 	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
@@ -80,7 +80,7 @@ static void fill_cpumask_cluster(int cpu, cpumask_t *cpu_map)
 			cpumask_set_cpu(cpu1, cpu_map);
 }
 
-static int __populate_cache_leaves(unsigned int cpu)
+int populate_cache_leaves(unsigned int cpu)
 {
 	struct cpuinfo_mips *c = &current_cpu_data;
 	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
@@ -109,6 +109,3 @@ static int __populate_cache_leaves(unsigned int cpu)
 
 	return 0;
 }
-
-DEFINE_SMP_CALL_CACHE_FUNCTION(init_cache_level)
-DEFINE_SMP_CALL_CACHE_FUNCTION(populate_cache_leaves)
diff --git a/arch/riscv/kernel/cacheinfo.c b/arch/riscv/kernel/cacheinfo.c
index 0bc86e5f8f3f..9d46c8575a61 100644
--- a/arch/riscv/kernel/cacheinfo.c
+++ b/arch/riscv/kernel/cacheinfo.c
@@ -31,7 +31,7 @@ static void ci_leaf_init(struct cacheinfo *this_leaf,
 		| CACHE_WRITE_ALLOCATE;
 }
 
-static int __init_cache_level(unsigned int cpu)
+int init_cache_level(unsigned int cpu)
 {
 	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
 	struct device_node *np = of_cpu_device_node_get(cpu);
@@ -67,7 +67,7 @@ static int __init_cache_level(unsigned int cpu)
 	return 0;
 }
 
-static int __populate_cache_leaves(unsigned int cpu)
+int populate_cache_leaves(unsigned int cpu)
 {
 	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
 	struct cacheinfo *this_leaf = this_cpu_ci->info_list;
@@ -99,6 +99,3 @@ static int __populate_cache_leaves(unsigned int cpu)
 
 	return 0;
 }
-
-DEFINE_SMP_CALL_CACHE_FUNCTION(init_cache_level)
-DEFINE_SMP_CALL_CACHE_FUNCTION(populate_cache_leaves)
diff --git a/arch/x86/kernel/cpu/cacheinfo.c b/arch/x86/kernel/cpu/cacheinfo.c
index 9d863e8f9b3f..4a393023f5ac 100644
--- a/arch/x86/kernel/cpu/cacheinfo.c
+++ b/arch/x86/kernel/cpu/cacheinfo.c
@@ -956,7 +956,7 @@ static void ci_leaf_init(struct cacheinfo *this_leaf,
 	this_leaf->priv = base->nb;
 }
 
-static int __init_cache_level(unsigned int cpu)
+int init_cache_level(unsigned int cpu)
 {
 	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
 
@@ -985,7 +985,7 @@ static void get_cache_id(int cpu, struct _cpuid4_info_regs *id4_regs)
 	id4_regs->id = c->apicid >> index_msb;
 }
 
-static int __populate_cache_leaves(unsigned int cpu)
+int populate_cache_leaves(unsigned int cpu)
 {
 	unsigned int idx, ret;
 	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
@@ -1004,6 +1004,3 @@ static int __populate_cache_leaves(unsigned int cpu)
 
 	return 0;
 }
-
-DEFINE_SMP_CALL_CACHE_FUNCTION(init_cache_level)
-DEFINE_SMP_CALL_CACHE_FUNCTION(populate_cache_leaves)
diff --git a/include/linux/cacheinfo.h b/include/linux/cacheinfo.h
index 70e19bc6cc9f..66654e6f9605 100644
--- a/include/linux/cacheinfo.h
+++ b/include/linux/cacheinfo.h
@@ -76,24 +76,6 @@ struct cpu_cacheinfo {
 	bool cpu_map_populated;
 };
 
-/*
- * Helpers to make sure "func" is executed on the cpu whose cache
- * attributes are being detected
- */
-#define DEFINE_SMP_CALL_CACHE_FUNCTION(func)			\
-static inline void _##func(void *ret)				\
-{								\
-	int cpu = smp_processor_id();				\
-	*(int *)ret = __##func(cpu);				\
-}								\
-								\
-int func(unsigned int cpu)					\
-{								\
-	int ret;						\
-	smp_call_function_single(cpu, _##func, &ret, true);	\
-	return ret;						\
-}
-
 struct cpu_cacheinfo *get_cpu_cacheinfo(unsigned int cpu);
 int init_cache_level(unsigned int cpu);
 int populate_cache_leaves(unsigned int cpu);
-- 
2.33.0



