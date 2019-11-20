Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58AEB103EF9
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 16:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731869AbfKTPkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 10:40:20 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52924 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731711AbfKTPkU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 10:40:20 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5U-0004ak-PR; Wed, 20 Nov 2019 15:40:12 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5U-0004Jg-FB; Wed, 20 Nov 2019 15:40:12 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        ebiederm@xmission.com, andy.shevchenko@gmail.com,
        "Dou Liyang" <douly.fnst@cn.fujitsu.com>,
        "Thomas Gleixner" <tglx@linutronix.de>, bhe@redhat.com
Date:   Wed, 20 Nov 2019 15:38:02 +0000
Message-ID: <lsq.1574264230.401530484@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 52/83] x86/apic: Drop logical_smp_processor_id() inline
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

From: Dou Liyang <douly.fnst@cn.fujitsu.com>

commit 8f1561680f42a5491b371b513f1ab8197f31fd62 upstream.

The logical_smp_processor_id() inline which is only called in
setup_local_APIC() on x86_32 systems has no real value.

Drop it and directly use GET_APIC_LOGICAL_ID() at the call site and use a
more suitable variable name for readability

Signed-off-by: Dou Liyang <douly.fnst@cn.fujitsu.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: andy.shevchenko@gmail.com
Cc: bhe@redhat.com
Cc: ebiederm@xmission.com
Link: https://lkml.kernel.org/r/20180301055930.2396-4-douly.fnst@cn.fujitsu.com
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -203,16 +203,6 @@ extern int safe_smp_processor_id(void);
 #endif
 
 #ifdef CONFIG_X86_LOCAL_APIC
-
-#ifndef CONFIG_X86_64
-static inline int logical_smp_processor_id(void)
-{
-	/* we don't want to mark this access volatile - bad code generation */
-	return GET_APIC_LOGICAL_ID(apic_read(APIC_LDR));
-}
-
-#endif
-
 extern int hard_smp_processor_id(void);
 
 #else /* CONFIG_X86_LOCAL_APIC */
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1305,6 +1305,9 @@ void setup_local_APIC(void)
 	int i, j, acked = 0;
 	unsigned long long tsc = 0, ntsc;
 	long long max_loops = cpu_khz ? cpu_khz : 1000000;
+#ifdef CONFIG_X86_32
+	int logical_apicid, ldr_apicid;
+#endif
 
 	if (cpu_has_tsc)
 		rdtscll(tsc);
@@ -1344,11 +1347,11 @@ void setup_local_APIC(void)
 	 * initialized during get_smp_config(), make sure it matches the
 	 * actual value.
 	 */
-	i = early_per_cpu(x86_cpu_to_logical_apicid, cpu);
-	WARN_ON(i != BAD_APICID && i != logical_smp_processor_id());
+	logical_apicid = early_per_cpu(x86_cpu_to_logical_apicid, cpu);
+	ldr_apicid = GET_APIC_LOGICAL_ID(apic_read(APIC_LDR));
+	WARN_ON(logical_apicid != BAD_APICID && logical_apicid != ldr_apicid);
 	/* always use the value from LDR */
-	early_per_cpu(x86_cpu_to_logical_apicid, cpu) =
-		logical_smp_processor_id();
+	early_per_cpu(x86_cpu_to_logical_apicid, cpu) = ldr_apicid;
 
 	/*
 	 * Some NUMA implementations (NUMAQ) don't initialize apicid to

