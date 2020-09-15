Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF6D526AB82
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 20:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbgIOSI7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 14:08:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:60824 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727954AbgIOSIS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 14:08:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5B5B8B302;
        Tue, 15 Sep 2020 18:07:30 +0000 (UTC)
From:   Michal Suchanek <msuchanek@suse.de>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Michal Suchanek <msuchanek@suse.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Santosh Sivaraj <santosh@fossix.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Ganesh Goudar <ganeshgr@linux.ibm.com>,
        Mahesh Salgaonkar <mahesh@linux.ibm.com>,
        Alistair Popple <alistair@popple.id.au>,
        Jordan Niethe <jniethe5@gmail.com>,
        Mike Rapoport <rppt@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] Revert "powerpc/64s: machine check interrupt update NMI accounting"
Date:   Tue, 15 Sep 2020 20:06:59 +0200
Message-Id: <20200915180659.12503-1-msuchanek@suse.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915084302.GG29778@kitsune.suse.cz>
References: <20200915084302.GG29778@kitsune.suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 116ac378bb3ff844df333e7609e7604651a0db9d.

This commit causes the kernel to oops and reboot when injecting a SLB
multihit which causes a MCE.

Before this commit a SLB multihit was corrected by the kernel and the
system continued to operate normally.

cc: stable@vger.kernel.org
Fixes: 116ac378bb3f ("powerpc/64s: machine check interrupt update NMI accounting")
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
 arch/powerpc/kernel/mce.c   |  7 -------
 arch/powerpc/kernel/traps.c | 18 +++---------------
 2 files changed, 3 insertions(+), 22 deletions(-)

diff --git a/arch/powerpc/kernel/mce.c b/arch/powerpc/kernel/mce.c
index ada59f6c4298..2e13528dcc92 100644
--- a/arch/powerpc/kernel/mce.c
+++ b/arch/powerpc/kernel/mce.c
@@ -591,14 +591,10 @@ EXPORT_SYMBOL_GPL(machine_check_print_event_info);
 long notrace machine_check_early(struct pt_regs *regs)
 {
 	long handled = 0;
-	bool nested = in_nmi();
 	u8 ftrace_enabled = this_cpu_get_ftrace_enabled();
 
 	this_cpu_set_ftrace_enabled(0);
 
-	if (!nested)
-		nmi_enter();
-
 	hv_nmi_check_nonrecoverable(regs);
 
 	/*
@@ -607,9 +603,6 @@ long notrace machine_check_early(struct pt_regs *regs)
 	if (ppc_md.machine_check_early)
 		handled = ppc_md.machine_check_early(regs);
 
-	if (!nested)
-		nmi_exit();
-
 	this_cpu_set_ftrace_enabled(ftrace_enabled);
 
 	return handled;
diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index d1ebe152f210..7853b770918d 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -827,19 +827,7 @@ void machine_check_exception(struct pt_regs *regs)
 {
 	int recover = 0;
 
-	/*
-	 * BOOK3S_64 does not call this handler as a non-maskable interrupt
-	 * (it uses its own early real-mode handler to handle the MCE proper
-	 * and then raises irq_work to call this handler when interrupts are
-	 * enabled).
-	 *
-	 * This is silly. The BOOK3S_64 should just call a different function
-	 * rather than expecting semantics to magically change. Something
-	 * like 'non_nmi_machine_check_exception()', perhaps?
-	 */
-	const bool nmi = !IS_ENABLED(CONFIG_PPC_BOOK3S_64);
-
-	if (nmi) nmi_enter();
+	nmi_enter();
 
 	__this_cpu_inc(irq_stat.mce_exceptions);
 
@@ -865,7 +853,7 @@ void machine_check_exception(struct pt_regs *regs)
 	if (check_io_access(regs))
 		goto bail;
 
-	if (nmi) nmi_exit();
+	nmi_exit();
 
 	die("Machine check", regs, SIGBUS);
 
@@ -876,7 +864,7 @@ void machine_check_exception(struct pt_regs *regs)
 	return;
 
 bail:
-	if (nmi) nmi_exit();
+	nmi_exit();
 }
 
 void SMIException(struct pt_regs *regs)
-- 
2.28.0

