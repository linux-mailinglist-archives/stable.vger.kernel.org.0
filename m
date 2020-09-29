Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A0E27C3C3
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728828AbgI2LIf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:08:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728705AbgI2LIe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:08:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED00422262;
        Tue, 29 Sep 2020 11:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377703;
        bh=0to5Wh6TwVu38wGVlPuoRqCGUi/7P+DPbxA5BxsTMAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hPbtjYP9p02ERfiYAvETUzHhT/Q2RsE2fgwkI+cSdHtGZknceJt0cmR2CkZs1oRHc
         KMfacHNB3c3clJx79/RhhOtvTZoGOgODtH33vxtJENW/4kzbVriZTSSLxQoIfjH8KL
         5oEVhN24JdVrEgJcy38mvqJYC/x7DN0ez5btKPLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, LinFeng <linfeng23@huawei.com>,
        Zhuang Yanying <ann.zhuangyanying@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 042/121] KVM: fix overflow of zero page refcount with ksm running
Date:   Tue, 29 Sep 2020 12:59:46 +0200
Message-Id: <20200929105932.279859338@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105930.172747117@linuxfoundation.org>
References: <20200929105930.172747117@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhuang Yanying <ann.zhuangyanying@huawei.com>

[ Upstream commit 7df003c85218b5f5b10a7f6418208f31e813f38f ]

We are testing Virtual Machine with KSM on v5.4-rc2 kernel,
and found the zero_page refcount overflow.
The cause of refcount overflow is increased in try_async_pf
(get_user_page) without being decreased in mmu_set_spte()
while handling ept violation.
In kvm_release_pfn_clean(), only unreserved page will call
put_page. However, zero page is reserved.
So, as well as creating and destroy vm, the refcount of
zero page will continue to increase until it overflows.

step1:
echo 10000 > /sys/kernel/pages_to_scan/pages_to_scan
echo 1 > /sys/kernel/pages_to_scan/run
echo 1 > /sys/kernel/pages_to_scan/use_zero_pages

step2:
just create several normal qemu kvm vms.
And destroy it after 10s.
Repeat this action all the time.

After a long period of time, all domains hang because
of the refcount of zero page overflow.

Qemu print error log as follow:
 â€¦
 error: kvm run failed Bad address
 EAX=00006cdc EBX=00000008 ECX=80202001 EDX=078bfbfd
 ESI=ffffffff EDI=00000000 EBP=00000008 ESP=00006cc4
 EIP=000efd75 EFL=00010002 [-------] CPL=0 II=0 A20=1 SMM=0 HLT=0
 ES =0010 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
 CS =0008 00000000 ffffffff 00c09b00 DPL=0 CS32 [-RA]
 SS =0010 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
 DS =0010 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
 FS =0010 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
 GS =0010 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
 LDT=0000 00000000 0000ffff 00008200 DPL=0 LDT
 TR =0000 00000000 0000ffff 00008b00 DPL=0 TSS32-busy
 GDT=     000f7070 00000037
 IDT=     000f70ae 00000000
 CR0=00000011 CR2=00000000 CR3=00000000 CR4=00000000
 DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000
 DR6=00000000ffff0ff0 DR7=0000000000000400
 EFER=0000000000000000
 Code=00 01 00 00 00 e9 e8 00 00 00 c7 05 4c 55 0f 00 01 00 00 00 <8b> 35 00 00 01 00 8b 3d 04 00 01 00 b8 d8 d3 00 00 c1 e0 08 0c ea a3 00 00 01 00 c7 05 04
 â€¦

Meanwhile, a kernel warning is departed.

 [40914.836375] WARNING: CPU: 3 PID: 82067 at ./include/linux/mm.h:987 try_get_page+0x1f/0x30
 [40914.836412] CPU: 3 PID: 82067 Comm: CPU 0/KVM Kdump: loaded Tainted: G           OE     5.2.0-rc2 #5
 [40914.836415] RIP: 0010:try_get_page+0x1f/0x30
 [40914.836417] Code: 40 00 c3 0f 1f 84 00 00 00 00 00 48 8b 47 08 a8 01 75 11 8b 47 34 85 c0 7e 10 f0 ff 47 34 b8 01 00 00 00 c3 48 8d 78 ff eb e9 <0f> 0b 31 c0 c3 66 90 66 2e 0f 1f 84 00 0
 0 00 00 00 48 8b 47 08 a8
 [40914.836418] RSP: 0018:ffffb4144e523988 EFLAGS: 00010286
 [40914.836419] RAX: 0000000080000000 RBX: 0000000000000326 RCX: 0000000000000000
 [40914.836420] RDX: 0000000000000000 RSI: 00004ffdeba10000 RDI: ffffdf07093f6440
 [40914.836421] RBP: ffffdf07093f6440 R08: 800000424fd91225 R09: 0000000000000000
 [40914.836421] R10: ffff9eb41bfeebb8 R11: 0000000000000000 R12: ffffdf06bbd1e8a8
 [40914.836422] R13: 0000000000000080 R14: 800000424fd91225 R15: ffffdf07093f6440
 [40914.836423] FS:  00007fb60ffff700(0000) GS:ffff9eb4802c0000(0000) knlGS:0000000000000000
 [40914.836425] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 [40914.836426] CR2: 0000000000000000 CR3: 0000002f220e6002 CR4: 00000000003626e0
 [40914.836427] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 [40914.836427] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 [40914.836428] Call Trace:
 [40914.836433]  follow_page_pte+0x302/0x47b
 [40914.836437]  __get_user_pages+0xf1/0x7d0
 [40914.836441]  ? irq_work_queue+0x9/0x70
 [40914.836443]  get_user_pages_unlocked+0x13f/0x1e0
 [40914.836469]  __gfn_to_pfn_memslot+0x10e/0x400 [kvm]
 [40914.836486]  try_async_pf+0x87/0x240 [kvm]
 [40914.836503]  tdp_page_fault+0x139/0x270 [kvm]
 [40914.836523]  kvm_mmu_page_fault+0x76/0x5e0 [kvm]
 [40914.836588]  vcpu_enter_guest+0xb45/0x1570 [kvm]
 [40914.836632]  kvm_arch_vcpu_ioctl_run+0x35d/0x580 [kvm]
 [40914.836645]  kvm_vcpu_ioctl+0x26e/0x5d0 [kvm]
 [40914.836650]  do_vfs_ioctl+0xa9/0x620
 [40914.836653]  ksys_ioctl+0x60/0x90
 [40914.836654]  __x64_sys_ioctl+0x16/0x20
 [40914.836658]  do_syscall_64+0x5b/0x180
 [40914.836664]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
 [40914.836666] RIP: 0033:0x7fb61cb6bfc7

Signed-off-by: LinFeng <linfeng23@huawei.com>
Signed-off-by: Zhuang Yanying <ann.zhuangyanying@huawei.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/kvm_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 010d8aee9346b..5bddabb3de7c3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -154,6 +154,7 @@ bool kvm_is_reserved_pfn(kvm_pfn_t pfn)
 	 */
 	if (pfn_valid(pfn))
 		return PageReserved(pfn_to_page(pfn)) &&
+		       !is_zero_pfn(pfn) &&
 		       !kvm_is_zone_device_pfn(pfn);
 
 	return true;
-- 
2.25.1



