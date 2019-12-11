Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6C211BAEB
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 19:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730267AbfLKSCC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 13:02:02 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:59292 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729512AbfLKSCC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 13:02:02 -0500
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1if6JA-0000Td-Ug; Wed, 11 Dec 2019 19:01:56 +0100
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH 1/3] KVM: arm/arm64: Properly handle faulting of device  mappings
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 11 Dec 2019 18:01:56 +0000
From:   Marc Zyngier <maz@kernel.org>
Cc:     <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        <stable@vger.kernel.org>
In-Reply-To: <a8dbd580-ed09-8d46-6ec5-a54bac3a6695@arm.com>
References: <20191211165651.7889-1-maz@kernel.org>
 <20191211165651.7889-2-maz@kernel.org>
 <a8dbd580-ed09-8d46-6ec5-a54bac3a6695@arm.com>
Message-ID: <4b504f8d380e3587fab197921ab0c7e8@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, christoffer.dall@arm.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Alex,

On 2019-12-11 17:53, Alexandru Elisei wrote:
> Hi,
>
> On 12/11/19 4:56 PM, Marc Zyngier wrote:
>> A device mapping is normally always mapped at Stage-2, since there
>> is very little gain in having it faulted in.
>>
>> Nonetheless, it is possible to end-up in a situation where the 
>> device
>> mapping has been removed from Stage-2 (userspace munmaped the VFIO
>> region, and the MMU notifier did its job), but present in a 
>> userspace
>> mapping (userpace has mapped it back at the same address). In such
>> a situation, the device mapping will be demand-paged as the guest
>> performs memory accesses.
>>
>> This requires to be careful when dealing with mapping size, cache
>> management, and to handle potential execution of a device mapping.
>>
>> Cc: stable@vger.kernel.org
>> Reported-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  virt/kvm/arm/mmu.c | 21 +++++++++++++++++----
>>  1 file changed, 17 insertions(+), 4 deletions(-)

[...]

> I've tested this patch using the scenario that you described in the 
> commit
> message. I've also tested it with the following scenarios:
>
> - The region is mmap'ed as backed by a VFIO device fd and the memslot
> is created,
> it is munmap'ed, then mmap'ed as anonymous.
> - The region is mmap'ed as anonymous and the memslot is created, it
> is munmap'ed,
> then mmap'ed as backed by a VFIO device fd.
>
> Everything worked as expected, so:
>
> Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks for that!

> Just a nitpick, but stage2_set_pte has a local variable iomap which 
> can be
> replaced with a call to is_iomap.

Yeah, I noticed. I'm just trying to keep the patch relatively small so
that it can be easily backported. The cleanup can come later! ;-)

Cheers,

         M.
-- 
Jazz is not dead. It just smells funny...
