Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6685C5BFAD
	for <lists+stable@lfdr.de>; Mon,  1 Jul 2019 17:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbfGAPXj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 11:23:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:36194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726869AbfGAPXi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jul 2019 11:23:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C2D6208CA;
        Mon,  1 Jul 2019 15:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561994617;
        bh=r7IXYNd8Bar2NEwnycxlDDpLrWskL1C9I2DymuT6iIs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NxFTVK7hAYHsqGCii5qlaTZJt3O82BN6Wl1HKW232LQzf2NbCU/tmW0GTe61iLxQB
         E8wsGL/PJTCnve+zBUJaHzwlIkCVNK7AXWgvBtD81FgOntLz4GBFnPO52qlwnV1VvZ
         VL08OVyDMGJxRSW8rQ7fc7yWsb9Gj4LLjOW7M5rA=
Date:   Mon, 1 Jul 2019 17:23:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
Cc:     stable@vger.kernel.org, Wei Wu <ww9210@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, akaher@vmware.com,
        srinidhir@vmware.com, bvikas@vmware.com, amakhalov@vmware.com,
        srivatsab@vmware.com
Subject: Re: [4.4.y PATCH 2/4] KVM: X86: Fix scan ioapic
 use-before-initialization
Message-ID: <20190701152335.GD28557@kroah.com>
References: <156174751125.35226.7600381640894671668.stgit@srivatsa-ubuntu>
 <156174756503.35226.12218857048001680955.stgit@srivatsa-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <156174756503.35226.12218857048001680955.stgit@srivatsa-ubuntu>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 28, 2019 at 11:46:10AM -0700, Srivatsa S. Bhat wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> commit e97f852fd4561e77721bb9a4e0ea9d98305b1e93 upstream.
> 
> Reported by syzkaller:
> 
>  BUG: unable to handle kernel NULL pointer dereference at 00000000000001c8
>  PGD 80000003ec4da067 P4D 80000003ec4da067 PUD 3f7bfa067 PMD 0
>  Oops: 0000 [#1] PREEMPT SMP PTI
>  CPU: 7 PID: 5059 Comm: debug Tainted: G           OE     4.19.0-rc5 #16
>  RIP: 0010:__lock_acquire+0x1a6/0x1990
>  Call Trace:
>   lock_acquire+0xdb/0x210
>   _raw_spin_lock+0x38/0x70
>   kvm_ioapic_scan_entry+0x3e/0x110 [kvm]
>   vcpu_enter_guest+0x167e/0x1910 [kvm]
>   kvm_arch_vcpu_ioctl_run+0x35c/0x610 [kvm]
>   kvm_vcpu_ioctl+0x3e9/0x6d0 [kvm]
>   do_vfs_ioctl+0xa5/0x690
>   ksys_ioctl+0x6d/0x80
>   __x64_sys_ioctl+0x1a/0x20
>   do_syscall_64+0x83/0x6e0
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> The reason is that the testcase writes hyperv synic HV_X64_MSR_SINT6 msr
> and triggers scan ioapic logic to load synic vectors into EOI exit bitmap.
> However, irqchip is not initialized by this simple testcase, ioapic/apic
> objects should not be accessed.
> This can be triggered by the following program:
> 
>     #define _GNU_SOURCE
> 
>     #include <endian.h>
>     #include <stdint.h>
>     #include <stdio.h>
>     #include <stdlib.h>
>     #include <string.h>
>     #include <sys/syscall.h>
>     #include <sys/types.h>
>     #include <unistd.h>
> 
>     uint64_t r[3] = {0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff};
> 
>     int main(void)
>     {
>     	syscall(__NR_mmap, 0x20000000, 0x1000000, 3, 0x32, -1, 0);
>     	long res = 0;
>     	memcpy((void*)0x20000040, "/dev/kvm", 9);
>     	res = syscall(__NR_openat, 0xffffffffffffff9c, 0x20000040, 0, 0);
>     	if (res != -1)
>     		r[0] = res;
>     	res = syscall(__NR_ioctl, r[0], 0xae01, 0);
>     	if (res != -1)
>     		r[1] = res;
>     	res = syscall(__NR_ioctl, r[1], 0xae41, 0);
>     	if (res != -1)
>     		r[2] = res;
>     	memcpy(
>     			(void*)0x20000080,
>     			"\x01\x00\x00\x00\x00\x5b\x61\xbb\x96\x00\x00\x40\x00\x00\x00\x00\x01\x00"
>     			"\x08\x00\x00\x00\x00\x00\x0b\x77\xd1\x78\x4d\xd8\x3a\xed\xb1\x5c\x2e\x43"
>     			"\xaa\x43\x39\xd6\xff\xf5\xf0\xa8\x98\xf2\x3e\x37\x29\x89\xde\x88\xc6\x33"
>     			"\xfc\x2a\xdb\xb7\xe1\x4c\xac\x28\x61\x7b\x9c\xa9\xbc\x0d\xa0\x63\xfe\xfe"
>     			"\xe8\x75\xde\xdd\x19\x38\xdc\x34\xf5\xec\x05\xfd\xeb\x5d\xed\x2e\xaf\x22"
>     			"\xfa\xab\xb7\xe4\x42\x67\xd0\xaf\x06\x1c\x6a\x35\x67\x10\x55\xcb",
>     			106);
>     	syscall(__NR_ioctl, r[2], 0x4008ae89, 0x20000080);
>     	syscall(__NR_ioctl, r[2], 0xae80, 0);
>     	return 0;
>     }
> 
> This patch fixes it by bailing out scan ioapic if ioapic is not initialized in
> kernel.
> 
> Reported-by: Wei Wu <ww9210@gmail.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Cc: Wei Wu <ww9210@gmail.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> [ Srivatsa: Adjusted the context for 4.4.y ]
> Signed-off-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
> ---
> 
>  arch/x86/kvm/x86.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 516d8b1..e1f1851 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6409,7 +6409,8 @@ static void vcpu_scan_ioapic(struct kvm_vcpu *vcpu)
>  		kvm_scan_ioapic_routes(vcpu, vcpu->arch.eoi_exit_bitmap);
>  	else {
>  		kvm_x86_ops->sync_pir_to_irr(vcpu);
> -		kvm_ioapic_scan_entry(vcpu, vcpu->arch.eoi_exit_bitmap);
> +		if (ioapic_in_kernel(vcpu->kvm))
> +			kvm_ioapic_scan_entry(vcpu, vcpu->arch.eoi_exit_bitmap);
>  	}
>  	kvm_x86_ops->load_eoi_exitmap(vcpu);
>  }
>

Applied, thanks.

greg k-h
