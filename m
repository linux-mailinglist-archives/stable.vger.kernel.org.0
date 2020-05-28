Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2341E5F25
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 14:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388602AbgE1L7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 07:59:38 -0400
Received: from foss.arm.com ([217.140.110.172]:51512 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388854AbgE1L7g (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 May 2020 07:59:36 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A4602D6E;
        Thu, 28 May 2020 04:59:35 -0700 (PDT)
Received: from [192.168.0.14] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D37283F6C4;
        Thu, 28 May 2020 04:59:34 -0700 (PDT)
Subject: Re: [PATCH 1/3] KVM: arm64: Stop writing aarch32's CSSELR into ACTLR
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        stable@vger.kernel.org
References: <20200526161834.29165-1-james.morse@arm.com>
 <20200526161834.29165-2-james.morse@arm.com>
 <4be0c0b654f7d7c1efe9f52efb856bd8@kernel.org>
From:   James Morse <james.morse@arm.com>
Message-ID: <09dca8e9-c548-43fd-a95b-747a77f19e02@arm.com>
Date:   Thu, 28 May 2020 12:59:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <4be0c0b654f7d7c1efe9f52efb856bd8@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Marc,

On 28/05/2020 09:57, Marc Zyngier wrote:
> On 2020-05-26 17:18, James Morse wrote:
>> access_csselr() uses the 32bit r->reg value to access the 64bit array,
>> so reads and write the wrong value. sys_regs[4], is ACTLR_EL1, which
>> is subsequently save/restored when we enter the guest.

>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 51db934702b6..2eda539f3281 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -2060,7 +2060,7 @@ static const struct sys_reg_desc cp15_regs[] = {
>>
>>      { Op1(1), CRn( 0), CRm( 0), Op2(0), access_ccsidr },
>>      { Op1(1), CRn( 0), CRm( 0), Op2(1), access_clidr },
>> -    { Op1(2), CRn( 0), CRm( 0), Op2(0), access_csselr, NULL, c0_CSSELR },
>> +    { Op1(2), CRn( 0), CRm( 0), Op2(0), access_csselr_el1, NULL, CSSELR_EL1 },
>>  };

> This is a departure from the way we deal with 32bit CP15 registers.
> We deal with this exact issue in a very different way for other
> CP15 regs, by adjusting the index in the sys_regs array (see the
> way we handle the VM regs).
> 
> How about something like this (untested):

[like access_vm_reg() does]

Sure, I'll give that a test and re-post it.


> Ideally, I'd like the core sys_reg code to deal with this sort
> of funnies, but I'm trying to keep the change minimal...

Roll this '/2' and upper/lower bits stuff into a vcpu_write_cp15_reg() that calls
vcpu_write_sys_reg()? (/me hunts out the todo list)


Thanks,

James
