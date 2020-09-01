Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDF5258DB6
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 13:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbgIALzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 07:55:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727962AbgIALyz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 07:54:55 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D712206FA;
        Tue,  1 Sep 2020 11:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598961289;
        bh=aHAuWJuf8BhyohJZ8xzi9pyGZ29N3vyPH5UuwrwdZTw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=r2LMNv2qHjtMdJAvfCl5+naFvKjEgd0eWtP9fcXgURlPTYOlLgqWKVkvnYnyIOIEk
         G3XA4Ec1nMUbbRfvz9gGkzlXaYKV8yE5Mbttg9Fl/LRmIAJv/RBJpVfrjXPkuP58nZ
         YNni8fmtwpKaFnAm/r9bx0HZ6uufBHNw5eEz1UE0=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kD4sB-008GKw-N4; Tue, 01 Sep 2020 12:54:47 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 01 Sep 2020 12:54:47 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     =?UTF-8?Q?Andr=C3=A9_Przywara?= <andre.przywara@arm.com>
Cc:     stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH stable v5.4 1/3] KVM: arm64: Add kvm_extable for
 vaxoricism code
In-Reply-To: <746764b0-7d63-b154-df02-7ca64a36ffcd@arm.com>
References: <20200901094923.52486-1-andre.przywara@arm.com>
 <20200901094923.52486-2-andre.przywara@arm.com>
 <79d6944d383945608b685a2d0f9d9b2c@kernel.org>
 <746764b0-7d63-b154-df02-7ca64a36ffcd@arm.com>
User-Agent: Roundcube Webmail/1.4.8
Message-ID: <ab5e986b5d405af3e0cbfc5681cad45f@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: andre.przywara@arm.com, stable@vger.kernel.org, james.morse@arm.com, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-09-01 12:17, André Przywara wrote:
> On 01/09/2020 12:12, Marc Zyngier wrote:
>> Hi Andre,
>> 
>> On 2020-09-01 10:49, Andre Przywara wrote:
>>> From: James Morse <james.morse@arm.com>
>>> 
>>> commit e9ee186bb735bfc17fa81dbc9aebf268aee5b41e upstream.
>>> 
>>> KVM has a one instruction window where it will allow an SError 
>>> exception
>>> to be consumed by the hypervisor without treating it as a hypervisor 
>>> bug.
>>> This is used to consume asynchronous external abort that were caused 
>>> by
>>> the guest.
>>> 
>>> As we are about to add another location that survives unexpected
>>> exceptions,
>>> generalise this code to make it behave like the host's extable.
>>> 
>>> KVM's version has to be mapped to EL2 to be accessible on nVHE 
>>> systems.
>>> 
>>> The SError vaxorcism code is a one instruction window, so has two 
>>> entries
>>> in the extable. Because the KVM code is copied for VHE and nVHE, we
>>> end up
>>> with four entries, half of which correspond with code that isn't 
>>> mapped.
>>> 
>>> Cc: <stable@vger.kernel.org> # 5.4.x
>>> Cc: Marc Zyngier <maz@kernel.org>
>>> Signed-off-by: James Morse <james.morse@arm.com>
>>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> 
>> Can you make sure these patches do carry the sign-off chain as we have
>> in mainline? In particular, this is missing:
>> 
>>     Reviewed-by: Marc Zyngier <maz@kernel.org>
>>     Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
>> 
>> You can add your own SoB after this.
> 
> Sure, I wasn't sure your review would apply to this version as well. I
> took the backports from James' kernel.org repo, where they were lacking
> any of those tags.
> So shall I copy all the tags from mainline to all backport versions? Or
> only to those where the changes were trivial? The backports to before
> 5.3 seem to be more involved.

My understanding is that the commit log should stay as close to the
original as possible, with potential additions to indicate deviations
from the upstream patch.

I'm happy to *add* another RB once I have reviewed the patch, just
like I add another SoB when I backport a patch on which I signed-off
the first place.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
