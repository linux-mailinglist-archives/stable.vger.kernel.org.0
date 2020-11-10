Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5272ACADF
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 03:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729661AbgKJCGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 21:06:33 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:35504 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729648AbgKJCGd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 21:06:33 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=zelin.deng@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UEqEC99_1604973988;
Received: from rs3a04324.et2sqa(mailfrom:zelin.deng@linux.alibaba.com fp:SMTPD_---0UEqEC99_1604973988)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 10 Nov 2020 10:06:29 +0800
Date:   Tue, 10 Nov 2020 10:06:28 +0800
From:   Zelin Deng <zelin.deng@linux.alibaba.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Fix vCPUs >= 64 can't be online and hotplugged
 in some scenarios
Message-ID: <20201110020628.GA19666@rs3a04324.et2sqa>
References: <1600066825-15461-1-git-send-email-zelin.deng@linux.alibaba.com>
 <098e95f3-9f8d-e9df-bc9f-fc1ae2124e24@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <098e95f3-9f8d-e9df-bc9f-fc1ae2124e24@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 09, 2020 at 07:19:44AM -0600, Brijesh Singh wrote:
> 
> On 9/14/20 2:00 AM, Zelin Deng wrote:
> > pvclock data pointers of vCPUs >= HVC_BOOT_ARRAY_SIZE (64) are stored in
> > hvclock_mem wihch is initialized in kvmclock_init_mem().
> > Here're 3 scenarios in current implementation:
> >     - no-kvmclock is set in cmdline. kvm pv clock driver is disabled,
> >       no impact.
> >     - no-kvmclock-vsyscall is set in cmdline. kvmclock_init_mem() won't
> >       be called. No memory for storing pvclock data of vCPUs >= 64, vCPUs
> >       >= 64 can not be online or hotpluged.
> >     - tsc unstable. kvmclock_init_mem() won't be called. vCPUs >= 64 can
> >       not be online or hotpluged.
> > It's not reasonable that vCPUs hotplug have been impacted by last 2
> > scenarios. Hence move kvmclock_init_mem() to front, in case hvclock_mem
> > can not be initialized unexpectedly.
> >
> > Fixes: 6a1cac56f41f9 (x86/kvm: Use __bss_decrypted attribute in shared variables)
> > Cc: <stable@vger.kernel.org>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Brijesh Singh <brijesh.singh@amd.com>
> > Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Zelin Deng <zelin.deng@linux.alibaba.com>
> > ---
> >  arch/x86/kernel/kvmclock.c | 9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> > index 34b18f6eeb2c..1abbda25e037 100644
> > --- a/arch/x86/kernel/kvmclock.c
> > +++ b/arch/x86/kernel/kvmclock.c
> > @@ -271,7 +271,14 @@ static int __init kvm_setup_vsyscall_timeinfo(void)
> >  {
> >  #ifdef CONFIG_X86_64
> >  	u8 flags;
> > +#endif
> > +
> > +	if (!kvmclock)
> > +		return 0;
> 
> 
> Overall, I agree with the fix to move the kvmclock_init_mem() in the
> beginning of the function so that memory hvclock_mem is allocated. But
> curious, why do we need this check? The if (kvmclock) did not exist in
> original function and I don't think kvmclock_init_mem() has any
> dependency with it, am I missing something ?
> 
> 
Per my under standing if "no-kvmclock" is set in cmdline, pvclock will
be disabled in guest kernel kvmclock_init() just returns without doing
anything right? However in this scenarios, this function still will be
executed as it is a early_initcall. To avoid a waste of memory, is it
reasonable to do this check?
> > +
> > +	kvmclock_init_mem();
> >  
> > +#ifdef CONFIG_X86_64
> >  	if (!per_cpu(hv_clock_per_cpu, 0) || !kvmclock_vsyscall)
> >  		return 0;
> >  
> > @@ -282,8 +289,6 @@ static int __init kvm_setup_vsyscall_timeinfo(void)
> >  	kvm_clock.vdso_clock_mode = VDSO_CLOCKMODE_PVCLOCK;
> >  #endif
> >  
> > -	kvmclock_init_mem();
> > -
> >  	return 0;
> >  }
> >  early_initcall(kvm_setup_vsyscall_timeinfo);
