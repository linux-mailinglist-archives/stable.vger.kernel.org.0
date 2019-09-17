Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64368B4A9D
	for <lists+stable@lfdr.de>; Tue, 17 Sep 2019 11:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbfIQJfT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 17 Sep 2019 05:35:19 -0400
Received: from smtpbgau1.qq.com ([54.206.16.166]:43271 "EHLO smtpbgau1.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727170AbfIQJfS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Sep 2019 05:35:18 -0400
X-QQ-mid: bizesmtp18t1568712900t2s9u62c
Received: from [192.168.142.168] (unknown [218.76.23.26])
        by esmtp6.qq.com (ESMTP) with 
        id ; Tue, 17 Sep 2019 17:34:51 +0800 (CST)
X-QQ-SSF: 00400000000000R0YS90000D0000000
X-QQ-FEAT: ZmU9OHAnTA5MBXbG9/WWta4vwBriVHsos/qMFc5rIYhhPuwQEEp1WEIn3rtIi
        QFEOssH2D6TVJ2at9N3QrGrD/6EPc6RDOxvYJiZhE7+TCqKufTU3UdWz2o6n4o+QzpXEQkm
        Sk2Utaexicx8WX4r+EfoL4uKvxwMpQuGv8zH/qyeNzKCcRFCelZbv5dP8kst0hoEROSAlTm
        C1xaiH0vmHUDkmGzaNt1YzmVt8Uo6KgrB468F/ntXmBeVLtNDqa4NV6hooAimbX78hGHxYc
        8zvHVhGj/W05yj8eDvvWywZRDG2n/WWnXCcFNwB23F2SPEsBepL7W2KdA7dyYRb2OzX4C7I
        Lrd/MAdH8ZRCEhht4EqjiMnBefmCl3/UXWL/EwC
X-QQ-GoodBg: 2
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH 2/4] CVE-2016-9777: KVM: x86: fix out-of-bounds accesses
 of rtc_eoi map
From:   Jackie Liu <liuyun01@kylinos.cn>
In-Reply-To: <1568712761-11089-2-git-send-email-liuyun01@kylinos.cn>
Date:   Tue, 17 Sep 2019 17:34:59 +0800
Cc:     nh@kylinos.cn,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        stable@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <7272467C-4017-4597-8767-A273C40627BA@kylinos.cn>
References: <1568712761-11089-1-git-send-email-liuyun01@kylinos.cn>
 <1568712761-11089-2-git-send-email-liuyun01@kylinos.cn>
To:     =?gb2312?B?zfXn+Q==?= <wangqi@kylinos.cn>
X-Mailer: Apple Mail (2.3445.104.11)
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:kylinos.cn:qybgforeign:qybgforeign4
X-QQ-Bgrelay: 1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sorry for noise, please ignore.

> 在 2019年9月17日，17:32，Jackie Liu <liuyun01@kylinos.cn> 写道：
> 
> From: Radim Krčmář <rkrcmar@redhat.com>
> 
> KVM was using arrays of size KVM_MAX_VCPUS with vcpu_id, but ID can be
> bigger that the maximal number of VCPUs, resulting in out-of-bounds
> access.
> 
> Found by syzkaller:
> 
>  BUG: KASAN: slab-out-of-bounds in __apic_accept_irq+0xb33/0xb50 at addr [...]
>  Write of size 1 by task a.out/27101
>  CPU: 1 PID: 27101 Comm: a.out Not tainted 4.9.0-rc5+ #49
>  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
>   [...]
>  Call Trace:
>   [...] __apic_accept_irq+0xb33/0xb50 arch/x86/kvm/lapic.c:905
>   [...] kvm_apic_set_irq+0x10e/0x180 arch/x86/kvm/lapic.c:495
>   [...] kvm_irq_delivery_to_apic+0x732/0xc10 arch/x86/kvm/irq_comm.c:86
>   [...] ioapic_service+0x41d/0x760 arch/x86/kvm/ioapic.c:360
>   [...] ioapic_set_irq+0x275/0x6c0 arch/x86/kvm/ioapic.c:222
>   [...] kvm_ioapic_inject_all arch/x86/kvm/ioapic.c:235
>   [...] kvm_set_ioapic+0x223/0x310 arch/x86/kvm/ioapic.c:670
>   [...] kvm_vm_ioctl_set_irqchip arch/x86/kvm/x86.c:3668
>   [...] kvm_arch_vm_ioctl+0x1a08/0x23c0 arch/x86/kvm/x86.c:3999
>   [...] kvm_vm_ioctl+0x1fa/0x1a70 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3099
> 
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Cc: stable@vger.kernel.org
> Fixes: af1bae5497b9 ("KVM: x86: bump KVM_MAX_VCPU_ID to 1023")
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
> Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
> ---
> arch/x86/kvm/ioapic.c | 2 +-
> arch/x86/kvm/ioapic.h | 4 ++--
> 2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
> index ec62df3..d25cbac 100644
> --- a/arch/x86/kvm/ioapic.c
> +++ b/arch/x86/kvm/ioapic.c
> @@ -94,7 +94,7 @@ static unsigned long ioapic_read_indirect(struct kvm_ioapic *ioapic,
> static void rtc_irq_eoi_tracking_reset(struct kvm_ioapic *ioapic)
> {
> 	ioapic->rtc_status.pending_eoi = 0;
> -	bitmap_zero(ioapic->rtc_status.dest_map.map, KVM_MAX_VCPUS);
> +	bitmap_zero(ioapic->rtc_status.dest_map.map, KVM_MAX_VCPU_ID);
> }
> 
> static void kvm_rtc_eoi_tracking_restore_all(struct kvm_ioapic *ioapic);
> diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
> index 7d2692a..1cc6e54 100644
> --- a/arch/x86/kvm/ioapic.h
> +++ b/arch/x86/kvm/ioapic.h
> @@ -42,13 +42,13 @@ struct kvm_vcpu;
> 
> struct dest_map {
> 	/* vcpu bitmap where IRQ has been sent */
> -	DECLARE_BITMAP(map, KVM_MAX_VCPUS);
> +	DECLARE_BITMAP(map, KVM_MAX_VCPU_ID);
> 
> 	/*
> 	 * Vector sent to a given vcpu, only valid when
> 	 * the vcpu's bit in map is set
> 	 */
> -	u8 vectors[KVM_MAX_VCPUS];
> +	u8 vectors[KVM_MAX_VCPU_ID];
> };
> 
> 
> -- 
> 2.7.4
> 


--
BR, Jackie Liu



