Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53DE6622F6D
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 16:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbiKIPzE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 10:55:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbiKIPzC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 10:55:02 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D571D11C36
        for <stable@vger.kernel.org>; Wed,  9 Nov 2022 07:55:01 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id b11so17098498pjp.2
        for <stable@vger.kernel.org>; Wed, 09 Nov 2022 07:55:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OYpojbNmmKHGxbjqOfnD0s3EMEGbo47m7QNwH+EM5Eo=;
        b=B/I2YD7Ri9F93xp/vhwGHv5P6JV+T5Q9uC6Ahy9Mr2rcve6M3tjTKx9oJ39pBCNmSR
         jgAd2/AUe6rg0UK9u9ln6DTcdcjISJN1qYsBzDYfSCdLnEcAeVNszpevnJOL3hNwV+A6
         U7mb2lWhhBTXzO2nsTRxqzCQ3dFrRzNIDokj/69AH+BWtEO1kiUyBPQXOhruC66H4gCo
         ZsnR7u6/apkIy6CJROtgBImm0V7QRuCykimTfAFSKeQqaaDM2oZuowR9kSiDoUwvC9eH
         eViPOcZLj/wsIoEhdU4frBS5l+a3IBePXtUuzOHZbWCgPDLQmirEA+fkL0D6cKAKBNxu
         NOcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OYpojbNmmKHGxbjqOfnD0s3EMEGbo47m7QNwH+EM5Eo=;
        b=3BdYSrDduLsJMdMAFoW+d17wO1ZJbfjM7QJhl44c862sRv+AsMebAWDu70ifDj5amS
         tBrvgioJ0ZZmlpmXaJo2jKGeR8HZjJ3amaqNfcoLMG4PnGqwCjuIAF5E95xf/89Tiigp
         YJ2CkFpg9LSzTDO8tbVkzT5cN9cot7y4eyYQXwwKWlhy3DoNCfKrr5KcHqLxySOnYvRv
         kY1eYy4DFiblnb5+jHPuVtueL/J6YNuAQKZ2Dva1f3OlIY+kgyB1lgX9nzy+13z7PSD9
         UGxqnBEh4wmpEL/n+NspZZa6lklCsieCZL9u6OMjV7W3+0SYHiNfN0lqj+g0MKGVNZ08
         wDGw==
X-Gm-Message-State: ACrzQf3JyZDShFT2xu7VGxbpLts63RaK3aBEEVmsifL3mkaCSipSGqMb
        zK78A/cfuas/PUSx1bm4SQF48g==
X-Google-Smtp-Source: AMsMyM61N5DTeOMMlXp5MsaGWJkgt6df0X1M/CuPrKTj5oYNKTl9qKfW5YjEnstQltvYEjP6iZpHLQ==
X-Received: by 2002:a17:90b:3446:b0:213:4990:fa2 with SMTP id lj6-20020a17090b344600b0021349900fa2mr82551403pjb.73.1668009301285;
        Wed, 09 Nov 2022 07:55:01 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id e5-20020a17090a684500b00205db4ff6dfsm1370370pjm.46.2022.11.09.07.55.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 07:55:00 -0800 (PST)
Date:   Wed, 9 Nov 2022 15:54:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        thomas.lendacky@amd.com, jmattson@google.com,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>
Subject: Re: [PATCH 09/11] KVM: SVM: restore host save area from assembly
Message-ID: <Y2vNUas4rzEu001a@google.com>
References: <20221109145156.84714-1-pbonzini@redhat.com>
 <20221109145156.84714-10-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109145156.84714-10-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 09, 2022, Paolo Bonzini wrote:
> Allow access to the percpu area via the GS segment base, which is
> needed in order to access the saved host spec_ctrl value.  In linux-next
> FILL_RETURN_BUFFER also needs to access percpu data.
> 
> For simplicity, the physical address of the save area is added to struct
> svm_cpu_data.
> 
> Cc: stable@vger.kernel.org
> Fixes: a149180fbcf3 ("x86: Add magic AMD return-thunk")
> Reported-by: Nathan Chancellor <nathan@kernel.org>
> Analyzed-by: Andrew Cooper <andrew.cooper3@citrix.com>
> Tested-by: Nathan Chancellor <nathan@kernel.org>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>

> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 2af6a71126c1..83955a4e520e 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -287,6 +287,8 @@ struct svm_cpu_data {
>  	struct kvm_ldttss_desc *tss_desc;
>  
>  	struct page *save_area;
> +	unsigned long save_area_pa;

I really dislike storing both the page and the address, but that's more about
storing the "struct page" instead of the virtual address, and that can be cleaned
up in a follow-up series.

Specifically, the ugly pointer arithmetic in svm_prepare_switch_to_guest() can
be avoided by updating "struct vmcb" to capture SEV-ES+, and by tracking the save
area as a VMCB (which it is).

E.g. as a very partial patch

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 0361626841bc..64ba98d32689 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -513,7 +513,10 @@ static inline void __unused_size_checks(void)
 
 struct vmcb {
        struct vmcb_control_area control;
-       struct vmcb_save_area save;
+       union {
+               struct sev_es_save_area sev_es_save;
+               struct vmcb_save_area save;
+       }
 } __packed;
 
 #define SVM_CPUID_FUNC 0x8000000a
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9f88c8e6766e..b23b7633033b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1462,12 +1462,8 @@ static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
         * or subsequent vmload of host save area.
         */
        vmsave(sd->save_area_pa);
-       if (sev_es_guest(vcpu->kvm)) {
-               struct sev_es_save_area *hostsa;
-               hostsa = (struct sev_es_save_area *)(page_address(sd->save_area) + 0x400);
-
-               sev_es_prepare_switch_to_guest(hostsa);
-       }
+       if (sev_es_guest(vcpu->kvm))
+               sev_es_prepare_switch_to_guest(sd->save_area->sev_es_save);
 
        if (tsc_scaling)
                __svm_write_tsc_multiplier(vcpu->arch.tsc_scaling_ratio);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 199a2ecef1ce..802ed393d860 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -286,7 +286,7 @@ struct svm_cpu_data {
        u32 min_asid;
        struct kvm_ldttss_desc *tss_desc;
 
-       struct page *save_area;
+       struct vmcb *save_area;
        unsigned long save_area_pa;
 
        struct vmcb *current_vmcb;
