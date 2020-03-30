Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E136197D2C
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 15:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgC3Nk4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 09:40:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:36540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727276AbgC3Nk4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Mar 2020 09:40:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50A612073B;
        Mon, 30 Mar 2020 13:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585575655;
        bh=hp0nc41NYFerrvQb4qs4Dvb95Rd2/gD841jXfsBC1Jo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bsYUv7cqRhbIu/SeCeOXEJo0olSx3vKYzlGL8HwWMIWR99iBujGOlz3udPNpqv9kN
         P1R5i6XcajhVYXlPYlSs8GzrGvQPbbGM+2yzvsenj+6PICDJ9noitYLu5YWHgVAsxC
         voeE+Yf15H7xWBh4tIkp8xOQU94SOKHTjuaYEb4Y=
Date:   Mon, 30 Mar 2020 15:40:53 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zhuang Yanying <ann.zhuangyanying@huawei.com>
Cc:     tv@lio96.de, stable@vger.kernel.org, pbonzini@redhat.com,
        LinFeng <linfeng23@huawei.com>
Subject: Re: [PATCH 1/2] KVM: fix overflow of zero page refcount with ksm
 running
Message-ID: <20200330134053.GC332213@kroah.com>
References: <8350b14e-f708-f2e3-19cd-4e85a4a3235c@redhat.com>
 <1585575162-37912-1-git-send-email-ann.zhuangyanying@huawei.com>
 <1585575162-37912-2-git-send-email-ann.zhuangyanying@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1585575162-37912-2-git-send-email-ann.zhuangyanying@huawei.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 30, 2020 at 09:32:41PM +0800, Zhuang Yanying wrote:
> We are testing Virtual Machine with KSM on v5.4-rc2 kernel,
> and found the zero_page refcount overflow.
> The cause of refcount overflow is increased in try_async_pf
> (get_user_page) without being decreased in mmu_set_spte()
> while handling ept violation.
> In kvm_release_pfn_clean(), only unreserved page will call
> put_page. However, zero page is reserved.
> So, as well as creating and destroy vm, the refcount of
> zero page will continue to increase until it overflows.
> 
> step1:
> echo 10000 > /sys/kernel/pages_to_scan/pages_to_scan
> echo 1 > /sys/kernel/pages_to_scan/run
> echo 1 > /sys/kernel/pages_to_scan/use_zero_pages
> 
> step2:
> just create several normal qemu kvm vms.
> And destroy it after 10s.
> Repeat this action all the time.
> 
> After a long period of time, all domains hang because
> of the refcount of zero page overflow.
> 
> Qemu print error log as follow:
>  â€¦
>  error: kvm run failed Bad address
>  EAX=00006cdc EBX=00000008 ECX=80202001 EDX=078bfbfd
>  ESI=ffffffff EDI=00000000 EBP=00000008 ESP=00006cc4
>  EIP=000efd75 EFL=00010002 [-------] CPL=0 II=0 A20=1 SMM=0 HLT=0
>  ES =0010 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
>  CS =0008 00000000 ffffffff 00c09b00 DPL=0 CS32 [-RA]
>  SS =0010 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
>  DS =0010 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
>  FS =0010 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
>  GS =0010 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
>  LDT=0000 00000000 0000ffff 00008200 DPL=0 LDT
>  TR =0000 00000000 0000ffff 00008b00 DPL=0 TSS32-busy
>  GDT=     000f7070 00000037
>  IDT=     000f70ae 00000000
>  CR0=00000011 CR2=00000000 CR3=00000000 CR4=00000000
>  DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000
>  DR6=00000000ffff0ff0 DR7=0000000000000400
>  EFER=0000000000000000
>  Code=00 01 00 00 00 e9 e8 00 00 00 c7 05 4c 55 0f 00 01 00 00 00 <8b> 35 00 00 01 00 8b 3d 04 00 01 00 b8 d8 d3 00 00 c1 e0 08 0c ea a3 00 00 01 00 c7 05 04
>  â€¦
> 
> Meanwhile, a kernel warning is departed.
> 
>  [40914.836375] WARNING: CPU: 3 PID: 82067 at ./include/linux/mm.h:987 try_get_page+0x1f/0x30
>  [40914.836412] CPU: 3 PID: 82067 Comm: CPU 0/KVM Kdump: loaded Tainted: G           OE     5.2.0-rc2 #5
>  [40914.836415] RIP: 0010:try_get_page+0x1f/0x30
>  [40914.836417] Code: 40 00 c3 0f 1f 84 00 00 00 00 00 48 8b 47 08 a8 01 75 11 8b 47 34 85 c0 7e 10 f0 ff 47 34 b8 01 00 00 00 c3 48 8d 78 ff eb e9 <0f> 0b 31 c0 c3 66 90 66 2e 0f 1f 84 00 0
>  0 00 00 00 48 8b 47 08 a8
>  [40914.836418] RSP: 0018:ffffb4144e523988 EFLAGS: 00010286
>  [40914.836419] RAX: 0000000080000000 RBX: 0000000000000326 RCX: 0000000000000000
>  [40914.836420] RDX: 0000000000000000 RSI: 00004ffdeba10000 RDI: ffffdf07093f6440
>  [40914.836421] RBP: ffffdf07093f6440 R08: 800000424fd91225 R09: 0000000000000000
>  [40914.836421] R10: ffff9eb41bfeebb8 R11: 0000000000000000 R12: ffffdf06bbd1e8a8
>  [40914.836422] R13: 0000000000000080 R14: 800000424fd91225 R15: ffffdf07093f6440
>  [40914.836423] FS:  00007fb60ffff700(0000) GS:ffff9eb4802c0000(0000) knlGS:0000000000000000
>  [40914.836425] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  [40914.836426] CR2: 0000000000000000 CR3: 0000002f220e6002 CR4: 00000000003626e0
>  [40914.836427] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  [40914.836427] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>  [40914.836428] Call Trace:
>  [40914.836433]  follow_page_pte+0x302/0x47b
>  [40914.836437]  __get_user_pages+0xf1/0x7d0
>  [40914.836441]  ? irq_work_queue+0x9/0x70
>  [40914.836443]  get_user_pages_unlocked+0x13f/0x1e0
>  [40914.836469]  __gfn_to_pfn_memslot+0x10e/0x400 [kvm]
>  [40914.836486]  try_async_pf+0x87/0x240 [kvm]
>  [40914.836503]  tdp_page_fault+0x139/0x270 [kvm]
>  [40914.836523]  kvm_mmu_page_fault+0x76/0x5e0 [kvm]
>  [40914.836588]  vcpu_enter_guest+0xb45/0x1570 [kvm]
>  [40914.836632]  kvm_arch_vcpu_ioctl_run+0x35d/0x580 [kvm]
>  [40914.836645]  kvm_vcpu_ioctl+0x26e/0x5d0 [kvm]
>  [40914.836650]  do_vfs_ioctl+0xa9/0x620
>  [40914.836653]  ksys_ioctl+0x60/0x90
>  [40914.836654]  __x64_sys_ioctl+0x16/0x20
>  [40914.836658]  do_syscall_64+0x5b/0x180
>  [40914.836664]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>  [40914.836666] RIP: 0033:0x7fb61cb6bfc7
> 
> Signed-off-by: LinFeng <linfeng23@huawei.com>
> Signed-off-by: Zhuang Yanying <ann.zhuangyanying@huawei.com>
> ---
>  virt/kvm/kvm_main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 7f9ee2929cfe..d49cdd6ca883 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -128,7 +128,8 @@ static bool largepages_enabled = true;
>  bool kvm_is_reserved_pfn(kvm_pfn_t pfn)
>  {
>  	if (pfn_valid(pfn))
> -		return PageReserved(pfn_to_page(pfn));
> +		return PageReserved(pfn_to_page(pfn)) &&
> +		       !is_zero_pfn(pfn);
>  
>  	return true;
>  }
> -- 
> 2.23.0
> 
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
