Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5414D2A590B
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730750AbgKCUnn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:43:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:57808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730746AbgKCUnm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:43:42 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28CB9223C6;
        Tue,  3 Nov 2020 20:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436221;
        bh=rOPMXqEtDNRJwWVXFy6NROEIgc+4CMJJgaNheuscSQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nfNS4IK1+0QuLnsUnEbdHI4lRkRQszIV3wfWUrhFjlkA+NicuOsndsJvCO13vzyay
         DMxYbvRGhr8xQsgrjDDTYhVdYpOmlc8vsrOJbAFpoka1HDXvi7iJrzf61DlTlSWEVM
         hEHqjwypq6ycmSK2k/VXz8OUeGUuUw2KNfOeEd7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Greg Kurz <groug@kaod.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@ozlabs.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 156/391] KVM: PPC: Book3S HV: Do not allocate HPT for a nested guest
Date:   Tue,  3 Nov 2020 21:33:27 +0100
Message-Id: <20201103203357.359796805@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabiano Rosas <farosas@linux.ibm.com>

[ Upstream commit 05e6295dc7de859c9d56334805485c4d20bebf25 ]

The current nested KVM code does not support HPT guests. This is
informed/enforced in some ways:

- Hosts < P9 will not be able to enable the nested HV feature;

- The nested hypervisor MMU capabilities will not contain
  KVM_CAP_PPC_MMU_HASH_V3;

- QEMU reflects the MMU capabilities in the
  'ibm,arch-vec-5-platform-support' device-tree property;

- The nested guest, at 'prom_parse_mmu_model' ignores the
  'disable_radix' kernel command line option if HPT is not supported;

- The KVM_PPC_CONFIGURE_V3_MMU ioctl will fail if trying to use HPT.

There is, however, still a way to start a HPT guest by using
max-compat-cpu=power8 at the QEMU machine options. This leads to the
guest being set to use hash after QEMU calls the KVM_PPC_ALLOCATE_HTAB
ioctl.

With the guest set to hash, the nested hypervisor goes through the
entry path that has no knowledge of nesting (kvmppc_run_vcpu) and
crashes when it tries to execute an hypervisor-privileged (mtspr
HDEC) instruction at __kvmppc_vcore_entry:

root@L1:~ $ qemu-system-ppc64 -machine pseries,max-cpu-compat=power8 ...

<snip>
[  538.543303] CPU: 83 PID: 25185 Comm: CPU 0/KVM Not tainted 5.9.0-rc4 #1
[  538.543355] NIP:  c00800000753f388 LR: c00800000753f368 CTR: c0000000001e5ec0
[  538.543417] REGS: c0000013e91e33b0 TRAP: 0700   Not tainted  (5.9.0-rc4)
[  538.543470] MSR:  8000000002843033 <SF,VEC,VSX,FP,ME,IR,DR,RI,LE>  CR: 22422882  XER: 20040000
[  538.543546] CFAR: c00800000753f4b0 IRQMASK: 3
               GPR00: c0080000075397a0 c0000013e91e3640 c00800000755e600 0000000080000000
               GPR04: 0000000000000000 c0000013eab19800 c000001394de0000 00000043a054db72
               GPR08: 00000000003b1652 0000000000000000 0000000000000000 c0080000075502e0
               GPR12: c0000000001e5ec0 c0000007ffa74200 c0000013eab19800 0000000000000008
               GPR16: 0000000000000000 c00000139676c6c0 c000000001d23948 c0000013e91e38b8
               GPR20: 0000000000000053 0000000000000000 0000000000000001 0000000000000000
               GPR24: 0000000000000001 0000000000000001 0000000000000000 0000000000000001
               GPR28: 0000000000000001 0000000000000053 c0000013eab19800 0000000000000001
[  538.544067] NIP [c00800000753f388] __kvmppc_vcore_entry+0x90/0x104 [kvm_hv]
[  538.544121] LR [c00800000753f368] __kvmppc_vcore_entry+0x70/0x104 [kvm_hv]
[  538.544173] Call Trace:
[  538.544196] [c0000013e91e3640] [c0000013e91e3680] 0xc0000013e91e3680 (unreliable)
[  538.544260] [c0000013e91e3820] [c0080000075397a0] kvmppc_run_core+0xbc8/0x19d0 [kvm_hv]
[  538.544325] [c0000013e91e39e0] [c00800000753d99c] kvmppc_vcpu_run_hv+0x404/0xc00 [kvm_hv]
[  538.544394] [c0000013e91e3ad0] [c0080000072da4fc] kvmppc_vcpu_run+0x34/0x48 [kvm]
[  538.544472] [c0000013e91e3af0] [c0080000072d61b8] kvm_arch_vcpu_ioctl_run+0x310/0x420 [kvm]
[  538.544539] [c0000013e91e3b80] [c0080000072c7450] kvm_vcpu_ioctl+0x298/0x778 [kvm]
[  538.544605] [c0000013e91e3ce0] [c0000000004b8c2c] sys_ioctl+0x1dc/0xc90
[  538.544662] [c0000013e91e3dc0] [c00000000002f9a4] system_call_exception+0xe4/0x1c0
[  538.544726] [c0000013e91e3e20] [c00000000000d140] system_call_common+0xf0/0x27c
[  538.544787] Instruction dump:
[  538.544821] f86d1098 60000000 60000000 48000099 e8ad0fe8 e8c500a0 e9264140 75290002
[  538.544886] 7d1602a6 7cec42a6 40820008 7d0807b4 <7d164ba6> 7d083a14 f90d10a0 480104fd
[  538.544953] ---[ end trace 74423e2b948c2e0c ]---

This patch makes the KVM_PPC_ALLOCATE_HTAB ioctl fail when running in
the nested hypervisor, causing QEMU to abort.

Reported-by: Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
Reviewed-by: Greg Kurz <groug@kaod.org>
Reviewed-by: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_hv.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 3bd3118c76330..e2b476d76506a 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -5257,6 +5257,12 @@ static long kvm_arch_vm_ioctl_hv(struct file *filp,
 	case KVM_PPC_ALLOCATE_HTAB: {
 		u32 htab_order;
 
+		/* If we're a nested hypervisor, we currently only support radix */
+		if (kvmhv_on_pseries()) {
+			r = -EOPNOTSUPP;
+			break;
+		}
+
 		r = -EFAULT;
 		if (get_user(htab_order, (u32 __user *)argp))
 			break;
-- 
2.27.0



