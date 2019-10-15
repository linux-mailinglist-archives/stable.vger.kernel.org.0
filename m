Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93DA6D71B8
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 11:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729510AbfJOJCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 05:02:19 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:43044 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728896AbfJOJCN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Oct 2019 05:02:13 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1iKIiU-0004Sd-G1; Tue, 15 Oct 2019 11:02:06 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 1F3961C0105;
        Tue, 15 Oct 2019 11:02:06 +0200 (CEST)
Date:   Tue, 15 Oct 2019 09:02:05 -0000
From:   "tip-bot2 for Sean Christopherson" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/apic/x2apic: Fix a NULL pointer deref when
 handling a dying cpu
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20191001205019.5789-1-sean.j.christopherson@intel.com>
References: <20191001205019.5789-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Message-ID: <157113012595.12254.4819420610843563041.tip-bot2@tip-bot2>
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

Commit-ID:     7a22e03b0c02988e91003c505b34d752a51de344
Gitweb:        https://git.kernel.org/tip/7a22e03b0c02988e91003c505b34d752a51de344
Author:        Sean Christopherson <sean.j.christopherson@intel.com>
AuthorDate:    Tue, 01 Oct 2019 13:50:19 -07:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 15 Oct 2019 10:57:09 +02:00

x86/apic/x2apic: Fix a NULL pointer deref when handling a dying cpu

Check that the per-cpu cluster mask pointer has been set prior to
clearing a dying cpu's bit.  The per-cpu pointer is not set until the
target cpu reaches smp_callin() during CPUHP_BRINGUP_CPU, whereas the
teardown function, x2apic_dead_cpu(), is associated with the earlier
CPUHP_X2APIC_PREPARE.  If an error occurs before the cpu is awakened,
e.g. if do_boot_cpu() itself fails, x2apic_dead_cpu() will dereference
the NULL pointer and cause a panic.

  smpboot: do_boot_cpu failed(-22) to wakeup CPU#1
  BUG: kernel NULL pointer dereference, address: 0000000000000008
  RIP: 0010:x2apic_dead_cpu+0x1a/0x30
  Call Trace:
   cpuhp_invoke_callback+0x9a/0x580
   _cpu_up+0x10d/0x140
   do_cpu_up+0x69/0xb0
   smp_init+0x63/0xa9
   kernel_init_freeable+0xd7/0x229
   ? rest_init+0xa0/0xa0
   kernel_init+0xa/0x100
   ret_from_fork+0x35/0x40

Fixes: 023a611748fd5 ("x86/apic/x2apic: Simplify cluster management")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20191001205019.5789-1-sean.j.christopherson@intel.com

---
 arch/x86/kernel/apic/x2apic_cluster.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 45e92cb..b0889c4 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -156,7 +156,8 @@ static int x2apic_dead_cpu(unsigned int dead_cpu)
 {
 	struct cluster_mask *cmsk = per_cpu(cluster_masks, dead_cpu);
 
-	cpumask_clear_cpu(dead_cpu, &cmsk->mask);
+	if (cmsk)
+		cpumask_clear_cpu(dead_cpu, &cmsk->mask);
 	free_cpumask_var(per_cpu(ipi_mask, dead_cpu));
 	return 0;
 }
