Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5263991FC
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 19:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbhFBR4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Jun 2021 13:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229467AbhFBR43 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Jun 2021 13:56:29 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CBCC061574
        for <stable@vger.kernel.org>; Wed,  2 Jun 2021 10:54:46 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: tintou)
        with ESMTPSA id 4897B1F42997
Message-ID: <9b894cd65f67116b5eb3b57d714f8782619c5434.camel@collabora.com>
Subject: Re: virtio-net: kernel panic in virtio_net.c
From:   Corentin =?ISO-8859-1?Q?No=EBl?= <corentin.noel@collabora.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        regressions@lists.linux.dev, Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Date:   Wed, 02 Jun 2021 19:54:41 +0200
In-Reply-To: <CANn89iKFjZJ=AtgAJmk4ZEtS3eL5XKMr6wiFUhtfTb2tFKbcuA@mail.gmail.com>
References: <3724b6d19b0bf4741c44977e083c1a655df57b55.camel@collabora.com>
         <YLZpVGDz4TVEdaK0@kroah.com>
         <5744b89e9a500a8c2aa97cbad850bc4797fa7115.camel@collabora.com>
         <CANn89iKFjZJ=AtgAJmk4ZEtS3eL5XKMr6wiFUhtfTb2tFKbcuA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le mardi 01 juin 2021 à 19:47 +0200, Eric Dumazet a écrit :
> On Tue, Jun 1, 2021 at 7:09 PM Corentin Noël
> <corentin.noel@collabora.com> wrote:
> > Le mardi 01 juin 2021 à 19:07 +0200, Greg KH a écrit :
> > > On Tue, Jun 01, 2021 at 06:06:50PM +0200, Corentin Noël wrote:
> > > > I've been experiencing crashes with 5.13 that do not occur with
> > > > 5.12,
> > > > here is the crash trace:
> > > > 
> > > > [   47.713713] skbuff: skb_over_panic: text:ffffffffb73a8354
> > > > len:3762
> > > > put:3762 head:ffff9e1e1e48e000 data:ffff9e1e1e48e010 tail:0xec2
> > > > end:0xec0 dev:<NULL>
> > > > [   47.716267] kernel BUG at net/core/skbuff.c:110!
> > > > [   47.717197] invalid opcode: 0000 [#1] SMP PTI
> > > > [   47.718049] CPU: 2 PID: 730 Comm: llvmpipe-0 Not tainted
> > > > 5.13.0-
> > > > rc3linux-v5.13-rc3-for-mesa-ci-87614d7f3282.tar.bz2 #1
> > > > [   47.719739] Hardware name: ChromiumOS crosvm, BIOS 0
> > > > [   47.720656] RIP: 0010:skb_panic+0x43/0x45
> > > > [   47.721426] Code: 4f 70 50 8b 87 bc 00 00 00 50 8b 87 b8 00
> > > > 00
> > > > 00 50
> > > > ff b7 c8 00 00 00 4c 8b 8f c0 00 00 00 48 c7 c7 78 ae ef b7 e8
> > > > 7f
> > > > 4c fb
> > > > ff <0f> 0b 48 8b 14 24 48 c7 c1 a0 22 d1 b7 e8 ab ff ff ff 48
> > > > c7 c6
> > > > e0
> > > > [   47.725944] RSP: 0000:ffffacec01347c20 EFLAGS: 00010246
> > > > [   47.726735] RAX: 000000000000008b RBX: 0000000000000010 RCX:
> > > > 00000000ffffdfff
> > > > [   47.727820] RDX: 0000000000000000 RSI: 00000000ffffffea RDI:
> > > > 0000000000000000
> > > > [   47.729096] RBP: ffffeb2700792380 R08: ffffffffb8144b08 R09:
> > > > 0000000000009ffb
> > > > [   47.730260] R10: 00000000ffffe000 R11: 3fffffffffffffff R12:
> > > > ffff9e1e1e95b300
> > > > [   47.731411] R13: 0000000000000000 R14: ffff9e1e1e48e000 R15:
> > > > 0000000000000eb2
> > > > [   47.732541] FS:  00007f3a82b53700(0000)
> > > > GS:ffff9e1f2bd00000(0000)
> > > > knlGS:0000000000000000
> > > > [   47.733858] CS:  0010 DS: 0000 ES: 0000 CR0:
> > > > 0000000080050033
> > > > [   47.734813] CR2: 00000000010d24f8 CR3: 0000000012d6e004 CR4:
> > > > 0000000000370ee0
> > > > [   47.735968] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> > > > 0000000000000000
> > > > [   47.737091] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> > > > 0000000000000400
> > > > [   47.738318] Call Trace:
> > > > [   47.738812]  skb_put.cold+0x10/0x10
> > > > [   47.739450]  page_to_skb+0xe4/0x400
> > > > [   47.740072]  receive_buf+0x86/0x1660
> > > > [   47.740693]  ? inet_gro_receive+0x54/0x2c0
> > > > [   47.741279]  ? dev_gro_receive+0x194/0x6a0
> > > > [   47.741846]  virtnet_poll+0x2b8/0x3c0
> > > > [   47.742357]  __napi_poll+0x25/0x150
> > > > [   47.742844]  net_rx_action+0x22f/0x280
> > > > [   47.743388]  __do_softirq+0xba/0x264
> > > > [   47.743947]  irq_exit_rcu+0x90/0xb0
> > > > [   47.744435]  common_interrupt+0x40/0xa0
> > > > [   47.744978]  ? asm_common_interrupt+0x8/0x40
> > > > [   47.745582]  asm_common_interrupt+0x1e/0x40
> > > > [   47.746182] RIP: 0033:0x7f3a7a276ed4
> > > > [   47.746708] Code: a0 03 00 00 c5 fc 29 84 24 40 0f 00 00 c5
> > > > bc
> > > > 54 c8
> > > > c5 7c 28 84 24 80 01 00 00 c5 bc 59 e9 c5 fe 5b ed c5 fd 76 c0
> > > > c5
> > > > d5 fa
> > > > c0 <c5> fd db ec c5 fd 7f 84 24 20 0f 00 00 c5 fc 5b ed c4 e2
> > > > 55 b8
> > > > cb
> > > > [   47.749292] RSP: 002b:00007f3a82b4dba0 EFLAGS: 00000212
> > > > [   47.750006] RAX: 00007f3a8c210324 RBX: ffffffffffffffff RCX:
> > > > ffffffffffffffff
> > > > [   47.750964] RDX: 00007f3a8c210348 RSI: 00007f3a8c21034c RDI:
> > > > 00007f3a7c0575a0
> > > > [   47.752049] RBP: 00007f3a82b52ca0 R08: 00007f3a8c210350 R09:
> > > > 00007f3a8c210354
> > > > [   47.753161] R10: 00007f3a8c210358 R11: 000000000000ffef R12:
> > > > 00007f3a8c210340
> > > > [   47.754260] R13: 00007f3a8c210344 R14: 00007f3a7c057580 R15:
> > > > 00007f3a8c21033c
> > > > [   47.755354] Modules linked in:
> > > > [   47.755871] ---[ end trace a8b692ea99c9cd9e ]---
> > > > [   47.756606] RIP: 0010:skb_panic+0x43/0x45
> > > > [   47.757297] Code: 4f 70 50 8b 87 bc 00 00 00 50 8b 87 b8 00
> > > > 00
> > > > 00 50
> > > > ff b7 c8 00 00 00 4c 8b 8f c0 00 00 00 48 c7 c7 78 ae ef b7 e8
> > > > 7f
> > > > 4c fb
> > > > ff <0f> 0b 48 8b 14 24 48 c7 c1 a0 22 d1 b7 e8 ab ff ff ff 48
> > > > c7 c6
> > > > e0
> > > > [   47.760168] RSP: 0000:ffffacec01347c20 EFLAGS: 00010246
> > > > [   47.760896] RAX: 000000000000008b RBX: 0000000000000010 RCX:
> > > > 00000000ffffdfff
> > > > [   47.761903] RDX: 0000000000000000 RSI: 00000000ffffffea RDI:
> > > > 0000000000000000
> > > > [   47.762945] RBP: ffffeb2700792380 R08: ffffffffb8144b08 R09:
> > > > 0000000000009ffb
> > > > [   47.764059] R10: 00000000ffffe000 R11: 3fffffffffffffff R12:
> > > > ffff9e1e1e95b300
> > > > [   47.765169] R13: 0000000000000000 R14: ffff9e1e1e48e000 R15:
> > > > 0000000000000eb2
> > > > [   47.766261] FS:  00007f3a82b53700(0000)
> > > > GS:ffff9e1f2bd00000(0000)
> > > > knlGS:0000000000000000
> > > > [   47.767512] CS:  0010 DS: 0000 ES: 0000 CR0:
> > > > 0000000080050033
> > > > [   47.768389] CR2: 00000000010d24f8 CR3: 0000000012d6e004 CR4:
> > > > 0000000000370ee0
> > > > [   47.769381] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> > > > 0000000000000000
> > > > [   47.770362] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> > > > 0000000000000400
> > > > [   47.771339] Kernel panic - not syncing: Fatal exception in
> > > > interrupt
> > > > [   47.772814] Kernel Offset: 0x35c00000 from
> > > > 0xffffffff81000000
> > > > (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> > > > 
> > > > I've been able to bisect the issue a little bit and the issue
> > > > disappeared after reverting the 4 following commits:
> > > >  * fb32856b16ad9d5bcd75b76a274e2c515ac7b9d7
> > > >  * af39c8f72301b268ad8b04bae646b6025918b82b
> > > >  * f5d7872a8b8a3176e65dc6f7f0705ce7e9a699e6
> > > >  * f80bd740cb7c954791279590b2e810ba6c214e52
> > > > 
> > > > Here is my kernel config:
> > > > https://gitlab.freedesktop.org/tintou/mesa/-/blob/e5d6c56bfae8522e924217883d2c6a6bfc1b332b/.gitlab-ci/container/x86_64.config
> > > 
> > > Do you have the same problem with 5.13-rc4?
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > Yes I tried with rc2, rc3 and rc4 resulting to the same panic.
> > 
> > Thanks,
> > 
> 
> Could you provide a stack trace with file names and line numbers ?
> 
> (ie use scripts/decode_stacktrace.sh )
> 
> Thanks.

Sure, here is the decoded trace:

[   44.523231] skbuff: skb_over_panic: text:ffffffffad1a8434 len:3762
put:3762 head:ffff9799e6b6b000 data:ffff9799e6b6b010 tail:0xec2
end:0xec0 dev:<NULL>
[   44.525254] kernel BUG at net/core/skbuff.c:110!
[   44.525910] invalid opcode: 0000 [#1] SMP PTI
[   44.526521] CPU: 2 PID: 245 Comm: llvmpipe-0 Not tainted 5.13.0-
rc4linux-v5.13-rc4-for-mesa-ci-184862285c49.tar.bz2 #1
[   44.528109] Hardware name: ChromiumOS crosvm, BIOS 0
[   44.529243] RIP: 0010:skb_panic (net/core/skbuff.c:110) 
[ 44.530284] Code: 4f 70 50 8b 87 bc 00 00 00 50 8b 87 b8 00 00 00 50
ff b7 c8 00 00 00 4c 8b 8f c0 00 00 00 48 c7 c7 f0 af cf ad e8 43 4c fb
ff <0f> 0b 48 8b 14 24 48 c7 c1 20 23 b1 ad e8 ab ff ff ff 48 c7 c6 60
All code
========
   0:	4f 70 50             	rex.WRXB jo 0x53
   3:	8b 87 bc 00 00 00    	mov    0xbc(%rdi),%eax
   9:	50                   	push   %rax
   a:	8b 87 b8 00 00 00    	mov    0xb8(%rdi),%eax
  10:	50                   	push   %rax
  11:	ff b7 c8 00 00 00    	pushq  0xc8(%rdi)
  17:	4c 8b 8f c0 00 00 00 	mov    0xc0(%rdi),%r9
  1e:	48 c7 c7 f0 af cf ad 	mov    $0xffffffffadcfaff0,%rdi
  25:	e8 43 4c fb ff       	callq  0xfffffffffffb4c6d
  2a:*	0f 0b                	ud2    		<-- trapping
instruction
  2c:	48 8b 14 24          	mov    (%rsp),%rdx
  30:	48 c7 c1 20 23 b1 ad 	mov    $0xffffffffadb12320,%rcx
  37:	e8 ab ff ff ff       	callq  0xffffffffffffffe7
  3c:	48                   	rex.W
  3d:	c7                   	.byte 0xc7
  3e:	c6                   	(bad)  
  3f:	60                   	(bad)  

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2    
   2:	48 8b 14 24          	mov    (%rsp),%rdx
   6:	48 c7 c1 20 23 b1 ad 	mov    $0xffffffffadb12320,%rcx
   d:	e8 ab ff ff ff       	callq  0xffffffffffffffbd
  12:	48                   	rex.W
  13:	c7                   	.byte 0xc7
  14:	c6                   	(bad)  
  15:	60                   	(bad)  
[   44.533988] RSP: 0000:ffffa651c134fc20 EFLAGS: 00010246
[   44.534723] RAX: 000000000000008b RBX: 0000000000000010 RCX:
00000000ffffdfff
[   44.535772] RDX: 0000000000000000 RSI: 00000000ffffffea RDI:
0000000000000000
[   44.536693] RBP: ffffd77b009adac0 R08: ffffffffadf44b08 R09:
0000000000009ffb
[   44.537569] R10: 00000000ffffe000 R11: 3fffffffffffffff R12:
ffff979ad2aa5600
[   44.538449] R13: 0000000000000000 R14: ffff9799e6b6b000 R15:
0000000000000eb2
[   44.539300] FS:  00007fdb9cb11700(0000) GS:ffff979aebd00000(0000)
knlGS:0000000000000000
[   44.540376] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   44.541103] CR2: 00007f99099f4024 CR3: 0000000129558005 CR4:
0000000000370ee0
[   44.542057] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[   44.543063] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[   44.544063] Call Trace:
[   44.544385] skb_put.cold (net/core/skbuff.c:5254 (discriminator 1)
net/core/skbuff.c:5252 (discriminator 1)) 
[   44.544864] page_to_skb (drivers/net/virtio_net.c:485) 
[   44.545361] receive_buf (drivers/net/virtio_net.c:849
drivers/net/virtio_net.c:1131) 
[   44.545870] ? netif_receive_skb_list_internal (net/core/dev.c:5714) 
[   44.546628] ? dev_gro_receive (net/core/dev.c:6103) 
[   44.547135] ? napi_complete_done (./include/linux/list.h:35
net/core/dev.c:5867 net/core/dev.c:5862 net/core/dev.c:6565) 
[   44.547672] virtnet_poll (drivers/net/virtio_net.c:1427
drivers/net/virtio_net.c:1525) 
[   44.548251] __napi_poll (net/core/dev.c:6985) 
[   44.548744] net_rx_action (net/core/dev.c:7054 net/core/dev.c:7139) 
[   44.549264] __do_softirq (./arch/x86/include/asm/jump_label.h:19
./include/linux/jump_label.h:200 ./include/trace/events/irq.h:142
kernel/softirq.c:560) 
[   44.549762] irq_exit_rcu (kernel/softirq.c:433 kernel/softirq.c:637
kernel/softirq.c:649) 
[   44.551384] common_interrupt (arch/x86/kernel/irq.c:240
(discriminator 13)) 
[   44.551991] ? asm_common_interrupt
(./arch/x86/include/asm/idtentry.h:638) 
[   44.552654] asm_common_interrupt
(./arch/x86/include/asm/idtentry.h:638) 
[   44.553276] RIP: 0033:0x7fdb981a82e4
[ 44.553809] Code: d2 48 63 f6 c4 41 7a 6f 0c 01 c4 41 7a 6f 14 09 c4
41 7a 6f 24 11 c4 41 7a 6f 2c 31 c4 c1 31 6a c2 c4 c1 19 6a d5 c5 f9 6c
f2 <c5> 79 6d c2 c5 f9 71 d6 08 c5 f9 db 44 24 20 c5 c1 71 f6 0b c5 f9
All code
========
   0:	d2 48 63             	rorb   %cl,0x63(%rax)
   3:	f6 c4 41             	test   $0x41,%ah
   6:	7a 6f                	jp     0x77
   8:	0c 01                	or     $0x1,%al
   a:	c4 41 7a 6f 14 09    	vmovdqu (%r9,%rcx,1),%xmm10
  10:	c4 41 7a 6f 24 11    	vmovdqu (%r9,%rdx,1),%xmm12
  16:	c4 41 7a 6f 2c 31    	vmovdqu (%r9,%rsi,1),%xmm13
  1c:	c4 c1 31 6a c2       	vpunpckhdq %xmm10,%xmm9,%xmm0
  21:	c4 c1 19 6a d5       	vpunpckhdq %xmm13,%xmm12,%xmm2
  26:	c5 f9 6c f2          	vpunpcklqdq %xmm2,%xmm0,%xmm6
  2a:*	c5 79 6d c2          	vpunpckhqdq %xmm2,%xmm0,%xmm8		
<-- trapping instruction
  2e:	c5 f9 71 d6 08       	vpsrlw $0x8,%xmm6,%xmm0
  33:	c5 f9 db 44 24 20    	vpand  0x20(%rsp),%xmm0,%xmm0
  39:	c5 c1 71 f6 0b       	vpsllw $0xb,%xmm6,%xmm7
  3e:	c5                   	.byte 0xc5
  3f:	f9                   	stc    

Code starting with the faulting instruction
===========================================
   0:	c5 79 6d c2          	vpunpckhqdq %xmm2,%xmm0,%xmm8
   4:	c5 f9 71 d6 08       	vpsrlw $0x8,%xmm6,%xmm0
   9:	c5 f9 db 44 24 20    	vpand  0x20(%rsp),%xmm0,%xmm0
   f:	c5 c1 71 f6 0b       	vpsllw $0xb,%xmm6,%xmm7
  14:	c5                   	.byte 0xc5
  15:	f9                   	stc    
[   44.556477] RSP: 002b:00007fdb9cb10240 EFLAGS: 00000202
[   44.557224] RAX: 0000000000122d40 RBX: 00007fdb5f9e8790 RCX:
0000000000122d40
[   44.558200] RDX: 0000000000122d40 RSI: 0000000000122d40 RDI:
000055d7049b9368
[   44.559088] RBP: 00007fdb9cb10ba0 R08: 00007fdb981a5174 R09:
00007fdb5e544040
[   44.560042] R10: 000000000000ffff R11: 000000000000ffff R12:
0000000000000000
[   44.560991] R13: 0000000000000000 R14: 0000000000005000 R15:
0000000000000000
[   44.561965] Modules linked in:
[   44.562426] ---[ end trace 9a32eb9d31cb21a1 ]---
[   44.563091] RIP: 0010:skb_panic (net/core/skbuff.c:110) 
[ 44.563721] Code: 4f 70 50 8b 87 bc 00 00 00 50 8b 87 b8 00 00 00 50
ff b7 c8 00 00 00 4c 8b 8f c0 00 00 00 48 c7 c7 f0 af cf ad e8 43 4c fb
ff <0f> 0b 48 8b 14 24 48 c7 c1 20 23 b1 ad e8 ab ff ff ff 48 c7 c6 60
All code
========
   0:	4f 70 50             	rex.WRXB jo 0x53
   3:	8b 87 bc 00 00 00    	mov    0xbc(%rdi),%eax
   9:	50                   	push   %rax
   a:	8b 87 b8 00 00 00    	mov    0xb8(%rdi),%eax
  10:	50                   	push   %rax
  11:	ff b7 c8 00 00 00    	pushq  0xc8(%rdi)
  17:	4c 8b 8f c0 00 00 00 	mov    0xc0(%rdi),%r9
  1e:	48 c7 c7 f0 af cf ad 	mov    $0xffffffffadcfaff0,%rdi
  25:	e8 43 4c fb ff       	callq  0xfffffffffffb4c6d
  2a:*	0f 0b                	ud2    		<-- trapping
instruction
  2c:	48 8b 14 24          	mov    (%rsp),%rdx
  30:	48 c7 c1 20 23 b1 ad 	mov    $0xffffffffadb12320,%rcx
  37:	e8 ab ff ff ff       	callq  0xffffffffffffffe7
  3c:	48                   	rex.W
  3d:	c7                   	.byte 0xc7
  3e:	c6                   	(bad)  
  3f:	60                   	(bad)  

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2    
   2:	48 8b 14 24          	mov    (%rsp),%rdx
   6:	48 c7 c1 20 23 b1 ad 	mov    $0xffffffffadb12320,%rcx
   d:	e8 ab ff ff ff       	callq  0xffffffffffffffbd
  12:	48                   	rex.W
  13:	c7                   	.byte 0xc7
  14:	c6                   	(bad)  
  15:	60                   	(bad)  
[   44.566252] RSP: 0000:ffffa651c134fc20 EFLAGS: 00010246
[   44.567051] RAX: 000000000000008b RBX: 0000000000000010 RCX:
00000000ffffdfff
[   44.567947] RDX: 0000000000000000 RSI: 00000000ffffffea RDI:
0000000000000000
[   44.568839] RBP: ffffd77b009adac0 R08: ffffffffadf44b08 R09:
0000000000009ffb
[   44.569725] R10: 00000000ffffe000 R11: 3fffffffffffffff R12:
ffff979ad2aa5600
[   44.570608] R13: 0000000000000000 R14: ffff9799e6b6b000 R15:
0000000000000eb2
[   44.571483] FS:  00007fdb9cb11700(0000) GS:ffff979aebd00000(0000)
knlGS:0000000000000000
[   44.572694] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   44.573474] CR2: 00007f99099f4024 CR3: 0000000129558005 CR4:
0000000000370ee0
[   44.574531] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[   44.575597] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[   44.576618] Kernel panic - not syncing: Fatal exception in interrupt
[   44.577996] Kernel Offset: 0x2ba00000 from 0xffffffff81000000
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)

