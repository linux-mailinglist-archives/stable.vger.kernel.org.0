Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC0095EF135
	for <lists+stable@lfdr.de>; Thu, 29 Sep 2022 11:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235080AbiI2JEQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 05:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235062AbiI2JEP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 05:04:15 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A0F138F08;
        Thu, 29 Sep 2022 02:04:13 -0700 (PDT)
Date:   Thu, 29 Sep 2022 09:04:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1664442250;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W4VtPc3IUbEA1iZLSCZHOROAem8/WmUPd60NhJr4UTI=;
        b=STyWG2ig2DPzX1N9FbbKqnbso4i7Zm4gjooKPt7iOUWb7eJY7b1yw/aDioyr2oKnCdGKmM
        rzAf3dJX5pHw/iYNnn4nNeYwrgR0Jl6KZiyUflS8j2sh8Q2UysBgVw0IstIgWGFgxpWPi6
        UOXfmG9fOPshspSz88NmaJHzxgURnxcledH/CvII+He4BOtweAG1Ei5qQYy30MzfwJ4xnf
        Ay2AQokbMCmeb5FIQzcpO0I7TSIVY96FvYjQKlL71d9F6R8R3jKHMQjN3UehpoujYrQnHy
        x1+DwXs0s6I1GlOIwQFWfUAKi5yJC0wsToa5enXUo2Spq5ljUrxl2nnizzNx3w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1664442250;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W4VtPc3IUbEA1iZLSCZHOROAem8/WmUPd60NhJr4UTI=;
        b=xycAQUARueWj7+9o4Ud0ooklqmXvWqgoupJJfqC2sr/4XgyAKrEmPvXCkWMNjojCDBEA7t
        g1r7c1K5AZAlRSAA==
From:   "tip-bot2 for Borislav Petkov" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/cacheinfo: Add a cpu_llc_shared_mask() UP variant
Cc:     Saurabh Sengar <ssengar@linux.microsoft.com>,
        Borislav Petkov <bp@suse.de>, <stable@vger.kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1660148115-302-1-git-send-email-ssengar@linux.microsoft.com>
References: <1660148115-302-1-git-send-email-ssengar@linux.microsoft.com>
MIME-Version: 1.0
Message-ID: <166444224911.401.15542526000823963244.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     df5b035b5683d6a25f077af889fb88e09827f8bc
Gitweb:        https://git.kernel.org/tip/df5b035b5683d6a25f077af889fb88e09827f8bc
Author:        Borislav Petkov <bp@suse.de>
AuthorDate:    Fri, 19 Aug 2022 19:47:44 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Wed, 28 Sep 2022 18:35:37 +02:00

x86/cacheinfo: Add a cpu_llc_shared_mask() UP variant

On a CONFIG_SMP=n kernel, the LLC shared mask is 0, which prevents
__cache_amd_cpumap_setup() from doing the L3 masks setup, and more
specifically from setting up the shared_cpu_map and shared_cpu_list
files in sysfs, leading to lscpu from util-linux getting confused and
segfaulting.

Add a cpu_llc_shared_mask() UP variant which returns a mask with a
single bit set, i.e., for CPU0.

Fixes: 2b83809a5e6d ("x86/cpu/amd: Derive L3 shared_cpu_map from cpu_llc_shared_mask")
Reported-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1660148115-302-1-git-send-email-ssengar@linux.microsoft.com
---
 arch/x86/include/asm/smp.h | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 81a0211..a73bced 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -21,16 +21,6 @@ DECLARE_PER_CPU_READ_MOSTLY(u16, cpu_llc_id);
 DECLARE_PER_CPU_READ_MOSTLY(u16, cpu_l2c_id);
 DECLARE_PER_CPU_READ_MOSTLY(int, cpu_number);
 
-static inline struct cpumask *cpu_llc_shared_mask(int cpu)
-{
-	return per_cpu(cpu_llc_shared_map, cpu);
-}
-
-static inline struct cpumask *cpu_l2c_shared_mask(int cpu)
-{
-	return per_cpu(cpu_l2c_shared_map, cpu);
-}
-
 DECLARE_EARLY_PER_CPU_READ_MOSTLY(u16, x86_cpu_to_apicid);
 DECLARE_EARLY_PER_CPU_READ_MOSTLY(u32, x86_cpu_to_acpiid);
 DECLARE_EARLY_PER_CPU_READ_MOSTLY(u16, x86_bios_cpu_apicid);
@@ -172,6 +162,16 @@ extern int safe_smp_processor_id(void);
 # define safe_smp_processor_id()	smp_processor_id()
 #endif
 
+static inline struct cpumask *cpu_llc_shared_mask(int cpu)
+{
+	return per_cpu(cpu_llc_shared_map, cpu);
+}
+
+static inline struct cpumask *cpu_l2c_shared_mask(int cpu)
+{
+	return per_cpu(cpu_l2c_shared_map, cpu);
+}
+
 #else /* !CONFIG_SMP */
 #define wbinvd_on_cpu(cpu)     wbinvd()
 static inline int wbinvd_on_all_cpus(void)
@@ -179,6 +179,11 @@ static inline int wbinvd_on_all_cpus(void)
 	wbinvd();
 	return 0;
 }
+
+static inline struct cpumask *cpu_llc_shared_mask(int cpu)
+{
+	return (struct cpumask *)cpumask_of(0);
+}
 #endif /* CONFIG_SMP */
 
 extern unsigned disabled_cpus;
