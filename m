Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0D3118B58
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 16:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbfEIONL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 10:13:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46936 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726690AbfEIONK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 10:13:10 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hOjnI-000128-LC; Thu, 09 May 2019 15:13:08 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hOjnI-0006MK-EO; Thu, 09 May 2019 15:13:08 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Joerg Roedel" <jroedel@suse.de>
Date:   Thu, 09 May 2019 15:08:17 +0100
Message-ID: <lsq.1557410897.741749439@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 07/10] KVM: VMX: Fix x2apic check in  vmx_msr_bitmap_mode()
In-Reply-To: <lsq.1557410896.171359878@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.67-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Joerg Roedel <jroedel@suse.de>

The stable backport of upstream commit

	904e14fb7cb96 KVM: VMX: make MSR bitmaps per-VCPU

has a bug in vmx_msr_bitmap_mode(). It enables the x2apic
MSR-bitmap when the kernel emulates x2apic for the guest in
software. The upstream version of the commit checkes whether
the hardware has virtualization enabled for x2apic
emulation.

Since KVM emulates x2apic for guests even when the host does
not support x2apic in hardware, this causes the intercept of
at least the X2APIC_TASKPRI MSR to be disabled on machines
not supporting that MSR. The result is undefined behavior,
on some machines (Intel Westmere based) it causes a crash of
the guest kernel when it tries to access that MSR.

Change the check in vmx_msr_bitmap_mode() to match the upstream
code. This fixes the guest crashes observed with stable
kernels starting with v4.4.168 through v4.4.175.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kvm/vmx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4224,7 +4224,9 @@ static u8 vmx_msr_bitmap_mode(struct kvm
 {
 	u8 mode = 0;
 
-	if (irqchip_in_kernel(vcpu->kvm) && apic_x2apic_mode(vcpu->arch.apic)) {
+	if (cpu_has_secondary_exec_ctrls() &&
+	    (vmcs_read32(SECONDARY_VM_EXEC_CONTROL) &
+	     SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE)) {
 		mode |= MSR_BITMAP_MODE_X2APIC;
 		if (enable_apicv)
 			mode |= MSR_BITMAP_MODE_X2APIC_APICV;

