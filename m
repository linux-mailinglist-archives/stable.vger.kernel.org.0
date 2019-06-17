Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 234FB48190
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 14:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbfFQMKz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 08:10:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbfFQMKz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 08:10:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 252A82084D;
        Mon, 17 Jun 2019 12:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560773454;
        bh=pAmixHP+Rk/P6yHQsB5WBMUJpjuBXLP2sDa10q1VBvg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VLSgi0WWOgH2nFbVnYYt/lXpgkDb+uTU8eZqxnOpmplQHYTfIcK2lhQW4F8DPqFxc
         r0kDm9Xm+SmXBVKUhQV3iFbCpWM7lBbGy5v4L2BdzCE/KX+4bDd+KP2pA3/lw0t/sI
         GzKguTF/VdGVAhiGIb2FOBoxFZT4pdFconoseSaM=
Date:   Mon, 17 Jun 2019 14:10:52 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Viresh Kumar <viresh.kumar@linaro.org>
Cc:     linux-arm-kernel@lists.infradead.org,
        Julien Thierry <Julien.Thierry@arm.com>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: Re: [PATCH v4.4 00/45] V4.4 backport of arm64 Spectre patches
Message-ID: <20190617121052.GA1456@kroah.com>
References: <cover.1560480942.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1560480942.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 14, 2019 at 08:37:43AM +0530, Viresh Kumar wrote:
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

Thanks for doing this work.

> @Julien: Can you please help reviewing / testing them ? Thanks.

Julien, I need yours, or someone from ARM to sign off on these patches
as working properly before I can accept them.

thanks,

greg k-h
