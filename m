Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6C064883D
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 18:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727967AbfFQQED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 12:04:03 -0400
Received: from foss.arm.com ([217.140.110.172]:54790 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727903AbfFQQEC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 12:04:02 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3E34328;
        Mon, 17 Jun 2019 09:04:01 -0700 (PDT)
Received: from [10.1.197.45] (e112298-lin.cambridge.arm.com [10.1.197.45])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5CA9B3F718;
        Mon, 17 Jun 2019 09:03:56 -0700 (PDT)
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
Message-ID: <7329e6d9-140d-59bc-c835-5f6300cf60e0@arm.com>
Date:   Mon, 17 Jun 2019 17:03:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
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

Thanks for doing that work and having provided a detailed description
for the backport process.

I haven't finished reviewing/testing the whole series yet, but I have
some concerns (do let me know in case I'm missing something and that it
turns out these aren't really issues).

Please see comments below.

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

I'm a bit unfamiliar with what gets or doesn't get backported. My
understanding is that we try to backport only what's necessary to reduce
the noise and potential introduction of issues in stable releases.

This commit is just a cleanup and (while valid) doesn't really seem
necessary (and potential conflicts from its absence would easily be
resolved IMO). So I'm just concerned that this doesn't constitute a
candidate for back porting (someone can correct me if I'm wrong).

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

Looking at this and at the patches that implement the BP callbacks, we
need that patch or an equivalent, otherwise we won't be using the
correct vectors for late CPUs...

I appreciate the code has changed, but it might be worth considering
6a6efbb45b7d95c84840010095367eb06a64f342 as a needed dependency for BP
hardening.

>   6840bdd73d07 arm64: KVM: Use per-CPU vector when BP hardening is enabled

I don't believe we can do without this patch. Otherwise we're only using
the vector that has no mitigation for kvm guests.

In v4.4, it looks like the contents of virt/kvm/arm/arm.c were contained
in arch/arm/kvm/arm.c (yes, even for amr64). Are there other reasons
this patch was not applying?

Thanks,

-- 
Julien Thierry
