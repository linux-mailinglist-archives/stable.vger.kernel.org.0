Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC32733B1A3
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 12:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbhCOLoY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 07:44:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:51784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231225AbhCOLoQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 07:44:16 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDB6061601;
        Mon, 15 Mar 2021 11:44:15 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lLldu-001dwX-27; Mon, 15 Mar 2021 11:44:14 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 15 Mar 2021 11:44:13 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     kvmarm@lists.cs.columbia.edu, kernel-team@android.com,
        Eric Auger <eric.auger@redhat.com>, stable@vger.kernel.org,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH][stable-4.{4,9,14,19}] KVM: arm64: Fix exclusive limit for
 IPA size
In-Reply-To: <YE9FVw1PE9kClrdi@kroah.com>
References: <20210315110833.4135927-1-maz@kernel.org>
 <YE9FVw1PE9kClrdi@kroah.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <7ec2199ed2b2c8e6d881461398882751@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: gregkh@linuxfoundation.org, kvmarm@lists.cs.columbia.edu, kernel-team@android.com, eric.auger@redhat.com, stable@vger.kernel.org, drjones@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-03-15 11:30, Greg KH wrote:
> On Mon, Mar 15, 2021 at 11:08:33AM +0000, Marc Zyngier wrote:
>> Commit 262b003d059c6671601a19057e9fe1a5e7f23722 upstream.
>> 
>> When registering a memslot, we check the size and location of that
>> memslot against the IPA size to ensure that we can provide guest
>> access to the whole of the memory.
>> 
>> Unfortunately, this check rejects memslot that end-up at the exact
>> limit of the addressing capability for a given IPA size. For example,
>> it refuses the creation of a 2GB memslot at 0x8000000 with a 32bit
>> IPA space.
>> 
>> Fix it by relaxing the check to accept a memslot reaching the
>> limit of the IPA space.
>> 
>> Fixes: c3058d5da222 ("arm/arm64: KVM: Ensure memslots are within 
>> KVM_PHYS_SIZE")
>> Reviewed-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> Cc: stable@vger.kernel.org # 4.4, 4.9, 4.14, 4.19
>> Reviewed-by: Andrew Jones <drjones@redhat.com>
>> Link: 
>> https://lore.kernel.org/r/20210311100016.3830038-3-maz@kernel.org
>> ---
>>  virt/kvm/arm/mmu.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> This file does not exist in 4.4.y or 4.9.y, so I can't apply it there 
> :(

Ah, git rename handling fixed that up for me, and I didn't pay
attention to the resulting path... Sorry about that.

I'll resend the patch for 4.4 and 4.9

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
