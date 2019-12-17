Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE8EA122828
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 11:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbfLQKBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 05:01:24 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:54861 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727039AbfLQKBX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Dec 2019 05:01:23 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1ih9fB-0003qk-Hn; Tue, 17 Dec 2019 11:01:09 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 3E6311C2A30;
        Tue, 17 Dec 2019 11:01:09 +0100 (CET)
Date:   Tue, 17 Dec 2019 10:01:09 -0000
From:   "tip-bot2 for Konstantin Khlebnikov" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: ras/urgent] x86/MCE/AMD: Do not use rdmsr_safe_on_cpu() in
 smca_configure()
Cc:     Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Borislav Petkov <bp@suse.de>,
        Yazen Ghannam <yazen.ghannam@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "linux-edac" <linux-edac@vger.kernel.org>,
        <stable@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>, "x86-ml" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <157252708836.3876.4604398213417262402.stgit@buzz>
References: <157252708836.3876.4604398213417262402.stgit@buzz>
MIME-Version: 1.0
Message-ID: <157657686913.30329.12674595394156740801.tip-bot2@tip-bot2>
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

The following commit has been merged into the ras/urgent branch of tip:

Commit-ID:     246ff09f89e54fdf740a8d496176c86743db3ec7
Gitweb:        https://git.kernel.org/tip/246ff09f89e54fdf740a8d496176c86743db3ec7
Author:        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
AuthorDate:    Thu, 31 Oct 2019 16:04:48 +03:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Tue, 17 Dec 2019 09:39:33 +01:00

x86/MCE/AMD: Do not use rdmsr_safe_on_cpu() in smca_configure()

... because interrupts are disabled that early and sending IPIs can
deadlock:

  BUG: sleeping function called from invalid context at kernel/sched/completion.c:99
  in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 0, name: swapper/1
  no locks held by swapper/1/0.
  irq event stamp: 0
  hardirqs last  enabled at (0): [<0000000000000000>] 0x0
  hardirqs last disabled at (0): [<ffffffff8106dda9>] copy_process+0x8b9/0x1ca0
  softirqs last  enabled at (0): [<ffffffff8106dda9>] copy_process+0x8b9/0x1ca0
  softirqs last disabled at (0): [<0000000000000000>] 0x0
  Preemption disabled at:
  [<ffffffff8104703b>] start_secondary+0x3b/0x190
  CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.5.0-rc2+ #1
  Hardware name: GIGABYTE MZ01-CE1-00/MZ01-CE1-00, BIOS F02 08/29/2018
  Call Trace:
   dump_stack
   ___might_sleep.cold.92
   wait_for_completion
   ? generic_exec_single
   rdmsr_safe_on_cpu
   ? wrmsr_on_cpus
   mce_amd_feature_init
   mcheck_cpu_init
   identify_cpu
   identify_secondary_cpu
   smp_store_cpu_info
   start_secondary
   secondary_startup_64

The function smca_configure() is called only on the current CPU anyway,
therefore replace rdmsr_safe_on_cpu() with atomic rdmsr_safe() and avoid
the IPI.

 [ bp: Update commit message. ]

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Yazen Ghannam <yazen.ghannam@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: linux-edac <linux-edac@vger.kernel.org>
Cc: <stable@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/157252708836.3876.4604398213417262402.stgit@buzz
---
 arch/x86/kernel/cpu/mce/amd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mce/amd.c b/arch/x86/kernel/cpu/mce/amd.c
index 5167bd2..e41e3b4 100644
--- a/arch/x86/kernel/cpu/mce/amd.c
+++ b/arch/x86/kernel/cpu/mce/amd.c
@@ -269,7 +269,7 @@ static void smca_configure(unsigned int bank, unsigned int cpu)
 	if (smca_banks[bank].hwid)
 		return;
 
-	if (rdmsr_safe_on_cpu(cpu, MSR_AMD64_SMCA_MCx_IPID(bank), &low, &high)) {
+	if (rdmsr_safe(MSR_AMD64_SMCA_MCx_IPID(bank), &low, &high)) {
 		pr_warn("Failed to read MCA_IPID for bank %d\n", bank);
 		return;
 	}
