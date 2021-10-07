Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5535425273
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 14:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbhJGMGV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 08:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbhJGMGU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Oct 2021 08:06:20 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F085DC061746
        for <stable@vger.kernel.org>; Thu,  7 Oct 2021 05:04:26 -0700 (PDT)
Received: from PC-Corentin-Collabora (unknown [IPv6:2a01:e0a:9a5:c500:7974:80df:25bb:d47a])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: tintou)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id A63C51F45096;
        Thu,  7 Oct 2021 13:04:25 +0100 (BST)
Message-ID: <5edaa2b7c2fe4abd0347b8454b2ac032b6694e2c.camel@collabora.com>
Subject: virtio-net: kernel panic in virtio_net.c
From:   Corentin =?ISO-8859-1?Q?No=EBl?= <corentin.noel@collabora.com>
To:     stable@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        regressions@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Date:   Thu, 07 Oct 2021 14:04:22 +0200
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I've been experiencing crashes with 5.14-rc1 and above that do not
occur with 5.13,

here is the crash trace:

[   61.346677] skbuff: skb_over_panic: text:ffffffff881ae2c7 len:3762
put:3762 head:ffff8a5ec8c22000 data:ffff8a5ec8c22010 tail:0xec2
end:0xec0 dev:<NULL>
[   61.369192] kernel BUG at net/core/skbuff.c:111!
[   61.372840] invalid opcode: 0000 [#1] SMP PTI
[   61.374892] CPU: 5 PID: 0 Comm: swapper/5 Not tainted 5.14.0-
rc1linux-v5.14-rc1-for-mesa-ci.tar.bz2 #1
[   61.376450] Hardware name: ChromiumOS crosvm, BIOS 0 
[   61.377222] RIP: 0010:skb_panic+0x43/0x45
[   61.377833] Code: 4f 70 50 8b 87 bc 00 00 00 50 8b 87 b8 00 00 00 50
ff b7 c8 00 00 00 4c 8b 8f c0 00 00 00 48 c7 c7 18 f1 cf 88 e8 6a 43 fb
ff <0f> 0b 48 8b 14 24 48 c7 c1 20 35 b1 88 e8 ab ff ff ff 48 c7 c6 60
[   61.380566] RSP: 0018:ffffae258017cce0 EFLAGS: 00010246
[   61.381267] RAX: 000000000000008b RBX: 0000000000000010 RCX:
00000000ffffdfff
[   61.382246] RDX: 0000000000000000 RSI: 00000000ffffffea RDI:
0000000000000000
[   61.383376] RBP: ffffde6a80230880 R08: ffffffff88f45568 R09:
0000000000009ffb
[   61.384494] R10: 00000000ffffe000 R11: 3fffffffffffffff R12:
ffff8a5ec7461200
[   61.385696] R13: ffff8a5ec8c22000 R14: 0000000000000000 R15:
0000000000000eb2
[   61.386825] FS:  0000000000000000(0000) GS:ffff8a5febd40000(0000)
knlGS:0000000000000000
[   61.388055] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   61.389221] CR2: 000000000148a060 CR3: 000000011ae0e005 CR4:
0000000000370ee0
[   61.390871] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[   61.392335] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[   61.393635] Call Trace:
[   61.394127]  <IRQ>
[   61.394488]  skb_put.cold+0x10/0x10
[   61.395095]  page_to_skb+0xf7/0x410
[   61.395689]  receive_buf+0x81/0x1660
[   61.396228]  ? netif_receive_skb_list_internal+0x1ad/0x2b0
[   61.397180]  ? napi_gro_flush+0x97/0xe0
[   61.397896]  ? detach_buf_split+0x67/0x120
[   61.398573]  virtnet_poll+0x2cf/0x420
[   61.399197]  __napi_poll+0x25/0x150
[   61.399764]  net_rx_action+0x22f/0x280
[   61.400394]  __do_softirq+0xba/0x257
[   61.401012]  irq_exit_rcu+0x8e/0xb0
[   61.401618]  common_interrupt+0x7b/0xa0
[   61.402270]  </IRQ>
[   61.402620]  asm_common_interrupt+0x1e/0x40
[   61.403302] RIP: 0010:default_idle+0xb/0x10
[   61.404018] Code: 8b 04 25 00 6d 01 00 f0 80 60 02 df c3 0f ae f0 0f
ae 38 0f ae f0 eb b9 0f 1f 80 00 00 00 00 eb 07 0f 00 2d df 3e 44 00 fb
f4 <c3> cc cc cc cc 65 8b 15 31 2f a4 77 89 d2 48 8b 05 d0 a1 0c 01 48
[   61.407636] RSP: 0018:ffffae258008fef8 EFLAGS: 00000202
[   61.408394] RAX: ffffffff885ce620 RBX: 0000000000000005 RCX:
ffff8a5febd56f80
[   61.409451] RDX: 0000000000c1ec32 RSI: 7ffffff1b7a1e726 RDI:
ffff8a5febd5dd00
[   61.410530] RBP: ffff8a5fc01f8000 R08: 0000000000c1ec32 R09:
0000000000000000
[   61.411715] R10: 0000000000000006 R11: 0000000000000002 R12:
0000000000000000
[   61.412984] R13: 0000000000000000 R14: 0000000000000000 R15:
0000000000000000
[   61.414183]  ? mwait_idle+0x70/0x70
[   61.414805]  ? mwait_idle+0x70/0x70
[   61.415592]  default_idle_call+0x2a/0xa0
[   61.416216]  do_idle+0x1e8/0x250
[   61.416722]  cpu_startup_entry+0x14/0x20
[   61.417347]  secondary_startup_64_no_verify+0xc2/0xcb
[   61.418144] Modules linked in:
[   61.418622] ---[ end trace 3741c3e580a52bbd ]---
[   61.419399] RIP: 0010:skb_panic+0x43/0x45
[   61.420054] Code: 4f 70 50 8b 87 bc 00 00 00 50 8b 87 b8 00 00 00 50
ff b7 c8 00 00 00 4c 8b 8f c0 00 00 00 48 c7 c7 18 f1 cf 88 e8 6a 43 fb
ff <0f> 0b 48 8b 14 24 48 c7 c1 20 35 b1 88 e8 ab ff ff ff 48 c7 c6 60
[   61.422606] RSP: 0018:ffffae258017cce0 EFLAGS: 00010246
[   61.423865] RAX: 000000000000008b RBX: 0000000000000010 RCX:
00000000ffffdfff
[   61.425031] RDX: 0000000000000000 RSI: 00000000ffffffea RDI:
0000000000000000
[   61.426229] RBP: ffffde6a80230880 R08: ffffffff88f45568 R09:
0000000000009ffb
[   61.427439] R10: 00000000ffffe000 R11: 3fffffffffffffff R12:
ffff8a5ec7461200
[   61.428615] R13: ffff8a5ec8c22000 R14: 0000000000000000 R15:
0000000000000eb2
[   61.429799] FS:  0000000000000000(0000) GS:ffff8a5febd40000(0000)
knlGS:0000000000000000
[   61.431048] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   61.431997] CR2: 000000000148a060 CR3: 000000011ae0e005 CR4:
0000000000370ee0
[   61.433206] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[   61.434502] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[   61.435799] Kernel panic - not syncing: Fatal exception in interrupt
[   61.439250] Kernel Offset: 0x6a00000 from 0xffffffff81000000
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)

Here is my kernel config: 
https://gitlab.freedesktop.org/tintou/mesa/-/raw/7cf2be0e1c53d1040ff8a973ddeeeb3d93250f8e/.gitlab-ci/container/x86_64.config


here is the decoded trace:

[   61.346677] skbuff: skb_over_panic: text:ffffffff881ae2c7 len:3762
put:3762 head:ffff8a5ec8c22000 data:ffff8a5ec8c22010 tail:0xec2
end:0xec0 dev:<NULL>
[   61.369192] kernel BUG at net/core/skbuff.c:111!
[   61.372840] invalid opcode: 0000 [#1] SMP PTI
[   61.374892] CPU: 5 PID: 0 Comm: swapper/5 Not tainted 5.14.0-
rc1linux-v5.14-rc1-for-mesa-ci.tar.bz2 #1
[   61.376450] Hardware name: ChromiumOS crosvm, BIOS 0
[   61.377222] RIP: skb_panic+0x43/0x45 
[ 61.377833] Code: 4f 70 50 8b 87 bc 00 00 00 50 8b 87 b8 00 00 00 50
ff b7 c8 00 00 00 4c 8b 8f c0 00 00 00 48 c7 c7 18 f1 cf 88 e8 6a 43 fb
ff <0f> 0b 48 8b 14 24 48 c7 c1 20 35 b1 88 e8 ab ff ff ff 48 c7 c6 60
All code
========
   0:	4f 70 50             	rex.WRXB jo 0x53
   3:	8b 87 bc 00 00 00    	mov    0xbc(%rdi),%eax
   9:	50                   	push   %rax
   a:	8b 87 b8 00 00 00    	mov    0xb8(%rdi),%eax
  10:	50                   	push   %rax
  11:	ff b7 c8 00 00 00    	pushq  0xc8(%rdi)
  17:	4c 8b 8f c0 00 00 00 	mov    0xc0(%rdi),%r9
  1e:	48 c7 c7 18 f1 cf 88 	mov    $0xffffffff88cff118,%rdi
  25:	e8 6a 43 fb ff       	callq  0xfffffffffffb4394
  2a:*	0f 0b                	ud2    		<-- trapping
instruction
  2c:	48 8b 14 24          	mov    (%rsp),%rdx
  30:	48 c7 c1 20 35 b1 88 	mov    $0xffffffff88b13520,%rcx
  37:	e8 ab ff ff ff       	callq  0xffffffffffffffe7
  3c:	48                   	rex.W
  3d:	c7                   	.byte 0xc7
  3e:	c6                   	(bad)  
  3f:	60                   	(bad)  

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2    
   2:	48 8b 14 24          	mov    (%rsp),%rdx
   6:	48 c7 c1 20 35 b1 88 	mov    $0xffffffff88b13520,%rcx
   d:	e8 ab ff ff ff       	callq  0xffffffffffffffbd
  12:	48                   	rex.W
  13:	c7                   	.byte 0xc7
  14:	c6                   	(bad)  
  15:	60                   	(bad)  
[   61.380566] RSP: 0018:ffffae258017cce0 EFLAGS: 00010246
[   61.381267] RAX: 000000000000008b RBX: 0000000000000010 RCX:
00000000ffffdfff
[   61.382246] RDX: 0000000000000000 RSI: 00000000ffffffea RDI:
0000000000000000
[   61.383376] RBP: ffffde6a80230880 R08: ffffffff88f45568 R09:
0000000000009ffb
[   61.384494] R10: 00000000ffffe000 R11: 3fffffffffffffff R12:
ffff8a5ec7461200
[   61.385696] R13: ffff8a5ec8c22000 R14: 0000000000000000 R15:
0000000000000eb2
[   61.386825] FS:  0000000000000000(0000) GS:ffff8a5febd40000(0000)
knlGS:0000000000000000
[   61.388055] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   61.389221] CR2: 000000000148a060 CR3: 000000011ae0e005 CR4:
0000000000370ee0
[   61.390871] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[   61.392335] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[   61.393635] Call Trace:
[   61.394127]  <IRQ>
[   61.394488] skb_put.cold+0x10/0x10 
[   61.395095] page_to_skb+0xf7/0x410 
[   61.395689] receive_buf+0x81/0x1660 
[   61.396228] ? netif_receive_skb_list_internal+0x1ad/0x2b0 
[   61.397180] ? napi_gro_flush+0x97/0xe0 
[   61.397896] ? detach_buf_split+0x67/0x120 
[   61.398573] virtnet_poll+0x2cf/0x420 
[   61.399197] __napi_poll+0x25/0x150 
[   61.399764] net_rx_action+0x22f/0x280 
[   61.400394] __do_softirq+0xba/0x257 
[   61.401012] irq_exit_rcu+0x8e/0xb0 
[   61.401618] common_interrupt+0x7b/0xa0 
[   61.402270]  </IRQ>
[   61.402620] asm_common_interrupt+0x1e/0x40 
[   61.403302] RIP: default_idle+0xb/0x10 
[ 61.404018] Code: 8b 04 25 00 6d 01 00 f0 80 60 02 df c3 0f ae f0 0f
ae 38 0f ae f0 eb b9 0f 1f 80 00 00 00 00 eb 07 0f 00 2d df 3e 44 00 fb
f4 <c3> cc cc cc cc 65 8b 15 31 2f a4 77 89 d2 48 8b 05 d0 a1 0c 01 48
All code
========
   0:	8b 04 25 00 6d 01 00 	mov    0x16d00,%eax
   7:	f0 80 60 02 df       	lock andb $0xdf,0x2(%rax)
   c:	c3                   	retq   
   d:	0f ae f0             	mfence 
  10:	0f ae 38             	clflush (%rax)
  13:	0f ae f0             	mfence 
  16:	eb b9                	jmp    0xffffffffffffffd1
  18:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  1f:	eb 07                	jmp    0x28
  21:	0f 00 2d df 3e 44 00 	verw   0x443edf(%rip)        # 0x443f07
  28:	fb                   	sti    
  29:	f4                   	hlt    
  2a:*	c3                   	retq   		<-- trapping
instruction
  2b:	cc                   	int3   
  2c:	cc                   	int3   
  2d:	cc                   	int3   
  2e:	cc                   	int3   
  2f:	65 8b 15 31 2f a4 77 	mov    %gs:0x77a42f31(%rip),%edx       
 # 0x77a42f67
  36:	89 d2                	mov    %edx,%edx
  38:	48 8b 05 d0 a1 0c 01 	mov    0x10ca1d0(%rip),%rax        #
0x10ca20f
  3f:	48                   	rex.W

Code starting with the faulting instruction
===========================================
   0:	c3                   	retq   
   1:	cc                   	int3   
   2:	cc                   	int3   
   3:	cc                   	int3   
   4:	cc                   	int3   
   5:	65 8b 15 31 2f a4 77 	mov    %gs:0x77a42f31(%rip),%edx       
 # 0x77a42f3d
   c:	89 d2                	mov    %edx,%edx
   e:	48 8b 05 d0 a1 0c 01 	mov    0x10ca1d0(%rip),%rax        #
0x10ca1e5
  15:	48                   	rex.W
[   61.407636] RSP: 0018:ffffae258008fef8 EFLAGS: 00000202
[   61.408394] RAX: ffffffff885ce620 RBX: 0000000000000005 RCX:
ffff8a5febd56f80
[   61.409451] RDX: 0000000000c1ec32 RSI: 7ffffff1b7a1e726 RDI:
ffff8a5febd5dd00
[   61.410530] RBP: ffff8a5fc01f8000 R08: 0000000000c1ec32 R09:
0000000000000000
[   61.411715] R10: 0000000000000006 R11: 0000000000000002 R12:
0000000000000000
[   61.412984] R13: 0000000000000000 R14: 0000000000000000 R15:
0000000000000000
[   61.414183] ? mwait_idle+0x70/0x70 
[   61.414805] ? mwait_idle+0x70/0x70 
[   61.415592] default_idle_call+0x2a/0xa0 
[   61.416216] do_idle+0x1e8/0x250 
[   61.416722] cpu_startup_entry+0x14/0x20 
[   61.417347] secondary_startup_64_no_verify+0xc2/0xcb 
[   61.418144] Modules linked in:
[   61.418622] ---[ end trace 3741c3e580a52bbd ]---
[   61.419399] RIP: skb_panic+0x43/0x45 
[ 61.420054] Code: 4f 70 50 8b 87 bc 00 00 00 50 8b 87 b8 00 00 00 50
ff b7 c8 00 00 00 4c 8b 8f c0 00 00 00 48 c7 c7 18 f1 cf 88 e8 6a 43 fb
ff <0f> 0b 48 8b 14 24 48 c7 c1 20 35 b1 88 e8 ab ff ff ff 48 c7 c6 60
All code
========
   0:	4f 70 50             	rex.WRXB jo 0x53
   3:	8b 87 bc 00 00 00    	mov    0xbc(%rdi),%eax
   9:	50                   	push   %rax
   a:	8b 87 b8 00 00 00    	mov    0xb8(%rdi),%eax
  10:	50                   	push   %rax
  11:	ff b7 c8 00 00 00    	pushq  0xc8(%rdi)
  17:	4c 8b 8f c0 00 00 00 	mov    0xc0(%rdi),%r9
  1e:	48 c7 c7 18 f1 cf 88 	mov    $0xffffffff88cff118,%rdi
  25:	e8 6a 43 fb ff       	callq  0xfffffffffffb4394
  2a:*	0f 0b                	ud2    		<-- trapping
instruction
  2c:	48 8b 14 24          	mov    (%rsp),%rdx
  30:	48 c7 c1 20 35 b1 88 	mov    $0xffffffff88b13520,%rcx
  37:	e8 ab ff ff ff       	callq  0xffffffffffffffe7
  3c:	48                   	rex.W
  3d:	c7                   	.byte 0xc7
  3e:	c6                   	(bad)  
  3f:	60                   	(bad)  

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2    
   2:	48 8b 14 24          	mov    (%rsp),%rdx
   6:	48 c7 c1 20 35 b1 88 	mov    $0xffffffff88b13520,%rcx
   d:	e8 ab ff ff ff       	callq  0xffffffffffffffbd
  12:	48                   	rex.W
  13:	c7                   	.byte 0xc7
  14:	c6                   	(bad)  
  15:	60                   	(bad)  
[   61.422606] RSP: 0018:ffffae258017cce0 EFLAGS: 00010246
[   61.423865] RAX: 000000000000008b RBX: 0000000000000010 RCX:
00000000ffffdfff
[   61.425031] RDX: 0000000000000000 RSI: 00000000ffffffea RDI:
0000000000000000
[   61.426229] RBP: ffffde6a80230880 R08: ffffffff88f45568 R09:
0000000000009ffb
[   61.427439] R10: 00000000ffffe000 R11: 3fffffffffffffff R12:
ffff8a5ec7461200
[   61.428615] R13: ffff8a5ec8c22000 R14: 0000000000000000 R15:
0000000000000eb2
[   61.429799] FS:  0000000000000000(0000) GS:ffff8a5febd40000(0000)
knlGS:0000000000000000

Regards,
Corentin

