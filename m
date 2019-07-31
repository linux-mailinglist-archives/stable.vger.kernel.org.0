Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D828B7BF3B
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 13:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbfGaL12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 07:27:28 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45725 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728123AbfGaL11 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 07:27:27 -0400
Received: by mail-pg1-f195.google.com with SMTP id o13so31819936pgp.12;
        Wed, 31 Jul 2019 04:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vQV5WkYi1RCaWV1rfzrmNeSid8EG2ORcB51l+rIc8nE=;
        b=YAQafS7T3YJom2VXMOvDWitBFs54x+WqCi/+XukFa7EOfEC/iuP5xGekW2D1YbYRc1
         1NcoIrd3zS4DPSHoYMzURGkQRdc6/i2zS3DuskzXg0alJOBimbt8/nVs4IAm3TqXAnmO
         1kfGJ+wCyQPXeA+X8F9qq8Nsc0+lSkuVlBU/ME5xGKRHTXRNlDkrVstOPBo/psYk3POi
         clKIoAWQFRqABDp7axVMg2G25NZS7YXBMVMJF5yXPyyql2L1Cj5vkBHPq+krSvznMVuA
         rojQ7PaezEKTurEfI7x2ItVHYTCAtDrgi49rbwEuTSKOay6K6lKkJUgRHAjQvDHOIFi3
         bhdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vQV5WkYi1RCaWV1rfzrmNeSid8EG2ORcB51l+rIc8nE=;
        b=C8ptdu2BRhlVPxqL7VecpzNjWx7SVc+2oyDURrLX5Kv9iNYi47M67Goug9z9e2WNFk
         M5FmzuBt1txxNkcNKFDMsePTgt2lmuC6kve5j4Hvl6HaF9b3z2IeZlTIKKNo6p1IpH/h
         poBmR9ReSuLybsY0Vked3mgwvPUU6tlKk8h/WITdUpc+xbndVePdmJdLbPJOXmqjJlE9
         55aPJREMu9Z2DSnBPWQofJwqvDKfgtvWvlNxW2Jqa5OJ92JgrUgQxNcc+1Ckyj3DFQSt
         1qe+5Ly6hSjQHiGOhCOenF1SsEW7CE20gST4F62tnwSgE6jbOFsD3elTAfCt4xcea8eU
         9Geg==
X-Gm-Message-State: APjAAAUAPI7OOf9Ad06MMTfq+RXLPxes8+3P5OPmpLAYKAVJ1WUPlIda
        HDqeVVcl1476o8T7AHIw+DRPboIvZmU=
X-Google-Smtp-Source: APXvYqyZyRrubMwWdKsJ5FhRtpzBvWs+SH6iatiD5Xa+UFGCV6WUXQmwGPq/GZVrzH6Cd6jqgVNNXQ==
X-Received: by 2002:a63:f750:: with SMTP id f16mr84157002pgk.317.1564572446710;
        Wed, 31 Jul 2019 04:27:26 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id e3sm1211441pgm.64.2019.07.31.04.27.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 31 Jul 2019 04:27:26 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH 3/3] KVM: Fix leak vCPU's VMCS value into other pCPU
Date:   Wed, 31 Jul 2019 19:27:18 +0800
Message-Id: <1564572438-15518-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564572438-15518-1-git-send-email-wanpengli@tencent.com>
References: <1564572438-15518-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

After commit d73eb57b80b (KVM: Boost vCPUs that are delivering interrupts), a 
five years ago bug is exposed. Running ebizzy benchmark in three 80 vCPUs VMs 
on one 80 pCPUs Skylake server, a lot of rcu_sched stall warning splatting 
in the VMs after stress testing:

 INFO: rcu_sched detected stalls on CPUs/tasks: { 4 41 57 62 77} (detected by 15, t=60004 jiffies, g=899, c=898, q=15073)
 Call Trace:
   flush_tlb_mm_range+0x68/0x140
   tlb_flush_mmu.part.75+0x37/0xe0
   tlb_finish_mmu+0x55/0x60
   zap_page_range+0x142/0x190
   SyS_madvise+0x3cd/0x9c0
   system_call_fastpath+0x1c/0x21

swait_active() sustains to be true before finish_swait() is called in 
kvm_vcpu_block(), voluntarily preempted vCPUs are taken into account 
by kvm_vcpu_on_spin() loop greatly increases the probability condition 
kvm_arch_vcpu_runnable(vcpu) is checked and can be true, when APICv 
is enabled the yield-candidate vCPU's VMCS RVI field leaks(by 
vmx_sync_pir_to_irr()) into spinning-on-a-taken-lock vCPU's current 
VMCS.

This patch fixes it by reverting the kvm_arch_vcpu_runnable() condition 
in kvm_vcpu_on_spin() loop.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Fixes: 98f4a1467 (KVM: add kvm_arch_vcpu_runnable() test to kvm_vcpu_on_spin() loop)
Cc: stable@vger.kernel.org
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ed061d8..12f2c91 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2506,7 +2506,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 				continue;
 			if (vcpu == me)
 				continue;
-			if (swait_active(&vcpu->wq) && !kvm_arch_vcpu_runnable(vcpu))
+			if (swait_active(&vcpu->wq))
 				continue;
 			if (READ_ONCE(vcpu->preempted) && yield_to_kernel_mode &&
 				!kvm_arch_vcpu_in_kernel(vcpu))
-- 
2.7.4

