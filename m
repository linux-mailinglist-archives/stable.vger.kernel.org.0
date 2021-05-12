Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75E2537ED91
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 00:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387661AbhELUjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 16:39:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:33790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1376579AbhELSzJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:55:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5311611BD;
        Wed, 12 May 2021 18:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620845640;
        bh=0v11jeez54FneOK7W+JHdJ88FtBJC12awhEy2sMyl+w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LQAx1WTbfrd/rYLoXyh97Re6e8HL2bqQzU+eQCqTCzTTP0Q+E0hx68NMBmgnFxyp5
         Yd53+drZw06vxLeL8HUpQrWNg7YlzEdtRqctl8gtLwAX9uOuGSy/MWHrro4Kwk2XFw
         7Je5lxvRZL6MXHonw/Fvnx0+J++J4KmtdMgP2Gl8=
Date:   Wed, 12 May 2021 20:53:57 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH 5.4 000/244] 5.4.119-rc1 review
Message-ID: <YJwkRS20XCeVcIox@kroah.com>
References: <20210512144743.039977287@linuxfoundation.org>
 <CA+G9fYs1AH8ZNWMJ=H4TY5C6bqp--=SZfW9P=WbB85qSBDkuXw@mail.gmail.com>
 <b7df0d7f-e582-6a0d-2385-b9fce50f9106@arm.com>
 <87h7j7opg2.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87h7j7opg2.wl-maz@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 12, 2021 at 06:02:37PM +0100, Marc Zyngier wrote:
> On Wed, 12 May 2021 18:00:16 +0100,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > Hi Naresh,
> > 
> > Thank you for the report!
> > 
> > On 5/12/21 5:47 PM, Naresh Kamboju wrote:
> > > On Wed, 12 May 2021 at 20:22, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > >> This is the start of the stable review cycle for the 5.4.119 release.
> > >> There are 244 patches in this series, all will be posted as a response
> > >> to this one.  If anyone has any issues with these being applied, please
> > >> let me know.
> > >>
> > >> Responses should be made by Fri, 14 May 2021 14:47:09 +0000.
> > >> Anything received after that time might be too late.
> > >>
> > >> The whole patch series can be found in one patch at:
> > >>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.119-rc1.gz
> > >> or in the git tree and branch at:
> > >>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > >> and the diffstat can be found below.
> > >>
> > >> thanks,
> > >>
> > >> greg k-h
> > > Build regression detected.
> > >
> > >> Alexandru Elisei <alexandru.elisei@arm.com>
> > >>     KVM: arm64: Initialize VCPU mdcr_el2 before loading it
> > > stable rc 5.4 arm axm55xx_defconfig builds failed due to these
> > > warnings / errors.
> > >   - arm (axm55xx_defconfig) with gcc-8,9 and 10 failed
> > >
> > > arch/arm/kvm/../../../virt/kvm/arm/arm.c: In function 'kvm_vcpu_first_run_init':
> > > arch/arm/kvm/../../../virt/kvm/arm/arm.c:582:2: error: implicit
> > > declaration of function 'kvm_arm_vcpu_init_debug'; did you mean
> > > 'kvm_arm_init_debug'? [-Werror=implicit-function-declaration]
> > >   kvm_arm_vcpu_init_debug(vcpu);
> > >   ^~~~~~~~~~~~~~~~~~~~~~~
> > >   kvm_arm_init_debug
> > > cc1: some warnings being treated as errors
> > 
> > This is my fault, in Linux v5.4 KVM for arm is still around, and
> > there's no prototype for the function when compiling for arm. I
> > suspect that's also the case for v4.19.
> > 
> > I made this change to get it to build:
> > 
> > $ git diff
> > diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> > index dd03d5e01a94..32564b017ba0 100644
> > --- a/arch/arm/include/asm/kvm_host.h
> > +++ b/arch/arm/include/asm/kvm_host.h
> > @@ -335,6 +335,7 @@ static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu,
> > int cpu) {}
> >  static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
> >  
> >  static inline void kvm_arm_init_debug(void) {}
> > +static inline void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu) {}
> >  static inline void kvm_arm_setup_debug(struct kvm_vcpu *vcpu) {}
> >  static inline void kvm_arm_clear_debug(struct kvm_vcpu *vcpu) {}
> >  static inline void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu) {}
> > 
> > which matches the stub for kvm_arm_init_debug(). I can spin a patch
> > out of it and send it for 5.4 and 4.19. Marc, what do you think?
> 
> Ideally, we'd drop the patch in its current form from 5.4 and 4.19,
> and send an updated patch with this hunk to fix the 32bit build.
> 

That would be great.  Do you want to do it for this set of releases
(i.e. today/tomorrow) or have me just drop this now and someone will
send me an updated version later when they get a chance?

thanks,

greg k-h
