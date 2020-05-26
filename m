Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 997001E2E64
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390159AbgEZTAt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:00:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:54976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390100AbgEZTAr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:00:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54CBF2086A;
        Tue, 26 May 2020 19:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519646;
        bh=e2yRorie/hUvGwWW+HymHQzWDy1WnXElmChHQ6bhDf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ub/rdyAksHVcMGMAxZMxOCcbttQ7P4qBn/OSRdUFAzat/pav20nEQW/Zb/uJBK9MQ
         DZxhw7icsTAfzntePybKlbZSuEXVfAhQ25PY4refcPqG6HNo1h6qZvAzKb6X1pQWk0
         HJRb6o3FIPzhJSuNRVpiOet834s+ccJTSZsiJKdc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 20/59] x86/apic: Move TSC deadline timer debug printk
Date:   Tue, 26 May 2020 20:53:05 +0200
Message-Id: <20200526183914.948609927@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183907.123822792@linuxfoundation.org>
References: <20200526183907.123822792@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit c84cb3735fd53c91101ccdb191f2e3331a9262cb ]

Leon reported that the printk_once() in __setup_APIC_LVTT() triggers a
lockdep splat due to a lock order violation between hrtimer_base::lock and
console_sem, when the 'once' condition is reset via
/sys/kernel/debug/clear_warn_once after boot.

The initial printk cannot trigger this because that happens during boot
when the local APIC timer is set up on the boot CPU.

Prevent it by moving the printk to a place which is guaranteed to be only
called once during boot.

Mark the deadline timer check related functions and data __init while at
it.

Reported-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/87y2qhoshi.fsf@nanos.tec.linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/apic/apic.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 6415b4aead54..48ab5fdd1044 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -353,8 +353,6 @@ static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
 		 * According to Intel, MFENCE can do the serialization here.
 		 */
 		asm volatile("mfence" : : : "memory");
-
-		printk_once(KERN_DEBUG "TSC deadline timer enabled\n");
 		return;
 	}
 
@@ -553,7 +551,7 @@ static DEFINE_PER_CPU(struct clock_event_device, lapic_events);
 #define DEADLINE_MODEL_MATCH_REV(model, rev)	\
 	{ X86_VENDOR_INTEL, 6, model, X86_FEATURE_ANY, (unsigned long)rev }
 
-static u32 hsx_deadline_rev(void)
+static __init u32 hsx_deadline_rev(void)
 {
 	switch (boot_cpu_data.x86_stepping) {
 	case 0x02: return 0x3a; /* EP */
@@ -563,7 +561,7 @@ static u32 hsx_deadline_rev(void)
 	return ~0U;
 }
 
-static u32 bdx_deadline_rev(void)
+static __init u32 bdx_deadline_rev(void)
 {
 	switch (boot_cpu_data.x86_stepping) {
 	case 0x02: return 0x00000011;
@@ -575,7 +573,7 @@ static u32 bdx_deadline_rev(void)
 	return ~0U;
 }
 
-static u32 skx_deadline_rev(void)
+static __init u32 skx_deadline_rev(void)
 {
 	switch (boot_cpu_data.x86_stepping) {
 	case 0x03: return 0x01000136;
@@ -588,7 +586,7 @@ static u32 skx_deadline_rev(void)
 	return ~0U;
 }
 
-static const struct x86_cpu_id deadline_match[] = {
+static const struct x86_cpu_id deadline_match[] __initconst = {
 	DEADLINE_MODEL_MATCH_FUNC( INTEL_FAM6_HASWELL_X,	hsx_deadline_rev),
 	DEADLINE_MODEL_MATCH_REV ( INTEL_FAM6_BROADWELL_X,	0x0b000020),
 	DEADLINE_MODEL_MATCH_FUNC( INTEL_FAM6_BROADWELL_XEON_D,	bdx_deadline_rev),
@@ -610,18 +608,19 @@ static const struct x86_cpu_id deadline_match[] = {
 	{},
 };
 
-static void apic_check_deadline_errata(void)
+static __init bool apic_validate_deadline_timer(void)
 {
 	const struct x86_cpu_id *m;
 	u32 rev;
 
-	if (!boot_cpu_has(X86_FEATURE_TSC_DEADLINE_TIMER) ||
-	    boot_cpu_has(X86_FEATURE_HYPERVISOR))
-		return;
+	if (!boot_cpu_has(X86_FEATURE_TSC_DEADLINE_TIMER))
+		return false;
+	if (boot_cpu_has(X86_FEATURE_HYPERVISOR))
+		return true;
 
 	m = x86_match_cpu(deadline_match);
 	if (!m)
-		return;
+		return true;
 
 	/*
 	 * Function pointers will have the MSB set due to address layout,
@@ -633,11 +632,12 @@ static void apic_check_deadline_errata(void)
 		rev = (u32)m->driver_data;
 
 	if (boot_cpu_data.microcode >= rev)
-		return;
+		return true;
 
 	setup_clear_cpu_cap(X86_FEATURE_TSC_DEADLINE_TIMER);
 	pr_err(FW_BUG "TSC_DEADLINE disabled due to Errata; "
 	       "please update microcode to version: 0x%x (or later)\n", rev);
+	return false;
 }
 
 /*
@@ -1914,7 +1914,8 @@ void __init init_apic_mappings(void)
 {
 	unsigned int new_apicid;
 
-	apic_check_deadline_errata();
+	if (apic_validate_deadline_timer())
+		pr_debug("TSC deadline timer available\n");
 
 	if (x2apic_mode) {
 		boot_cpu_physical_apicid = read_apic_id();
-- 
2.25.1



