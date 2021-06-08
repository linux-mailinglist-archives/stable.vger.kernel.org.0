Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6189C39F63D
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 14:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbhFHMUA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 08:20:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:33932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232452AbhFHMUA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 08:20:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62CBE61073;
        Tue,  8 Jun 2021 12:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623154681;
        bh=Rq0V8EoWTmyVk1fYFOYY5fRKRTQNuYHRTh12/kWNbtg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H1OODlGxqj3f9PgYcve8Je+rJMf8ochjPr82KmTwcbbgt6Z3TZ1QIdoiqRnn8If34
         Wgr0/J2kXJrh3sm78t122hIM6uNe3ttXVE/fO/lcByqqR4WFnmAX6RrH3PVT77aEd9
         DdJh55o2W3nQNaiVilKdduuR1iXnQ4zg9B/7AdpE=
Date:   Tue, 8 Jun 2021 14:17:58 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Corentin =?iso-8859-1?Q?No=EBl?= <corentin.noel@collabora.com>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, stable@vger.kernel.org,
        "Michael S.Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        regressions@lists.linux.dev, Eric Dumazet <edumazet@google.com>
Subject: Re: virtio-net: kernel panic in virtio_net.c
Message-ID: <YL9f9uFoPGj2Q9Zl@kroah.com>
References: <1622688283.7488964-1-xuanzhuo@linux.alibaba.com>
 <6a9ec4daa03a68d8d74e90bec358324f95ec1c32.camel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6a9ec4daa03a68d8d74e90bec358324f95ec1c32.camel@collabora.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 03, 2021 at 10:57:52AM +0200, Corentin Noël wrote:
> Le jeudi 03 juin 2021 à 10:44 +0800, Xuan Zhuo a écrit :
> > On Wed, 02 Jun 2021 19:54:41 +0200, Corentin Noël <
> > corentin.noel@collabora.com> wrote:
> > > Sure, here is the decoded trace:
> > > 
> > > [   44.523231] skbuff: skb_over_panic: text:ffffffffad1a8434
> > > len:3762
> > > put:3762 head:ffff9799e6b6b000 data:ffff9799e6b6b010 tail:0xec2
> > > end:0xec0 dev:<NULL>
> > > [   44.525254] kernel BUG at net/core/skbuff.c:110!
> > > [   44.525910] invalid opcode: 0000 [#1] SMP PTI
> > > [   44.526521] CPU: 2 PID: 245 Comm: llvmpipe-0 Not tainted 5.13.0-
> > > rc4linux-v5.13-rc4-for-mesa-ci-184862285c49.tar.bz2 #1
> > > [   44.528109] Hardware name: ChromiumOS crosvm, BIOS 0
> > > [   44.529243] RIP: 0010:skb_panic (net/core/skbuff.c:110)
> > > [ 44.530284] Code: 4f 70 50 8b 87 bc 00 00 00 50 8b 87 b8 00 00 00
> > > 50
> > > ff b7 c8 00 00 00 4c 8b 8f c0 00 00 00 48 c7 c7 f0 af cf ad e8 43
> > > 4c fb
> > > ff <0f> 0b 48 8b 14 24 48 c7 c1 20 23 b1 ad e8 ab ff ff ff 48 c7 c6
> > > 60
> > > All code
> > > ========
> > >    0:	4f 70 50             	rex.WRXB jo 0x53
> > >    3:	8b 87 bc 00 00 00    	mov    0xbc(%rdi),%eax
> > >    9:	50                   	push   %rax
> > >    a:	8b 87 b8 00 00 00    	mov    0xb8(%rdi),%eax
> > >   10:	50                   	push   %rax
> > >   11:	ff b7 c8 00 00 00    	pushq  0xc8(%rdi)
> > >   17:	4c 8b 8f c0 00 00 00 	mov    0xc0(%rdi),%r9
> > >   1e:	48 c7 c7 f0 af cf ad 	mov    $0xffffffffadcfaff0,
> > > %rdi
> > >   25:	e8 43 4c fb ff       	callq  0xfffffffffffb4c6d
> > >   2a:*	0f 0b                	ud2    		<--
> > > trapping
> > > instruction
> > >   2c:	48 8b 14 24          	mov    (%rsp),%rdx
> > >   30:	48 c7 c1 20 23 b1 ad 	mov    $0xffffffffadb12320,
> > > %rcx
> > >   37:	e8 ab ff ff ff       	callq  0xffffffffffffffe7
> > >   3c:	48                   	rex.W
> > >   3d:	c7                   	.byte 0xc7
> > >   3e:	c6                   	(bad)
> > >   3f:	60                   	(bad)
> > > 
> > > Code starting with the faulting instruction
> > > ===========================================
> > >    0:	0f 0b                	ud2
> > >    2:	48 8b 14 24          	mov    (%rsp),%rdx
> > >    6:	48 c7 c1 20 23 b1 ad 	mov    $0xffffffffadb12320,
> > > %rcx
> > >    d:	e8 ab ff ff ff       	callq  0xffffffffffffffbd
> > >   12:	48                   	rex.W
> > >   13:	c7                   	.byte 0xc7
> > >   14:	c6                   	(bad)
> > >   15:	60                   	(bad)
> > > [   44.533988] RSP: 0000:ffffa651c134fc20 EFLAGS: 00010246
> > > [   44.534723] RAX: 000000000000008b RBX: 0000000000000010 RCX:
> > > 00000000ffffdfff
> > > [   44.535772] RDX: 0000000000000000 RSI: 00000000ffffffea RDI:
> > > 0000000000000000
> > > [   44.536693] RBP: ffffd77b009adac0 R08: ffffffffadf44b08 R09:
> > > 0000000000009ffb
> > > [   44.537569] R10: 00000000ffffe000 R11: 3fffffffffffffff R12:
> > > ffff979ad2aa5600
> > > [   44.538449] R13: 0000000000000000 R14: ffff9799e6b6b000 R15:
> > > 0000000000000eb2
> > > [   44.539300] FS:  00007fdb9cb11700(0000)
> > > GS:ffff979aebd00000(0000)
> > > knlGS:0000000000000000
> > > [   44.540376] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [   44.541103] CR2: 00007f99099f4024 CR3: 0000000129558005 CR4:
> > > 0000000000370ee0
> > > [   44.542057] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> > > 0000000000000000
> > > [   44.543063] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> > > 0000000000000400
> > > [   44.544063] Call Trace:
> > > [   44.544385] skb_put.cold (net/core/skbuff.c:5254 (discriminator
> > > 1)
> > > net/core/skbuff.c:5252 (discriminator 1))
> > > [   44.544864] page_to_skb (drivers/net/virtio_net.c:485)
> > > [   44.545361] receive_buf (drivers/net/virtio_net.c:849
> > > drivers/net/virtio_net.c:1131)
> > > [   44.545870] ? netif_receive_skb_list_internal
> > > (net/core/dev.c:5714)
> > > [   44.546628] ? dev_gro_receive (net/core/dev.c:6103)
> > > [   44.547135] ? napi_complete_done (./include/linux/list.h:35
> > > net/core/dev.c:5867 net/core/dev.c:5862 net/core/dev.c:6565)
> > > [   44.547672] virtnet_poll (drivers/net/virtio_net.c:1427
> > > drivers/net/virtio_net.c:1525)
> > > [   44.548251] __napi_poll (net/core/dev.c:6985)
> > > [   44.548744] net_rx_action (net/core/dev.c:7054
> > > net/core/dev.c:7139)
> > > [   44.549264] __do_softirq (./arch/x86/include/asm/jump_label.h:19
> > > ./include/linux/jump_label.h:200 ./include/trace/events/irq.h:142
> > > kernel/softirq.c:560)
> > > [   44.549762] irq_exit_rcu (kernel/softirq.c:433
> > > kernel/softirq.c:637
> > > kernel/softirq.c:649)
> > > [   44.551384] common_interrupt (arch/x86/kernel/irq.c:240
> > > (discriminator 13))
> > > [   44.551991] ? asm_common_interrupt
> > > (./arch/x86/include/asm/idtentry.h:638)
> > > [   44.552654] asm_common_interrupt
> > > (./arch/x86/include/asm/idtentry.h:638)
> > > [   44.553276] RIP: 0033:0x7fdb981a82e4
> > > [ 44.553809] Code: d2 48 63 f6 c4 41 7a 6f 0c 01 c4 41 7a 6f 14 09
> > > c4
> > > 41 7a 6f 24 11 c4 41 7a 6f 2c 31 c4 c1 31 6a c2 c4 c1 19 6a d5 c5
> > > f9 6c
> > > f2 <c5> 79 6d c2 c5 f9 71 d6 08 c5 f9 db 44 24 20 c5 c1 71 f6 0b c5
> > > f9
> > > All code
> > > ========
> > >    0:	d2 48 63             	rorb   %cl,0x63(%rax)
> > >    3:	f6 c4 41             	test   $0x41,%ah
> > >    6:	7a 6f                	jp     0x77
> > >    8:	0c 01                	or     $0x1,%al
> > >    a:	c4 41 7a 6f 14 09    	vmovdqu (%r9,%rcx,1),%xmm10
> > >   10:	c4 41 7a 6f 24 11    	vmovdqu (%r9,%rdx,1),%xmm12
> > >   16:	c4 41 7a 6f 2c 31    	vmovdqu (%r9,%rsi,1),%xmm13
> > >   1c:	c4 c1 31 6a c2       	vpunpckhdq
> > > %xmm10,%xmm9,%xmm0
> > >   21:	c4 c1 19 6a d5       	vpunpckhdq
> > > %xmm13,%xmm12,%xmm2
> > >   26:	c5 f9 6c f2          	vpunpcklqdq
> > > %xmm2,%xmm0,%xmm6
> > >   2a:*	c5 79 6d c2          	vpunpckhqdq
> > > %xmm2,%xmm0,%xmm8
> > > <-- trapping instruction
> > >   2e:	c5 f9 71 d6 08       	vpsrlw $0x8,%xmm6,%xmm0
> > >   33:	c5 f9 db 44 24 20    	vpand  0x20(%rsp),%xmm0,%xm
> > > m0
> > >   39:	c5 c1 71 f6 0b       	vpsllw $0xb,%xmm6,%xmm7
> > >   3e:	c5                   	.byte 0xc5
> > >   3f:	f9                   	stc
> > > 
> > > Code starting with the faulting instruction
> > > ===========================================
> > >    0:	c5 79 6d c2          	vpunpckhqdq
> > > %xmm2,%xmm0,%xmm8
> > >    4:	c5 f9 71 d6 08       	vpsrlw $0x8,%xmm6,%xmm0
> > >    9:	c5 f9 db 44 24 20    	vpand  0x20(%rsp),%xmm0,%xm
> > > m0
> > >    f:	c5 c1 71 f6 0b       	vpsllw $0xb,%xmm6,%xmm7
> > >   14:	c5                   	.byte 0xc5
> > >   15:	f9                   	stc
> > > [   44.556477] RSP: 002b:00007fdb9cb10240 EFLAGS: 00000202
> > > [   44.557224] RAX: 0000000000122d40 RBX: 00007fdb5f9e8790 RCX:
> > > 0000000000122d40
> > > [   44.558200] RDX: 0000000000122d40 RSI: 0000000000122d40 RDI:
> > > 000055d7049b9368
> > > [   44.559088] RBP: 00007fdb9cb10ba0 R08: 00007fdb981a5174 R09:
> > > 00007fdb5e544040
> > > [   44.560042] R10: 000000000000ffff R11: 000000000000ffff R12:
> > > 0000000000000000
> > > [   44.560991] R13: 0000000000000000 R14: 0000000000005000 R15:
> > > 0000000000000000
> > > [   44.561965] Modules linked in:
> > > [   44.562426] ---[ end trace 9a32eb9d31cb21a1 ]---
> > > [   44.563091] RIP: 0010:skb_panic (net/core/skbuff.c:110)
> > > [ 44.563721] Code: 4f 70 50 8b 87 bc 00 00 00 50 8b 87 b8 00 00 00
> > > 50
> > > ff b7 c8 00 00 00 4c 8b 8f c0 00 00 00 48 c7 c7 f0 af cf ad e8 43
> > > 4c fb
> > > ff <0f> 0b 48 8b 14 24 48 c7 c1 20 23 b1 ad e8 ab ff ff ff 48 c7 c6
> > > 60
> > > All code
> > > ========
> > >    0:	4f 70 50             	rex.WRXB jo 0x53
> > >    3:	8b 87 bc 00 00 00    	mov    0xbc(%rdi),%eax
> > >    9:	50                   	push   %rax
> > >    a:	8b 87 b8 00 00 00    	mov    0xb8(%rdi),%eax
> > >   10:	50                   	push   %rax
> > >   11:	ff b7 c8 00 00 00    	pushq  0xc8(%rdi)
> > >   17:	4c 8b 8f c0 00 00 00 	mov    0xc0(%rdi),%r9
> > >   1e:	48 c7 c7 f0 af cf ad 	mov    $0xffffffffadcfaff0,
> > > %rdi
> > >   25:	e8 43 4c fb ff       	callq  0xfffffffffffb4c6d
> > >   2a:*	0f 0b                	ud2    		<--
> > > trapping
> > > instruction
> > >   2c:	48 8b 14 24          	mov    (%rsp),%rdx
> > >   30:	48 c7 c1 20 23 b1 ad 	mov    $0xffffffffadb12320,
> > > %rcx
> > >   37:	e8 ab ff ff ff       	callq  0xffffffffffffffe7
> > >   3c:	48                   	rex.W
> > >   3d:	c7                   	.byte 0xc7
> > >   3e:	c6                   	(bad)
> > >   3f:	60                   	(bad)
> > > 
> > > Code starting with the faulting instruction
> > > ===========================================
> > >    0:	0f 0b                	ud2
> > >    2:	48 8b 14 24          	mov    (%rsp),%rdx
> > >    6:	48 c7 c1 20 23 b1 ad 	mov    $0xffffffffadb12320,
> > > %rcx
> > >    d:	e8 ab ff ff ff       	callq  0xffffffffffffffbd
> > >   12:	48                   	rex.W
> > >   13:	c7                   	.byte 0xc7
> > >   14:	c6                   	(bad)
> > >   15:	60                   	(bad)
> > > [   44.566252] RSP: 0000:ffffa651c134fc20 EFLAGS: 00010246
> > > [   44.567051] RAX: 000000000000008b RBX: 0000000000000010 RCX:
> > > 00000000ffffdfff
> > > [   44.567947] RDX: 0000000000000000 RSI: 00000000ffffffea RDI:
> > > 0000000000000000
> > > [   44.568839] RBP: ffffd77b009adac0 R08: ffffffffadf44b08 R09:
> > > 0000000000009ffb
> > > [   44.569725] R10: 00000000ffffe000 R11: 3fffffffffffffff R12:
> > > ffff979ad2aa5600
> > > [   44.570608] R13: 0000000000000000 R14: ffff9799e6b6b000 R15:
> > > 0000000000000eb2
> > > [   44.571483] FS:  00007fdb9cb11700(0000)
> > > GS:ffff979aebd00000(0000)
> > > knlGS:0000000000000000
> > > [   44.572694] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [   44.573474] CR2: 00007f99099f4024 CR3: 0000000129558005 CR4:
> > > 0000000000370ee0
> > > [   44.574531] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> > > 0000000000000000
> > > [   44.575597] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> > > 0000000000000400
> > > [   44.576618] Kernel panic - not syncing: Fatal exception in
> > > interrupt
> > > [   44.577996] Kernel Offset: 0x2ba00000 from 0xffffffff81000000
> > > (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> > > 
> > 
> > Can you test this patch on the latest net branch?
> > 
> > Thanks.
> > 
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index fa407eb8b457..78a01c71a17c 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -406,7 +406,7 @@ static struct sk_buff *page_to_skb(struct
> > virtnet_info *vi,
> >          * add_recvbuf_mergeable() + get_mergeable_buf_len()
> >          */
> >         truesize = headroom ? PAGE_SIZE : truesize;
> > -       tailroom = truesize - len - headroom;
> > +       tailroom = truesize - len - headroom - (hdr_padded_len -
> > hdr_len);
> >         buf = p - headroom;
> > 
> >         len -= hdr_len;
> 
> With this patch and the latest net branch I no longer get crashes.

Did this ever get properly submitted to the networking tree to get into
5.13-final?

thanks,

greg k-h
