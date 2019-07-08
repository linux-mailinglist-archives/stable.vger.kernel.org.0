Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9E836244E
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731585AbfGHPZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:25:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:53396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388681AbfGHPZu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:25:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9284A204EC;
        Mon,  8 Jul 2019 15:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599549;
        bh=H4G29Oxk1339cRsoFCBpWjqf39RTO8vLCCaVvbRG9Bo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FpByg06Px//mGGoKBiauz3UeI/Ej/R1JqRlWGiRgaDTB4jqc0LHCK+AwG2s2Xa3vV
         HP5I53UP1QXXvT7WrTdinV9awAblWChqZqj4FO6uk2/3A3FO9uKm86nPsK6FrbTKEc
         oWG3vP1rR4DOtPG+Pir67QsmuJzMYHZoOkKoClK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rong Chen <rong.a.chen@intel.com>,
        Feng Tang <feng.tang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH 4.14 51/56] KVM: LAPIC: Fix pending interrupt in IRR blocked by software disable LAPIC
Date:   Mon,  8 Jul 2019 17:13:43 +0200
Message-Id: <20190708150524.090194311@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150514.376317156@linuxfoundation.org>
References: <20190708150514.376317156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

commit bb34e690e9340bc155ebed5a3d75fc63ff69e082 upstream.

Thomas reported that:

 | Background:
 |
 |    In preparation of supporting IPI shorthands I changed the CPU offline
 |    code to software disable the local APIC instead of just masking it.
 |    That's done by clearing the APIC_SPIV_APIC_ENABLED bit in the APIC_SPIV
 |    register.
 |
 | Failure:
 |
 |    When the CPU comes back online the startup code triggers occasionally
 |    the warning in apic_pending_intr_clear(). That complains that the IRRs
 |    are not empty.
 |
 |    The offending vector is the local APIC timer vector who's IRR bit is set
 |    and stays set.
 |
 | It took me quite some time to reproduce the issue locally, but now I can
 | see what happens.
 |
 | It requires apicv_enabled=0, i.e. full apic emulation. With apicv_enabled=1
 | (and hardware support) it behaves correctly.
 |
 | Here is the series of events:
 |
 |     Guest CPU
 |
 |     goes down
 |
 |       native_cpu_disable()
 |
 | 			apic_soft_disable();
 |
 |     play_dead()
 |
 |     ....
 |
 |     startup()
 |
 |       if (apic_enabled())
 |         apic_pending_intr_clear()	<- Not taken
 |
 |      enable APIC
 |
 |         apic_pending_intr_clear()	<- Triggers warning because IRR is stale
 |
 | When this happens then the deadline timer or the regular APIC timer -
 | happens with both, has fired shortly before the APIC is disabled, but the
 | interrupt was not serviced because the guest CPU was in an interrupt
 | disabled region at that point.
 |
 | The state of the timer vector ISR/IRR bits:
 |
 |     	     	       	        ISR     IRR
 | before apic_soft_disable()    0	      1
 | after apic_soft_disable()     0	      1
 |
 | On startup		      		 0	      1
 |
 | Now one would assume that the IRR is cleared after the INIT reset, but this
 | happens only on CPU0.
 |
 | Why?
 |
 | Because our CPU0 hotplug is just for testing to make sure nothing breaks
 | and goes through an NMI wakeup vehicle because INIT would send it through
 | the boots-trap code which is not really working if that CPU was not
 | physically unplugged.
 |
 | Now looking at a real world APIC the situation in that case is:
 |
 |     	     	       	      	ISR     IRR
 | before apic_soft_disable()    0	      1
 | after apic_soft_disable()     0	      1
 |
 | On startup		      		 0	      0
 |
 | Why?
 |
 | Once the dying CPU reenables interrupts the pending interrupt gets
 | delivered as a spurious interupt and then the state is clear.
 |
 | While that CPU0 hotplug test case is surely an esoteric issue, the APIC
 | emulation is still wrong, Even if the play_dead() code would not enable
 | interrupts then the pending IRR bit would turn into an ISR .. interrupt
 | when the APIC is reenabled on startup.

>From SDM 10.4.7.2 Local APIC State After It Has Been Software Disabled
* Pending interrupts in the IRR and ISR registers are held and require
  masking or handling by the CPU.

In Thomas's testing, hardware cpu will not respect soft disable LAPIC
when IRR has already been set or APICv posted-interrupt is in flight,
so we can skip soft disable APIC checking when clearing IRR and set ISR,
continue to respect soft disable APIC when attempting to set IRR.

Reported-by: Rong Chen <rong.a.chen@intel.com>
Reported-by: Feng Tang <feng.tang@intel.com>
Reported-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Rong Chen <rong.a.chen@intel.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/lapic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2161,7 +2161,7 @@ int kvm_apic_has_interrupt(struct kvm_vc
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	u32 ppr;
 
-	if (!apic_enabled(apic))
+	if (!kvm_apic_hw_enabled(apic))
 		return -1;
 
 	__apic_update_ppr(apic, &ppr);


