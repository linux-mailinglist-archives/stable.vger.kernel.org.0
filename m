Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF6230ADFD
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 18:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbhBARgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 12:36:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34137 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229981AbhBARgG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 12:36:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612200879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2NZKbeXzcfHbSANzM+icsyeTW8NUFJCX0ZTecBjzbRc=;
        b=iYKpd1F5pfGJUOTVQjajL3t2ZS0k4ClXhWgFxf+jjbWXGi5wtBziCL6DxpFu8VeGYFEy38
        TgDUfrgOLGlnLtt6HT1kXkGllApsrQQg917QMZu6SkCmqN055MZiwJx7XBIFLhlK+ZQFfI
        +zBmH2LmSWE1t4DM6fFj2bo4u52j9JQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-55-U1Uaj_H1P7ulennh_3e3yw-1; Mon, 01 Feb 2021 12:34:38 -0500
X-MC-Unique: U1Uaj_H1P7ulennh_3e3yw-1
Received: by mail-ed1-f72.google.com with SMTP id a26so8357847edx.8
        for <stable@vger.kernel.org>; Mon, 01 Feb 2021 09:34:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2NZKbeXzcfHbSANzM+icsyeTW8NUFJCX0ZTecBjzbRc=;
        b=TA+xSfwF5ULxz9c4al19tCU9FHeN2mbQ8VhKALHaUdOuiqwgcFtFZWqGN0U1ViGs+w
         wg+UUf2LuzJOYRUhxqEhhw3H0o67L/SZUt+wRNq5hOssw296sxBGSuuTzkrvFRdiZhSR
         iAnoyreazgD1DkjkYWGypbVRdNpemVZa0L0SNPbRh5YQLbxJM6vwirxAxWfErBU0xf8I
         vW+VQg4MYxumLd1fZc0k/PJSRBTvEe2BA4ZpkI8hwYrNxqcfBcV0wE0VaC7yfyVumMei
         YjhcLfVhS27zVrzlk08vwochXcbsoPsmnToSrFeq9Fm9r3AXyQE9zTO3dB760PNk6dRq
         lTnA==
X-Gm-Message-State: AOAM533jBZmJrRHC0r/6nSp+POvOCvG8JQ/1xuDITGW8Gz5ldPuvlNTh
        /JencPD0O0ivsGCFgFXciA6HB6oPXKCekXTY1ZjXMisCoIeDFw0ix4Gy/3fEI0SnqP7xpmpD/cF
        aYxRjv5Egekb8bNfIirchzyEqbiC3nO3m8IZ88fCYAWPYIwNxViSLO3hDYlMb3oIjg5Rh
X-Received: by 2002:a17:906:8a59:: with SMTP id gx25mr11149292ejc.310.1612200876428;
        Mon, 01 Feb 2021 09:34:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyuco1n7Z+thK68eUv56Qg6mm+AGU0xTXiBvHNpIbM28BF8ssdwHrUJs/MqCOkkBonnQiUaJA==
X-Received: by 2002:a17:906:8a59:: with SMTP id gx25mr11149263ejc.310.1612200876180;
        Mon, 01 Feb 2021 09:34:36 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id j27sm8302466ejb.102.2021.02.01.09.34.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Feb 2021 09:34:35 -0800 (PST)
Subject: Re: [PATCH v2] KVM: x86: Allow guests to see MSR_IA32_TSX_CTRL even
 if tsx=off
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        jmattson@google.com, stable@vger.kernel.org
References: <20210129101912.1857809-1-pbonzini@redhat.com>
 <YBQ+peAEdX2h3tro@google.com>
 <37be5fb8-056f-8fba-3016-464634e069af@redhat.com>
 <618c5513-5092-f7cd-b47b-933936001180@redhat.com>
 <YBgugM03fsEiOxz1@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cac389ad-96b0-293e-f977-4e9c6d719dea@redhat.com>
Date:   Mon, 1 Feb 2021 18:34:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YBgugM03fsEiOxz1@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01/02/21 17:38, Sean Christopherson wrote:
>>>>      /*
>>>>       * On TAA affected systems:
>>>>       *      - nothing to do if TSX is disabled on the host.
>>>>       *      - we emulate TSX_CTRL if present on the host.
>>>>       *      This lets the guest use VERW to clear CPU buffers.
>>>>       */
> 
> it says "nothing to do..." and then clears a
> flag.  The other interpretation of "nothing to do... at runtime" is also wrong
> as KVM emulates the MSR as a nop.
> 
> I guess I just find the whole comment more confusing than the code itself.

What about:


         if (!boot_cpu_has(X86_FEATURE_RTM)) {
                 /*
                  * If RTM=0 because the kernel has disabled TSX, the 
host might
                  * have TAA_NO or TSX_CTRL.  Clear TAA_NO (the guest 
sees RTM=0
                  * and therefore knows that there cannot be TAA) but keep
                  * TSX_CTRL: some buggy userspaces leave it set on 
tsx=on hosts,
                  * and we want to allow migrating those guests to 
tsx=off hosts.
                  */
                 data &= ~ARCH_CAP_TAA_NO;
         } else if (!boot_cpu_has_bug(X86_BUG_TAA)) {
                 data |= ARCH_CAP_TAA_NO;
         } else {
                 /*
                  * Nothing to do here; we emulate TSX_CTRL if present 
on the
                  * host so the guest can choose between disabling TSX or
                  * using VERW to clear CPU buffers.
                  */
         }

Paolo

