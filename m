Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF8A5294B2C
	for <lists+stable@lfdr.de>; Wed, 21 Oct 2020 12:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392108AbgJUKXi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Oct 2020 06:23:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:54844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387407AbgJUKXi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Oct 2020 06:23:38 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B23E1206DD;
        Wed, 21 Oct 2020 10:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603275816;
        bh=Xi9n4FXEU/qsx25IaluF10B+ojNvuTfU294ietdilFo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oZ8V1oAYwFvzEMStVJVQ15nJ44sX/CdWz28rphoLCe2SNQSY9Ad4K3ZgXJTVv/JjL
         Bb69rLxpfkQaV7tG+X7+TrDnM3Y+zVOGSlVpLI/AuSnVbGAHj16LjtGy0l3yYspHUp
         srSqprpVozGNX39DAUHrpgenuNlvQUIL9jGVMoRk=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kVBHK-0030dg-Nj; Wed, 21 Oct 2020 11:23:34 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 21 Oct 2020 11:23:34 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Will Deacon <will@kernel.org>
Cc:     Stephen Boyd <swboyd@chromium.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Andre Przywara <andre.przywara@arm.com>,
        Steven Price <steven.price@arm.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] arm64: ARM_SMCCC_ARCH_WORKAROUND_1 doesn't return
 SMCCC_RET_NOT_REQUIRED
In-Reply-To: <20201021075722.GA17230@willie-the-truck>
References: <20201020214544.3206838-1-swboyd@chromium.org>
 <20201020214544.3206838-2-swboyd@chromium.org>
 <20201021075722.GA17230@willie-the-truck>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <c0591bdc2983167f00d002a731cba82e@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: will@kernel.org, swboyd@chromium.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, andre.przywara@arm.com, steven.price@arm.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-10-21 08:57, Will Deacon wrote:
> On Tue, Oct 20, 2020 at 02:45:43PM -0700, Stephen Boyd wrote:
>> According to the SMCCC spec (7.5.2 Discovery) the
>> ARM_SMCCC_ARCH_WORKAROUND_1 function id only returns 0, 1, and
>> SMCCC_RET_NOT_SUPPORTED corresponding to "workaround required",
>> "workaround not required but implemented", and "who knows, you're on
>> your own" respectively. For kvm hypercalls (hvc), we've implemented 
>> this
>> function id to return SMCCC_RET_NOT_SUPPORTED, 1, and
>> SMCCC_RET_NOT_REQUIRED. The SMCCC_RET_NOT_REQUIRED return value is not 
>> a
>> thing for this function id, and is probably copy/pasted from the
>> SMCCC_ARCH_WORKAROUND_2 function id that does support it.
>> 
>> Clean this up by returning 0, 1, and SMCCC_RET_NOT_SUPPORTED
>> appropriately. Changing this exposes the problem that
>> spectre_v2_get_cpu_fw_mitigation_state() assumes a
>> SMCCC_RET_NOT_SUPPORTED return value means we are vulnerable, but 
>> really
>> it means we have no idea and should assume we can't do anything about
>> mitigation. Put another way, it better be unaffected because it can't 
>> be
>> mitigated in the firmware (in this case kvm) as the call isn't
>> implemented!
>> 
>> Cc: Andre Przywara <andre.przywara@arm.com>
>> Cc: Steven Price <steven.price@arm.com>
>> Cc: Marc Zyngier <maz@kernel.org>
>> Cc: stable@vger.kernel.org
>> Fixes: c118bbb52743 ("arm64: KVM: Propagate full Spectre v2 workaround 
>> state to KVM guests")
>> Fixes: 73f381660959 ("arm64: Advertise mitigation of Spectre-v2, or 
>> lack thereof")
>> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
>> ---
>> 
>> This will require a slightly different backport to stable kernels, but
>> at least it looks like this is a problem given that this return value
>> isn't valid per the spec and we've been going around it by returning
>> something invalid for some time.
>> 
>>  arch/arm64/kernel/proton-pack.c | 3 +--
>>  arch/arm64/kvm/hypercalls.c     | 2 +-
>>  2 files changed, 2 insertions(+), 3 deletions(-)
>> 
>> diff --git a/arch/arm64/kernel/proton-pack.c 
>> b/arch/arm64/kernel/proton-pack.c
>> index 68b710f1b43f..00bd54f63f4f 100644
>> --- a/arch/arm64/kernel/proton-pack.c
>> +++ b/arch/arm64/kernel/proton-pack.c
>> @@ -149,10 +149,9 @@ static enum mitigation_state 
>> spectre_v2_get_cpu_fw_mitigation_state(void)
>>  	case SMCCC_RET_SUCCESS:
>>  		return SPECTRE_MITIGATED;
>>  	case SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED:
>> +	case SMCCC_RET_NOT_SUPPORTED: /* Good luck w/ the Gatekeeper of 
>> Gozer */
>>  		return SPECTRE_UNAFFECTED;
> 
> Hmm, I'm not sure this is correct. The SMCCC spec is terrifically
> unhelpful:
> 
>   NOT_SUPPORTED:
>   Either:
>   * None of the PEs in the system require firmware mitigation for 
> CVE-2017-5715.
>   * The system contains at least 1 PE affected by CVE-2017-5715 that
> has no firmware
>     mitigation available.
>   * The firmware does not provide any information about whether
> firmware mitigation is
>     required.
> 
> so we can't tell whether the thing is vulnerable or not in this case, 
> and
> have to assume that it is.
> 
>>  	default:
>> -		fallthrough;
>> -	case SMCCC_RET_NOT_SUPPORTED:
>>  		return SPECTRE_VULNERABLE;
>>  	}
>>  }
>> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
>> index 9824025ccc5c..868486957808 100644
>> --- a/arch/arm64/kvm/hypercalls.c
>> +++ b/arch/arm64/kvm/hypercalls.c
>> @@ -31,7 +31,7 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>>  				val = SMCCC_RET_SUCCESS;
>>  				break;
>>  			case SPECTRE_UNAFFECTED:
>> -				val = SMCCC_RET_NOT_REQUIRED;
>> +				val = SMCCC_RET_NOT_SUPPORTED;
> 
> Which means we need to return SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED 
> here, I
> suppose?

Gahh, I keep mixing Spectre-v2 and WA2. Not good. I *think* the patch
below is enough, but I need to give it a go...

         M.

diff --git a/arch/arm64/kernel/proton-pack.c 
b/arch/arm64/kernel/proton-pack.c
index 68b710f1b43f..3f417d6305ef 100644
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -134,8 +134,6 @@ static enum mitigation_state 
spectre_v2_get_cpu_hw_mitigation_state(void)
  	return SPECTRE_VULNERABLE;
  }

-#define SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED	(1)
-
  static enum mitigation_state 
spectre_v2_get_cpu_fw_mitigation_state(void)
  {
  	int ret;
@@ -148,7 +146,7 @@ static enum mitigation_state 
spectre_v2_get_cpu_fw_mitigation_state(void)
  	switch (ret) {
  	case SMCCC_RET_SUCCESS:
  		return SPECTRE_MITIGATED;
-	case SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED:
+	case SMCCC_RET_UNAFFECTED:
  		return SPECTRE_UNAFFECTED;
  	default:
  		fallthrough;
@@ -474,7 +472,7 @@ static enum mitigation_state 
spectre_v4_get_cpu_fw_mitigation_state(void)
  	switch (ret) {
  	case SMCCC_RET_SUCCESS:
  		return SPECTRE_MITIGATED;
-	case SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED:
+	case SMCCC_RET_UNAFFECTED:
  		fallthrough;
  	case SMCCC_RET_NOT_REQUIRED:
  		return SPECTRE_UNAFFECTED;
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 9824025ccc5c..792824de5d27 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -31,7 +31,7 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
  				val = SMCCC_RET_SUCCESS;
  				break;
  			case SPECTRE_UNAFFECTED:
-				val = SMCCC_RET_NOT_REQUIRED;
+				val = SMCCC_RET_UNAFFECTED;
  				break;
  			}
  			break;
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 885c9ffc835c..6b4902dde822 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -104,6 +104,7 @@
   * Return codes defined in ARM DEN 0070A
   * ARM DEN 0070A is now merged/consolidated into ARM DEN 0028 C
   */
+#define SMCCC_RET_UNAFFECTED			1
  #define SMCCC_RET_SUCCESS			0
  #define SMCCC_RET_NOT_SUPPORTED			-1
  #define SMCCC_RET_NOT_REQUIRED			-2

-- 
Jazz is not dead. It just smells funny...
