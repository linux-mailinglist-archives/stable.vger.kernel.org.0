Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD0909D358
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 17:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbfHZPut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 11:50:49 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:40551 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727548AbfHZPut (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Aug 2019 11:50:49 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1i2HGX-0008Gb-He; Mon, 26 Aug 2019 17:50:45 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 10D411C0DAE;
        Mon, 26 Aug 2019 17:50:45 +0200 (CEST)
Date:   Mon, 26 Aug 2019 15:50:44 -0000
From:   tip-bot2 for Bandan Das <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/apic: Do not initialize LDR and DFR for bigsmp
Cc:     Thomas Gleixner <tglx@linutronix.de>, Bandan Das <bsd@redhat.com>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <r20190826101513.5080-2-bsd@redhat.com>
References: <r20190826101513.5080-2-bsd@redhat.com>
MIME-Version: 1.0
Message-ID: <156683464488.2617.2972249639441435121.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     9cfe98a6dbfb2a72ae29831e57b406eab7668da8
Gitweb:        https://git.kernel.org/tip/9cfe98a6dbfb2a72ae29831e57b406eab7668da8
Author:        Bandan Das <bsd@redhat.com>
AuthorDate:    Mon, 26 Aug 2019 06:15:12 -04:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Mon, 26 Aug 2019 17:45:22 +02:00

x86/apic: Do not initialize LDR and DFR for bigsmp

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
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r20190826101513.5080-2-bsd@redhat.com

---
 arch/x86/kernel/apic/bigsmp_32.c | 24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index afee386..caedd8d 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -38,32 +38,12 @@ static int bigsmp_early_logical_apicid(int cpu)
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
