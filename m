Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA1AF5FE033
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbiJMSFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbiJMSEp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:04:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393A816D8A8;
        Thu, 13 Oct 2022 11:04:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FD7261931;
        Thu, 13 Oct 2022 17:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CF41C433D6;
        Thu, 13 Oct 2022 17:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665683859;
        bh=EyyroCt/Oi7NB05fM0Tdh01bogd28QcQYT/jhBM2tZc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qh8KP1LpxDd9TUgJSMPcjhYu2RX2yN/EuWuwwhWNEpTQxVyYH2G29uKONQhNvZueu
         drL/zWdgT7Ah4yoolSji5CKEn/5dCf8tDuCOrtcUs93Me6bY260SjF0LSKSK8CaFgp
         hSjRv+YKhmTSLfqvrLYpmmDy3NYLKO4g/BoB0GncLTaLllRG/hzM6TXkNzHlzR8DyP
         2XV+rLUZM1CTE40Gsbn8hsFfz9dk/V2/3Q5yAAc4UrUymOi9RleMkTQLVRpywHz8RX
         0dVEt1ltUrK/okgw58W4AV5IyaQXLtpd1aXmTCRg1E1nha9No+URmzXCf0VpL5DZkN
         hntD4GirhZiZg==
Date:   Thu, 13 Oct 2022 13:57:38 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>, peterz@infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.19 17/40] arm64: atomics: remove LL/SC
 trampolines
Message-ID: <Y0hRkupzzH785cju@sashalap>
References: <20221011145129.1623487-1-sashal@kernel.org>
 <20221011145129.1623487-17-sashal@kernel.org>
 <Y0aAoQGH7lzqhv4F@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y0aAoQGH7lzqhv4F@arm.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 12, 2022 at 09:53:53AM +0100, Catalin Marinas wrote:
>Hi Sasha,
>
>On Tue, Oct 11, 2022 at 10:51:06AM -0400, Sasha Levin wrote:
>> From: Mark Rutland <mark.rutland@arm.com>
>>
>> [ Upstream commit b2c3ccbd0011bb3b51d0fec24cb3a5812b1ec8ea ]
>>
>> When CONFIG_ARM64_LSE_ATOMICS=y, each use of an LL/SC atomic results in
>> a fragment of code being generated in a subsection without a clear
>> association with its caller. A trampoline in the caller branches to the
>> LL/SC atomic with with a direct branch, and the atomic directly branches
>> back into its trampoline.
>>
>> This breaks backtracing, as any PC within the out-of-line fragment will
>> be symbolized as an offset from the nearest prior symbol (which may not
>> be the function using the atomic), and since the atomic returns with a
>> direct branch, the caller's PC may be missing from the backtrace.
>>
>> For example, with secondary_start_kernel() hacked to contain
>> atomic_inc(NULL), the resulting exception can be reported as being taken
>> from cpus_are_stuck_in_kernel():
>>
>> | Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
>> | Mem abort info:
>> |   ESR = 0x0000000096000004
>> |   EC = 0x25: DABT (current EL), IL = 32 bits
>> |   SET = 0, FnV = 0
>> |   EA = 0, S1PTW = 0
>> |   FSC = 0x04: level 0 translation fault
>> | Data abort info:
>> |   ISV = 0, ISS = 0x00000004
>> |   CM = 0, WnR = 0
>> | [0000000000000000] user address but active_mm is swapper
>> | Internal error: Oops: 96000004 [#1] PREEMPT SMP
>> | Modules linked in:
>> | CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.19.0-11219-geb555cb5b794-dirty #3
>> | Hardware name: linux,dummy-virt (DT)
>> | pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>> | pc : cpus_are_stuck_in_kernel+0xa4/0x120
>> | lr : secondary_start_kernel+0x164/0x170
>> | sp : ffff80000a4cbe90
>> | x29: ffff80000a4cbe90 x28: 0000000000000000 x27: 0000000000000000
>> | x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
>> | x23: 0000000000000000 x22: 0000000000000000 x21: 0000000000000000
>> | x20: 0000000000000001 x19: 0000000000000001 x18: 0000000000000008
>> | x17: 3030383832343030 x16: 3030303030307830 x15: ffff80000a4cbab0
>> | x14: 0000000000000001 x13: 5d31666130663133 x12: 3478305b20313030
>> | x11: 3030303030303078 x10: 3020726f73736563 x9 : 726f737365636f72
>> | x8 : ffff800009ff2ef0 x7 : 0000000000000003 x6 : 0000000000000000
>> | x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000100
>> | x2 : 0000000000000000 x1 : ffff0000029bd880 x0 : 0000000000000000
>> | Call trace:
>> |  cpus_are_stuck_in_kernel+0xa4/0x120
>> |  __secondary_switched+0xb0/0xb4
>> | Code: 35ffffa3 17fffc6c d53cd040 f9800011 (885f7c01)
>> | ---[ end trace 0000000000000000 ]---
>>
>> This is confusing and hinders debugging, and will be problematic for
>> CONFIG_LIVEPATCH as these cases cannot be unwound reliably.
>>
>> This is very similar to recent issues with out-of-line exception fixups,
>> which were removed in commits:
>>
>>   35d67794b8828333 ("arm64: lib: __arch_clear_user(): fold fixups into body")
>>   4012e0e22739eef9 ("arm64: lib: __arch_copy_from_user(): fold fixups into body")
>>   139f9ab73d60cf76 ("arm64: lib: __arch_copy_to_user(): fold fixups into body")
>>
>> When the trampolines were introduced in commit:
>>
>>   addfc38672c73efd ("arm64: atomics: avoid out-of-line ll/sc atomics")
>>
>> The rationale was to improve icache performance by grouping the LL/SC
>> atomics together. This has never been measured, and this theoretical
>> benefit is outweighed by other factors:
>>
>> * As the subsections are collapsed into sections at object file
>>   granularity, these are spread out throughout the kernel and can share
>>   cachelines with unrelated code regardless.
>>
>> * GCC 12.1.0 has been observed to place the trampoline out-of-line in
>>   specialised __ll_sc_*() functions, introducing more branching than was
>>   intended.
>>
>> * Removing the trampolines has been observed to shrink a defconfig
>>   kernel Image by 64KiB when building with GCC 12.1.0.
>>
>> This patch removes the LL/SC trampolines, meaning that the LL/SC atomics
>> will be inlined into their callers (or placed in out-of line functions
>> using regular BL/RET pairs). When CONFIG_ARM64_LSE_ATOMICS=y, the LL/SC
>> atomics are always called in an unlikely branch, and will be placed in a
>> cold portion of the function, so this should have minimal impact to the
>> hot paths.
>>
>> Other than the improved backtracing, there should be no functional
>> change as a result of this patch.
>>
>> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
>> Cc: Will Deacon <will@kernel.org>
>> Link: https://lore.kernel.org/r/20220817155914.3975112-2-mark.rutland@arm.com
>> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>I don't think we should back-port this. There is no functional change,
>more of a clean-up in preparation for RELIABLE_STACKTRACE. The oops
>message in the log is to show how reporting works rather than a real
>bug.

I went by the "This breaks backtracing" line when backporting :)

I'll drop it, thanks!

-- 
Thanks,
Sasha
