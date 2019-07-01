Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDCCA3908D
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731727AbfFGPsQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:48:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:33402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731740AbfFGPsQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:48:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F07621473;
        Fri,  7 Jun 2019 15:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922494;
        bh=U4oE/BoyLOsyOD9ZAZIJdt1xJZX5yc+JTimxO+wqZVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lb+L4YcOizwzdolMgreg143k/IfL+G/hl8AHaro+a+YtgJ21dPnk6LYtY+uLXSZO6
         vggS+iJcQ9JMNmS3SNqA9GUoeoTvCThsu9GAOpptU5fAAa0Nk+86OiUBL9GBlYM8C7
         C1yqXKs0reijvp285C7HXB2HPBQmb0RKfB8f16kI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Greg Kurz <groug@kaod.org>, Paul Mackerras <paulus@ozlabs.org>
Subject: [PATCH 5.1 34/85] KVM: PPC: Book3S HV: XIVE: Do not clear IRQ data of passthrough interrupts
Date:   Fri,  7 Jun 2019 17:39:19 +0200
Message-Id: <20190607153853.464818722@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153849.101321647@linuxfoundation.org>
References: <20190607153849.101321647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cédric Le Goater <clg@kaod.org>

commit ef9740204051d0e00f5402fe96cf3a43ddd2bbbf upstream.

The passthrough interrupts are defined at the host level and their IRQ
data should not be cleared unless specifically deconfigured (shutdown)
by the host. They differ from the IPI interrupts which are allocated
by the XIVE KVM device and reserved to the guest usage only.

This fixes a host crash when destroying a VM in which a PCI adapter
was passed-through. In this case, the interrupt is cleared and freed
by the KVM device and then shutdown by vfio at the host level.

[ 1007.360265] BUG: Kernel NULL pointer dereference at 0x00000d00
[ 1007.360285] Faulting instruction address: 0xc00000000009da34
[ 1007.360296] Oops: Kernel access of bad area, sig: 7 [#1]
[ 1007.360303] LE PAGE_SIZE=64K MMU=Radix MMU=Hash SMP NR_CPUS=2048 NUMA PowerNV
[ 1007.360314] Modules linked in: vhost_net vhost iptable_mangle ipt_MASQUERADE iptable_nat nf_nat xt_conntrack nf_conntrack nf_defrag_ipv4 ipt_REJECT nf_reject_ipv4 tun bridge stp llc kvm_hv kvm xt_tcpudp iptable_filter squashfs fuse binfmt_misc vmx_crypto ib_iser rdma_cm iw_cm ib_cm libiscsi scsi_transport_iscsi nfsd ip_tables x_tables autofs4 btrfs zstd_decompress zstd_compress lzo_compress raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq multipath mlx5_ib ib_uverbs ib_core crc32c_vpmsum mlx5_core
[ 1007.360425] CPU: 9 PID: 15576 Comm: CPU 18/KVM Kdump: loaded Not tainted 5.1.0-gad7e7d0ef #4
[ 1007.360454] NIP:  c00000000009da34 LR: c00000000009e50c CTR: c00000000009e5d0
[ 1007.360482] REGS: c000007f24ccf330 TRAP: 0300   Not tainted  (5.1.0-gad7e7d0ef)
[ 1007.360500] MSR:  900000000280b033 <SF,HV,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 24002484  XER: 00000000
[ 1007.360532] CFAR: c00000000009da10 DAR: 0000000000000d00 DSISR: 00080000 IRQMASK: 1
[ 1007.360532] GPR00: c00000000009e62c c000007f24ccf5c0 c000000001510600 c000007fe7f947c0
[ 1007.360532] GPR04: 0000000000000d00 0000000000000000 0000000000000000 c000005eff02d200
[ 1007.360532] GPR08: 0000000000400000 0000000000000000 0000000000000000 fffffffffffffffd
[ 1007.360532] GPR12: c00000000009e5d0 c000007fffff7b00 0000000000000031 000000012c345718
[ 1007.360532] GPR16: 0000000000000000 0000000000000008 0000000000418004 0000000000040100
[ 1007.360532] GPR20: 0000000000000000 0000000008430000 00000000003c0000 0000000000000027
[ 1007.360532] GPR24: 00000000000000ff 0000000000000000 00000000000000ff c000007faa90d98c
[ 1007.360532] GPR28: c000007faa90da40 00000000000fe040 ffffffffffffffff c000007fe7f947c0
[ 1007.360689] NIP [c00000000009da34] xive_esb_read+0x34/0x120
[ 1007.360706] LR [c00000000009e50c] xive_do_source_set_mask.part.0+0x2c/0x50
[ 1007.360732] Call Trace:
[ 1007.360738] [c000007f24ccf5c0] [c000000000a6383c] snooze_loop+0x15c/0x270 (unreliable)
[ 1007.360775] [c000007f24ccf5f0] [c00000000009e62c] xive_irq_shutdown+0x5c/0xe0
[ 1007.360795] [c000007f24ccf630] [c00000000019e4a0] irq_shutdown+0x60/0xe0
[ 1007.360813] [c000007f24ccf660] [c000000000198c44] __free_irq+0x3a4/0x420
[ 1007.360831] [c000007f24ccf700] [c000000000198dc8] free_irq+0x78/0xe0
[ 1007.360849] [c000007f24ccf730] [c00000000096c5a8] vfio_msi_set_vector_signal+0xa8/0x350
[ 1007.360878] [c000007f24ccf7f0] [c00000000096c938] vfio_msi_set_block+0xe8/0x1e0
[ 1007.360899] [c000007f24ccf850] [c00000000096cae0] vfio_msi_disable+0xb0/0x110
[ 1007.360912] [c000007f24ccf8a0] [c00000000096cd04] vfio_pci_set_msi_trigger+0x1c4/0x3d0
[ 1007.360922] [c000007f24ccf910] [c00000000096d910] vfio_pci_set_irqs_ioctl+0xa0/0x170
[ 1007.360941] [c000007f24ccf930] [c00000000096b400] vfio_pci_disable+0x80/0x5e0
[ 1007.360963] [c000007f24ccfa10] [c00000000096b9bc] vfio_pci_release+0x5c/0x90
[ 1007.360991] [c000007f24ccfa40] [c000000000963a9c] vfio_device_fops_release+0x3c/0x70
[ 1007.361012] [c000007f24ccfa70] [c0000000003b5668] __fput+0xc8/0x2b0
[ 1007.361040] [c000007f24ccfac0] [c0000000001409b0] task_work_run+0x140/0x1b0
[ 1007.361059] [c000007f24ccfb20] [c000000000118f8c] do_exit+0x3ac/0xd00
[ 1007.361076] [c000007f24ccfc00] [c0000000001199b0] do_group_exit+0x60/0x100
[ 1007.361094] [c000007f24ccfc40] [c00000000012b514] get_signal+0x1a4/0x8f0
[ 1007.361112] [c000007f24ccfd30] [c000000000021cc8] do_notify_resume+0x1a8/0x430
[ 1007.361141] [c000007f24ccfe20] [c00000000000e444] ret_from_except_lite+0x70/0x74
[ 1007.361159] Instruction dump:
[ 1007.361175] 38422c00 e9230000 712a0004 41820010 548a2036 7d442378 78840020 71290020
[ 1007.361194] 4082004c e9230010 7c892214 7c0004ac <e9240000> 0c090000 4c00012c 792a0022

Cc: stable@vger.kernel.org # v4.12+
Fixes: 5af50993850a ("KVM: PPC: Book3S HV: Native usage of the XIVE interrupt controller")
Signed-off-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Greg Kurz <groug@kaod.org>
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kvm/book3s_xive.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kvm/book3s_xive.c
+++ b/arch/powerpc/kvm/book3s_xive.c
@@ -1786,7 +1786,6 @@ static void kvmppc_xive_cleanup_irq(u32
 {
 	xive_vm_esb_load(xd, XIVE_ESB_SET_PQ_01);
 	xive_native_configure_irq(hw_num, 0, MASKED, 0);
-	xive_cleanup_irq_data(xd);
 }
 
 static void kvmppc_xive_free_sources(struct kvmppc_xive_src_block *sb)
@@ -1800,9 +1799,10 @@ static void kvmppc_xive_free_sources(str
 			continue;
 
 		kvmppc_xive_cleanup_irq(state->ipi_number, &state->ipi_data);
+		xive_cleanup_irq_data(&state->ipi_data);
 		xive_native_free_irq(state->ipi_number);
 
-		/* Pass-through, cleanup too */
+		/* Pass-through, cleanup too but keep IRQ hw data */
 		if (state->pt_number)
 			kvmppc_xive_cleanup_irq(state->pt_number, state->pt_data);
 


