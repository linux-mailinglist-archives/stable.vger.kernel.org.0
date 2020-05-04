Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86DA31C44C0
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731896AbgEDSF7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:05:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:36086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731890AbgEDSF6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:05:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84F47206B8;
        Mon,  4 May 2020 18:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615558;
        bh=dO6RhbOudPOhZ0c/Cb1uMroFYNjWJ07NIm5zR9uk3N4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GTRWy29qoLqWoCvL9jZXjXFBANAHt113asu29DSOPyUycVEwn3FrvkR/rtlM4sxcV
         KD8CXOxP1RBxbgagT3kRjtu/fC6Ll6m8NGbfmV8OpJiQGsVxjgbd8N8p7t+q8NeOlu
         A6a5CwNZup+stGs0MHx5EgUdANznryuaZ7uIK55g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 5.6 29/73] x86/hyperv: Suspend/resume the VP assist page for hibernation
Date:   Mon,  4 May 2020 19:57:32 +0200
Message-Id: <20200504165507.203047839@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165501.781878940@linuxfoundation.org>
References: <20200504165501.781878940@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

commit 421f090c819d695942a470051cd624dc43deaf95 upstream.

Unlike the other CPUs, CPU0 is never offlined during hibernation, so in the
resume path, the "new" kernel's VP assist page is not suspended (i.e. not
disabled), and later when we jump to the "old" kernel, the page is not
properly re-enabled for CPU0 with the allocated page from the old kernel.

So far, the VP assist page is used by hv_apic_eoi_write(), and is also
used in the case of nested virtualization (running KVM atop Hyper-V).

For hv_apic_eoi_write(), when the page is not properly re-enabled,
hvp->apic_assist is always 0, so the HV_X64_MSR_EOI MSR is always written.
This is not ideal with respect to performance, but Hyper-V can still
correctly handle this according to the Hyper-V spec; nevertheless, Linux
still must update the Hyper-V hypervisor with the correct VP assist page
to prevent Hyper-V from writing to the stale page, which causes guest
memory corruption and consequently may have caused the hangs and triple
faults seen during non-boot CPUs resume.

Fix the issue by calling hv_cpu_die()/hv_cpu_init() in the syscore ops.
Without the fix, hibernation can fail at a rate of 1/300 ~ 1/500.
With the fix, hibernation can pass a long-haul test of 2000 runs.

In the case of nested virtualization, disabling/reenabling the assist
page upon hibernation may be unsafe if there are active L2 guests.
It looks KVM should be enhanced to abort the hibernation request if
there is any active L2 guest.

Fixes: 05bd330a7fd8 ("x86/hyperv: Suspend/resume the hypercall page for hibernation")
Cc: stable@vger.kernel.org
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Link: https://lore.kernel.org/r/1587437171-2472-1-git-send-email-decui@microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/hyperv/hv_init.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -73,7 +73,8 @@ static int hv_cpu_init(unsigned int cpu)
 	struct page *pg;
 
 	input_arg = (void **)this_cpu_ptr(hyperv_pcpu_input_arg);
-	pg = alloc_page(GFP_KERNEL);
+	/* hv_cpu_init() can be called with IRQs disabled from hv_resume() */
+	pg = alloc_page(irqs_disabled() ? GFP_ATOMIC : GFP_KERNEL);
 	if (unlikely(!pg))
 		return -ENOMEM;
 	*input_arg = page_address(pg);
@@ -254,6 +255,7 @@ static int __init hv_pci_init(void)
 static int hv_suspend(void)
 {
 	union hv_x64_msr_hypercall_contents hypercall_msr;
+	int ret;
 
 	/*
 	 * Reset the hypercall page as it is going to be invalidated
@@ -270,12 +272,17 @@ static int hv_suspend(void)
 	hypercall_msr.enable = 0;
 	wrmsrl(HV_X64_MSR_HYPERCALL, hypercall_msr.as_uint64);
 
-	return 0;
+	ret = hv_cpu_die(0);
+	return ret;
 }
 
 static void hv_resume(void)
 {
 	union hv_x64_msr_hypercall_contents hypercall_msr;
+	int ret;
+
+	ret = hv_cpu_init(0);
+	WARN_ON(ret);
 
 	/* Re-enable the hypercall page */
 	rdmsrl(HV_X64_MSR_HYPERCALL, hypercall_msr.as_uint64);
@@ -288,6 +295,7 @@ static void hv_resume(void)
 	hv_hypercall_pg_saved = NULL;
 }
 
+/* Note: when the ops are called, only CPU0 is online and IRQs are disabled. */
 static struct syscore_ops hv_syscore_ops = {
 	.suspend	= hv_suspend,
 	.resume		= hv_resume,


