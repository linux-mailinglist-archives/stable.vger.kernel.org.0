Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4588933920B
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 16:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232502AbhCLPpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 10:45:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:59146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232665AbhCLPol (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 10:44:41 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF86864FDC;
        Fri, 12 Mar 2021 15:44:40 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lKjxu-001Fuj-NY; Fri, 12 Mar 2021 15:44:38 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 12 Mar 2021 15:44:38 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Andrew Jones <drjones@redhat.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Eric Auger <eric.auger@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com, stable@vger.kernel.org
Subject: Re: [PATCH v3 2/2] KVM: arm64: Fix exclusive limit for IPA size
In-Reply-To: <20210311111500.uqy4lolxtp7t4xd4@kamzik.brq.redhat.com>
References: <20210311100016.3830038-1-maz@kernel.org>
 <20210311100016.3830038-3-maz@kernel.org>
 <20210311111500.uqy4lolxtp7t4xd4@kamzik.brq.redhat.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <7ce8f57d2bcc19a77993fc01845ac6cb@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: drjones@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, will@kernel.org, eric.auger@redhat.com, alexandru.elisei@arm.com, kernel-team@android.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-03-11 11:15, Andrew Jones wrote:
> On Thu, Mar 11, 2021 at 10:00:16AM +0000, Marc Zyngier wrote:
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
>> Fixes: e55cac5bf2a9 ("kvm: arm/arm64: Prepare for VM specific stage2 
>> translations")
> 
> Isn't this actually fixing commit c3058d5da222 ("arm/arm64: KVM: Ensure
> memslots are within KVM_PHYS_SIZE") ?

Ah, yes, that's indeed better (more backport work... ;-)

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
