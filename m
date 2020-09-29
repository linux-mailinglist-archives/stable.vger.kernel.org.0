Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A76427BE1A
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 09:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725554AbgI2Hgz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 03:36:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:48208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725320AbgI2Hgz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 03:36:55 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C5C520848;
        Tue, 29 Sep 2020 07:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601365014;
        bh=f5CqFW+R9qy/pBbeH0e8BFE609xxVosyBEUc6Bd7c88=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zxJvRsCcT6dW9w5T+RRV/Rb1C03bvT1FnEV1t35QX5IiUQA6G18yDRyXVwcdJXAfJ
         d7jdTSAgI0bs2NQsOReA3T4MBPw+UlDKreUpH8EkSGUvCbfcJxCzkRd3te1XAr6fVk
         Aj1ZluN4R1M+R9OFWYdnPG4NZFkVitZ7eb76zgwo=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kNABw-00FhuX-Ht; Tue, 29 Sep 2020 08:36:52 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 29 Sep 2020 08:36:52 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        linux- stable <stable@vger.kernel.org>,
        Will Deacon <will@kernel.org>, kernel-team@android.com,
        lkft-triage@lists.linaro.org
Subject: Re: [PATCH stable-5.8] KVM: arm64: Assume write fault on S1PTW
 permission fault on instruction fetch
In-Reply-To: <20200929070118.GE2439787@kroah.com>
References: <20200928171850.618223-1-maz@kernel.org>
 <20200928174629.GA2118806@kroah.com>
 <CA+G9fYs5DpC7fq6Ukqs6iS4wEOz2+g5zwgup3B5JPnE52_fvYA@mail.gmail.com>
 <20200929070118.GE2439787@kroah.com>
User-Agent: Roundcube Webmail/1.4.8
Message-ID: <9dd777f363c16884daf5bf74a7d6045a@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: gregkh@linuxfoundation.org, naresh.kamboju@linaro.org, stable@vger.kernel.org, will@kernel.org, kernel-team@android.com, lkft-triage@lists.linaro.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-09-29 08:01, Greg KH wrote:
> On Tue, Sep 29, 2020 at 01:16:34AM +0530, Naresh Kamboju wrote:
>> On Mon, 28 Sep 2020 at 23:16, Greg KH <gregkh@linuxfoundation.org> 
>> wrote:
>> >
>> > On Mon, Sep 28, 2020 at 06:18:50PM +0100, Marc Zyngier wrote:
>> > > Commit c4ad98e4b72cb5be30ea282fce935248f2300e62 upstream.
>> > >
>> > > KVM currently assumes that an instruction abort can never be a write.
>> > > This is in general true, except when the abort is triggered by
>> > > a S1PTW on instruction fetch that tries to update the S1 page tables
>> > > (to set AF, for example).
>> > >
>> > > This can happen if the page tables have been paged out and brought
>> > > back in without seeing a direct write to them (they are thus marked
>> > > read only), and the fault handling code will make the PT executable(!)
>> > > instead of writable. The guest gets stuck forever.
>> > >
>> > > In these conditions, the permission fault must be considered as
>> > > a write so that the Stage-1 update can take place. This is essentially
>> > > the I-side equivalent of the problem fixed by 60e21a0ef54c ("arm64: KVM:
>> > > Take S1 walks into account when determining S2 write faults").
>> > >
>> > > Update kvm_is_write_fault() to return true on IABT+S1PTW, and introduce
>> > > kvm_vcpu_trap_is_exec_fault() that only return true when no faulting
>> > > on a S1 fault. Additionally, kvm_vcpu_dabt_iss1tw() is renamed to
>> > > kvm_vcpu_abt_iss1tw(), as the above makes it plain that it isn't
>> > > specific to data abort.
>> > >
>> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
>> > > Reviewed-by: Will Deacon <will@kernel.org>
>> > > Cc: stable@vger.kernel.org
>> > > Link: https://lore.kernel.org/r/20200915104218.1284701-2-maz@kernel.org
>> >
>> > Thanks for all 3 of these, now queued up!
>> 
>> stable rc branch 4.19 arm64 build broken.
>> 
>> ../arch/arm64/kvm/../../../virt/kvm/arm/mmu.c:1283:13: error:
>> redefinition of ‘kvm_is_write_fault’
>>  1283 | static bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
>>       |             ^~~~~~~~~~~~~~~~~~
>> 
>> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> 
> Thanks, I'll go drop this patch from the 4.19.y queue and wait for a
> fixed up version from Marc.

Right. I have no idea what I tested yesterday, but clearly this didn't
stand a chance to even compile on arm64... :-( Funnily enough, 32bit ARM
(which nobody cares about when it comes to KVM) was just fine. Bah.

Apologies for the noise, v2 coming once I have had my second coffee...

         M.
-- 
Jazz is not dead. It just smells funny...
