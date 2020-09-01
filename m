Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF1352591BA
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 16:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgIALZZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 07:25:25 -0400
Received: from foss.arm.com ([217.140.110.172]:40632 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726326AbgIALZS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 07:25:18 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 76C531FB;
        Tue,  1 Sep 2020 04:18:13 -0700 (PDT)
Received: from [192.168.2.22] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D9A073F68F;
        Tue,  1 Sep 2020 04:18:12 -0700 (PDT)
Subject: Re: [PATCH stable v5.4 1/3] KVM: arm64: Add kvm_extable for
 vaxoricism code
To:     Marc Zyngier <maz@kernel.org>
Cc:     stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
References: <20200901094923.52486-1-andre.przywara@arm.com>
 <20200901094923.52486-2-andre.przywara@arm.com>
 <79d6944d383945608b685a2d0f9d9b2c@kernel.org>
From:   =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Organization: ARM Ltd.
Message-ID: <746764b0-7d63-b154-df02-7ca64a36ffcd@arm.com>
Date:   Tue, 1 Sep 2020 12:17:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <79d6944d383945608b685a2d0f9d9b2c@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01/09/2020 12:12, Marc Zyngier wrote:
> Hi Andre,
> 
> On 2020-09-01 10:49, Andre Przywara wrote:
>> From: James Morse <james.morse@arm.com>
>>
>> commit e9ee186bb735bfc17fa81dbc9aebf268aee5b41e upstream.
>>
>> KVM has a one instruction window where it will allow an SError exception
>> to be consumed by the hypervisor without treating it as a hypervisor bug.
>> This is used to consume asynchronous external abort that were caused by
>> the guest.
>>
>> As we are about to add another location that survives unexpected
>> exceptions,
>> generalise this code to make it behave like the host's extable.
>>
>> KVM's version has to be mapped to EL2 to be accessible on nVHE systems.
>>
>> The SError vaxorcism code is a one instruction window, so has two entries
>> in the extable. Because the KVM code is copied for VHE and nVHE, we
>> end up
>> with four entries, half of which correspond with code that isn't mapped.
>>
>> Cc: <stable@vger.kernel.org> # 5.4.x
>> Cc: Marc Zyngier <maz@kernel.org>
>> Signed-off-by: James Morse <james.morse@arm.com>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> 
> Can you make sure these patches do carry the sign-off chain as we have
> in mainline? In particular, this is missing:
> 
>     Reviewed-by: Marc Zyngier <maz@kernel.org>
>     Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> You can add your own SoB after this.

Sure, I wasn't sure your review would apply to this version as well. I
took the backports from James' kernel.org repo, where they were lacking
any of those tags.
So shall I copy all the tags from mainline to all backport versions? Or
only to those where the changes were trivial? The backports to before
5.3 seem to be more involved.

Cheers,
Andre.
