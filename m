Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC09137ED9F
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 00:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387855AbhELUkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 16:40:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:56298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1376693AbhELT1Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 15:27:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 783D3613F7;
        Wed, 12 May 2021 19:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620847566;
        bh=cpcLCEh07MPFgU7nC0SnvS+k674aBQRE/mdbKfiBHi0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fSItDh3kg9vohG+wOu8+YgwLSSy+onkW9xDYg4ZOVM68khqkeexpZkFjlEQN85aGc
         AwUbrfBgEZ11mqCUKlDXfkZ8k5OBiUPDIDcBAxj2EPFC/K2TggS7CsIel3fNdXJd6r
         w1O/TQqVQDmJ7nhyupTbcskn52vyJ6EaruHeXQeiVKVQubeFvtQjs9mtlaLHs6dV7W
         3EUYEf39mI8nrWRmbcN1RR1q1qKbxVeTLRXkYE54U2/PTwNBr7u6faP/G9qXWbfhRS
         KDT+MgyJF9p4i5nfbTMKNtsi6C2I8+2L/lHYF3LkxdleTEQX0a/Jf1VA2Qol1xcmD3
         R8oUwm/HoOB0Q==
Date:   Wed, 12 May 2021 15:26:05 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Message-ID: <YJwrzVNYg43MrA8V@sashalap>
References: <20210512144743.039977287@linuxfoundation.org>
 <CA+G9fYs1AH8ZNWMJ=H4TY5C6bqp--=SZfW9P=WbB85qSBDkuXw@mail.gmail.com>
 <b7df0d7f-e582-6a0d-2385-b9fce50f9106@arm.com>
 <87h7j7opg2.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87h7j7opg2.wl-maz@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 12, 2021 at 06:02:37PM +0100, Marc Zyngier wrote:
>On Wed, 12 May 2021 18:00:16 +0100,
>Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>> I made this change to get it to build:
>>
>> $ git diff
>> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
>> index dd03d5e01a94..32564b017ba0 100644
>> --- a/arch/arm/include/asm/kvm_host.h
>> +++ b/arch/arm/include/asm/kvm_host.h
>> @@ -335,6 +335,7 @@ static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu,
>> int cpu) {}
>>  static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
>>  
>>  static inline void kvm_arm_init_debug(void) {}
>> +static inline void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu) {}
>>  static inline void kvm_arm_setup_debug(struct kvm_vcpu *vcpu) {}
>>  static inline void kvm_arm_clear_debug(struct kvm_vcpu *vcpu) {}
>>  static inline void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu) {}
>>
>> which matches the stub for kvm_arm_init_debug(). I can spin a patch
>> out of it and send it for 5.4 and 4.19. Marc, what do you think?
>
>Ideally, we'd drop the patch in its current form from 5.4 and 4.19,
>and send an updated patch with this hunk to fix the 32bit build.

Yes please. I've dropped it from 5.4 and 4.19 and we can queue up a
fixed backport for the next round of releases.

-- 
Thanks,
Sasha
