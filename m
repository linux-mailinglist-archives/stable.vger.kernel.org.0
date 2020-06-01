Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 308731EAE75
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729769AbgFASyJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:54:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729907AbgFASCP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:02:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 647D9207D0;
        Mon,  1 Jun 2020 18:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034534;
        bh=xDqOcDPxgEtN8yP3ZDnF8X43wyViTPb3+SglNOHmTUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RYg0eVU8MPi04EsobwPQyhTQduT5K4TXAYvoq+xroqWsOBiWgLT58Ego5H0u1S+7U
         trm7jmk7XaYoXKW/3H01cYpeJS7z28vh6uFkYiE6x1aoVBIqMePV9x6Vi7k3anTHnH
         9mWyNLjk055oAqqSrNVUU3YBfKz7IFnjlcLXLgP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gerhard Wiesinger <redhat@wiesinger.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.14 75/77] KVM: VMX: check for existence of secondary exec controls before accessing
Date:   Mon,  1 Jun 2020 19:54:20 +0200
Message-Id: <20200601174029.419790717@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174016.396817032@linuxfoundation.org>
References: <20200601174016.396817032@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit fd6b6d9b82f97a851fb0078201ddc38fe9728cda upstream.

Return early from vmx_set_virtual_apic_mode() if the processor doesn't
support VIRTUALIZE_APIC_ACCESSES or VIRTUALIZE_X2APIC_MODE, both of
which reside in SECONDARY_VM_EXEC_CONTROL.  This eliminates warnings
due to VMWRITEs to SECONDARY_VM_EXEC_CONTROL (VMCS field 401e) failing
on processors without secondary exec controls.

Remove the similar check for TPR shadowing as it is incorporated in the
flexpriority_enabled check and the APIC-related code in
vmx_update_msr_bitmap() is further gated by VIRTUALIZE_X2APIC_MODE.

Reported-by: Gerhard Wiesinger <redhat@wiesinger.com>
Fixes: 8d860bbeedef ("kvm: vmx: Basic APIC virtualization controls have three settings")
Cc: Jim Mattson <jmattson@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -9280,15 +9280,16 @@ static void vmx_set_virtual_apic_mode(st
 	if (!lapic_in_kernel(vcpu))
 		return;
 
+	if (!flexpriority_enabled &&
+	    !cpu_has_vmx_virtualize_x2apic_mode())
+		return;
+
 	/* Postpone execution until vmcs01 is the current VMCS. */
 	if (is_guest_mode(vcpu)) {
 		to_vmx(vcpu)->nested.change_vmcs01_virtual_apic_mode = true;
 		return;
 	}
 
-	if (!cpu_need_tpr_shadow(vcpu))
-		return;
-
 	sec_exec_control = vmcs_read32(SECONDARY_VM_EXEC_CONTROL);
 	sec_exec_control &= ~(SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |
 			      SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE);


