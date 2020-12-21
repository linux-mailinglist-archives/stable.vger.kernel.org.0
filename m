Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A04E2DFFD8
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 19:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgLUSd1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 13:33:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21574 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727071AbgLUSdX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Dec 2020 13:33:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608575517;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K9FeuGmQgyv7B/8HpfW7JWOxHabUVt0zhGvyltedBTw=;
        b=XqmakEukUe4JzhHGspKOolL2ByruBE/ssJxUsTD+WldvQaVjViB6R7Cf6VVxQain+RKwDZ
        CvkwGrIDwDCzknvfIEMk0tVFrwYM+ONTKYIZ1IBphr4ANXQlWgvpyM5LgapfBQU40wuuGD
        zFXxAKxhe+2lwJf12a+1y5ub7vzyoO0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-IpuT7952Nl6WE6Mle0Xsug-1; Mon, 21 Dec 2020 13:31:55 -0500
X-MC-Unique: IpuT7952Nl6WE6Mle0Xsug-1
Received: by mail-wr1-f70.google.com with SMTP id v5so9254200wrr.0
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 10:31:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K9FeuGmQgyv7B/8HpfW7JWOxHabUVt0zhGvyltedBTw=;
        b=BhQjtpN+m+CyulDodVfx2r0PiggRHYP2THUaBfY+13enhKH8j6pm7gkeMteTgKWn4m
         mg8fMYOJM1Jhgqy3OppB0+McIxzgnO7KzzjB827GUPXlxYyy9/HNXFr34iLHFTIwmggO
         SPYZyNQ58TqvfPnIDw7qMphS3WWZKYT0D+HAFsPqiITq7D2NVmr+Z98KMeod+ILeDaQc
         d8DS+XH3wwA7CFTbncMSTYAH4HMXALlPvCFl4XN5bLsXA331LgqjZlxH6H/1aDw8QaKw
         W9dGp3o4OGTaQbNvEVe0eO5hq5aNArZlGGgJVk02s2cSee1OKwt96VIZO3prlVPmcCKc
         RnyQ==
X-Gm-Message-State: AOAM531gZkLqXDU8cJXErvOqODNmML9+0pF4FSfjdIHlcOT/XhEstZnx
        OWeh4Z77VWRRmTB5p4/STVkWLmQnZagx22kRKJcR2RNdS6o0Rjl829eJmrLz9rRn45l1P+KEFeG
        CH2fFFkJ9cs7AYNUpxy7Kzj/qWBe3VQGH5VeGSLnmbsbKgRW9Go4fDk5lssh0ZjFSxjtj
X-Received: by 2002:a5d:62c8:: with SMTP id o8mr20536526wrv.51.1608575513771;
        Mon, 21 Dec 2020 10:31:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwSeg8I2cfYyaGyf0kM/XC//Jnj5R+Jg+aS41jlXlZ40yng81myXCqLuP6DCmIHPLCq7CfQHA==
X-Received: by 2002:a5d:62c8:: with SMTP id o8mr20536508wrv.51.1608575513589;
        Mon, 21 Dec 2020 10:31:53 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u83sm11568628wmu.12.2020.12.21.10.31.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Dec 2020 10:31:52 -0800 (PST)
Subject: Re: [PATCH V3] kvm: check tlbs_dirty directly
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>, stable@vger.kernel.org
References: <X9kEAh7z1rmlmyhZ@google.com>
 <20201217154118.16497-1-jiangshanlai@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8c5f3503-860d-b3c0-4838-0a4a04f64a47@redhat.com>
Date:   Mon, 21 Dec 2020 19:31:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201217154118.16497-1-jiangshanlai@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 17/12/20 16:41, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> In kvm_mmu_notifier_invalidate_range_start(), tlbs_dirty is used as:
>          need_tlb_flush |= kvm->tlbs_dirty;
> with need_tlb_flush's type being int and tlbs_dirty's type being long.
> 
> It means that tlbs_dirty is always used as int and the higher 32 bits
> is useless.  We need to check tlbs_dirty in a correct way and this
> change checks it directly without propagating it to need_tlb_flush.
> 
> Note: it's _extremely_ unlikely this neglecting of higher 32 bits can
> cause problems in practice.  It would require encountering tlbs_dirty
> on a 4 billion count boundary, and KVM would need to be using shadow
> paging or be running a nested guest.
> 
> Cc: stable@vger.kernel.org
> Fixes: a4ee1ca4a36e ("KVM: MMU: delay flush all tlbs on sync_page path")
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
> Changed from V1:
>          Update the patch and the changelog as Sean Christopherson suggested.
> 
> Changed from v2:
> 	don't change the type of need_tlb_flush
> 
>   virt/kvm/kvm_main.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 2541a17ff1c4..3083fb53861d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -482,9 +482,8 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
>   	kvm->mmu_notifier_count++;
>   	need_tlb_flush = kvm_unmap_hva_range(kvm, range->start, range->end,
>   					     range->flags);
> -	need_tlb_flush |= kvm->tlbs_dirty;
>   	/* we've to flush the tlb before the pages can be freed */
> -	if (need_tlb_flush)
> +	if (need_tlb_flush || kvm->tlbs_dirty)
>   		kvm_flush_remote_tlbs(kvm);
>   
>   	spin_unlock(&kvm->mmu_lock);
> 

Queued, thanks.

Paolo

