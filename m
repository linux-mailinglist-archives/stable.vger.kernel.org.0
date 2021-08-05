Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07D713E13CB
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 13:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240924AbhHELXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 07:23:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33833 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240808AbhHELXs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 07:23:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628162613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5Fd84Q4wmp1HHp9/8faQUi9ZHuuSm34D/5/TWDWrlNs=;
        b=WlUsJhauQRRfAeaJMZqcm4c+t1klPzC1wkh6S6LljzxJUkrwUzplqXy2l9vvtFt7wuK0r4
        Mjs51CUb8xNUpO75bHQx/e/rb01xBA2ZVMcnk0aKjAZhLondamFABaamJ7PnK4l1ORZiUO
        O6rVEUr0uXW6EBKflGg3/IXgcS9bp9w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-wixwhbkRN3qmj4jFdc4rcQ-1; Thu, 05 Aug 2021 07:23:32 -0400
X-MC-Unique: wixwhbkRN3qmj4jFdc4rcQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC9E291199;
        Thu,  5 Aug 2021 11:23:28 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F120D60E1C;
        Thu,  5 Aug 2021 11:23:20 +0000 (UTC)
Message-ID: <c7d6cd80f767791b67505bce005c7e73d94edda0.camel@redhat.com>
Subject: Re: [PATCH] selftests: KVM: avoid failures due to reserved
 HyperTransport region
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     stable@vger.kernel.org, David Matlack <dmatlack@google.com>
Date:   Thu, 05 Aug 2021 14:23:19 +0300
In-Reply-To: <20210805105423.412878-1-pbonzini@redhat.com>
References: <20210805105423.412878-1-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2021-08-05 at 06:54 -0400, Paolo Bonzini wrote:
> Accessing guest physical addresses at 0xFFFD_0000_0000 and above causes
> a failure on AMD processors because those addresses are reserved by
> HyperTransport (this is not documented).  Avoid selftests failures
> by reserving those guest physical addresses.
> 
> Fixes: ef4c9f4f6546 ("KVM: selftests: Fix 32-bit truncation of vm_get_max_gfn()")
> Cc: stable@vger.kernel.org
> Cc: David Matlack <dmatlack@google.com>
> Reported-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  tools/testing/selftests/kvm/lib/kvm_util.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 10a8ed691c66..d995cc9836ee 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -309,6 +309,12 @@ struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
>  	/* Limit physical addresses to PA-bits. */
>  	vm->max_gfn = ((1ULL << vm->pa_bits) >> vm->page_shift) - 1;
>  
> +#ifdef __x86_64__
> +	/* Avoid reserved HyperTransport region on AMD processors.  */
> +	if (vm->pa_bits == 48)
> +		vm->max_gfn = 0xfffcfffff;
> +#endif
> +
>  	/* Allocate and setup memory for guest. */
>  	vm->vpages_mapped = sparsebit_alloc();
>  	if (phy_pages != 0)

I probably would have restricted this workaround to AMD vendor string,
but I don't mind this to be like that as well at least for now.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

