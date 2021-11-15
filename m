Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64C5B45103B
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237926AbhKOSow (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:44:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:50352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242272AbhKOSms (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:42:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6826A63300;
        Mon, 15 Nov 2021 18:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999514;
        bh=/Lm5MC5ObMzOznXPIr0XniCeHYmSyUkwvGj0O9nmKwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FHNHquebIDYjuUUgMCHFMdCtZGBlUsCLAMtuDFbst4lUKNowR9ocqSNAgwS3A1GL8
         IL6J/s7ZCxMCB31tPtzZI469x2aPi0kjHkfbeXDwRLeIrVxTVp/0d3/6TRf5pLuNGC
         MeMNThwv2V+Ck1XwhMrYwQvfxMamAe/2D351007U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Kelley <mikelley@microsoft.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 326/849] x86/hyperv: Protect set_hv_tscchange_cb() against getting preempted
Date:   Mon, 15 Nov 2021 17:56:49 +0100
Message-Id: <20211115165431.271584276@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 6952e219cba36..d7e1eac3802f4 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -160,7 +160,6 @@ void set_hv_tscchange_cb(void (*cb)(void))
 	struct hv_reenlightenment_control re_ctrl = {
 		.vector = HYPERV_REENLIGHTENMENT_VECTOR,
 		.enabled = 1,
-		.target_vp = hv_vp_index[smp_processor_id()]
 	};
 	struct hv_tsc_emulation_control emu_ctrl = {.enabled = 1};
 
@@ -174,8 +173,12 @@ void set_hv_tscchange_cb(void (*cb)(void))
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



