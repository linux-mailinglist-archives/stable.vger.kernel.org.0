Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71EE51E6071
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 14:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388686AbgE1MK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 08:10:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:33144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389705AbgE1MKZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 May 2020 08:10:25 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A250C2063A;
        Thu, 28 May 2020 12:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590667824;
        bh=d+BX6Yu8bblCkc+YNytpyy6IyNc3spMni5yB2tDpCBo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ht9aeBKOOs2qT1O/Jvk9zPAOcwXArR2X6BqtFlTRNkhygdQL6r7LWzmyaWb1t3W8h
         UqL6mOfc0/m5+zw2y/OBxfwIasqR7K5PEpKjOHGYp4+m2sY25Oc9jSCCDK8KjpZOvF
         ib1gW6SFhgUu7PfBzWBFDbczaL8jB4B44mtPq0fU=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jeHMd-00Fyr7-3o; Thu, 28 May 2020 13:10:23 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Thu, 28 May 2020 13:10:23 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     James Morse <james.morse@arm.com>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: arm64: Stop writing aarch32's CSSELR into ACTLR
In-Reply-To: <09dca8e9-c548-43fd-a95b-747a77f19e02@arm.com>
References: <20200526161834.29165-1-james.morse@arm.com>
 <20200526161834.29165-2-james.morse@arm.com>
 <4be0c0b654f7d7c1efe9f52efb856bd8@kernel.org>
 <09dca8e9-c548-43fd-a95b-747a77f19e02@arm.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <705687e37c5d5339a6baafa9e31675cb@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: james.morse@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-05-28 12:59, James Morse wrote:
> Hi Marc,
> 
> On 28/05/2020 09:57, Marc Zyngier wrote:
>> On 2020-05-26 17:18, James Morse wrote:
>>> access_csselr() uses the 32bit r->reg value to access the 64bit 
>>> array,
>>> so reads and write the wrong value. sys_regs[4], is ACTLR_EL1, which
>>> is subsequently save/restored when we enter the guest.
> 
>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>> index 51db934702b6..2eda539f3281 100644
>>> --- a/arch/arm64/kvm/sys_regs.c
>>> +++ b/arch/arm64/kvm/sys_regs.c
>>> @@ -2060,7 +2060,7 @@ static const struct sys_reg_desc cp15_regs[] = 
>>> {
>>> 
>>>      { Op1(1), CRn( 0), CRm( 0), Op2(0), access_ccsidr },
>>>      { Op1(1), CRn( 0), CRm( 0), Op2(1), access_clidr },
>>> -    { Op1(2), CRn( 0), CRm( 0), Op2(0), access_csselr, NULL, 
>>> c0_CSSELR },
>>> +    { Op1(2), CRn( 0), CRm( 0), Op2(0), access_csselr_el1, NULL, 
>>> CSSELR_EL1 },
>>>  };
> 
>> This is a departure from the way we deal with 32bit CP15 registers.
>> We deal with this exact issue in a very different way for other
>> CP15 regs, by adjusting the index in the sys_regs array (see the
>> way we handle the VM regs).
>> 
>> How about something like this (untested):
> 
> [like access_vm_reg() does]
> 
> Sure, I'll give that a test and re-post it.

Thanks!

> 
> 
>> Ideally, I'd like the core sys_reg code to deal with this sort
>> of funnies, but I'm trying to keep the change minimal...
> 
> Roll this '/2' and upper/lower bits stuff into a vcpu_write_cp15_reg()
> that calls
> vcpu_write_sys_reg()? (/me hunts out the todo list)

I was thinking of hiding it differently: in emulate_cp, substitute the
sys_reg_desc structure for a temporary one that represents the 64bit
version, and make it completely transparent.

I'm sure there is a couple of nits around that though...

         M.
-- 
Jazz is not dead. It just smells funny...
