Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4778FE4E21
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 16:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394647AbfJYN4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 09:56:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:50696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393547AbfJYN4W (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Oct 2019 09:56:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15F24222BD;
        Fri, 25 Oct 2019 13:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572011781;
        bh=Kng16m/t/WNxtUlNeRND0rxRsZYZ9Z4Lln/p1bnA7HM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ntNtq83ft2ZJ/1APDsZzioMitK0dAQuQUw71kTvH+XYmpQfc3O0A3UjQZusdCP4Vq
         KTpatm7D1+uyQIHkmheBZ7hOANYi6RUrBlCw/t9E8x9aak360NJUHsVhWfbefdeSvq
         U/gBpV/GOAdyesUYFNKRjWMuBPdWLzXNFK2P2+wI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        Paul Mackerras <paulus@ozlabs.org>,
        Sasha Levin <sashal@kernel.org>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 11/37] KVM: PPC: Book3S HV: Fix lockdep warning when entering the guest
Date:   Fri, 25 Oct 2019 09:55:35 -0400
Message-Id: <20191025135603.25093-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025135603.25093-1-sashal@kernel.org>
References: <20191025135603.25093-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

[ Upstream commit 3309bec85e60d60d6394802cb8e183a4f4a72def ]

The trace_hardirqs_on() sets current->hardirqs_enabled and from here
the lockdep assumes interrupts are enabled although they are remain
disabled until the context switches to the guest. Consequent
srcu_read_lock() checks the flags in rcu_lock_acquire(), observes
disabled interrupts and prints a warning (see below).

This moves trace_hardirqs_on/off closer to __kvmppc_vcore_entry to
prevent lockdep from being confused.

DEBUG_LOCKS_WARN_ON(current->hardirqs_enabled)
WARNING: CPU: 16 PID: 8038 at kernel/locking/lockdep.c:4128 check_flags.part.25+0x224/0x280
[...]
NIP [c000000000185b84] check_flags.part.25+0x224/0x280
LR [c000000000185b80] check_flags.part.25+0x220/0x280
Call Trace:
[c000003fec253710] [c000000000185b80] check_flags.part.25+0x220/0x280 (unreliable)
[c000003fec253780] [c000000000187ea4] lock_acquire+0x94/0x260
[c000003fec253840] [c00800001a1e9768] kvmppc_run_core+0xa60/0x1ab0 [kvm_hv]
[c000003fec253a10] [c00800001a1ed944] kvmppc_vcpu_run_hv+0x73c/0xec0 [kvm_hv]
[c000003fec253ae0] [c00800001a1095dc] kvmppc_vcpu_run+0x34/0x48 [kvm]
[c000003fec253b00] [c00800001a1056bc] kvm_arch_vcpu_ioctl_run+0x2f4/0x400 [kvm]
[c000003fec253b90] [c00800001a0f3618] kvm_vcpu_ioctl+0x460/0x850 [kvm]
[c000003fec253d00] [c00000000041c4f4] do_vfs_ioctl+0xe4/0x930
[c000003fec253db0] [c00000000041ce04] ksys_ioctl+0xc4/0x110
[c000003fec253e00] [c00000000041ce78] sys_ioctl+0x28/0x80
[c000003fec253e20] [c00000000000b5a4] system_call+0x5c/0x70
Instruction dump:
419e0034 3d220004 39291730 81290000 2f890000 409e0020 3c82ffc6 3c62ffc5
3884be70 386329c0 4bf6ea71 60000000 <0fe00000> 3c62ffc6 3863be90 4801273d
irq event stamp: 1025
hardirqs last  enabled at (1025): [<c00800001a1e9728>] kvmppc_run_core+0xa20/0x1ab0 [kvm_hv]
hardirqs last disabled at (1024): [<c00800001a1e9358>] kvmppc_run_core+0x650/0x1ab0 [kvm_hv]
softirqs last  enabled at (0): [<c0000000000f1210>] copy_process.isra.4.part.5+0x5f0/0x1d00
softirqs last disabled at (0): [<0000000000000000>]           (null)
---[ end trace 31180adcc848993e ]---
possible reason: unannotated irqs-off.
irq event stamp: 1025
hardirqs last  enabled at (1025): [<c00800001a1e9728>] kvmppc_run_core+0xa20/0x1ab0 [kvm_hv]
hardirqs last disabled at (1024): [<c00800001a1e9358>] kvmppc_run_core+0x650/0x1ab0 [kvm_hv]
softirqs last  enabled at (0): [<c0000000000f1210>] copy_process.isra.4.part.5+0x5f0/0x1d00
softirqs last disabled at (0): [<0000000000000000>]           (null)

Fixes: 8b24e69fc47e ("KVM: PPC: Book3S HV: Close race with testing for signals on guest entry", 2017-06-26)
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_hv.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 3ae3e8d141e3e..dbfe32327212e 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2993,25 +2993,26 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
 		}
 	}
 
-	/*
-	 * Interrupts will be enabled once we get into the guest,
-	 * so tell lockdep that we're about to enable interrupts.
-	 */
-	trace_hardirqs_on();
-
 	guest_enter_irqoff();
 
 	srcu_idx = srcu_read_lock(&vc->kvm->srcu);
 
 	this_cpu_disable_ftrace();
 
+	/*
+	 * Interrupts will be enabled once we get into the guest,
+	 * so tell lockdep that we're about to enable interrupts.
+	 */
+	trace_hardirqs_on();
+
 	trap = __kvmppc_vcore_entry();
 
+	trace_hardirqs_off();
+
 	this_cpu_enable_ftrace();
 
 	srcu_read_unlock(&vc->kvm->srcu, srcu_idx);
 
-	trace_hardirqs_off();
 	set_irq_happened(trap);
 
 	spin_lock(&vc->lock);
-- 
2.20.1

