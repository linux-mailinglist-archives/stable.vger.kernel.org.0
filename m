Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5A237CF29
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240777AbhELRJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:09:13 -0400
Received: from foss.arm.com ([217.140.110.172]:44850 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344065AbhELRAo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 13:00:44 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5845D31B;
        Wed, 12 May 2021 09:59:36 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4C46D3F719;
        Wed, 12 May 2021 09:59:34 -0700 (PDT)
Subject: Re: [PATCH 5.4 000/244] 5.4.119-rc1 review
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Marc Zyngier <maz@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu
References: <20210512144743.039977287@linuxfoundation.org>
 <CA+G9fYs1AH8ZNWMJ=H4TY5C6bqp--=SZfW9P=WbB85qSBDkuXw@mail.gmail.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <b7df0d7f-e582-6a0d-2385-b9fce50f9106@arm.com>
Date:   Wed, 12 May 2021 18:00:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CA+G9fYs1AH8ZNWMJ=H4TY5C6bqp--=SZfW9P=WbB85qSBDkuXw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Naresh,

Thank you for the report!

On 5/12/21 5:47 PM, Naresh Kamboju wrote:
> On Wed, 12 May 2021 at 20:22, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>> This is the start of the stable review cycle for the 5.4.119 release.
>> There are 244 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri, 14 May 2021 14:47:09 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.119-rc1.gz
>> or in the git tree and branch at:
>>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> Build regression detected.
>
>> Alexandru Elisei <alexandru.elisei@arm.com>
>>     KVM: arm64: Initialize VCPU mdcr_el2 before loading it
> stable rc 5.4 arm axm55xx_defconfig builds failed due to these
> warnings / errors.
>   - arm (axm55xx_defconfig) with gcc-8,9 and 10 failed
>
> arch/arm/kvm/../../../virt/kvm/arm/arm.c: In function 'kvm_vcpu_first_run_init':
> arch/arm/kvm/../../../virt/kvm/arm/arm.c:582:2: error: implicit
> declaration of function 'kvm_arm_vcpu_init_debug'; did you mean
> 'kvm_arm_init_debug'? [-Werror=implicit-function-declaration]
>   kvm_arm_vcpu_init_debug(vcpu);
>   ^~~~~~~~~~~~~~~~~~~~~~~
>   kvm_arm_init_debug
> cc1: some warnings being treated as errors

This is my fault, in Linux v5.4 KVM for arm is still around, and there's no
prototype for the function when compiling for arm. I suspect that's also the case
for v4.19.

I made this change to get it to build:

$ git diff
diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index dd03d5e01a94..32564b017ba0 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -335,6 +335,7 @@ static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu,
int cpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
 static inline void kvm_arm_init_debug(void) {}
+static inline void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arm_setup_debug(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arm_clear_debug(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu) {}

which matches the stub for kvm_arm_init_debug(). I can spin a patch out of it and
send it for 5.4 and 4.19. Marc, what do you think?

Thanks,

Alex

>
>
> steps to reproduce:
> --------------------
> #!/bin/sh
>
> # TuxMake is a command line tool and Python library that provides
> # portable and repeatable Linux kernel builds across a variety of
> # architectures, toolchains, kernel configurations, and make targets.
> #
> # TuxMake supports the concept of runtimes.
> # See https://docs.tuxmake.org/runtimes/, for that to work it requires
> # that you install podman or docker on your system.
> #
> # To install tuxmake on your system globally:
> # sudo pip3 install -U tuxmake
> #
> # See https://docs.tuxmake.org/ for complete documentation.
>
>
> tuxmake --runtime podman --target-arch arm --toolchain gcc-8 --kconfig
> axm55xx_defconfig
>
> ref:
> https://builds.tuxbuild.com/1sRT0HOyHnZ8N5ktJmaEcMIQZL0/
>
>
> --
> Linaro LKFT
> https://lkft.linaro.org
