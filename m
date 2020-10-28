Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A782429DE84
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 01:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731744AbgJ1WSD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 18:18:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731778AbgJ1WRp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Oct 2020 18:17:45 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4C1A246A5;
        Wed, 28 Oct 2020 10:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603879432;
        bh=NQhHQntLZbnUoS/6yc85poCYnBYFJB0tEBEoFqmqy00=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Quj9xe/wOc2qoLkwpTkRu8kIGxN+5+Zi3TDhn8yy78/ocub3k4+QHI3CIO/oKpqZc
         32xw0NGlkrwLeWAN26hnncv/68VVX9pJZia/iMoSzI2FFq3yt0ckWHtrOg3exEjslz
         XRJ9TXyJAsjshRSW4E2cTqU9vM/gnKoz1cYTMsiQ=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kXiJ3-0053dT-NI; Wed, 28 Oct 2020 10:03:49 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 28 Oct 2020 10:03:49 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Will Deacon <will@kernel.org>
Cc:     Stephen Boyd <swboyd@chromium.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Andre Przywara <andre.przywara@arm.com>,
        Steven Price <steven.price@arm.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3] KVM: arm64: ARM_SMCCC_ARCH_WORKAROUND_1 doesn't return
 SMCCC_RET_NOT_REQUIRED
In-Reply-To: <20201026132533.GC24349@willie-the-truck>
References: <20201023154751.1973872-1-swboyd@chromium.org>
 <20201026132533.GC24349@willie-the-truck>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <5e9bded886e31f7c7aaee195e6c373e1@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: will@kernel.org, swboyd@chromium.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, andre.przywara@arm.com, steven.price@arm.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-10-26 13:25, Will Deacon wrote:
> On Fri, Oct 23, 2020 at 08:47:50AM -0700, Stephen Boyd wrote:
>> According to the SMCCC spec[1](7.5.2 Discovery) the
>> ARM_SMCCC_ARCH_WORKAROUND_1 function id only returns 0, 1, and
>> SMCCC_RET_NOT_SUPPORTED.
>> 
>>  0 is "workaround required and safe to call this function"
>>  1 is "workaround not required but safe to call this function"
>>  SMCCC_RET_NOT_SUPPORTED is "might be vulnerable or might not be, who 
>> knows, I give up!"
>> 
>> SMCCC_RET_NOT_SUPPORTED might as well mean "workaround required, 
>> except
>> calling this function may not work because it isn't implemented in 
>> some
>> cases". Wonderful. We map this SMC call to
>> 
>>  0 is SPECTRE_MITIGATED
>>  1 is SPECTRE_UNAFFECTED
>>  SMCCC_RET_NOT_SUPPORTED is SPECTRE_VULNERABLE
>> 
>> For KVM hypercalls (hvc), we've implemented this function id to return
>> SMCCC_RET_NOT_SUPPORTED, 0, and SMCCC_RET_NOT_REQUIRED. One of those
>> isn't supposed to be there. Per the code we call
>> arm64_get_spectre_v2_state() to figure out what to return for this
>> feature discovery call.
>> 
>>  0 is SPECTRE_MITIGATED
>>  SMCCC_RET_NOT_REQUIRED is SPECTRE_UNAFFECTED
>>  SMCCC_RET_NOT_SUPPORTED is SPECTRE_VULNERABLE
>> 
>> Let's clean this up so that KVM tells the guest this mapping:
>> 
>>  0 is SPECTRE_MITIGATED
>>  1 is SPECTRE_UNAFFECTED
>>  SMCCC_RET_NOT_SUPPORTED is SPECTRE_VULNERABLE
>> 
>> Note: SMCCC_RET_NOT_AFFECTED is 1 but isn't part of the SMCCC spec
>> 
>> Cc: Andre Przywara <andre.przywara@arm.com>
>> Cc: Steven Price <steven.price@arm.com>
>> Cc: Marc Zyngier <maz@kernel.org>
>> Cc: stable@vger.kernel.org
>> Link: https://developer.arm.com/documentation/den0028/latest [1]
>> Fixes: c118bbb52743 ("arm64: KVM: Propagate full Spectre v2 workaround 
>> state to KVM guests")
>> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
>> ---
>> 
>> I see that before commit c118bbb52743 ("arm64: KVM: Propagate full
>> Spectre v2 workaround state to KVM guests") we had this mapping:
>> 
>>  0 is SPECTRE_MITIGATED
>>  SMCCC_RET_NOT_SUPPORTED is SPECTRE_VULNERABLE
>> 
>> so the return value '1' wasn't there then. Once the commit was merged 
>> we
>> introduced the notion of NOT_REQUIRED here when it shouldn't have been
>> introduced.
>> 
>> Changes from v2:
>>  * Moved define to header file and used it
>> 
>> Changes from v1:
>>  * Way longer commit text, more background (sorry)
>>  * Dropped proton-pack part because it was wrong
>>  * Rebased onto other patch accepted upstream
>> 
>>  arch/arm64/kernel/proton-pack.c | 2 --
>>  arch/arm64/kvm/hypercalls.c     | 2 +-
>>  include/linux/arm-smccc.h       | 2 ++
>>  3 files changed, 3 insertions(+), 3 deletions(-)
>> 
>> diff --git a/arch/arm64/kernel/proton-pack.c 
>> b/arch/arm64/kernel/proton-pack.c
>> index 25f3c80b5ffe..c18eb7d41274 100644
>> --- a/arch/arm64/kernel/proton-pack.c
>> +++ b/arch/arm64/kernel/proton-pack.c
>> @@ -135,8 +135,6 @@ static enum mitigation_state 
>> spectre_v2_get_cpu_hw_mitigation_state(void)
>>  	return SPECTRE_VULNERABLE;
>>  }
>> 
>> -#define SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED	(1)
>> -
>>  static enum mitigation_state 
>> spectre_v2_get_cpu_fw_mitigation_state(void)
>>  {
>>  	int ret;
>> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
>> index 9824025ccc5c..25ea4ecb6449 100644
>> --- a/arch/arm64/kvm/hypercalls.c
>> +++ b/arch/arm64/kvm/hypercalls.c
>> @@ -31,7 +31,7 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>>  				val = SMCCC_RET_SUCCESS;
>>  				break;
>>  			case SPECTRE_UNAFFECTED:
>> -				val = SMCCC_RET_NOT_REQUIRED;
>> +				val = SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED;
>>  				break;
>>  			}
>>  			break;
>> diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
>> index 15c706fb0a37..0e50ba3e88d7 100644
>> --- a/include/linux/arm-smccc.h
>> +++ b/include/linux/arm-smccc.h
>> @@ -86,6 +86,8 @@
>>  			   ARM_SMCCC_SMC_32,				\
>>  			   0, 0x7fff)
>> 
>> +#define SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED	1
> 
> I thought we'd stick this in asm/spectre.h, but here is also good:
> 
> Acked-by: Will Deacon <will@kernel.org>

Acked-by: Marc Zyngier <maz@kernel.org>

Will, if you're about to send fixes to Linus, can you please pick
this one up?

         M.
-- 
Jazz is not dead. It just smells funny...
