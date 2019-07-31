Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3A217C032
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 13:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbfGaLkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 07:40:03 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34903 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfGaLkD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 07:40:03 -0400
Received: by mail-pf1-f193.google.com with SMTP id u14so31742485pfn.2;
        Wed, 31 Jul 2019 04:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ioEVQgkCZ3XHkGfukyPn8AoF8aXKuaUVBcVPK+Y84sg=;
        b=MFo0on9+QPhpo4y6M+rqnXS6DJ0lVOYQKIKOSeetucqRHBNdbHigIh665xCjnOwGFB
         rE3kweQhMDpoaHxy6qhLuoF7lZSlDXH9tIu5sKPFhlHrC0M28tYLoaa2Tt71xahf+8R+
         4w7Jp5SDLPTHyrVwUpYgV689VDPPk3ZAL7V/gVOOOL1ytRz4B/iEd5WoieeU4kq+qUvZ
         Gb4PWxCsAbBPU0h5/hsuC/NJCTu5zwh25YWkQ1KcCScrhk8kzZkLmN8qlREag28tASjt
         +nJWZ1s/a5jqclGiwCePDz+bNjpGlQjPSj23d7Wpq5gXqHyjv2snqCTlKBEva4/DSvd4
         zxwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ioEVQgkCZ3XHkGfukyPn8AoF8aXKuaUVBcVPK+Y84sg=;
        b=bsi6z646p+D20+xneinKe7LENq7djzvaYCvdFm5GCGk4H8y3OkeUYRFMmYCCmRi6Nj
         pXREWnOWYejPI/dAIHCDzA4QRKoqXytKywU3TxDeebU/Qz7Buykftp1sjnqAoNsZNsrs
         lUmKvrvPXYTafU3wfTwL0iAgCfsDNvMI8fgi6Nb0+BJZJHq1d03G7sN1UyJdW39TCxr3
         G+rakyC44h6/X2GALZ6tSzO+KxnLkK9nKNfLxjX7Fl7fq1M7wds4xuwcbXW8XVLC7/OD
         ddHge8QUyksLx4tkHLOUQqJClIAFKaUqBu2aWgF2/+pZOqhXKJseWKfXdHqKQcPUIdhT
         Hneg==
X-Gm-Message-State: APjAAAVFZ+w533HopXJ0gAASWG4Vp2TVNTZr3EF9K7qb6VUmYsFrZF5d
        ScSVvJX2uJ8Ad05VAHoqZmbPq8qZTYE=
X-Google-Smtp-Source: APXvYqyhwhcD6OfvCncLJRvxP7Tjw9JOOJZEKttxK03Zik2sYra+s+HDy5hptj0+HleWRThzWEiOGA==
X-Received: by 2002:a63:a66:: with SMTP id z38mr18204717pgk.247.1564573202836;
        Wed, 31 Jul 2019 04:40:02 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id f20sm81136633pgg.56.2019.07.31.04.40.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 31 Jul 2019 04:40:02 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 3/3] KVM: Fix leak vCPU's VMCS value into other pCPU
Date:   Wed, 31 Jul 2019 19:39:58 +0800
Message-Id: <1564573198-16219-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564572438-15518-3-git-send-email-wanpengli@tencent.com>
References: <1564572438-15518-3-git-send-email-wanpengli@tencent.com>
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
in kvm_vcpu_on_spin() loop and checking swait_active(&vcpu->wq) for 
involuntary preemption.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Fixes: 98f4a1467 (KVM: add kvm_arch_vcpu_runnable() test to kvm_vcpu_on_spin() loop)
Cc: stable@vger.kernel.org
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v1 -> v2:
 * checking swait_active(&vcpu->wq) for involuntary preemption

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
+			if (READ_ONCE(vcpu->preempted) && swait_active(&vcpu->wq))
 				continue;
 			if (READ_ONCE(vcpu->preempted) && yield_to_kernel_mode &&
 				!kvm_arch_vcpu_in_kernel(vcpu))
-- 
2.7.4

