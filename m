Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B47F304AC6
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730416AbhAZE7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:59:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:37712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731092AbhAYSuc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:50:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3495A20758;
        Mon, 25 Jan 2021 18:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600591;
        bh=Y0y4RiRCOTkbxzR1OuKcUy8g7sjPnEEbdSQgPF7jO/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vcjXxJCO5osr7BTEnFw+nds5NncQKb3yvmPHLnDAklvC+Km8JOLimtJsNV3I031RV
         uYeS+fbElo+Pdv9K1rX1G/SaFOWHDlIZMbiYhfD9CY1zXU2p49ZGAh+DGdgBW1ZZzM
         RRt6PiGW7jyfy97f1txx6j2x5ImXofQexDbbCXlk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Woodhouse <dwmw@amazon.co.uk>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 057/199] x86/xen: Fix xen_hvm_smp_init() when vector callback not available
Date:   Mon, 25 Jan 2021 19:37:59 +0100
Message-Id: <20210125183218.669824593@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

[ Upstream commit 3d7746bea92530e8695258a3cf3ddec7a135edd6 ]

Only the IPI-related functions in the smp_ops should be conditional
on the vector callback being available. The rest should still happen:

 • xen_hvm_smp_prepare_boot_cpu()

   This function does two things, both of which should still happen if
   there is no vector callback support.

   The call to xen_vcpu_setup() for vCPU0 should still happen as it just
   sets up the vcpu_info for CPU0. That does happen for the secondary
   vCPUs too, from xen_cpu_up_prepare_hvm().

   The second thing it does is call xen_init_spinlocks(), which perhaps
   counter-intuitively should *also* still be happening in the case
   without vector callbacks, so that it can clear its local xen_pvspin
   flag and disable the virt_spin_lock_key accordingly.

   Checking xen_have_vector_callback in xen_init_spinlocks() itself
   would affect PV guests, so set the global nopvspin flag in
   xen_hvm_smp_init() instead, when vector callbacks aren't available.

 • xen_hvm_smp_prepare_cpus()

   This does some IPI-related setup by calling xen_smp_intr_init() and
   xen_init_lock_cpu(), which can be made conditional. And it sets the
   xen_vcpu_id to XEN_VCPU_ID_INVALID for all possible CPUS, which does
   need to happen.

 • xen_smp_cpus_done()

   This offlines any vCPUs which doesn't fit in the global shared_info
   page, if separate vcpu_info placement isn't available. That part also
   needs to happen regardless of vector callback support.

 • xen_hvm_cpu_die()

   This doesn't actually do anything other than commin_cpu_die() right
   right now in the !vector_callback case; all three teardown functions
   it calls should be no-ops. But to guard against future regressions
   it's useful to call it anyway, and for it to explicitly check for
   xen_have_vector_callback before calling those additional functions.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: https://lore.kernel.org/r/20210106153958.584169-6-dwmw2@infradead.org
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/smp_hvm.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/arch/x86/xen/smp_hvm.c b/arch/x86/xen/smp_hvm.c
index f5e7db4f82abb..056430a1080bb 100644
--- a/arch/x86/xen/smp_hvm.c
+++ b/arch/x86/xen/smp_hvm.c
@@ -33,9 +33,11 @@ static void __init xen_hvm_smp_prepare_cpus(unsigned int max_cpus)
 	int cpu;
 
 	native_smp_prepare_cpus(max_cpus);
-	WARN_ON(xen_smp_intr_init(0));
 
-	xen_init_lock_cpu(0);
+	if (xen_have_vector_callback) {
+		WARN_ON(xen_smp_intr_init(0));
+		xen_init_lock_cpu(0);
+	}
 
 	for_each_possible_cpu(cpu) {
 		if (cpu == 0)
@@ -50,9 +52,11 @@ static void __init xen_hvm_smp_prepare_cpus(unsigned int max_cpus)
 static void xen_hvm_cpu_die(unsigned int cpu)
 {
 	if (common_cpu_die(cpu) == 0) {
-		xen_smp_intr_free(cpu);
-		xen_uninit_lock_cpu(cpu);
-		xen_teardown_timer(cpu);
+		if (xen_have_vector_callback) {
+			xen_smp_intr_free(cpu);
+			xen_uninit_lock_cpu(cpu);
+			xen_teardown_timer(cpu);
+		}
 	}
 }
 #else
@@ -64,14 +68,17 @@ static void xen_hvm_cpu_die(unsigned int cpu)
 
 void __init xen_hvm_smp_init(void)
 {
-	if (!xen_have_vector_callback)
+	smp_ops.smp_prepare_boot_cpu = xen_hvm_smp_prepare_boot_cpu;
+	smp_ops.smp_prepare_cpus = xen_hvm_smp_prepare_cpus;
+	smp_ops.smp_cpus_done = xen_smp_cpus_done;
+	smp_ops.cpu_die = xen_hvm_cpu_die;
+
+	if (!xen_have_vector_callback) {
+		nopvspin = true;
 		return;
+	}
 
-	smp_ops.smp_prepare_cpus = xen_hvm_smp_prepare_cpus;
 	smp_ops.smp_send_reschedule = xen_smp_send_reschedule;
-	smp_ops.cpu_die = xen_hvm_cpu_die;
 	smp_ops.send_call_func_ipi = xen_smp_send_call_function_ipi;
 	smp_ops.send_call_func_single_ipi = xen_smp_send_call_function_single_ipi;
-	smp_ops.smp_prepare_boot_cpu = xen_hvm_smp_prepare_boot_cpu;
-	smp_ops.smp_cpus_done = xen_smp_cpus_done;
 }
-- 
2.27.0



