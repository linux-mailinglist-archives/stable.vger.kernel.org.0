Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D95373066DF
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 22:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231828AbhA0Vzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 16:55:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234162AbhA0VzU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jan 2021 16:55:20 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92CDC06174A
        for <stable@vger.kernel.org>; Wed, 27 Jan 2021 13:54:39 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id g15so2386676pjd.2
        for <stable@vger.kernel.org>; Wed, 27 Jan 2021 13:54:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QhoJaXcBLO+tF0usfswt07f3dqsQi5Fzviu82scMC4E=;
        b=Rc37eSOr2aNYJTUX0COdY4fMePBOXDX6j5spA7p2EF6kxytSBvfl53Ev63GQsuD9jy
         l3mo3Qtn9Ir8tAB6rHXWh3MXYO10/wVHmekmCjF5oarpaPqwoI/LkcSqZlpJEZZR929e
         TZatZqjvzDmDQmcpatwCwmZ5dyA/jhL8vREJBKV3VE0v7jeoAtt2Ufz4d5vzyKxEU/pX
         NKMQKXA25b6WVsk7oI4+UVt4ijkTSiLR7oo6U/3cvnE6TzYaCoePXLKcCjiJLe+8e5kz
         kc0MLqp/f6ZgCPB+VdPZQA0gQRGJM+F08hKL77eYoqvhuQrn4MH3xR0oSBs2GWoIX+On
         HVrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QhoJaXcBLO+tF0usfswt07f3dqsQi5Fzviu82scMC4E=;
        b=XGFraNuZ6hlWZWpnmNeIf74T7RPIHbsy7SNHuBk1wnLgMUO7tZKU/9tP+MK3VgSHZM
         4xN9lpny+6qq0E4AClHudMhKbpJWaWWNtJw/ar06JCjdpF6WngRMmZ8h6zu8seqhoWCJ
         3MQbIj3FpLZsZQFDHyy3JdzB50E3xqZmz15DIqOHQPh2mbiVgNpvysXjr0OKJk4SbPxT
         TAk7b/znhCEMTd3i+uPeoR9o6PRovpi4jg+/bMQGg56eNTLxDbaAaqBqd+gpIs6iY5gj
         aeLWKuJTk3/5sCiTOuUPRHvVO7195vcF2pT7TXobq9WDLqwhLm54O1GB5qi9JqxgIcEV
         TR9w==
X-Gm-Message-State: AOAM530LK71FeGK3BM2emwDu+U7lyRnWJabvAjD+/0UO8hy+WWYvAiO2
        //RICXCh6uL3Ok4lsSgSvCZxyg==
X-Google-Smtp-Source: ABdhPJwLgzAVkx35Svk8ZRpuTj/a+g+Xoe2lGgzYVsUXm+iPuGDqiM9lglEoZGceFzE9yUs285TPzA==
X-Received: by 2002:a17:90a:a483:: with SMTP id z3mr8085808pjp.140.1611784479079;
        Wed, 27 Jan 2021 13:54:39 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id q12sm3431952pgj.24.2021.01.27.13.54.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 13:54:38 -0800 (PST)
Date:   Wed, 27 Jan 2021 13:54:31 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>, x86@kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] Fix unsynchronized access to sev members through
 svm_register_enc_region
Message-ID: <YBHhF8ktuMfivQEP@google.com>
References: <20210127161524.2832400-1-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210127161524.2832400-1-pgonda@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 27, 2021, Peter Gonda wrote:
> Grab kvm->lock before pinning memory when registering an encrypted
> region; sev_pin_memory() relies on kvm->lock being held to ensure
> correctness when checking and updating the number of pinned pages.
> 
> Add a lockdep assertion to help prevent future regressions.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: x86@kernel.org
> Cc: kvm@vger.kernel.org
> Cc: stable@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Fixes: 1e80fdc09d12 ("KVM: SVM: Pin guest memory when SEV is active")
> Signed-off-by: Peter Gonda <pgonda@google.com>
> 
> V2
>  - Fix up patch description
>  - Correct file paths svm.c -> sev.c
>  - Add unlock of kvm->lock on sev_pin_memory error
> 
> V1
>  - https://lore.kernel.org/kvm/20210126185431.1824530-1-pgonda@google.com/

Put version info, and anything else that shouldn't be in the final commit, below
the three dashes.  AFAIK that requires manually editing the patch file before
sending it.

> 
> ---

Version info goes here.

>  arch/x86/kvm/svm/sev.c | 17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index c8ffdbc81709..b80e9bf0a31b 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -342,6 +342,8 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
>  	unsigned long first, last;
>  	int ret;
>  
> +	lockdep_assert_held(&kvm->lock);
> +
>  	if (ulen == 0 || uaddr + ulen < uaddr)
>  		return ERR_PTR(-EINVAL);
>  
> @@ -1119,12 +1121,20 @@ int svm_register_enc_region(struct kvm *kvm,
>  	if (!region)
>  		return -ENOMEM;
>  
> +	mutex_lock(&kvm->lock);
>  	region->pages = sev_pin_memory(kvm, range->addr, range->size, &region->npages, 1);
>  	if (IS_ERR(region->pages)) {
>  		ret = PTR_ERR(region->pages);
> +		mutex_unlock(&kvm->lock);
>  		goto e_free;
>  	}
>  
> +	region->uaddr = range->addr;
> +	region->size = range->size;
> +
> +	list_add_tail(&region->list, &sev->regions_list);
> +	mutex_unlock(&kvm->lock);
> +
>  	/*
>  	 * The guest may change the memory encryption attribute from C=0 -> C=1
>  	 * or vice versa for this memory range. Lets make sure caches are
> @@ -1133,13 +1143,6 @@ int svm_register_enc_region(struct kvm *kvm,
>  	 */
>  	sev_clflush_pages(region->pages, region->npages);

I don't think it actually matters, but it feels like the flush should be done
before adding the region to the list.  That would also make this sequence
consistent with the other flows.

Tom, any thoughts?

>  
> -	region->uaddr = range->addr;
> -	region->size = range->size;
> -
> -	mutex_lock(&kvm->lock);
> -	list_add_tail(&region->list, &sev->regions_list);
> -	mutex_unlock(&kvm->lock);
> -
>  	return ret;
>  
>  e_free:
> -- 
> 2.30.0.280.ga3ce27912f-goog
> 
