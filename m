Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAAA7C3D9A
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 19:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729888AbfJAQkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 12:40:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:51538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729837AbfJAQkU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 12:40:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F301121D79;
        Tue,  1 Oct 2019 16:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948018;
        bh=8s8v0yNQxp/azENEIyJoN93RtdmY35h4AqfX90LSP/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UdtVQ9sSOclMBFocvgMDygixh8d9jNniGEWLGngStQYdQadiQZ9Gw9pJYT8npzaz4
         z7ctlHkT3d6zLM/CqS4dFudLp2ptm/Bc3Uz4az5bRio6wWLY58dwgBnEQwMgyFnly2
         z1EfWAcpyZwOxE4bZTT+ruKLhQ0Uzo98jXBXoFOk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        syzbot+dff25ee91f0c7d5c1695@syzkaller.appspotmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 39/71] KVM: hyperv: Fix Direct Synthetic timers assert an interrupt w/o lapic_in_kernel
Date:   Tue,  1 Oct 2019 12:38:49 -0400
Message-Id: <20191001163922.14735-39-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001163922.14735-1-sashal@kernel.org>
References: <20191001163922.14735-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

[ Upstream commit a073d7e3ad687a7ef32b65affe80faa7ce89bf92 ]

Reported by syzkaller:

	kasan: GPF could be caused by NULL-ptr deref or user memory access
	general protection fault: 0000 [#1] PREEMPT SMP KASAN
	RIP: 0010:__apic_accept_irq+0x46/0x740 arch/x86/kvm/lapic.c:1029
	Call Trace:
	kvm_apic_set_irq+0xb4/0x140 arch/x86/kvm/lapic.c:558
	stimer_notify_direct arch/x86/kvm/hyperv.c:648 [inline]
	stimer_expiration arch/x86/kvm/hyperv.c:659 [inline]
	kvm_hv_process_stimers+0x594/0x1650 arch/x86/kvm/hyperv.c:686
	vcpu_enter_guest+0x2b2a/0x54b0 arch/x86/kvm/x86.c:7896
	vcpu_run+0x393/0xd40 arch/x86/kvm/x86.c:8152
	kvm_arch_vcpu_ioctl_run+0x636/0x900 arch/x86/kvm/x86.c:8360
	kvm_vcpu_ioctl+0x6cf/0xaf0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:2765

The testcase programs HV_X64_MSR_STIMERn_CONFIG/HV_X64_MSR_STIMERn_COUNT,
in addition, there is no lapic in the kernel, the counters value are small
enough in order that kvm_hv_process_stimers() inject this already-expired
timer interrupt into the guest through lapic in the kernel which triggers
the NULL deferencing. This patch fixes it by don't advertise direct mode
synthetic timers and discarding the inject when lapic is not in kernel.

syzkaller source: https://syzkaller.appspot.com/x/repro.c?x=1752fe0a600000

Reported-by: syzbot+dff25ee91f0c7d5c1695@syzkaller.appspotmail.com
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/hyperv.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index fff790a3f4ee9..c0867b0aae3ec 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -645,7 +645,9 @@ static int stimer_notify_direct(struct kvm_vcpu_hv_stimer *stimer)
 		.vector = stimer->config.apic_vector
 	};
 
-	return !kvm_apic_set_irq(vcpu, &irq, NULL);
+	if (lapic_in_kernel(vcpu))
+		return !kvm_apic_set_irq(vcpu, &irq, NULL);
+	return 0;
 }
 
 static void stimer_expiration(struct kvm_vcpu_hv_stimer *stimer)
@@ -1852,7 +1854,13 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 
 			ent->edx |= HV_FEATURE_FREQUENCY_MSRS_AVAILABLE;
 			ent->edx |= HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE;
-			ent->edx |= HV_STIMER_DIRECT_MODE_AVAILABLE;
+
+			/*
+			 * Direct Synthetic timers only make sense with in-kernel
+			 * LAPIC
+			 */
+			if (lapic_in_kernel(vcpu))
+				ent->edx |= HV_STIMER_DIRECT_MODE_AVAILABLE;
 
 			break;
 
-- 
2.20.1

