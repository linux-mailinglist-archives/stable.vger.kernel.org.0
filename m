Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8721379B1F
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 02:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbhEKATS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 20:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbhEKATR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 20:19:17 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A29C06175F
        for <stable@vger.kernel.org>; Mon, 10 May 2021 17:18:11 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id cl24-20020a17090af698b0290157efd14899so332059pjb.2
        for <stable@vger.kernel.org>; Mon, 10 May 2021 17:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ikfVvr5cpOXAclsRrng8wpNS2FGQXkIocuD0PuY3Rzg=;
        b=QQm08qjhO9hEu4hEn7czTFqAA8u6AFQcfQWATVLm5/JxkfZSD3dz6zwhb4eGOQqT/+
         qvsVePq/3y4E0e4mwGzIk71xFqOZMgETPbfJf7WDYwBl5ah+Rh0snT+c3JOeILg6E4u2
         ZrQE+v6i0HwKMKMokPfflQglaJAMeIkxbv8EFh8bfSvAflX2LOJpOm9Jgs6XhLbpBuur
         5GAu0J/8AdmYIsiOeaj5qqzaQVrB+ZNCRAgrzHeGAThJq52OFsM4Hs/o5N2ZkFRZXJ1/
         0lil+6Z2KZO+4bCSwx8tbHTw7hTijjggRZuwUjrMT++cazHzFBnSHHsdMooAuQB/jkr+
         uAJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ikfVvr5cpOXAclsRrng8wpNS2FGQXkIocuD0PuY3Rzg=;
        b=Wgj9go1dmml0WBwo3bYFbE3/J5B8+pWisXZ2E5gQFjnbnsWhTzJCO+Y20zQqJxj6sJ
         mkraQcCuptfeAIoGkyRk9cGRZb/WBR7gnz0sMNmm0Tk7iVMzA4ESZsCtOHcubJvnxjsE
         jdWD0nW6sBqunbUw04QRt3UrjYXXlliyoeR7JtP0mFNlxaEOD5UqHpd2xTE7xFk54tfQ
         dJRAdvi0ukKQSWJ2QTc4u79jrZf3LWFueUIewhxtr7YyOIQ+jk73pgAB+K4Kh9nOagEp
         KgtJQ7TZzwxiOx90+tzmKLe+CZ5oUCunCVtDWFQ2JuCwQqFM/S7MyEOZqtWVFB95EgtQ
         V3zA==
X-Gm-Message-State: AOAM532BH8PZ63tXXD7GNrbV6uO0D4bL9pzIdEBP2NzIxYKGj5n27izl
        iZ3wQTQsGJyp2tw/G1RB/SmzxQ==
X-Google-Smtp-Source: ABdhPJxplAR7tJENAHjFyyue0ZJQV0NzZ9jIhZ0stkVaVOs+UT1MefDKqZCQHmTfe7qLhH+HTUQSUQ==
X-Received: by 2002:a17:90a:71c6:: with SMTP id m6mr2004510pjs.174.1620692290358;
        Mon, 10 May 2021 17:18:10 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id i8sm4912597pgt.58.2021.05.10.17.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 17:18:09 -0700 (PDT)
Date:   Tue, 11 May 2021 00:18:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, stable@vger.kernel.org
Subject: Re: [PATCH 3/3] KVM: X86: Fix vCPU preempted state from guest point
 of view
Message-ID: <YJnNPpalqYwERwEL@google.com>
References: <1620466310-8428-1-git-send-email-wanpengli@tencent.com>
 <1620466310-8428-3-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1620466310-8428-3-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 08, 2021, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Commit 66570e966dd9 (kvm: x86: only provide PV features if enabled in guest's 
> CPUID) avoids to access pv tlb shootdown host side logic when this pv feature 
> is not exposed to guest, however, kvm_steal_time.preempted not only leveraged 
> by pv tlb shootdown logic but also mitigate the lock holder preemption issue. 
> From guest point of view, vCPU is always preempted since we lose the reset of
> kvm_steal_time.preempted before vmentry if pv tlb shootdown feature is not 
> exposed. This patch fixes it by clearing kvm_steal_time.preempted before 
> vmentry.
> 
> Fixes: 66570e966dd9 (kvm: x86: only provide PV features if enabled in guest's CPUID)
> Cc: stable@vger.kernel.org
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/x86.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c0244a6..c38e990 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3105,7 +3105,8 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
>  				       st->preempted & KVM_VCPU_FLUSH_TLB);
>  		if (xchg(&st->preempted, 0) & KVM_VCPU_FLUSH_TLB)
>  			kvm_vcpu_flush_tlb_guest(vcpu);
> -	}
> +	} else
> +		st->preempted = 0;

Curly braces needed since the if-statment needs 'em.  Other than that,

Reviewed-by: Sean Christopherson <seanjc@google.com>

>  
>  	vcpu->arch.st.preempted = 0;
>  
> -- 
> 2.7.4
> 
