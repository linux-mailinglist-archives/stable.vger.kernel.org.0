Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B4F1F3A12
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 13:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgFILss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 07:48:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726395AbgFILso (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 07:48:44 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E6B52068D;
        Tue,  9 Jun 2020 11:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591703323;
        bh=jZQ4Zg8DwzAMUN+GXuZsfRY/XUjTHIpyRTgWTNdxQ6U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SJHtmjskzqroQWd1r6br+wTjNT4XT/FqsM/GKHQWDyjLzIrRFrVhmW0IDafmtC9Ww
         ehsbYKYgQVtTV/FweObun9JuYyHm7puwcbAMPh7GDgA5ur6YqoQ/+obEdfwg0sVJbn
         EaYlTyWJUdF7g4ky+Jz8KNOfDDuKxchuhUyVaMQk=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jickD-001ROy-Pv; Tue, 09 Jun 2020 12:48:41 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 09 Jun 2020 12:48:41 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        James Morse <james.morse@arm.com>, stable@vger.kernel.org,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH 1/2] KVM: arm64: Make vcpu_cp1x() work on Big Endian hosts
In-Reply-To: <7c173265-3f8e-51df-d700-7e3658a0e4d8@arm.com>
References: <20200609084921.1448445-1-maz@kernel.org>
 <20200609084921.1448445-2-maz@kernel.org>
 <7c173265-3f8e-51df-d700-7e3658a0e4d8@arm.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <7451e64c22d8432f998458e0343aee7f@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: robin.murphy@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kernel-team@android.com, james.morse@arm.com, stable@vger.kernel.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Robin,

On 2020-06-09 12:41, Robin Murphy wrote:
> On 2020-06-09 09:49, Marc Zyngier wrote:
>> AArch32 CP1x registers are overlayed on their AArch64 counterparts
>> in the vcpu struct. This leads to an interesting problem as they
>> are stored in their CPU-local format, and thus a CP1x register
>> doesn't "hit" the lower 32bit portion of the AArch64 register on
>> a BE host.
>> 
>> To workaround this unfortunate situation, introduce a bias trick
>> in the vcpu_cp1x() accessors which picks the correct half of the
>> 64bit register.
>> 
>> Cc: stable@vger.kernel.org
>> Reported-by: James Morse <james.morse@arm.com>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>   arch/arm64/include/asm/kvm_host.h | 10 ++++++++--
>>   1 file changed, 8 insertions(+), 2 deletions(-)
>> 
>> diff --git a/arch/arm64/include/asm/kvm_host.h 
>> b/arch/arm64/include/asm/kvm_host.h
>> index 59029e90b557..e80c0e06f235 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -404,8 +404,14 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, 
>> u64 val, int reg);
>>    * CP14 and CP15 live in the same array, as they are backed by the
>>    * same system registers.
>>    */
>> -#define vcpu_cp14(v,r)		((v)->arch.ctxt.copro[(r)])
>> -#define vcpu_cp15(v,r)		((v)->arch.ctxt.copro[(r)])
>> +#ifdef CPU_BIG_ENDIAN
> 
> Ahem... I think you're missing a "CONFIG_" there ;)

Duh! As I said, I didn't test the thing at all! ;-)

> Bonus trickery - for a 0 or 1 value you can simply use IS_ENABLED().

Beautiful! Definitely a must! :D

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
