Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F173F5CC95
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 11:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfGBJZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 05:25:14 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45264 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbfGBJZO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 05:25:14 -0400
Received: by mail-pl1-f193.google.com with SMTP id bi6so51479plb.12;
        Tue, 02 Jul 2019 02:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PIxpwWWXerCiKBiSXfcI0F3Iq1/jaQ1QxObYQ2pXJMs=;
        b=DddQvsLh76CykOun9Q/BEyIcbPTU3Qpd06QhFTsP8MzhvIJJVmbHJRgcbMqU6DwJNJ
         qfbd4vTiefiNkA2cZeT8t5w3aoHpkUMUP0eR/kd6SRpYQSz3F50B0ngKD8m4hdgqXgsz
         H12H76FOBDEJQvSrj5/6SNdz4XoQ+O4WNWhm6j2sC5bQUJkJTNRX9qBRX1tBJXnR33aT
         odenA2GbOT9H6Ei7n7n1Y5WD1yaQDxHRY3rcLPqFJdvIgM/Inm+wXs99ymTshAVFfLxG
         I+y7de5Db+Rb++LQZNFcgOlGRu9Z5DJYsKUDSqK4PO0ddlN1greJiW+suN/a7gA0wDF6
         mSeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PIxpwWWXerCiKBiSXfcI0F3Iq1/jaQ1QxObYQ2pXJMs=;
        b=jHi8zQv3y45q6+eDd4GSmKAC2VVfOaCV1vY0Gpc2ORtFYwX0K8SfeM2OWKxVS+80Tb
         oQF3nMXZCDiizN37/BlzVYEkAC7we2FX/SKBHDHBZzOv1duAL4/t7HFelHrpJkdtV4oo
         Ce0zeyvV5cHE3OyO+LQTpkULkkqhhR1Ls0t9SV4zSGZvZWmPpinfyB3tl4bcH1wNgp8Q
         dBG/dYAfwgH0BorjyAWhAXjdv5DvFVVUulG73wB2YlnwaKugz4DYZ1Z53v3Fld8sZW2c
         GT4DuPCE3zgvWAe53nGqBg0MYrdKm8gLzemUzLr/32ix7wREgZIAk6BlUDpNdXUUKnFy
         kOvQ==
X-Gm-Message-State: APjAAAUQz46uAjwk+MDfypPpl818WvbM9gWAnph4/2DhV9ZGLU1k+Tly
        zBkfO5Y1EWHgt+fwlQpJdQUzBWDQ
X-Google-Smtp-Source: APXvYqzqZLo+Au+ZFbXdSxlA8Ugb+OGEzJ7kjKF9NZb/zeywXmvVJ1ZgjsCP19nP2s5NFJ+FCe9P3g==
X-Received: by 2002:a17:902:2a26:: with SMTP id i35mr33791060plb.315.1562059513141;
        Tue, 02 Jul 2019 02:25:13 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id n89sm4020744pjc.0.2019.07.02.02.25.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 02 Jul 2019 02:25:12 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rong Chen <rong.a.chen@intel.com>,
        Feng Tang <feng.tang@intel.com>, stable@vger.kernel.org
Subject: [PATCH] KVM: LAPIC: Fix pending interrupt in IRR blocked by software disable LAPIC
Date:   Tue,  2 Jul 2019 17:25:02 +0800
Message-Id: <1562059502-8581-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

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


From SDM 10.4.7.2 Local APIC State After It Has Been Software Disabled
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
---
 arch/x86/kvm/lapic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 05d8934..f857a12 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2376,7 +2376,7 @@ int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu)
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	u32 ppr;
 
-	if (!apic_enabled(apic))
+	if (!kvm_apic_hw_enabled(apic))
 		return -1;
 
 	__apic_update_ppr(apic, &ppr);
-- 
2.7.4

