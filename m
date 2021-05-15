Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5C93818C4
	for <lists+stable@lfdr.de>; Sat, 15 May 2021 14:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhEOMjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 May 2021 08:39:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229939AbhEOMjF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 15 May 2021 08:39:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A5F261350;
        Sat, 15 May 2021 12:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621082272;
        bh=WWmIcDr+upD+zMR4OAwOdU85NgJDtBBZrripByMit1Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nySE0fBfryfKF+rshyLcMs7t/1v7b4R0V0KLXItzs4dRbgZ/otlNr2ilyptzWULHH
         VlJpTY1LxhSLRwxyuMpvG89ABDLRltUqFsLy9jvG4Pm/jsXjhuMvvMMzxG4nwoak4m
         M6wc5GcW4q9VBLTwW02Lxlts/xhpRWHcHh8BZFU2Q7EmIoW5PbXxbGkXCKRjCdPFV2
         9owMf+B94QI78NXNoI4yMbBgv+Uv5VO5df/hxEEbMTlpo/QJyVD4U6WkIfKIqZIU4u
         r7eSRgxH9KMvzXGODm2LVNKHHAtxWIga2KVNM2xRisCPc83ektRhMD9Sfma+z2H3dQ
         kyvoplcTlnoxg==
Date:   Sat, 15 May 2021 08:37:51 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     stable-commits@vger.kernel.org, stable <stable@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: Patch "arm64: entry: factor irq triage logic into macros" has
 been added to the 5.12-stable tree
Message-ID: <YJ/An4/uSrxeaqFp@sashalap>
References: <20210515021826.35E98613F2@mail.kernel.org>
 <87a6ow5lg2.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <87a6ow5lg2.wl-maz@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 15, 2021 at 11:40:45AM +0100, Marc Zyngier wrote:
>Hi Sasha,
>
>On Sat, 15 May 2021 03:18:25 +0100,
>Sasha Levin <sashal@kernel.org> wrote:
>>
>> This is a note to let you know that I've just added the patch titled
>>
>>     arm64: entry: factor irq triage logic into macros
>>
>> to the 5.12-stable tree which can be found at:
>>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>>
>> The filename of the patch is:
>>      arm64-entry-factor-irq-triage-logic-into-macros.patch
>> and it can be found in the queue-5.12 subdirectory.
>>
>> If you, or anyone else, feels it should not be added to the stable tree,
>> please let <stable@vger.kernel.org> know about it.
>>
>>
>>
>> commit ec301e4d131aad1648e28305c8d02ae8265a50d7
>> Author: Marc Zyngier <maz@kernel.org>
>> Date:   Mon Mar 15 11:56:27 2021 +0000
>>
>>     arm64: entry: factor irq triage logic into macros
>>
>>     [ Upstream commit 9eb563cdabe1d583c262042d5d44cc256f644543 ]
>>
>>     In subsequent patches we'll allow an FIQ handler to be registered, and
>>     FIQ exceptions will need to be triaged very similarly to IRQ exceptions.
>>     So that we can reuse the existing logic, this patch factors the IRQ
>>     triage logic out into macros that can be reused for FIQ.
>>
>>     The macros are named to follow the elX_foo_handler scheme used by the C
>>     exception handlers. For consistency with other top-level exception
>>     handlers, the kernel_entry/kernel_exit logic is not moved into the
>>     macros. As FIQ will use a different C handler, this handler name is
>>     provided as an argument to the macros.
>>
>>     There should be no functional change as a result of this patch.
>>
>>     Signed-off-by: Marc Zyngier <maz@kernel.org>
>>     [Mark: rework macros, commit message, rebase before DAIF rework]
>>     Signed-off-by: Mark Rutland <mark.rutland@arm.com>
>>     Tested-by: Hector Martin <marcan@marcan.st>
>>     Cc: James Morse <james.morse@arm.com>
>>     Cc: Thomas Gleixner <tglx@linutronix.de>
>>     Cc: Will Deacon <will@kernel.org>
>>     Acked-by: Will Deacon <will@kernel.org>
>>     Link: https://lore.kernel.org/r/20210315115629.57191-5-mark.rutland@arm.com
>>     Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
>>     Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>I don't think there is any reason for backporting this patch at this
>stage. It isn't a fix, and we don't plan to support the feature it
>subsequently enables in anything older than 5.13.
>
>Unless there is a another pressing reason for adding this patch, I
>suggest it is dropped from 5.10, 5.11 and 5.12 stable branches.

Actually, looks like I took it to make 4d6a38da8e79 ("arm64: entry:
always set GIC_PRIO_PSR_I_SET during entry") apply easier, does it make
sense to keep it in this scenario?

-- 
Thanks,
Sasha
