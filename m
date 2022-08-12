Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D19C0590CF2
	for <lists+stable@lfdr.de>; Fri, 12 Aug 2022 09:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237672AbiHLHyY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Aug 2022 03:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235784AbiHLHyX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Aug 2022 03:54:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7851EA7225
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 00:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660290861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DWx2NoTz8YKZGUsJCzDtAAh8o7YhEmSWzOd2b2DX02o=;
        b=Ofyzfv46SMe7k+ca7xhUv6YVXC2w4kV/dTxueHDJAk6/H0JR38fF/xl7FDmYuMMWpU8IzB
        p+K0TazLWMrY+KVMykjcD4WGJnqsnLBiHD8wh5tRDqNJ7Yb4LRZ88X06XICIxiCTr2hu2p
        H3UYi2Opk6xaCAAGKZ8sxHkv0rtDqsk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-561-obikkoKLMt68Zits2gTDjA-1; Fri, 12 Aug 2022 03:54:20 -0400
X-MC-Unique: obikkoKLMt68Zits2gTDjA-1
Received: by mail-ed1-f71.google.com with SMTP id r12-20020a05640251cc00b00440647ec649so174457edd.21
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 00:54:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=DWx2NoTz8YKZGUsJCzDtAAh8o7YhEmSWzOd2b2DX02o=;
        b=QlFLcm6vVo79rZg5BRLKqk34EFZr6BjJpqZZY5kcNjKSLWA72tj1EqatH88Ef4s5cB
         lPWi5q/hmEXjXFOWCZfvACJFbMzBcFjbBz4/NeTPnwMbx+KYCXbEshxGfTEqI1tomMV3
         Fmh9owbqOpAIson2+S/tmmkHGQa3z8laMTJ9ZGM1xTUp/ErfKLxl1gnBGa3TSM3PKcE9
         p4Ho/VP8ufMBAr9dsNDHnQOYQ7oou4dxUHru7lcWt7EjUawVyzDOVn3cVemV6WTqJtr/
         SdBpMiZ3Q4DnsnPpKB4oFoHGcqqi5uY9NoO0BiOBhdrJRsI4aDBACXA/Nt1gX21EVfnh
         hiXA==
X-Gm-Message-State: ACgBeo0JooOoVqlfBlslDzEsUWxQLPBSMYt4+2sdzzr5dtOGtY9hv9Jy
        SeYezRXmcIw/CX8u7Cji8QfGJfPZWRSXYu/G2mOhsjLJElEnL3mtgI/b860U+XHcuXpT1t8O7nV
        QuWoJw9yl6xHEl8wY
X-Received: by 2002:a17:906:8a44:b0:730:9d18:17b5 with SMTP id gx4-20020a1709068a4400b007309d1817b5mr1899177ejc.378.1660290859145;
        Fri, 12 Aug 2022 00:54:19 -0700 (PDT)
X-Google-Smtp-Source: AA6agR69cZqtIT0+5fS0uq8Hg2fxp3BKmHpBqtqR6BlevMTPPxxHzJnsI2fgOiUn64XjsDzMXVMIgg==
X-Received: by 2002:a17:906:8a44:b0:730:9d18:17b5 with SMTP id gx4-20020a1709068a4400b007309d1817b5mr1899162ejc.378.1660290858880;
        Fri, 12 Aug 2022 00:54:18 -0700 (PDT)
Received: from [192.168.10.81] ([93.56.169.144])
        by smtp.googlemail.com with ESMTPSA id n17-20020aa7db51000000b0043bc4b28464sm942080edt.34.2022.08.12.00.54.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 00:54:18 -0700 (PDT)
Message-ID: <5a5dffae-260b-2a3e-53ac-5d748cb7e9d4@redhat.com>
Date:   Fri, 12 Aug 2022 09:54:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 4.19 2/3] KVM: x86: Check lapic_in_kernel() before
 attempting to set a SynIC irq
Content-Language: en-US
To:     Stefan Ghinea <stefan.ghinea@windriver.com>, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20220810202625.32529-1-stefan.ghinea@windriver.com>
 <20220810202625.32529-2-stefan.ghinea@windriver.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220810202625.32529-2-stefan.ghinea@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/10/22 22:26, Stefan Ghinea wrote:
> From: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> commit 7ec37d1cbe17d8189d9562178d8b29167fe1c31a upstream
> 
> When KVM_CAP_HYPERV_SYNIC{,2} is activated, KVM already checks for
> irqchip_in_kernel() so normally SynIC irqs should never be set. It is,
> however,  possible for a misbehaving VMM to write to SYNIC/STIMER MSRs
> causing erroneous behavior.
> 
> The immediate issue being fixed is that kvm_irq_delivery_to_apic()
> (kvm_irq_delivery_to_apic_fast()) crashes when called with
> 'irq.shorthand = APIC_DEST_SELF' and 'src == NULL'.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Message-Id: <20220325132140.25650-2-vkuznets@redhat.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Stefan Ghinea <stefan.ghinea@windriver.com>
> ---
>   arch/x86/kvm/hyperv.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index ca5a6c3f8c91..2047edb5ff74 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -341,6 +341,9 @@ static int synic_set_irq(struct kvm_vcpu_hv_synic *synic, u32 sint)
>   	struct kvm_lapic_irq irq;
>   	int ret, vector;
>   
> +	if (KVM_BUG_ON(!lapic_in_kernel(vcpu), vcpu->kvm))
> +		return -EINVAL;
> +
>   	if (sint >= ARRAY_SIZE(synic->sint))
>   		return -EINVAL;
>   

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

