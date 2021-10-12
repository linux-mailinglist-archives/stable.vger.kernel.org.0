Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CABB442B00E
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 01:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbhJLXU7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 19:20:59 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:36761 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbhJLXU6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 19:20:58 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HTWnQ61KVz4xbV;
        Wed, 13 Oct 2021 10:18:50 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1634080731;
        bh=OE6oRoU7leftmpozpM8opqbtx84rI3zCAItSRNesiQk=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Mdum3yIMUjGfJifyYvGdr+Ag2TbM1alq9gb+Sop2EEe2Fc35dSsmd99zNRoDgGo6v
         FLGa/9XnuWu6lc5D6qRaJZ9oL1OsgLxwCdlK93/8Ib/MttYrhK5/2u2OpGtWIfHsk8
         f5qgza7AW+PD6CrCdzF8pNBAeFlqUxvuPmuQVdS+TsO7OUQytk2qo+6Y0a/1fOmE7r
         CLFAbVW1AXtYxIjnxcG/TyQNEJ3RyPktzL6Vtb1hAx+fGNbJC1NrxEyg1Z8/BBd4dd
         DmtVYTYPLeuQU88R6ITWBCpw1F9j9UDi5uq2w4zT3o9qmdC7zDgkpzIEOpJcGXFqC7
         8Hl15ysA9tyHg==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Laurent Vivier <lvivier@redhat.com>, kvm-ppc@vger.kernel.org
Cc:     Paul Mackerras <paulus@ozlabs.org>, Greg Kurz <groug@kaod.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        linuxppc-dev@lists.ozlabs.org, Laurent Vivier <lvivier@redhat.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] KVM: PPC: Defer vtime accounting 'til after IRQ
 handling
In-Reply-To: <20211007142856.41205-1-lvivier@redhat.com>
References: <20211007142856.41205-1-lvivier@redhat.com>
Date:   Wed, 13 Oct 2021 10:18:47 +1100
Message-ID: <875yu17rxk.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Laurent Vivier <lvivier@redhat.com> writes:
> Commit 112665286d08 moved guest_exit() in the interrupt protected
> area to avoid wrong context warning (or worse), but the tick counter
> cannot be updated and the guest time is accounted to the system time.
>
> To fix the problem port to POWER the x86 fix
> 160457140187 ("Defer vtime accounting 'til after IRQ handling"):
>
> "Defer the call to account guest time until after servicing any IRQ(s)
>  that happened in the guest or immediately after VM-Exit.  Tick-based
>  accounting of vCPU time relies on PF_VCPU being set when the tick IRQ
>  handler runs, and IRQs are blocked throughout the main sequence of
>  vcpu_enter_guest(), including the call into vendor code to actually
>  enter and exit the guest."
>
> Fixes: 112665286d08 ("KVM: PPC: Book3S HV: Context tracking exit guest context before enabling irqs")
> Cc: npiggin@gmail.com
> Cc: <stable@vger.kernel.org> # 5.12
> Signed-off-by: Laurent Vivier <lvivier@redhat.com>
> ---
>
> Notes:
>     v2: remove reference to commit 61bd0f66ff92
>         cc stable 5.12
>         add the same comment in the code as for x86
>
>  arch/powerpc/kvm/book3s_hv.c | 24 ++++++++++++++++++++----
>  1 file changed, 20 insertions(+), 4 deletions(-)
>
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 2acb1c96cfaf..a694d1a8f6ce 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
...
> @@ -4506,13 +4514,21 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
>  
>  	srcu_read_unlock(&kvm->srcu, srcu_idx);
>  
> +	context_tracking_guest_exit();
> +
>  	set_irq_happened(trap);
>  
>  	kvmppc_set_host_core(pcpu);
>  
> -	guest_exit_irqoff();
> -
>  	local_irq_enable();
> +	/*
> +	 * Wait until after servicing IRQs to account guest time so that any
> +	 * ticks that occurred while running the guest are properly accounted
> +	 * to the guest.  Waiting until IRQs are enabled degrades the accuracy
> +	 * of accounting via context tracking, but the loss of accuracy is
> +	 * acceptable for all known use cases.
> +	 */
> +	vtime_account_guest_exit();

This pops a warning for me, running guest(s) on Power8:
 
  [  270.745303][T16661] ------------[ cut here ]------------
  [  270.745374][T16661] WARNING: CPU: 72 PID: 16661 at arch/powerpc/kernel/time.c:311 vtime_account_kernel+0xe0/0xf0
  [  270.745397][T16661] Modules linked in: nf_conntrack_netlink xfrm_user xfrm_algo xt_addrtype xt_MASQUERADE xt_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp iptable_mangle iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nfnetlink ip6table_filter ip6_tables iptable_filter tun overlay fuse kvm_hv kvm binfmt_misc squashfs mlx4_ib dm_multipath scsi_dh_rdac ib_uverbs scsi_dh_alua mlx4_en ib_core sr_mod cdrom lpfc bnx2x sg mlx4_core mdio crc_t10dif crct10dif_generic scsi_transport_fc vmx_crypto gf128mul leds_powernv crct10dif_vpmsum powernv_rng led_class crct10dif_common powernv_op_panel rng_core crc32c_vpmsum sunrpc ip_tables x_tables autofs4
  [  270.745565][T16661] CPU: 72 PID: 16661 Comm: qemu-system-ppc Not tainted 5.15.0-rc5-01885-g5e96f0599cff #1
  [  270.745578][T16661] NIP:  c000000000027c20 LR: c00800000b6e9ca8 CTR: c000000000027b40
  [  270.745588][T16661] REGS: c00000081043f4f0 TRAP: 0700   Not tainted  (5.15.0-rc5-01885-g5e96f0599cff)
  [  270.745599][T16661] MSR:  900000000282b033 <SF,HV,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 22442222  XER: 20000000
  [  270.745635][T16661] CFAR: c000000000027b7c IRQMASK: 0
  [  270.745635][T16661] GPR00: c00800000b6e9ca8 c00000081043f790 c00000000248f900 c000000ffffda820
  [  270.745635][T16661] GPR04: c00000080b93b488 0000000000000006 00000000000f4240 c000001fffffc000
  [  270.745635][T16661] GPR08: 0000000ffa6f0000 0000000000000000 0000000000008002 c00800000b6ffba8
  [  270.745635][T16661] GPR12: c000000000027b40 c000000ffffd9e00 0000000000000001 0000000000000000
  [  270.745635][T16661] GPR16: 0000000000000000 c00000000254c0b0 0000000000000000 c000000941e84414
  [  270.745635][T16661] GPR20: 0000000000000001 0000000000000048 c00800000b710f0c 0000000000000001
  [  270.745635][T16661] GPR24: c000000941e90aa8 0000000000000000 c0000000024c6d60 0000000000000001
  [  270.745635][T16661] GPR28: c000000803222470 c00000080b93aa00 0000000000000008 c000000ffffd9e00
  [  270.745747][T16661] NIP [c000000000027c20] vtime_account_kernel+0xe0/0xf0
  [  270.745756][T16661] LR [c00800000b6e9ca8] kvmppc_run_core+0xda0/0x16c0 [kvm_hv]
  [  270.745773][T16661] Call Trace:
  [  270.745779][T16661] [c00000081043f790] [c00000081043f7d0] 0xc00000081043f7d0 (unreliable)
  [  270.745793][T16661] [c00000081043f7d0] [c00800000b6e9ca8] kvmppc_run_core+0xda0/0x16c0 [kvm_hv]
  [  270.745808][T16661] [c00000081043f950] [c00800000b6eee28] kvmppc_vcpu_run_hv+0x570/0xce0 [kvm_hv]
  [  270.745823][T16661] [c00000081043fa10] [c00800000b5d2afc] kvmppc_vcpu_run+0x34/0x48 [kvm]
  [  270.745847][T16661] [c00000081043fa30] [c00800000b5ce728] kvm_arch_vcpu_ioctl_run+0x340/0x450 [kvm]
  [  270.745870][T16661] [c00000081043fac0] [c00800000b5bc060] kvm_vcpu_ioctl+0x338/0x930 [kvm]
  [  270.745890][T16661] [c00000081043fca0] [c00000000050b7b4] sys_ioctl+0x6b4/0x13b0
  [  270.745901][T16661] [c00000081043fdb0] [c00000000002fa54] system_call_exception+0x184/0x330
  [  270.745912][T16661] [c00000081043fe10] [c00000000000c84c] system_call_common+0xec/0x268
  [  270.745923][T16661] --- interrupt: c00 at 0x7fff9eb9f010
  [  270.745930][T16661] NIP:  00007fff9eb9f010 LR: 0000000136aa3670 CTR: 0000000000000000
  [  270.745937][T16661] REGS: c00000081043fe80 TRAP: 0c00   Not tainted  (5.15.0-rc5-01885-g5e96f0599cff)
  [  270.745945][T16661] MSR:  900000000280f033 <SF,HV,VEC,VSX,EE,PR,FP,ME,IR,DR,RI,LE>  CR: 22444802  XER: 00000000
  [  270.745974][T16661] IRQMASK: 0
  [  270.745974][T16661] GPR00: 0000000000000036 00007fff9d5bdc30 00007fff9ec97100 000000000000000d
  [  270.745974][T16661] GPR04: 000000002000ae80 0000000000000000 0000000000000000 0000000000000000
  [  270.745974][T16661] GPR08: 000000000000000d 0000000000000000 0000000000000000 0000000000000000
  [  270.745974][T16661] GPR12: 0000000000000000 00007fff9d5c6290 00007fff9ece4410 0000000000000000
  [  270.745974][T16661] GPR16: 00007fff9f970000 00007fff9ece0320 00007fff9d5bebe0 00007fff9f8d0028
  [  270.745974][T16661] GPR20: 0000000000000000 0000000000000000 00000001370fd068 000000002000ae80
  [  270.745974][T16661] GPR24: 00007fff9d7100ae 0000000000000000 00007fff9d5bf290 00007fff9d720010
  [  270.745974][T16661] GPR28: 00000001376611c0 00007fff9d720010 0000000000000000 000000002000ae80
  [  270.746064][T16661] NIP [00007fff9eb9f010] 0x7fff9eb9f010
  [  270.746071][T16661] LR [0000000136aa3670] 0x136aa3670
  [  270.746078][T16661] --- interrupt: c00
  [  270.746083][T16661] Instruction dump:
  [  270.746090][T16661] 7c691a14 f89f0a40 f87f0a30 e8010010 eba1ffe8 ebc1fff0 ebe1fff8 7c0803a6
  [  270.746109][T16661] 4e800020 60000000 60000000 60420000 <0fe00000> 60000000 60000000 60420000
  [  270.746128][T16661] irq event stamp: 2118
  [  270.746133][T16661] hardirqs last  enabled at (2117): [<c00800000b6e9c8c>] kvmppc_run_core+0xd84/0x16c0 [kvm_hv]
  [  270.746146][T16661] hardirqs last disabled at (2118): [<c0000000000293dc>] interrupt_enter_prepare.constprop.0+0xfc/0x140
  [  270.746156][T16661] softirqs last  enabled at (1940): [<c000000000fd6b8c>] __do_softirq+0x5ec/0x658
  [  270.746166][T16661] softirqs last disabled at (1935): [<c00000000011a6e8>] __irq_exit_rcu+0x158/0x1c0
  [  270.746176][T16661] ---[ end trace b1b029e8dc7c2667 ]---


cheers
