Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C88D30CA36
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 19:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233746AbhBBSmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 13:42:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:47084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233720AbhBBOCz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:02:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B0D165000;
        Tue,  2 Feb 2021 13:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273674;
        bh=YTMoRGl6oNhgN8j7e9cX7LYd/JEqbwZm8vfZePlktbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2dj3rWk1n/cf2S34uvD0+QI+fsDEUC76OTFokkXH+OTTHohSkvN4Kvy7swqrg4SAz
         hBc4Q8MnvnzmmYrPPJksIHu7BaEuWjbwkFgPe3a3OChzzlRo3VbXx06lejo04vAIwy
         jZ0sfiUJ+Fbk6UVlse4HW+DoTD12FuR+42w7YrQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+ae488dc136a4cc6ba32b@syzkaller.appspotmail.com,
        Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.4 18/61] KVM: x86/pmu: Fix UBSAN shift-out-of-bounds warning in intel_pmu_refresh()
Date:   Tue,  2 Feb 2021 14:37:56 +0100
Message-Id: <20210202132947.229146255@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132946.480479453@linuxfoundation.org>
References: <20210202132946.480479453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

commit e61ab2a320c3dfd6209efe18a575979e07470597 upstream.

Since we know vPMU will not work properly when (1) the guest bit_width(s)
of the [gp|fixed] counters are greater than the host ones, or (2) guest
requested architectural events exceeds the range supported by the host, so
we can setup a smaller left shift value and refresh the guest cpuid entry,
thus fixing the following UBSAN shift-out-of-bounds warning:

shift exponent 197 is too large for 64-bit type 'long long unsigned int'

Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
 __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x181 lib/ubsan.c:395
 intel_pmu_refresh.cold+0x75/0x99 arch/x86/kvm/vmx/pmu_intel.c:348
 kvm_vcpu_after_set_cpuid+0x65a/0xf80 arch/x86/kvm/cpuid.c:177
 kvm_vcpu_ioctl_set_cpuid2+0x160/0x440 arch/x86/kvm/cpuid.c:308
 kvm_arch_vcpu_ioctl+0x11b6/0x2d70 arch/x86/kvm/x86.c:4709
 kvm_vcpu_ioctl+0x7b9/0xdb0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3386
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl fs/ioctl.c:739 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Reported-by: syzbot+ae488dc136a4cc6ba32b@syzkaller.appspotmail.com
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Message-Id: <20210118025800.34620-1-like.xu@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx/pmu_intel.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -296,7 +296,9 @@ static void intel_pmu_refresh(struct kvm
 
 	pmu->nr_arch_gp_counters = min_t(int, eax.split.num_counters,
 					 x86_pmu.num_counters_gp);
+	eax.split.bit_width = min_t(int, eax.split.bit_width, x86_pmu.bit_width_gp);
 	pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << eax.split.bit_width) - 1;
+	eax.split.mask_length = min_t(int, eax.split.mask_length, x86_pmu.events_mask_len);
 	pmu->available_event_types = ~entry->ebx &
 					((1ull << eax.split.mask_length) - 1);
 
@@ -306,6 +308,8 @@ static void intel_pmu_refresh(struct kvm
 		pmu->nr_arch_fixed_counters =
 			min_t(int, edx.split.num_counters_fixed,
 			      x86_pmu.num_counters_fixed);
+		edx.split.bit_width_fixed = min_t(int,
+			edx.split.bit_width_fixed, x86_pmu.bit_width_fixed);
 		pmu->counter_bitmask[KVM_PMC_FIXED] =
 			((u64)1 << edx.split.bit_width_fixed) - 1;
 	}


