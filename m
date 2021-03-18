Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF70A340632
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 13:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbhCRM5V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 08:57:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:55394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231288AbhCRM5C (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Mar 2021 08:57:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C892464E28;
        Thu, 18 Mar 2021 12:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616072222;
        bh=QM1fCH9+yvE1msPa2fUjwKePuiAxlHmW2l1xQy/WFqc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OPwlrSaIcEpUkAMbAGSntvmHL6qLaPXpOw/TEnMZApdmFurbtBjSqn3xeWfiQgWTy
         v1LXKWuKD7lUeFLThyxsXw6Sjke2/kkJ+ODDAFOi9kZtF+amXwVV87GJ6FSyTE499G
         lUbNeUcMYzltvYkwyYNkFHNaYhKO2lNgJ0kqiGAEJuRWNqK1SksqCzNvKtxA03Y0AB
         bHf2NxWjpIhPImyOqoQ8TPD6pJmHfwuP7WivR6QlrdMSkaxoCLisc9AS8tuCyB9Xwc
         Z/V8bG7nY0e8G3Wt+jy2UWw3eFay2xBBh5ChVCir1j+37kUiId/PWKupOHZSkv+zVZ
         0gn8tags78KSg==
Date:   Thu, 18 Mar 2021 08:57:00 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Will Deacon <will@kernel.org>
Cc:     Vladimir Murzin <vladimir.murzin@arm.com>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        catalin.marinas@arm.com, maz@kernel.org, dbrazdil@google.com
Subject: Re: [PATCH v2][for-stable-v5.11] arm64: Unconditionally set virtual
 cpu id registers
Message-ID: <YFNOHKX6V4dkwWIp@sashalap>
References: <20210316134319.89472-1-vladimir.murzin@arm.com>
 <20210317132614.GB5225@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210317132614.GB5225@willie-the-truck>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 17, 2021 at 01:26:15PM +0000, Will Deacon wrote:
>On Tue, Mar 16, 2021 at 01:43:19PM +0000, Vladimir Murzin wrote:
>> Commit 78869f0f0552 ("arm64: Extract parts of el2_setup into a macro")
>> reorganized el2 setup in such way that virtual cpu id registers set
>> only in nVHE, yet they used (and need) to be set irrespective VHE
>> support.
>>
>> Fixes: 78869f0f0552 ("arm64: Extract parts of el2_setup into a macro")
>> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
>> ---
>> Changelog
>>
>>   v1 -> v2
>>      - Drop the reference to 32bit guests from commit message (per Marc)
>>
>> There is no upstream fix since issue went away due to code there has
>> been reworked in 5.12: nVHE comes first, so virtual cpu id register
>> are always set.
>>
>> Maintainers, please, Ack.
>>
>>  arch/arm64/include/asm/el2_setup.h | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>
>Acked-by: Will Deacon <will@kernel.org>
>
>It's a bit weird to have a patch in stable that isn't upstream, but I don't
>see a better option here.

Yes, I'd agree here - the commits that would need to be backported look
way too invasive.

I've queued it up, thanks.

-- 
Thanks,
Sasha
