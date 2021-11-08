Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D6A44A306
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242247AbhKIBZn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:25:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:40938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241716AbhKIBPe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:15:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 955B961AE2;
        Tue,  9 Nov 2021 01:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419998;
        bh=VQ/XpjLMN06VarBHID7J8EAudkaPGA6lrPwedjZHmg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i7vvjnpSka2CG3pg5rpTWL7kGRlmYbPEgM4TTo4avc4k4rFkccl90rI6juiMbQ2TB
         oXy/m45brsCeR/fV8KRbq34kVoU8ktm5d6BLtfnQUWFnjJpYOaTMNHC5NgIQZZm7Fs
         eA0w+P0qb0Bts+8SVXlbreK0KlUsDLCYzvJhzFOs/DhcU3MEuKQY3GGiLEFvO4xmGV
         SlbXUHe1d6V1Og2dJVTBckTrsapHvC3e2BQymOp8QQVFL1SkBVFnnmpTgqkV8Clv6K
         t1t6pzhhSyCgoSHuKT+WgjQgwppTBkgKqGIHcKfV1RWKxJ6LeVAVGB08huwX3rrKTo
         6SAZ+PzSlzGzQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        linux-hyperv@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 43/47] x86/hyperv: Protect set_hv_tscchange_cb() against getting preempted
Date:   Mon,  8 Nov 2021 12:50:27 -0500
Message-Id: <20211108175031.1190422-43-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108175031.1190422-1-sashal@kernel.org>
References: <20211108175031.1190422-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit 285f68afa8b20f752b0b7194d54980b5e0e27b75 ]

The following issue is observed with CONFIG_DEBUG_PREEMPT when KVM loads:

 KVM: vmx: using Hyper-V Enlightened VMCS
 BUG: using smp_processor_id() in preemptible [00000000] code: systemd-udevd/488
 caller is set_hv_tscchange_cb+0x16/0x80
 CPU: 1 PID: 488 Comm: systemd-udevd Not tainted 5.15.0-rc5+ #396
 Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS Hyper-V UEFI Release v4.0 12/17/2019
 Call Trace:
  dump_stack_lvl+0x6a/0x9a
  check_preemption_disabled+0xde/0xe0
  ? kvm_gen_update_masterclock+0xd0/0xd0 [kvm]
  set_hv_tscchange_cb+0x16/0x80
  kvm_arch_init+0x23f/0x290 [kvm]
  kvm_init+0x30/0x310 [kvm]
  vmx_init+0xaf/0x134 [kvm_intel]
  ...

set_hv_tscchange_cb() can get preempted in between acquiring
smp_processor_id() and writing to HV_X64_MSR_REENLIGHTENMENT_CONTROL. This
is not an issue by itself: HV_X64_MSR_REENLIGHTENMENT_CONTROL is a
partition-wide MSR and it doesn't matter which particular CPU will be
used to receive reenlightenment notifications. The only real problem can
(in theory) be observed if the CPU whose id was acquired with
smp_processor_id() goes offline before we manage to write to the MSR,
the logic in hv_cpu_die() won't be able to reassign it correctly.

Reported-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Link: https://lore.kernel.org/r/20211012155005.1613352-1-vkuznets@redhat.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/hyperv/hv_init.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
index 1663ad84778ba..bd4b6951b1483 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -192,7 +192,6 @@ void set_hv_tscchange_cb(void (*cb)(void))
 	struct hv_reenlightenment_control re_ctrl = {
 		.vector = HYPERV_REENLIGHTENMENT_VECTOR,
 		.enabled = 1,
-		.target_vp = hv_vp_index[smp_processor_id()]
 	};
 	struct hv_tsc_emulation_control emu_ctrl = {.enabled = 1};
 
@@ -206,8 +205,12 @@ void set_hv_tscchange_cb(void (*cb)(void))
 	/* Make sure callback is registered before we write to MSRs */
 	wmb();
 
+	re_ctrl.target_vp = hv_vp_index[get_cpu()];
+
 	wrmsrl(HV_X64_MSR_REENLIGHTENMENT_CONTROL, *((u64 *)&re_ctrl));
 	wrmsrl(HV_X64_MSR_TSC_EMULATION_CONTROL, *((u64 *)&emu_ctrl));
+
+	put_cpu();
 }
 EXPORT_SYMBOL_GPL(set_hv_tscchange_cb);
 
-- 
2.33.0

