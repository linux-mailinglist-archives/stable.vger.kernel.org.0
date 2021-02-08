Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28F0D313A34
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 17:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbhBHQz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 11:55:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35197 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234553AbhBHQzb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 11:55:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612803244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mpKQMznskIi3xd4XqVYyI2LFxEbTfjM/cP6CMM6SQOg=;
        b=H0YQxPY3IHDHA345I0trrsbbgfxybx99EwFWBDPsdqkb5+VPa8G5npouyKeaeWQDk+K/Nt
        MQMQvoRSsy8I96hicFgv4G7LYgXjMoWHObi/JFwKSWat9M7nv46wD5aH4yN3pfxRqQUtTX
        aBAYS7ECNa3wzj2SNXeEn6zGDbB849k=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-462-tkDNknZUMu6FQYdFWI_-oQ-1; Mon, 08 Feb 2021 11:54:00 -0500
X-MC-Unique: tkDNknZUMu6FQYdFWI_-oQ-1
Received: by mail-wr1-f71.google.com with SMTP id x1so6884571wrg.22
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 08:53:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mpKQMznskIi3xd4XqVYyI2LFxEbTfjM/cP6CMM6SQOg=;
        b=sxCsVK96KqZEtxqkIbnCPdbWpnrBubKoenazwkV+2pwDcEXtuVYLTsPsfMTdo+zHAD
         41SpDZw030JmNzi9CxsrxlmPd82pBaDD6lDH2ZqrNb9t+GKiWKVnAuT6xrPM2Old1Sbm
         Grv/mLKH8ahazv2f3+KxkUWsyUP3h153k7mrks7+BcuHaq5//XTYSZ2aEaNxFsRvPf8g
         e/wwnkFiYr2uaCa8EY858h5dSmFq8YH8LwW73K+VVGnsAljoyL99cf044zgcj2v+Mm45
         z2Ygwud6vnbITC7IvcpXbNLrjl0lBokN6daA/Ta2l1K/BU0PzHCGqnkEjjWT4ziOZP18
         VnMg==
X-Gm-Message-State: AOAM530wWHJKkYTsF4l072GOpFFmyvAw4caVW1oSai8BUZ1ohVsZ5SLg
        TEwH69vJpu6H58AH2Rdtw5k7alA4uw7Ntj5dPpfBfnz5OSIQiNdVWBDVpXhh8lJlYCzq/WOIjAt
        dXqcj+ShuE2Fsydhc
X-Received: by 2002:adf:f18a:: with SMTP id h10mr20539790wro.299.1612803238732;
        Mon, 08 Feb 2021 08:53:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyC7yZtx0zmzU25QtL4DFvRA5vG2h2e+LjUBP2VpEPAtzjMnRkJwQ9BCEXF4w5AEFDn4Bds7g==
X-Received: by 2002:adf:f18a:: with SMTP id h10mr20539768wro.299.1612803238553;
        Mon, 08 Feb 2021 08:53:58 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id z15sm28050792wrs.25.2021.02.08.08.53.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 08:53:57 -0800 (PST)
Subject: Re: [PATCH for 4.19] Fix unsynchronized access to sev members through
 svm_register_enc_region
To:     Peter Gonda <pgonda@google.com>, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210208164840.769333-1-pgonda@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2654c1ab-0178-e980-8573-3893e0bbcd60@redhat.com>
Date:   Mon, 8 Feb 2021 17:53:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210208164840.769333-1-pgonda@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08/02/21 17:48, Peter Gonda wrote:
> commit 19a23da53932bc8011220bd8c410cb76012de004 upstream.
> 
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
>   - Fix up patch description
>   - Correct file paths svm.c -> sev.c
>   - Add unlock of kvm->lock on sev_pin_memory error
> 
> V1
>   - https://lore.kernel.org/kvm/20210126185431.1824530-1-pgonda@google.com/
> 
> Message-Id: <20210127161524.2832400-1-pgonda@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/svm.c | 18 +++++++++++-------
>   1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 2b506904be02..93c89f1ffc5d 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -1830,6 +1830,8 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
>   	struct page **pages;
>   	unsigned long first, last;
>   
> +	lockdep_assert_held(&kvm->lock);
> +
>   	if (ulen == 0 || uaddr + ulen < uaddr)
>   		return NULL;
>   
> @@ -7086,12 +7088,21 @@ static int svm_register_enc_region(struct kvm *kvm,
>   	if (!region)
>   		return -ENOMEM;
>   
> +	mutex_lock(&kvm->lock);
>   	region->pages = sev_pin_memory(kvm, range->addr, range->size, &region->npages, 1);
>   	if (!region->pages) {
>   		ret = -ENOMEM;
> +		mutex_unlock(&kvm->lock);
>   		goto e_free;
>   	}
>   
> +	region->uaddr = range->addr;
> +	region->size = range->size;
> +
> +	mutex_lock(&kvm->lock);
> +	list_add_tail(&region->list, &sev->regions_list);
> +	mutex_unlock(&kvm->lock);
> +
>   	/*
>   	 * The guest may change the memory encryption attribute from C=0 -> C=1
>   	 * or vice versa for this memory range. Lets make sure caches are
> @@ -7100,13 +7111,6 @@ static int svm_register_enc_region(struct kvm *kvm,
>   	 */
>   	sev_clflush_pages(region->pages, region->npages);
>   
> -	region->uaddr = range->addr;
> -	region->size = range->size;
> -
> -	mutex_lock(&kvm->lock);
> -	list_add_tail(&region->list, &sev->regions_list);
> -	mutex_unlock(&kvm->lock);
> -
>   	return ret;
>   
>   e_free:
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

