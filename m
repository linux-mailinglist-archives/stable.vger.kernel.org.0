Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2BC441115F
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 10:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbhITIxR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 04:53:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:47260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229844AbhITIxR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 04:53:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3672C601FF;
        Mon, 20 Sep 2021 08:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632127910;
        bh=m3Kw9M2qYf1OFGq0vLhHKpDUUL00JCF7TV3TDk446jc=;
        h=Subject:To:Cc:From:Date:From;
        b=pkJ5KCsFLarfCRF+GudXWqJi2+WykFbqOba1NBzCQ7+P1KyN+SJRhsl9uuFJ5qBjF
         iC88u3v7PUH+nUAWBqigOSuw2Ml7gMUXslqBWCA9cgCfUbUR6u9NY0TSHvlD9eNf4Z
         Xaw/YnD5CVxIRfVR2Jbu0MWSSh7/1d1NsKQj8f6o=
Subject: FAILED: patch "[PATCH] x86/hyperv: remove on-stack cpumask from" failed to apply to 5.4-stable tree
To:     wei.liu@kernel.org, mikelley@microsoft.com,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Sep 2021 10:51:38 +0200
Message-ID: <163212789813160@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From dfb5c1e12c28e35e4d4e5bc8022b0e9d585b89a7 Mon Sep 17 00:00:00 2001
From: Wei Liu <wei.liu@kernel.org>
Date: Fri, 10 Sep 2021 18:57:14 +0000
Subject: [PATCH] x86/hyperv: remove on-stack cpumask from
 hv_send_ipi_mask_allbutself

It is not a good practice to allocate a cpumask on stack, given it may
consume up to 1 kilobytes of stack space if the kernel is configured to
have 8192 cpus.

The internal helper functions __send_ipi_mask{,_ex} need to loop over
the provided mask anyway, so it is not too difficult to skip `self'
there. We can thus do away with the on-stack cpumask in
hv_send_ipi_mask_allbutself.

Adjust call sites of __send_ipi_mask as needed.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Suggested-by: Michael Kelley <mikelley@microsoft.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Fixes: 68bb7bfb7985d ("X86/Hyper-V: Enable IPI enlightenments")
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/20210910185714.299411-3-wei.liu@kernel.org

diff --git a/arch/x86/hyperv/hv_apic.c b/arch/x86/hyperv/hv_apic.c
index 90e682a92820..32a1ad356c18 100644
--- a/arch/x86/hyperv/hv_apic.c
+++ b/arch/x86/hyperv/hv_apic.c
@@ -99,7 +99,8 @@ static void hv_apic_eoi_write(u32 reg, u32 val)
 /*
  * IPI implementation on Hyper-V.
  */
-static bool __send_ipi_mask_ex(const struct cpumask *mask, int vector)
+static bool __send_ipi_mask_ex(const struct cpumask *mask, int vector,
+		bool exclude_self)
 {
 	struct hv_send_ipi_ex **arg;
 	struct hv_send_ipi_ex *ipi_arg;
@@ -123,7 +124,10 @@ static bool __send_ipi_mask_ex(const struct cpumask *mask, int vector)
 
 	if (!cpumask_equal(mask, cpu_present_mask)) {
 		ipi_arg->vp_set.format = HV_GENERIC_SET_SPARSE_4K;
-		nr_bank = cpumask_to_vpset(&(ipi_arg->vp_set), mask);
+		if (exclude_self)
+			nr_bank = cpumask_to_vpset_noself(&(ipi_arg->vp_set), mask);
+		else
+			nr_bank = cpumask_to_vpset(&(ipi_arg->vp_set), mask);
 	}
 	if (nr_bank < 0)
 		goto ipi_mask_ex_done;
@@ -138,15 +142,25 @@ static bool __send_ipi_mask_ex(const struct cpumask *mask, int vector)
 	return hv_result_success(status);
 }
 
-static bool __send_ipi_mask(const struct cpumask *mask, int vector)
+static bool __send_ipi_mask(const struct cpumask *mask, int vector,
+		bool exclude_self)
 {
-	int cur_cpu, vcpu;
+	int cur_cpu, vcpu, this_cpu = smp_processor_id();
 	struct hv_send_ipi ipi_arg;
 	u64 status;
+	unsigned int weight;
 
 	trace_hyperv_send_ipi_mask(mask, vector);
 
-	if (cpumask_empty(mask))
+	weight = cpumask_weight(mask);
+
+	/*
+	 * Do nothing if
+	 *   1. the mask is empty
+	 *   2. the mask only contains self when exclude_self is true
+	 */
+	if (weight == 0 ||
+	    (exclude_self && weight == 1 && cpumask_test_cpu(this_cpu, mask)))
 		return true;
 
 	if (!hv_hypercall_pg)
@@ -172,6 +186,8 @@ static bool __send_ipi_mask(const struct cpumask *mask, int vector)
 	ipi_arg.cpu_mask = 0;
 
 	for_each_cpu(cur_cpu, mask) {
+		if (exclude_self && cur_cpu == this_cpu)
+			continue;
 		vcpu = hv_cpu_number_to_vp_number(cur_cpu);
 		if (vcpu == VP_INVAL)
 			return false;
@@ -191,7 +207,7 @@ static bool __send_ipi_mask(const struct cpumask *mask, int vector)
 	return hv_result_success(status);
 
 do_ex_hypercall:
-	return __send_ipi_mask_ex(mask, vector);
+	return __send_ipi_mask_ex(mask, vector, exclude_self);
 }
 
 static bool __send_ipi_one(int cpu, int vector)
@@ -208,7 +224,7 @@ static bool __send_ipi_one(int cpu, int vector)
 		return false;
 
 	if (vp >= 64)
-		return __send_ipi_mask_ex(cpumask_of(cpu), vector);
+		return __send_ipi_mask_ex(cpumask_of(cpu), vector, false);
 
 	status = hv_do_fast_hypercall16(HVCALL_SEND_IPI, vector, BIT_ULL(vp));
 	return hv_result_success(status);
@@ -222,20 +238,13 @@ static void hv_send_ipi(int cpu, int vector)
 
 static void hv_send_ipi_mask(const struct cpumask *mask, int vector)
 {
-	if (!__send_ipi_mask(mask, vector))
+	if (!__send_ipi_mask(mask, vector, false))
 		orig_apic.send_IPI_mask(mask, vector);
 }
 
 static void hv_send_ipi_mask_allbutself(const struct cpumask *mask, int vector)
 {
-	unsigned int this_cpu = smp_processor_id();
-	struct cpumask new_mask;
-	const struct cpumask *local_mask;
-
-	cpumask_copy(&new_mask, mask);
-	cpumask_clear_cpu(this_cpu, &new_mask);
-	local_mask = &new_mask;
-	if (!__send_ipi_mask(local_mask, vector))
+	if (!__send_ipi_mask(mask, vector, true))
 		orig_apic.send_IPI_mask_allbutself(mask, vector);
 }
 
@@ -246,7 +255,7 @@ static void hv_send_ipi_allbutself(int vector)
 
 static void hv_send_ipi_all(int vector)
 {
-	if (!__send_ipi_mask(cpu_online_mask, vector))
+	if (!__send_ipi_mask(cpu_online_mask, vector, false))
 		orig_apic.send_IPI_all(vector);
 }
 

