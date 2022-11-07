Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3399961FAD6
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 18:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbiKGRJA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 12:09:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231506AbiKGRI6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 12:08:58 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA51C140D5
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 09:08:55 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id u8-20020a17090a5e4800b002106dcdd4a0so15272157pji.1
        for <stable@vger.kernel.org>; Mon, 07 Nov 2022 09:08:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BWlMm+qSeMSAb3tYJlNe1lOoygJ5pWzq44wvHwGxmVE=;
        b=AfDBPFz79zRPGdRbOWc2y6ZZ7JXPj2o6zv5diFxEuS+58LUCNzgqxCgkghl/K+h6Kl
         i8cLMR4IF146RwUPuRiV7I/grFl68iZEq+sO2LwGeXUroaqEUJBq/b8hjFRi+KlUKcXW
         rkUpmrx7wrQnp/87yktTBrMZD7FvWAH23gvDXyphi+NGGOesg5cF5YOe4E4rQwny/ddR
         nErcUnYXpfi55MilNxh3qBnsr8tPATBgIY9oFd88vPFktE94aOiouZNApXhB8ug6Z9k4
         bePiUcveEuNQgCdABOiJwIAqzP7snyQfwfqDb6h02YSOjKMfIfJGHjPyv37TpVrCGD+3
         aFCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BWlMm+qSeMSAb3tYJlNe1lOoygJ5pWzq44wvHwGxmVE=;
        b=akLcywryIXsubpXUANZc6VVOBbMzIHsHSsmMyj7cKttGAbH31wNQj9kjuSuWwEl9/z
         j/E6QvDcndMunxxOm+VK2czJ+h1ZyoPGAgWJ87QjQANOUtJu/w3QwEY9LIOEqm/1Ifu9
         XVii9DVeYjsN2+W1Vp7x+gRWMAObRoK8vTfHtbd/keP8uAfWBT9yJog+WDJPoDt3zQAF
         9HMjvsSVMVGWKeD5JMnfK/gZh/GJkRJHyFaly0srEEoHM+LJYb4K4uoJLhcE7xhtVHNT
         6P4WuhnPJdNbUZz2Kbka3ZTrJohSfovRSPyKKj7qjZ0+yj9itATmQqxhQKS1DZUUQq48
         qWEA==
X-Gm-Message-State: ACrzQf1qBc4onKcSGyXHmwWtyukvbkg71T9Y25Zd9l7GIH7Jh8Gnvin9
        nbEkBIx6ZcERP4HDHbdbCXqrDA==
X-Google-Smtp-Source: AMsMyM4khohiAM6lsDgpkjVm5EWngW2nrC8xXK9n15PisApW9Ig/Jt9mzlFT0uWfPQGNN5rPpcsM+Q==
X-Received: by 2002:a17:903:244e:b0:186:c41e:ce9e with SMTP id l14-20020a170903244e00b00186c41ece9emr52877828pls.100.1667840935131;
        Mon, 07 Nov 2022 09:08:55 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a20-20020a1709027d9400b0018862b7f8besm5257880plm.160.2022.11.07.09.08.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 09:08:54 -0800 (PST)
Date:   Mon, 7 Nov 2022 17:08:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        nathan@kernel.org, thomas.lendacky@amd.com,
        andrew.cooper3@citrix.com, peterz@infradead.org,
        jmattson@google.com, stable@vger.kernel.org
Subject: Re: [PATCH 1/8] KVM: SVM: extract VMCB accessors to a new file
Message-ID: <Y2k7o8i/qhBm9bpC@google.com>
References: <20221107145436.276079-1-pbonzini@redhat.com>
 <20221107145436.276079-2-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107145436.276079-2-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 07, 2022, Paolo Bonzini wrote:
> Having inline functions confuses the compilation of asm-offsets.c,
> which cannot find kvm_cache_regs.h because arch/x86/kvm is not in
> asm-offset.c's include path.  Just extract the functions to a
> new file.
> 
> No functional change intended.
> 
> Cc: stable@vger.kernel.org
> Fixes: f14eec0a3203 ("KVM: SVM: move more vmentry code to assembly")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/svm/avic.c         |   1 +
>  arch/x86/kvm/svm/nested.c       |   1 +
>  arch/x86/kvm/svm/sev.c          |   1 +
>  arch/x86/kvm/svm/svm.c          |   1 +
>  arch/x86/kvm/svm/svm.h          | 200 ------------------------------
>  arch/x86/kvm/svm/svm_onhyperv.c |   1 +
>  arch/x86/kvm/svm/vmcb.h         | 211 ++++++++++++++++++++++++++++++++

I don't think vmcb.h is a good name.  The logical inclusion sequence would be for
svm.h to include vmcb.h, e.g. SVM requires knowledge about VMCBs, but this requires
vmcb.h to include svm.h to dereference "struct vcpu_svm".

Unlike VMX's vmcs.h, the new file isn't a "pure" VMCB helper, it also holds a
decent amount of KVM's SVM logic.

What about making KVM self-sufficient?  The includes in asm-offsets.c are quite
ugly

 #include "../kvm/vmx/vmx.h"
 #include "../kvm/svm/svm.h"

or as a stopgap to make backporting easier, just include kvm_cache_regs.h?

>  void svm_leave_nested(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/svm/svm_onhyperv.c b/arch/x86/kvm/svm/svm_onhyperv.c
> index 8cdc62c74a96..ae0a101329e6 100644
> --- a/arch/x86/kvm/svm/svm_onhyperv.c
> +++ b/arch/x86/kvm/svm/svm_onhyperv.c
> @@ -8,6 +8,7 @@
>  #include <asm/mshyperv.h>
>  
>  #include "svm.h"
> +#include "vmcb.h"
>  #include "svm_ops.h"
>  
>  #include "hyperv.h"
> diff --git a/arch/x86/kvm/svm/vmcb.h b/arch/x86/kvm/svm/vmcb.h
> new file mode 100644
> index 000000000000..8757cda27e3a
> --- /dev/null
> +++ b/arch/x86/kvm/svm/vmcb.h
> @@ -0,0 +1,211 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Kernel-based Virtual Machine driver for Linux
> + *
> + * AMD SVM support - VMCB accessors
> + */
> +
> +#ifndef __SVM_VMCB_H
> +#define __SVM_VMCB_H
> +
> +#include "kvm_cache_regs.h"

This should include "svm.h" instead of relying on the parent to include said file.
