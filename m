Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2E60395A06
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 14:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbhEaMGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 08:06:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38054 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231462AbhEaMGH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 08:06:07 -0400
Received: from mail-wr1-f72.google.com ([209.85.221.72])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lngeh-00086A-6B
        for stable@vger.kernel.org; Mon, 31 May 2021 12:04:27 +0000
Received: by mail-wr1-f72.google.com with SMTP id u20-20020a0560001614b02901115c8f2d89so3871325wrb.3
        for <stable@vger.kernel.org>; Mon, 31 May 2021 05:04:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bpsu+MIOc4SJXfox8x1WXwUd0TznyG9mps5FADndD8Q=;
        b=fCX84eLqBfnJC3l758rmh1QOsrrThWGwDMzy9uOQWYDhMuSzbmz73j4g+9dRwmTZAY
         PwVBZ7ss7wQYWPdzHhYw19lWlW0C64UjDKjmHGwkPP5V5/QXiuctzCEen5yvd93jtlul
         Q0sC7RjB1gd383FBsRiK8lrM2wHaP4HSCN7gwxCzdDORxwA5JeJKyPaXtV+1tIDskMV0
         FhGFyVhmGrppmeTzEMnadlRj3Q6UDCZTkVGj3dGPdYltuBzaDlwsezMHmXjIMqixaB1f
         o5Y5P/lP6svHfsY3zHlVSk8K+7LddyxLvNcIbPX8/6bx3VfSFl9Oly32yVl6+u2LfCei
         E7aw==
X-Gm-Message-State: AOAM530nt+49mLg4zK96jRVoZy34CC76xf+SpHaomc2WBYKRpL56Kldt
        pdiGblrgx+UdenhM4gne/tH8tqxMLYDFp0fOimMoLxKeMy7BfO812CX5t1tC7hmECwxLbuIR4kv
        DjqWge45FF+Qq7rL8EreEVZ+PLhJNbKa9dg==
X-Received: by 2002:a05:6000:11c9:: with SMTP id i9mr21793245wrx.153.1622462666432;
        Mon, 31 May 2021 05:04:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyx042FyfmIk5CNuND91mGKcqnypXkc2JGDs8W26x9DJS8V/FpWPYBuCmoQPEKa4+/EM+01iA==
X-Received: by 2002:a05:6000:11c9:: with SMTP id i9mr21793235wrx.153.1622462666343;
        Mon, 31 May 2021 05:04:26 -0700 (PDT)
Received: from [192.168.1.115] (xdsl-188-155-185-9.adslplus.ch. [188.155.185.9])
        by smtp.gmail.com with ESMTPSA id f7sm14651626wmq.30.2021.05.31.05.04.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 May 2021 05:04:26 -0700 (PDT)
Subject: Re: [PATCH v2 | stable v5.4+ 0/3] x86/kvm: fixes for hibernation
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Andrea Righi <andrea.righi@canonical.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20210531110053.14640-1-krzysztof.kozlowski@canonical.com>
 <YLTN+IeJ9d42N4sL@kroah.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <5ea98e47-a74e-8736-c90b-0d0a3685d77a@canonical.com>
Date:   Mon, 31 May 2021 14:04:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YLTN+IeJ9d42N4sL@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 31/05/2021 13:52, Greg KH wrote:
> On Mon, May 31, 2021 at 01:00:50PM +0200, Krzysztof Kozlowski wrote:
>> Hi,
>>
>> This is version 2 of aa backport for v5.4+.
> 
> Patch 3 does not apply to 5.12.y, so perhaps you need 3 series of
> patches here?
> 
> And patch 1/3 looks about half of what is in Linus's tree, are you sure
> about that?

Thanks for noticing it, I made mistake actually applied previous version
of our internal backport. Please drop it, I'll  send a v3.


Best regards,
Krzysztof
