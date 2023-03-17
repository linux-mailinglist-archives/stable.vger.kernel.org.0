Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5D96BE4D6
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 10:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbjCQJFh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 05:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231993AbjCQJFQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 05:05:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7326310DE47;
        Fri, 17 Mar 2023 02:03:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF559B82546;
        Fri, 17 Mar 2023 09:03:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E38C433D2;
        Fri, 17 Mar 2023 09:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679043832;
        bh=RrbCxRQbeYh+QHF+SQ74FvWDUfJeosjdXICD/8hIBR0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LkYEb5vLxw9Pnphh2sN+xstLaO1E8fOa8cuAwYfKL+3NIAbTObJvfmjcAmjQxqsLv
         CpvtLKj8vbYdaViupwyXxgujt12LuBAPg5UqqBCDENNXHSy39O1FUnYM+OLdAzckNm
         dL1a/HcC1vCJMyVbsfN3z++Kq23lYYBA/pR2M3DYLYD7O7Sl9T7YF0tkODYBkzj3N1
         1Opcm/BJ6MIvr7POaOJkskIrG3uo7r0W9kCN9PQ/o7kvOYvORZh/ow5aiFWGhvh5UW
         /14GSRz/beCTNJqYdPSe5m6GCrz7lERRSVF8HdtSpfEIdD/w5azEMBJfQC/7XW4nOh
         szugRJkAY8v3A==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pd606-000tA9-51;
        Fri, 17 Mar 2023 09:03:50 +0000
MIME-Version: 1.0
Date:   Fri, 17 Mar 2023 09:03:50 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] KVM: arm64: Disable interrupts while walking
 userspace PTs
In-Reply-To: <ZBOpVLEPEJazjyGD@linux.dev>
References: <20230316174546.3777507-1-maz@kernel.org>
 <20230316174546.3777507-2-maz@kernel.org> <ZBOpVLEPEJazjyGD@linux.dev>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <760caa64691576b728c224bbbfdd18a4@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, ardb@kernel.org, will@kernel.org, qperret@google.com, seanjc@google.com, dmatlack@google.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023-03-16 23:42, Oliver Upton wrote:
> Marc,
> 
> On Thu, Mar 16, 2023 at 05:45:45PM +0000, Marc Zyngier wrote:
>> We walk the userspace PTs to discover what mapping size was
>> used there. However, this can race against the userspace tables
>> being freed, and we end-up in the weeds.
>> 
>> Thankfully, the mm code is being generous and will IPI us when
>> doing so. So let's implement our part of the bargain and disable
>> interrupts around the walk. This ensures that nothing terrible
>> happens during that time.
>> 
>> We still need to handle the removal of the page tables before
>> the walk. For that, allow get_user_mapping_size() to return an
>> error, and make sure this error can be propagated all the way
>> to the the exit handler.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> Cc: stable@vger.kernel.org
> 
> Looks good. I've squashed in this meaningless diff to make use of an 
> existing
> helper.
> 
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index e95593736ae3..3b9d4d24c361 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -691,7 +691,7 @@ static int get_user_mapping_size(struct kvm *kvm, 
> u64 addr)
>  		return -EFAULT;
> 
>  	/* Oops, the userspace PTs are gone... Replay the fault */
> -	if (!(pte & PTE_VALID))
> +	if (!kvm_pte_valid(pte))
>  		return -EAGAIN;

Sure, LGTM.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
