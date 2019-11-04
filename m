Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF4AEF149
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 00:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729904AbfKDXlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 18:41:21 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:39134 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729871AbfKDXlV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 18:41:21 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1iRlg1-00012v-EZ; Tue, 05 Nov 2019 00:22:26 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id A45E61C0105;
        Tue,  5 Nov 2019 00:22:24 +0100 (CET)
Date:   Mon, 04 Nov 2019 23:22:24 -0000
From:   "tip-bot2 for Jan Beulich" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/apic/32: Avoid bogus LDR warnings
Cc:     Jan Beulich <jbeulich@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <666d8f91-b5a8-1afd-7add-821e72a35f03@suse.com>
References: <666d8f91-b5a8-1afd-7add-821e72a35f03@suse.com>
MIME-Version: 1.0
Message-ID: <157290974421.29376.16287501451478726858.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     fe6f85ca121e9c74e7490fe66b0c5aae38e332c3
Gitweb:        https://git.kernel.org/tip/fe6f85ca121e9c74e7490fe66b0c5aae38e332c3
Author:        Jan Beulich <jbeulich@suse.com>
AuthorDate:    Tue, 29 Oct 2019 10:34:19 +01:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 05 Nov 2019 00:11:00 +01:00

x86/apic/32: Avoid bogus LDR warnings

The removal of the LDR initialization in the bigsmp_32 APIC code unearthed
a problem in setup_local_APIC().

The code checks unconditionally for a mismatch of the logical APIC id by
comparing the early APIC id which was initialized in get_smp_config() with
the actual LDR value in the APIC.

Due to the removal of the bogus LDR initialization the check now can
trigger on bigsmp_32 APIC systems emitting a warning for every booting
CPU. This is of course a false positive because the APIC is not using
logical destination mode.

Restrict the check and the possibly resulting fixup to systems which are
actually using the APIC in logical destination mode.

[ tglx: Massaged changelog and added Cc stable ]

Fixes: bae3a8d3308 ("x86/apic: Do not initialize LDR and DFR for bigsmp")
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/666d8f91-b5a8-1afd-7add-821e72a35f03@suse.com
---
 arch/x86/kernel/apic/apic.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 9e2dd2b..2b0faf8 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1586,9 +1586,6 @@ static void setup_local_APIC(void)
 {
 	int cpu = smp_processor_id();
 	unsigned int value;
-#ifdef CONFIG_X86_32
-	int logical_apicid, ldr_apicid;
-#endif
 
 	if (disable_apic) {
 		disable_ioapic_support();
@@ -1626,16 +1623,21 @@ static void setup_local_APIC(void)
 	apic->init_apic_ldr();
 
 #ifdef CONFIG_X86_32
-	/*
-	 * APIC LDR is initialized.  If logical_apicid mapping was
-	 * initialized during get_smp_config(), make sure it matches the
-	 * actual value.
-	 */
-	logical_apicid = early_per_cpu(x86_cpu_to_logical_apicid, cpu);
-	ldr_apicid = GET_APIC_LOGICAL_ID(apic_read(APIC_LDR));
-	WARN_ON(logical_apicid != BAD_APICID && logical_apicid != ldr_apicid);
-	/* always use the value from LDR */
-	early_per_cpu(x86_cpu_to_logical_apicid, cpu) = ldr_apicid;
+	if (apic->dest_logical) {
+		int logical_apicid, ldr_apicid;
+
+		/*
+		 * APIC LDR is initialized.  If logical_apicid mapping was
+		 * initialized during get_smp_config(), make sure it matches
+		 * the actual value.
+		 */
+		logical_apicid = early_per_cpu(x86_cpu_to_logical_apicid, cpu);
+		ldr_apicid = GET_APIC_LOGICAL_ID(apic_read(APIC_LDR));
+		if (logical_apicid != BAD_APICID)
+			WARN_ON(logical_apicid != ldr_apicid);
+		/* Always use the value from LDR. */
+		early_per_cpu(x86_cpu_to_logical_apicid, cpu) = ldr_apicid;
+	}
 #endif
 
 	/*
