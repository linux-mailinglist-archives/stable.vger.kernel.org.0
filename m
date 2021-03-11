Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 175BC3370F1
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 12:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232518AbhCKLPP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 06:15:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58617 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232611AbhCKLPO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 06:15:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615461314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HLjJbWr4BucAiEq+UPFMlG+jYewhjm6x9TggCNo+wzk=;
        b=H/jvSlnxM8LY2jkmwL37jZv0AWchHhoffq6yZPlIHkM9SN4uNp/1zLXG3ebtLY0BOobPpJ
        tSjZdUlY/Qq2qEsf4lvu+M0Q3/WWK7NgINUbwFcL9TSVVBEpQus07Tb6QIS8n/DumuJCus
        2d/BVXfDcfVF41UQHa+9KziuVM7rwvQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-u3Nb2-jMM2qT9pMPrj0aJg-1; Thu, 11 Mar 2021 06:15:12 -0500
X-MC-Unique: u3Nb2-jMM2qT9pMPrj0aJg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 48E8118460E1;
        Thu, 11 Mar 2021 11:15:10 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.217])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4BDC950D38;
        Thu, 11 Mar 2021 11:15:03 +0000 (UTC)
Date:   Thu, 11 Mar 2021 12:15:00 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Eric Auger <eric.auger@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com, stable@vger.kernel.org
Subject: Re: [PATCH v3 2/2] KVM: arm64: Fix exclusive limit for IPA size
Message-ID: <20210311111500.uqy4lolxtp7t4xd4@kamzik.brq.redhat.com>
References: <20210311100016.3830038-1-maz@kernel.org>
 <20210311100016.3830038-3-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311100016.3830038-3-maz@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 11, 2021 at 10:00:16AM +0000, Marc Zyngier wrote:
> When registering a memslot, we check the size and location of that
> memslot against the IPA size to ensure that we can provide guest
> access to the whole of the memory.
> 
> Unfortunately, this check rejects memslot that end-up at the exact
> limit of the addressing capability for a given IPA size. For example,
> it refuses the creation of a 2GB memslot at 0x8000000 with a 32bit
> IPA space.
> 
> Fix it by relaxing the check to accept a memslot reaching the
> limit of the IPA space.
> 
> Fixes: e55cac5bf2a9 ("kvm: arm/arm64: Prepare for VM specific stage2 translations")

Isn't this actually fixing commit c3058d5da222 ("arm/arm64: KVM: Ensure
memslots are within KVM_PHYS_SIZE") ?

> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org
> ---
>  arch/arm64/kvm/mmu.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 77cb2d28f2a4..8711894db8c2 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1312,8 +1312,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>  	 * Prevent userspace from creating a memory region outside of the IPA
>  	 * space addressable by the KVM guest IPA space.
>  	 */
> -	if (memslot->base_gfn + memslot->npages >=
> -	    (kvm_phys_size(kvm) >> PAGE_SHIFT))
> +	if ((memslot->base_gfn + memslot->npages) > (kvm_phys_size(kvm) >> PAGE_SHIFT))
>  		return -EFAULT;
>  
>  	mmap_read_lock(current->mm);
> -- 
> 2.29.2
> 

Otherwise

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

