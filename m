Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB38D5F25
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 11:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731092AbfJNJlW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 05:41:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:44432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730977AbfJNJlV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Oct 2019 05:41:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16A1620663;
        Mon, 14 Oct 2019 09:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571046080;
        bh=diRFlxJdPpwxJzwD6o7heiqFYOgIzONcIhEg4USVzi4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OizufxVBxP5BdzbfmAIetfQvEWskWn76w2rZlTBZNIbX1RCSvWBqVKHYVPMKiX1jQ
         YB8xQdW0+7qf3+SAAjZebrL0MB4oD1tgRqantHUD/x5T4xKPHoBOYw+717Ur52uqxy
         ot0Rao9Y9RYU6g1Fw5x0gvRqaCZj5MHJaIvdNGfs=
Date:   Mon, 14 Oct 2019 11:41:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     pbonzini@redhat.com, bugzilla-daemon@bugzilla.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [Bug 205171] New: kernel panic during windows 10pro start
Message-ID: <20191014094118.GB3050866@kroah.com>
References: <bug-205171-28872@https.bugzilla.kernel.org/>
 <87bluj66ev.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bluj66ev.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 14, 2019 at 11:08:24AM +0200, Vitaly Kuznetsov wrote:
> bugzilla-daemon@bugzilla.kernel.org writes:
> 
> > https://bugzilla.kernel.org/show_bug.cgi?id=205171
> >
> >             Bug ID: 205171
> >            Summary: kernel panic during windows 10pro start
> >            Product: Virtualization
> >            Version: unspecified
> >     Kernel Version: 4.19.74 and higher
> >           Hardware: All
> >                 OS: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Severity: normal
> >           Priority: P1
> >          Component: kvm
> >           Assignee: virtualization_kvm@kernel-bugs.osdl.org
> >           Reporter: dront78@gmail.com
> >         Regression: No
> >
> > works fine on 4.19.73
> >
> > [ 5829.948945] BUG: unable to handle kernel NULL pointer dereference at
> > 0000000000000000
> > [ 5829.948951] PGD 0 P4D 0 
> > [ 5829.948954] Oops: 0002 [#1] SMP NOPTI
> > [ 5829.948957] CPU: 3 PID: 1699 Comm: CPU 0/KVM Tainted: G           OE    
> > 4.19.78-2-lts #1
> > [ 5829.948958] Hardware name: Micro-Star International Co., Ltd. GE62
> > 6QF/MS-16J4, BIOS E16J4IMS.117 01/18/2018
> > [ 5829.948989] RIP: 0010:kvm_write_guest_virt_system+0x1e/0x40 [kvm]
> 
> It seems 4.19 stable backport is broken, upstream commit f7eea636c3d50
> has:
> 
> @@ -4588,7 +4589,8 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
>                                 vmx_instruction_info, true, len, &gva))
>                         return 1;
>                 /* _system ok, nested_vmx_check_permission has verified cpl=0 */
> -               kvm_write_guest_virt_system(vcpu, gva, &field_value, len, NULL);
> +               if (kvm_write_guest_virt_system(vcpu, gva, &field_value, len, &e))
> +                       kvm_inject_page_fault(vcpu, &e);
>         }
> 
> and it's 4.19 counterpart (73c31bd92039):
> 
> @@ -8798,8 +8799,10 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
>                                 vmx_instruction_info, true, &gva))
>                         return 1;
>                 /* _system ok, nested_vmx_check_permission has verified cpl=0 */
> -               kvm_write_guest_virt_system(vcpu, gva, &field_value,
> -                                           (is_long_mode(vcpu) ? 8 : 4), NULL);
> +               if (kvm_write_guest_virt_system(vcpu, gva, &field_value,
> +                                               (is_long_mode(vcpu) ? 8 : 4),
> +                                               NULL))
> +                       kvm_inject_page_fault(vcpu, &e);
>         }
>  
> (note the last argument to kvm_write_guest_virt_system() - it's NULL
> instead of &e.
> 
> And v4.19.74 has 6e60900cfa3e (541ab2aeb282 upstream):
> 
> @@ -5016,6 +5016,13 @@ int kvm_write_guest_virt_system(struct kvm_vcpu *vcpu, gva_t addr, void *val,
>         /* kvm_write_guest_virt_system can pull in tons of pages. */
>         vcpu->arch.l1tf_flush_l1d = true;
>  
> +       /*
> +        * FIXME: this should call handle_emulation_failure if X86EMUL_IO_NEEDED
> +        * is returned, but our callers are not ready for that and they blindly
> +        * call kvm_inject_page_fault.  Ensure that they at least do not leak
> +        * uninitialized kernel stack memory into cr2 and error code.
> +        */
> +       memset(exception, 0, sizeof(*exception));
>         return kvm_write_guest_virt_helper(addr, val, bytes, vcpu,
>                                            PFERR_WRITE_MASK, exception);
>  }
> 
> This all results in memset(NULL). (also, 6e60900cfa3e should come
> *after* f7eea636c3d50 and not before but oh well..)
> 
> The following will likely fix the problem (untested):
> 
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index e83f4f6bfdac..d3a900a4fa0e 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -8801,7 +8801,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
>                 /* _system ok, nested_vmx_check_permission has verified cpl=0 */
>                 if (kvm_write_guest_virt_system(vcpu, gva, &field_value,
>                                                 (is_long_mode(vcpu) ? 8 : 4),
> -                                               NULL))
> +                                               &e))
>                         kvm_inject_page_fault(vcpu, &e);
>         }
> 
> I can send a patch to stable@ if needed.

A patch was already sent, and is included in the 4.19.79 and 4.14.149
kernel releases, and will be part of the next 4.9.y and 4.4.y kernel
releases that happen later this week.

thanks,

greg k-h
