Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2406261FB2F
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 18:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbiKGRX6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 12:23:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbiKGRX6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 12:23:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9EDB1DDCF
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 09:22:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667841777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rZ09hkMmaoZyaAHo1tsMTz2+wpqw+JOCPiAMroMDJUc=;
        b=f2bbVvFWtSz/4C5a+W6T4PiaMQbBgHrjQMfsXreywUX7mg2mAn2KrtsKso7p4fxBZm7Qv6
        QZYKGkq5O7Vd5sLonmTZ1z4fu1fyvQjTEnzRwr2HUkYbaWyDAG2fXN4+Hd9iLZAQnairYE
        JKpKtabCrL+Grbh7/vEmkSZZmJsOagc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-497-rdgfl03nMFyfpZeudEOceQ-1; Mon, 07 Nov 2022 12:22:56 -0500
X-MC-Unique: rdgfl03nMFyfpZeudEOceQ-1
Received: by mail-wm1-f72.google.com with SMTP id h8-20020a1c2108000000b003cf550bfc8dso8736266wmh.2
        for <stable@vger.kernel.org>; Mon, 07 Nov 2022 09:22:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rZ09hkMmaoZyaAHo1tsMTz2+wpqw+JOCPiAMroMDJUc=;
        b=mNzcUmIfbgUlkXnQLAtMLHh2DdnIUGpKt7JLZNDs1jwDO5J4+p0lwJyXlKxDxYQQCC
         vKBJt0KQsQobRjPkUD3M1hCuvJAfPNh9AwnrfqEUIX+2ceQ+cThjEqgKqM45sTREImyv
         sLMaFyVmHX/25uSR/kqkunzYO7HrBjv3WMQL4M9jUgU2g84b50vUIbMjrHE1ocTuwQFo
         PqD8wEwzeqb0f4yorXLMxp0GgGAFrBlX4QeK2s0RQTIMFq3TpDzpqEpY1jbaFLsAZ+f/
         YaW6zHXolCX3EbvcLubxFI/LIMZNRwxXv8eeAJypjZlGgPYFO6h39ZgZztu2FOLJYy16
         4Iqg==
X-Gm-Message-State: ANoB5pknM/hy5Ikxtqn6R8xfwE61/Qzjn76qpyVTN2rGp61jV1GOmvi7
        tx88S6pAliLZyL8akzxuniZLLhUqX+duJykYQrHvBgU9/RzUJrjvtao5SmtXcLbQ8LgwptPH/bg
        LB80htMq69kWWitMu
X-Received: by 2002:a05:600c:230d:b0:3cf:acc6:ba97 with SMTP id 13-20020a05600c230d00b003cfacc6ba97mr3544884wmo.102.1667841774873;
        Mon, 07 Nov 2022 09:22:54 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7qokg77pGCfqZ79Xlcw58RP/DEA32EcgvzY5lzjy3O/cLRok4O78DHfLKUoSjy0W/V37mzEA==
X-Received: by 2002:a05:600c:230d:b0:3cf:acc6:ba97 with SMTP id 13-20020a05600c230d00b003cfacc6ba97mr3544869wmo.102.1667841774642;
        Mon, 07 Nov 2022 09:22:54 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id p15-20020adfce0f000000b0022cbf4cda62sm9477730wrn.27.2022.11.07.09.22.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Nov 2022 09:22:53 -0800 (PST)
Message-ID: <f86a6ea3-3197-4009-0b67-9c9f99963805@redhat.com>
Date:   Mon, 7 Nov 2022 18:22:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 2/8] KVM: SVM: replace regs argument of __svm_vcpu_run
 with vcpu_svm
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        nathan@kernel.org, thomas.lendacky@amd.com,
        andrew.cooper3@citrix.com, peterz@infradead.org,
        jmattson@google.com, stable@vger.kernel.org
References: <20221107145436.276079-1-pbonzini@redhat.com>
 <20221107145436.276079-3-pbonzini@redhat.com> <Y2k8DilImFBVcZPG@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y2k8DilImFBVcZPG@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/7/22 18:10, Sean Christopherson wrote:
> Needs to include asm/asm-offsets.h, otherwise the compiler may think that
> SVM_vcpu_arch_regs is a symbol.
> 
>    ERROR: modpost: "SVM_vcpu_arch_regs" [arch/x86/kvm/kvm-amd.ko] undefined!
> 
> diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
> index 8fac744361e5..8d0b0781462e 100644
> --- a/arch/x86/kvm/svm/vmenter.S
> +++ b/arch/x86/kvm/svm/vmenter.S
> @@ -1,6 +1,7 @@
>   /* SPDX-License-Identifier: GPL-2.0 */
>   #include <linux/linkage.h>
>   #include <asm/asm.h>
> +#include <asm/asm-offsets.h>
>   #include <asm/bitsperlong.h>
>   #include <asm/kvm_vcpu_regs.h>
>   #include <asm/nospec-branch.h>

Yeah, it's included slightly later (I did test each patch independently, 
but I'm not sure how it ended up disappearing from this one).

Paolo

