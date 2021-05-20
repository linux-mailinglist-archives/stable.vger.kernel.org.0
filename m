Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54537389D6C
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 07:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbhETF5l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 01:57:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230255AbhETF5k (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 01:57:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5417610CC;
        Thu, 20 May 2021 05:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621490179;
        bh=ydM3vfpkcc4TbIxtmaCdDBOoA0NS1RoJmAU7WRiRL/A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XA96Aq0muzPdR0sSWDQovZK2zFU9BDQw6+JdMCYY1JByJYuVN3PDAM4MbN8YVeFmJ
         hZFQl0gVcf1AbiglrzGL4n2NwaM8HmxeRz/vDBihsDYBnRAfKC6nqb3wpLtriHd4ki
         XqyrKOODWqKl0paQaWtcMRGJT9y3RLhfMe4Ip8zo=
Date:   Thu, 20 May 2021 07:56:16 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Imran Khan <imran.f.khan@oracle.com>
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [RFC PATCH] x86/apic: Fix BUG due to multiple allocation of
 legacy vectors.
Message-ID: <YKX6AJZVaqGNn3Yg@kroah.com>
References: <20210519233928.2157496-1-imran.f.khan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519233928.2157496-1-imran.f.khan@oracle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 19, 2021 at 11:39:28PM +0000, Imran Khan wrote:
> During activation of secondary CPUs, lapic_online is
> invoked to initialize vectors. While lapic_online
> installs legacy vectors on all CPUs, it does not set
> the corresponding bits in per CPU bitmap maintained
> under irq_matrix.
> This may result in these legacy vectors getting allocated
> by irq_matrix_alloc and if that happens subsequent invocation
> of apic_update_vector will cause BUG like the one shown below:
> 
> [  154.738226] kernel BUG at arch/x86/kernel/apic/vector.c:172!
> [  154.805956] invalid opcode: 0000 [#1] SMP PTI
> [  154.858092] CPU: 22 PID: 3569 Comm: ifup-eth Not tainted 5.8.0-20200716.x86_64 #1
> [  154.954939] Hardware name: Oracle Corporation ORACLE SERVER X6-2/ASM,MOTHERBOARD,1U
> [  155.073636] RIP: 0010:apic_update_vector+0xa7/0x190
> [  155.131996] Code: 01 00 4a 8b 14 ed 80 69 01 a6 48 89 c8 4a 8d 04 e0 48 8b 04 10 48
> 85 c0 0f 84 d2 00 00 00 48 3d 00 f0 ff ff 0f 87 c6 00 00 00 <0f> 0b 41 8b 46 10 48 0f
> a3 05 6b 3e 7c 01 0f 92 c0 84 c0 0f 84 83
> [  155.356788] RSP: 0018:ffffb3848b417970 EFLAGS: 00010087
> [  155.419311] RAX: ffff9e9047c79000 RBX: 0000000000000000 RCX: 0000000000017040
> [  155.504719] RDX: ffff9e9fbf800000 RSI: 0000000000000182 RDI: ffff9e9fbe7936c0
> [  155.590127] RBP: ffffb3848b4179b0 R08: 0000000000000000 R09: 0004000000000000
> [  155.675533] R10: ffff000000000000 R11: 0000000000000246 R12: 0000000000000030
> [  155.760939] R13: 000000000000000a R14: ffff9e9fbe7939c0 R15: 0000000000000030
> [  155.846341] FS:  00007f6513279740(0000) GS:ffff9e979fb00000(0000) knlGS:0000000000000000
> [  155.943189] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  156.011947] CR2: 00007f6513280000 CR3: 00000007f2cbc003 CR4: 00000000003606e0
> [  156.097355] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  156.182761] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  156.268168] Call Trace:
> [  156.297409]  ? irq_matrix_alloc+0x8a/0x150
> [  156.346408]  assign_vector_locked+0xd2/0x170
> [  156.397489]  x86_vector_activate+0x1b5/0x320
> [  156.448570]  __irq_domain_activate_irq+0x64/0xa0
> [  156.503808]  __irq_domain_activate_irq+0x38/0xa0
> [  156.559050]  irq_domain_activate_irq+0x2b/0x40
> [  156.612213]  irq_activate+0x25/0x30
> [  156.653930]  __setup_irq+0x58f/0x7b0
> [  156.696690]  request_threaded_irq+0xf8/0x1b0
> [  156.747784]  ixgbe_open+0x3af/0x600 [ixgbe]
> [  156.797827]  __dev_open+0xd8/0x160
> [  156.838503]  dev_open+0x48/0x90
> [  156.876065]  bond_enslave+0x2b6/0x12c0 [bonding]
> [  156.931310]  ? vsscanf+0x5af/0x8e0
> [  156.971986]  ? sscanf+0x4e/0x70
> [  157.009546]  bond_option_slaves_set+0x112/0x1c0 [bonding]
> [  157.074148]  __bond_opt_set+0xdc/0x320 [bonding]
> [  157.129389]  __bond_opt_set_notify+0x2c/0x90 [bonding]
> [  157.190871]  bond_opt_tryset_rtnl+0x56/0xa0 [bonding]
> [  157.251315]  bonding_sysfs_store_option+0x52/0x90 [bonding]
> 
> This patch marks these legacy vectors as assigned in irq_matrix
> so that corresponding bits in percpu bitmaps get set and these
> legacy vectors don't get reallocted.
> 
> Signed-off-by: Imran Khan <imran.f.khan@oracle.com>
> ---
>  arch/x86/kernel/apic/vector.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
