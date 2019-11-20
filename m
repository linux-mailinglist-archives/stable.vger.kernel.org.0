Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18C52103F5C
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 16:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729531AbfKTPnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 10:43:16 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52784 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730021AbfKTPkT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 10:40:19 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5U-0004aq-P0; Wed, 20 Nov 2019 15:40:12 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5U-0004Ja-EE; Wed, 20 Nov 2019 15:40:12 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Bandan Das" <bsd@redhat.com>
Date:   Wed, 20 Nov 2019 15:38:01 +0000
Message-ID: <lsq.1574264230.42299582@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 51/83] x86/apic: Do not initialize LDR and DFR for bigsmp
In-Reply-To: <lsq.1574264230.280218497@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.78-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Bandan Das <bsd@redhat.com>

commit bae3a8d3308ee69a7dbdf145911b18dfda8ade0d upstream.

Legacy apic init uses bigsmp for smp systems with 8 and more CPUs. The
bigsmp APIC implementation uses physical destination mode, but it
nevertheless initializes LDR and DFR. The LDR even ends up incorrectly with
multiple bit being set.

This does not cause a functional problem because LDR and DFR are ignored
when physical destination mode is active, but it triggered a problem on a
32-bit KVM guest which jumps into a kdump kernel.

The multiple bits set unearthed a bug in the KVM APIC implementation. The
code which creates the logical destination map for VCPUs ignores the
disabled state of the APIC and ends up overwriting an existing valid entry
and as a result, APIC calibration hangs in the guest during kdump
initialization.

Remove the bogus LDR/DFR initialization.

This is not intended to work around the KVM APIC bug. The LDR/DFR
ininitalization is wrong on its own.

The issue goes back into the pre git history. The fixes tag is the commit
in the bitkeeper import which introduced bigsmp support in 2003.

  git://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git

Fixes: db7b9e9f26b8 ("[PATCH] Clustered APIC setup for >8 CPU systems")
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Bandan Das <bsd@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20190826101513.5080-2-bsd@redhat.com
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/apic/bigsmp_32.c | 24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -42,32 +42,12 @@ static int bigsmp_early_logical_apicid(i
 	return early_per_cpu(x86_cpu_to_apicid, cpu);
 }
 
-static inline unsigned long calculate_ldr(int cpu)
-{
-	unsigned long val, id;
-
-	val = apic_read(APIC_LDR) & ~APIC_LDR_MASK;
-	id = per_cpu(x86_bios_cpu_apicid, cpu);
-	val |= SET_APIC_LOGICAL_ID(id);
-
-	return val;
-}
-
 /*
- * Set up the logical destination ID.
- *
- * Intel recommends to set DFR, LDR and TPR before enabling
- * an APIC.  See e.g. "AP-388 82489DX User's Manual" (Intel
- * document number 292116).  So here it goes...
+ * bigsmp enables physical destination mode
+ * and doesn't use LDR and DFR
  */
 static void bigsmp_init_apic_ldr(void)
 {
-	unsigned long val;
-	int cpu = smp_processor_id();
-
-	apic_write(APIC_DFR, APIC_DFR_FLAT);
-	val = calculate_ldr(cpu);
-	apic_write(APIC_LDR, val);
 }
 
 static void bigsmp_setup_apic_routing(void)

