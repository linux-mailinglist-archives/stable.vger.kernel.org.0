Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26CC173964
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389729AbfGXTju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:39:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:40890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389672AbfGXTjt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:39:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C99C1229F4;
        Wed, 24 Jul 2019 19:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997188;
        bh=hRYKJrh/aEOINyYXSOz+/SEqwqSZyDF63QUZ78IxELA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NvJp8jlKOyjkKx3bClt8iTj799fiv9yZkuPgbbTKGHQRzAjh2Pu20bkf71r7ehGg2
         WUF6d/mwB3j2B1zIsrt0ULtC6iwQ9MVv6mAOOmBOJNfDyN7KIXN1iD/XqFbmiye0W9
         AfGJ9YswV/0fd0iy1A2iSOwWcnPbd4Y1LW37Yk2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.2 352/413] x86/hyper-v: Zero out the VP ASSIST PAGE on allocation
Date:   Wed, 24 Jul 2019 21:20:43 +0200
Message-Id: <20190724191800.948573938@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

commit e320ab3cec7dd8b1606964d81ae1e14391ff8e96 upstream.

The VP ASSIST PAGE is an "overlay" page (see Hyper-V TLFS's Section
5.2.1 "GPA Overlay Pages" for the details) and here is an excerpt:

"The hypervisor defines several special pages that "overlay" the guest's
 Guest Physical Addresses (GPA) space. Overlays are addressed GPA but are
 not included in the normal GPA map maintained internally by the hypervisor.
 Conceptually, they exist in a separate map that overlays the GPA map.

 If a page within the GPA space is overlaid, any SPA page mapped to the
 GPA page is effectively "obscured" and generally unreachable by the
 virtual processor through processor memory accesses.

 If an overlay page is disabled, the underlying GPA page is "uncovered",
 and an existing mapping becomes accessible to the guest."

SPA = System Physical Address = the final real physical address.

When a CPU (e.g. CPU1) is onlined, hv_cpu_init() allocates the VP ASSIST
PAGE and enables the EOI optimization for this CPU by writing the MSR
HV_X64_MSR_VP_ASSIST_PAGE. From now on, hvp->apic_assist belongs to the
special SPA page, and this CPU *always* uses hvp->apic_assist (which is
shared with the hypervisor) to decide if it needs to write the EOI MSR.

When a CPU is offlined then on the outgoing CPU:
1. hv_cpu_die() disables the EOI optimizaton for this CPU, and from
   now on hvp->apic_assist belongs to the original "normal" SPA page;
2. the remaining work of stopping this CPU is done
3. this CPU is completely stopped.

Between 1 and 3, this CPU can still receive interrupts (e.g. reschedule
IPIs from CPU0, and Local APIC timer interrupts), and this CPU *must* write
the EOI MSR for every interrupt received, otherwise the hypervisor may not
deliver further interrupts, which may be needed to completely stop the CPU.

So, after the EOI optimization is disabled in hv_cpu_die(), it's required
that the hvp->apic_assist's bit0 is zero, which is not guaranteed by the
current allocation mode because it lacks __GFP_ZERO. As a consequence the
bit might be set and interrupt handling would not write the EOI MSR causing
interrupt delivery to become stuck.

Add the missing __GFP_ZERO to the allocation.

Note 1: after the "normal" SPA page is allocted and zeroed out, neither the
hypervisor nor the guest writes into the page, so the page remains with
zeros.

Note 2: see Section 10.3.5 "EOI Assist" for the details of the EOI
optimization. When the optimization is enabled, the guest can still write
the EOI MSR register irrespective of the "No EOI required" value, but
that's slower than the optimized assist based variant.

Fixes: ba696429d290 ("x86/hyper-v: Implement EOI assist")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/ <PU1P153MB0169B716A637FABF07433C04BFCB0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/hyperv/hv_init.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -111,8 +111,17 @@ static int hv_cpu_init(unsigned int cpu)
 	if (!hv_vp_assist_page)
 		return 0;
 
-	if (!*hvp)
-		*hvp = __vmalloc(PAGE_SIZE, GFP_KERNEL, PAGE_KERNEL);
+	/*
+	 * The VP ASSIST PAGE is an "overlay" page (see Hyper-V TLFS's Section
+	 * 5.2.1 "GPA Overlay Pages"). Here it must be zeroed out to make sure
+	 * we always write the EOI MSR in hv_apic_eoi_write() *after* the
+	 * EOI optimization is disabled in hv_cpu_die(), otherwise a CPU may
+	 * not be stopped in the case of CPU offlining and the VM will hang.
+	 */
+	if (!*hvp) {
+		*hvp = __vmalloc(PAGE_SIZE, GFP_KERNEL | __GFP_ZERO,
+				 PAGE_KERNEL);
+	}
 
 	if (*hvp) {
 		u64 val;


