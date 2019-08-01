Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9EC87D75A
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729898AbfHAIVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:21:30 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43324 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfHAIV3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:21:29 -0400
Received: by mail-pf1-f196.google.com with SMTP id i189so33609688pfg.10
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OQQ7xLa0wSJEVHtnIJUBQOen48CMIup3yNRZI8hCHQM=;
        b=oUYvAhHhaGgQYxb7bVSRF/4PxV5nyflrpPmlxaW+Z0f9y4sbb5KYVLE2zZNCcCI8QC
         k6vhSEVq7El7m5wPYxjtWN+N50RBaxgAi75+esakTPx2EM8j8CsaHi6hbRpqZWS8QO6X
         J/25wYqXIe7p4IkEL1rWhx9nKPlX1oVIUTjPCtmlEV2i3zrah/Ba0a7jcMgt+O94BV1M
         NgDePvBcBEtfGbQpdElGyGpl/swofqLnHMPuTtPSERWiJys4+7sFcMZz9PCRPbozZ6/y
         jzqznP9NbpYao0nojWycpAH5xwx+8WyFQnqAJyO/3kxfDNdI4cMMVNIL96CVc6vhGyz3
         +eYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OQQ7xLa0wSJEVHtnIJUBQOen48CMIup3yNRZI8hCHQM=;
        b=PJTW+g6xU47GNjM03i/6WTWnuQKzoKg1VW/7iiP+/YKJG+3lrNm1tkpEkdPEg0W8vd
         mdlct7kluk/pV9931yXlQS25KbStVo9Do/MJZUOisgXEpwDPuwzpBH8Psv87cPIzy05M
         tyM/eiu6+lTnr/Q4BV6i1u2fsr1azYsKvNX7BgYR2XaIkiF0NEpjPSy7Ts2+Td9iyCQC
         19kptuR4cGBjFyKlotsV2gMoPhGLEgOX8Sxm4MwXZn5vHe8gW1iI1IqR01cbDC7BPSs2
         PEkA6v3s2HNRGDWUpoZXHQSUc34ofb/zJi/GBwOc97QG4pgzU7sBBn7zf6HV8Q4LYyaN
         c14g==
X-Gm-Message-State: APjAAAU8r1+B9qobWXB46KUUA3ClkAih3C+JUBKdtpl7fz6kZ+zLtGCy
        HX89AfY22ctc77S1UHPiNjiyygN1svU=
X-Google-Smtp-Source: APXvYqya+t/VhD0GIZflUZQ26GkCty6MeltN7KGb6H/Xahi+frxD8hl8EQVaSEgY0SyvPt7cNJxFUw==
X-Received: by 2002:a63:5b23:: with SMTP id p35mr5755254pgb.366.1564647688896;
        Thu, 01 Aug 2019 01:21:28 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id t9sm65393089pgj.89.2019.08.01.01.21.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:21:28 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        Julien Thierry <Julien.Thierry@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com, guohanjun@huawei.com
Subject: [PATCH ARM32 v4.4 V2 44/47] ARM: 8595/2: apply more __ro_after_init
Date:   Thu,  1 Aug 2019 13:46:28 +0530
Message-Id: <dcfb5f1678049c607535772519edd3ab8cf38dfb.1564646727.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1564646727.git.viresh.kumar@linaro.org>
References: <cover.1564646727.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

Commit 7619751f8c900fa5fdd76db06f4caf095c56de8e upstream.

Guided by grsecurity's analogous __read_only markings in arch/arm,
this applies several uses of __ro_after_init to structures that are
only updated during __init.

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/kernel/cpuidle.c |  2 +-
 arch/arm/kernel/setup.c   | 10 +++++-----
 arch/arm/kernel/smp.c     |  2 +-
 arch/arm/lib/delay.c      |  2 +-
 arch/arm/mm/mmu.c         |  2 +-
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm/kernel/cpuidle.c b/arch/arm/kernel/cpuidle.c
index 318da33465f4..68be7d89141d 100644
--- a/arch/arm/kernel/cpuidle.c
+++ b/arch/arm/kernel/cpuidle.c
@@ -19,7 +19,7 @@ extern struct of_cpuidle_method __cpuidle_method_of_table[];
 static const struct of_cpuidle_method __cpuidle_method_of_table_sentinel
 	__used __section(__cpuidle_method_of_table_end);
 
-static struct cpuidle_ops cpuidle_ops[NR_CPUS];
+static struct cpuidle_ops cpuidle_ops[NR_CPUS] __ro_after_init;
 
 /**
  * arm_cpuidle_simple_enter() - a wrapper to cpu_do_idle()
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 13bda9574e18..8081f88bf636 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -112,19 +112,19 @@ EXPORT_SYMBOL(elf_hwcap2);
 
 
 #ifdef MULTI_CPU
-struct processor processor __read_mostly;
+struct processor processor __ro_after_init;
 #endif
 #ifdef MULTI_TLB
-struct cpu_tlb_fns cpu_tlb __read_mostly;
+struct cpu_tlb_fns cpu_tlb __ro_after_init;
 #endif
 #ifdef MULTI_USER
-struct cpu_user_fns cpu_user __read_mostly;
+struct cpu_user_fns cpu_user __ro_after_init;
 #endif
 #ifdef MULTI_CACHE
-struct cpu_cache_fns cpu_cache __read_mostly;
+struct cpu_cache_fns cpu_cache __ro_after_init;
 #endif
 #ifdef CONFIG_OUTER_CACHE
-struct outer_cache_fns outer_cache __read_mostly;
+struct outer_cache_fns outer_cache __ro_after_init;
 EXPORT_SYMBOL(outer_cache);
 #endif
 
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index bafbd29c6e64..c92abf791aed 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -79,7 +79,7 @@ enum ipi_msg_type {
 
 static DECLARE_COMPLETION(cpu_running);
 
-static struct smp_operations smp_ops;
+static struct smp_operations smp_ops __ro_after_init;
 
 void __init smp_set_ops(const struct smp_operations *ops)
 {
diff --git a/arch/arm/lib/delay.c b/arch/arm/lib/delay.c
index 8044591dca72..2cef11884857 100644
--- a/arch/arm/lib/delay.c
+++ b/arch/arm/lib/delay.c
@@ -29,7 +29,7 @@
 /*
  * Default to the loop-based delay implementation.
  */
-struct arm_delay_ops arm_delay_ops = {
+struct arm_delay_ops arm_delay_ops __ro_after_init = {
 	.delay		= __loop_delay,
 	.const_udelay	= __loop_const_udelay,
 	.udelay		= __loop_udelay,
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index aead23f15213..36f8c033714f 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -243,7 +243,7 @@ __setup("noalign", noalign_setup);
 #define PROT_PTE_S2_DEVICE	PROT_PTE_DEVICE
 #define PROT_SECT_DEVICE	PMD_TYPE_SECT|PMD_SECT_AP_WRITE
 
-static struct mem_type mem_types[] = {
+static struct mem_type mem_types[] __ro_after_init = {
 	[MT_DEVICE] = {		  /* Strongly ordered / ARMv6 shared device */
 		.prot_pte	= PROT_PTE_DEVICE | L_PTE_MT_DEV_SHARED |
 				  L_PTE_SHARED,
-- 
2.21.0.rc0.269.g1a574e7a288b

