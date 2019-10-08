Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5A1CF3A8
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 09:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730150AbfJHHXk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 03:23:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:36012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730112AbfJHHXk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Oct 2019 03:23:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4EAF205C9;
        Tue,  8 Oct 2019 07:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570519419;
        bh=jDEkE9sNFS8+V5JW7XziDxDRXNgl/9dmT5rk4n/8yyU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NBBlV1ghqKBi+laU2kDHQwrJfDX6LLh69D9nYqiVAWotkNP5FxK8dvTzgh+zBttXL
         RUeNYapQBGhtjQBT+jZMTH74Lc+zcam7stVlYlHYN58uizRNYheHXmjWFRwVG2jjoB
         B6QsBWTzwy0OsyGDZBw35IIggb1B8S9alcse9KEc=
Date:   Tue, 8 Oct 2019 09:23:37 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jack Wang <jinpuwang@gmail.com>, sashal@kernel.org,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: Re: [stable 4.4/4.9/4.14/4.19] KVM: nVMX: handle page fault in
 vmread fix
Message-ID: <20191008072337.GA2472560@kroah.com>
References: <20191007123653.17961-1-jinpuwang@gmail.com>
 <2fed8f4e-c2df-9bde-9d0f-7d0882aa19a4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2fed8f4e-c2df-9bde-9d0f-7d0882aa19a4@redhat.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 07, 2019 at 03:05:34PM +0200, Paolo Bonzini wrote:
> On 07/10/19 14:36, Jack Wang wrote:
> > From: Jack Wang <jinpu.wang@cloud.ionos.com>
> > 
> > During backport f7eea636c3d5 ("KVM: nVMX: handle page fault in vmread"),
> > there was a mistake the exception reference should be passed to function
> > kvm_write_guest_virt_system, instead of NULL, other wise, we will get
> > NULL pointer deref, eg
> > 
> > kvm-unit-test triggered a NULL pointer deref below:
> > [  948.518437] kvm [24114]: vcpu0, guest rIP: 0x407ef9 kvm_set_msr_common: MSR_IA32_DEBUGCTLMSR 0x3, nop
> > [  949.106464] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
> > [  949.106707] PGD 0 P4D 0
> > [  949.106872] Oops: 0002 [#1] SMP
> > [  949.107038] CPU: 2 PID: 24126 Comm: qemu-2.7 Not tainted 4.19.77-pserver #4.19.77-1+feature+daily+update+20191005.1625+a4168bb~deb9
> > [  949.107283] Hardware name: Dell Inc. Precision Tower 3620/09WH54, BIOS 2.7.3 01/31/2018
> > [  949.107549] RIP: 0010:kvm_write_guest_virt_system+0x12/0x40 [kvm]
> > [  949.107719] Code: c0 5d 41 5c 41 5d 41 5e 83 f8 03 41 0f 94 c0 41 c1 e0 02 e9 b0 ed ff ff 0f 1f 44 00 00 48 89 f0 c6 87 59 56 00 00 01 48 89 d6 <49> c7 00 00 00 00 00 89 ca 49 c7 40 08 00 00 00 00 49 c7 40 10 00
> > [  949.108044] RSP: 0018:ffffb31b0a953cb0 EFLAGS: 00010202
> > [  949.108216] RAX: 000000000046b4d8 RBX: ffff9e9f415b0000 RCX: 0000000000000008
> > [  949.108389] RDX: ffffb31b0a953cc0 RSI: ffffb31b0a953cc0 RDI: ffff9e9f415b0000
> > [  949.108562] RBP: 00000000d2e14928 R08: 0000000000000000 R09: 0000000000000000
> > [  949.108733] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffffffffffc8
> > [  949.108907] R13: 0000000000000002 R14: ffff9e9f4f26f2e8 R15: 0000000000000000
> > [  949.109079] FS:  00007eff8694c700(0000) GS:ffff9e9f51a80000(0000) knlGS:0000000031415928
> > [  949.109318] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [  949.109495] CR2: 0000000000000000 CR3: 00000003be53b002 CR4: 00000000003626e0
> > [  949.109671] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [  949.109845] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > [  949.110017] Call Trace:
> > [  949.110186]  handle_vmread+0x22b/0x2f0 [kvm_intel]
> > [  949.110356]  ? vmexit_fill_RSB+0xc/0x30 [kvm_intel]
> > [  949.110549]  kvm_arch_vcpu_ioctl_run+0xa98/0x1b30 [kvm]
> > [  949.110725]  ? kvm_vcpu_ioctl+0x388/0x5d0 [kvm]
> > [  949.110901]  kvm_vcpu_ioctl+0x388/0x5d0 [kvm]
> > [  949.111072]  do_vfs_ioctl+0xa2/0x620
> > 
> > Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> > ---
> >  arch/x86/kvm/vmx.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> > index f6b0f5c01546..3bfdbb5fced5 100644
> > --- a/arch/x86/kvm/vmx.c
> > +++ b/arch/x86/kvm/vmx.c
> > @@ -8026,7 +8026,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
> >  		/* _system ok, nested_vmx_check_permission has verified cpl=0 */
> >  		if (kvm_write_guest_virt_system(vcpu, gva, &field_value,
> >  						(is_long_mode(vcpu) ? 8 : 4),
> > -						NULL))
> > +						&e))
> >  			kvm_inject_page_fault(vcpu, &e);
> >  	}
> >  
> > 
> 
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Now applied, thanks!

greg k-h
