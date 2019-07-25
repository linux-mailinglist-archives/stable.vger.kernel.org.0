Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3FAE74D24
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 13:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390779AbfGYLem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 07:34:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:40236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388479AbfGYLem (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 07:34:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A96052184B;
        Thu, 25 Jul 2019 11:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564054480;
        bh=nBOvUuzvC2p8gP+bnMWX3ZYG2Z6gx6IlHhzdXjtO114=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R3ux+oQifD81Ws9cfZ6N50zWTqufwQSDGIQzc8mXoZ2uVngZKcLpZuqlNWA/TjAuU
         EMW+el1rV6aChQG+cZ8O6zuESdOAH8JSS6yS4sWck9c3DEtk3/XnSqPEycA+LUZ7B+
         LuBpXKeY4NT2YrYKonQJlYRq+6ZQbNaZxtQZGxNg=
Date:   Thu, 25 Jul 2019 13:34:37 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, ben.hutchings@codethink.co.uk,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, linux@roeck-us.net
Subject: Re: [PATCH 5.2 000/413] 5.2.3-stable review
Message-ID: <20190725113437.GA27429@kroah.com>
References: <20190724191735.096702571@linuxfoundation.org>
 <CADYN=9+WLxhmqX3JNL_s-kWSN97G=8WhD=TF=uAuKecJnKcj_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADYN=9+WLxhmqX3JNL_s-kWSN97G=8WhD=TF=uAuKecJnKcj_Q@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 25, 2019 at 01:16:19PM +0200, Anders Roxell wrote:
> On Wed, 24 Jul 2019 at 21:25, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.2.3 release.
> > There are 413 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri 26 Jul 2019 07:13:35 PM UTC.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.3-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> Regressions detected.
> 
> Summary
> ------------------------------------------------------------------------
> 
> kernel: 5.2.3-rc1
> git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> git branch: linux-5.2.y
> git commit: db628fe0e67ff8c66e8c6ba76e5e4becfa75fe21
> git describe: v5.2.2-414-gdb628fe0e67f
> Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.2-oe/build/v5.2.2-414-gdb628fe0e67f
> 
> Regressions (compared to build v5.2.2)
> ------------------------------------------------------------------------
> 
> x86:
>   kvm-unit-tests:
>     * vmx
> 
> 
> TESTNAME=vmx TIMEOUT=90s ACCEL= ./x86/run x86/vmx.flat -smp 1 -cpu
> host,+vmx -append \"-exit_monitor_from_l2_test -ept_access* -vmx_smp*
> -vmx_vmcs_shadow_test\"
> [  155.670748] kvm [6062]: vcpu0, guest rIP: 0x4050cb
> kvm_set_msr_common: MSR_IA32_DEBUGCTLMSR 0x1, nop
> [  155.681027] kvm [6062]: vcpu0, guest rIP: 0x408911
> kvm_set_msr_common: MSR_IA32_DEBUGCTLMSR 0x3, nop
> [  155.690749] kvm [6062]: vcpu0, guest rIP: 0x40bb39
> kvm_set_msr_common: MSR_IA32_DEBUGCTLMSR 0x1, nop
> [  155.700595] kvm [6062]: vcpu0, guest rIP: 0x4089b2
> kvm_set_msr_common: MSR_IA32_DEBUGCTLMSR 0x3, nop
> [  158.349308] nested_vmx_exit_reflected failed vm entry 7
> [  158.363737] nested_vmx_exit_reflected failed vm entry 7
> [  158.378010] nested_vmx_exit_reflected failed vm entry 7
> [  158.392480] nested_vmx_exit_reflected failed vm entry 7
> [  158.406920] nested_vmx_exit_reflected failed vm entry 7
> [  158.421390] nested_vmx_exit_reflected failed vm entry 7
> [  158.435795] nested_vmx_exit_reflected failed vm entry 7
> [  158.450276] nested_vmx_exit_reflected failed vm entry 7
> [  158.464674] nested_vmx_exit_reflected failed vm entry 7
> [  158.479030] nested_vmx_exit_reflected failed vm entry 7
> [  161.044379] set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.
> FAIL vmx (timeout; duration=90s)
> 
> kernel-config: http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/intel-corei7-64/lkft/linux-stable-rc-5.2/14/config
> Full log: https://lkft.validation.linaro.org/scheduler/job/836289#L1597

Ick.

Any chance you can run 'git bisect' to find the offending patch?  Or
just try reverting a few, you can ignore the ppc ones, so that only
leaves you 7 different commits.

Does this same test pass in 5.3-rc1?

thanks,

greg k-h
