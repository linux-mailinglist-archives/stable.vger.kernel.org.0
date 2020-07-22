Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1FB5229BF8
	for <lists+stable@lfdr.de>; Wed, 22 Jul 2020 17:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728579AbgGVPyf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jul 2020 11:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbgGVPye (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jul 2020 11:54:34 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 577F7C0619DC
        for <stable@vger.kernel.org>; Wed, 22 Jul 2020 08:54:34 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id q5so2398145wru.6
        for <stable@vger.kernel.org>; Wed, 22 Jul 2020 08:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MIgLg/+oCtXlnnVfAH5YGWvDn4tjulz+CHstgUNDuBI=;
        b=Fc6AThDwpMZFaDh1J0ZF6aEYxH5PWsiLQnsPcR1msZjugsxaTlPNJI1EaPiYtBVUrL
         w7/aLZZWVHoz96ozYeZPpGKs1CgLpnSC8NvJMSz1tAty6ZTzfV2MIHXG2k1Ap+gkx6KW
         uR8LAOJFitbxsqxEeqS85LtqoOb9fLCCRKzFz2Jp2jcPk7sBGzwJPzuK4yNzDm12i5Q2
         +Br4rSACN+TBzT16HLMpPbKnDWFd3VexUwg9izcccJw/AYqrjWCWt1g47A231rQxUTIr
         H0kYmZqtfksQSJpjjrgRTWNLWAJFJ1JDmFIZdeOQz1sBGfeS0uDm/K3gFJoGV/AExT7P
         ksmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MIgLg/+oCtXlnnVfAH5YGWvDn4tjulz+CHstgUNDuBI=;
        b=CeksDqN24K4y5K9NL1LLn8kRoYVGYKAQ0vVSiPZZJ3FI4rRs5giX3caZJrlddJlolI
         n9uobaunTlqN6xZdl6Bgakr6IuwWJ1Pf88DxpPasYWlXLvX3Kyl3CyQ+CM6ZKUpJwbOI
         f6ECPcYMWUNvrmdmKzlY53n3G+Bf45TNZHpvDNsgTPpK6hnah7Xaz7xr/FzeJ1Wr6vrI
         G4k9prYX2Jft3bKR0IUnIZhZFY703LlopJsuC3etXe+SdqzzxtTFBt11br430vKvWmFr
         u9PPj+igou9dNUhVTAWR/sMBCoCOdakZoXkcwawXaQYhY7T0V7Tc74ECQqrQ2Ykd0XW3
         0Lrw==
X-Gm-Message-State: AOAM533rww5e0cl58k42MkoytakaV8/dFthqxIPsvDcKekCpLSGEQAWl
        srXPPKTw+hBQemLpoYTLih/4gA==
X-Google-Smtp-Source: ABdhPJyQ3z9VjiLaef75OMhJ7VefC8duEZSjc0/Ra37mpKst2cgL8HBdMjFok5IZBXkFsUtMCGezDQ==
X-Received: by 2002:adf:ed88:: with SMTP id c8mr169859wro.233.1595433272651;
        Wed, 22 Jul 2020 08:54:32 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:110:f693:9fff:fef4:a7ef])
        by smtp.gmail.com with ESMTPSA id c7sm378288wrq.58.2020.07.22.08.54.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 08:54:31 -0700 (PDT)
Date:   Wed, 22 Jul 2020 16:54:28 +0100
From:   Quentin Perret <qperret@google.com>
To:     Will Deacon <will@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        james.morse@arm.com, suzuki.poulose@arm.com,
        kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Don't inherit exec permission across
 page-table levels
Message-ID: <20200722155428.GA275809@google.com>
References: <20200722131511.14639-1-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722131511.14639-1-will@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey Will,

On Wednesday 22 Jul 2020 at 14:15:10 (+0100), Will Deacon wrote:
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 8c0035cab6b6..69dc36d1d486 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1326,7 +1326,7 @@ static bool stage2_get_leaf_entry(struct kvm *kvm, phys_addr_t addr,
>  	return true;
>  }
>  
> -static bool stage2_is_exec(struct kvm *kvm, phys_addr_t addr)
> +static bool stage2_is_exec(struct kvm *kvm, phys_addr_t addr, unsigned long sz)
>  {
>  	pud_t *pudp;
>  	pmd_t *pmdp;
> @@ -1338,9 +1338,9 @@ static bool stage2_is_exec(struct kvm *kvm, phys_addr_t addr)
>  		return false;
>  
>  	if (pudp)
> -		return kvm_s2pud_exec(pudp);
> +		return sz == PUD_SIZE && kvm_s2pud_exec(pudp);
>  	else if (pmdp)
> -		return kvm_s2pmd_exec(pmdp);
> +		return sz == PMD_SIZE && kvm_s2pmd_exec(pmdp);
>  	else
>  		return kvm_s2pte_exec(ptep);

This wants a 'sz == PAGE_SIZE' check, otherwise you'll happily inherit
the exec flag when a PTE has exec rights while you create a block
mapping on top.

Also, I think it should be safe to make the PMD and PUD case more
permissive, as 'sz <= PMD_SIZE' for instance, as the icache
invalidation shouldn't be an issue there? That probably doesn't matter
all that much though.

>  }
> @@ -1958,7 +1958,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	 * execute permissions, and we preserve whatever we have.
>  	 */
>  	needs_exec = exec_fault ||
> -		(fault_status == FSC_PERM && stage2_is_exec(kvm, fault_ipa));
> +		(fault_status == FSC_PERM &&
> +		 stage2_is_exec(kvm, fault_ipa, vma_pagesize));
>  
>  	if (vma_pagesize == PUD_SIZE) {
>  		pud_t new_pud = kvm_pfn_pud(pfn, mem_type);
> -- 
> 2.28.0.rc0.105.gf9edc3c819-goog
> 

FWIW, I reproduced the issue with a dummy guest accessing memory just
the wrong way, and toggling dirty logging at the right moment. And this
patch + my suggestion above seems to cure things. So, with the above
applied:

Reviewed-by: Quentin Perret <qperret@google.com>
Tested-by: Quentin Perret <qperret@google.com>

Thanks,
Quentin
