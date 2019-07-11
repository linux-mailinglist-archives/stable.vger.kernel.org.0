Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B72C6583D
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 15:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728298AbfGKN5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 09:57:45 -0400
Received: from foss.arm.com ([217.140.110.172]:46408 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728275AbfGKN5p (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jul 2019 09:57:45 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9B3BA2B;
        Thu, 11 Jul 2019 06:57:44 -0700 (PDT)
Received: from [10.1.197.45] (e112298-lin.cambridge.arm.com [10.1.197.45])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8A7BF3F59C;
        Thu, 11 Jul 2019 06:57:42 -0700 (PDT)
Subject: Re: [PATCH v4.4 00/45] V4.4 backport of arm64 Spectre patches
To:     Viresh Kumar <viresh.kumar@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Cc:     stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
References: <cover.1560480942.git.viresh.kumar@linaro.org>
From:   Julien Thierry <julien.thierry@arm.com>
Message-ID: <19247d89-8f83-f5f7-dc03-0f6106c6e28e@arm.com>
Date:   Thu, 11 Jul 2019 14:57:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <cover.1560480942.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Viresh,

On 14/06/2019 04:07, Viresh Kumar wrote:
> Hello,
> 
> Here is an attempt to backport arm64 spectre patches to v4.4 stable
> tree.
> 
> I have started this backport with Mark Rutland's backport of Spectre to
> 4.9 [1] and tried applying the upstream version of them over 4.4 and
> resolved conflicts by checking how they have been resolved in 4.9.
> 
> I had to pick few extra upstream patches to avoid unnecessary conflicts
> (upstream commit ids mentioned):
> 
>   a842789837c0 arm64: remove duplicate macro __KERNEL__ check
>   64f8ebaf115b mm/kasan: add API to check memory regions
>   bffe1baff5d5 arm64: kasan: instrument user memory access API
>   92406f0cc9e3 arm64: cpufeature: Add scope for capability check
>   9eb8a2cdf65c arm64: cputype info for Broadcom Vulcan
>   0d90718871fe arm64: cputype: Add MIDR values for Cavium ThunderX2 CPUs
>   98dd64f34f47 ARM: 8478/2: arm/arm64: add arm-smccc
> 
> 
> I had to drop few patches as well as they weren't getting applied
> properly due to missing files/features (upstream commit id mentioned):
> 
>   93f339ef4175 arm64: cpufeature: __this_cpu_has_cap() shouldn't stop early
>   3c31fa5a06b4 arm64: Run enable method for errata work arounds on late CPUs
>   6840bdd73d07 arm64: KVM: Use per-CPU vector when BP hardening is enabled
>   90348689d500 arm64: KVM: Make PSCI_VERSION a fast path
> 
> 
> Since v4.4 doesn't contain arch/arm/kvm/hyp/switch.c file, changes for
> it are dropped from some of the patches. The commit log of specific
> patches are updated with this information.
> 
> Also for commit id (from 4.9 stable):
>   c24c205d2528 arm64: Add ARM_SMCCC_ARCH_WORKAROUND_1 BP hardening support
> 
> I have dropped arch/arm64/crypto/sha256-core.S and sha512-core.S files
> as they weren't part of the upstream commit. Not sure why it was
> included by Mark as the commit log doesn't provide any reasoning for it.
> 
> The patches in this series are pushed here [2].
> 
> This is only build/boot tested by me as I don't have access to the
> required test-suite which can verify spectre mitigations.
> 
> @Julien: Can you please help reviewing / testing them ? Thanks.
> 

Since there were seems to be a lot of changes between the current branch
and the patch series you posted, it would probably be good to post a new
version on the mailing list once you believe you have them in a good shape.

Testing the branch is fine, but reviewing is definitely something that
should happen on patches posted on the mailing list.

Thanks,

-- 
Julien Thierry
