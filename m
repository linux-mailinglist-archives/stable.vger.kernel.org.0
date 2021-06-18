Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B00E3AC7D3
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 11:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232270AbhFRJnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 05:43:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49548 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231987AbhFRJnW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Jun 2021 05:43:22 -0400
Received: from mail-ej1-f71.google.com ([209.85.218.71])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1luAzw-0005GW-Vx
        for stable@vger.kernel.org; Fri, 18 Jun 2021 09:41:13 +0000
Received: by mail-ej1-f71.google.com with SMTP id br12-20020a170906d14cb02904311c0f32adso3675131ejb.9
        for <stable@vger.kernel.org>; Fri, 18 Jun 2021 02:41:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wo2cA5pweSO0kqrQxgILuU1snjksEOHw0ShsHwnGQtI=;
        b=mbSZJnocD2yNRLI3Gv2XXlq60A0uQdnhTNjyyhqkeC0IefIoKmH/zmO5tRh0xrhsRI
         +1+ujJJfp8QhwZNg2ufzhdHVE4JdWteD+1MAk0G7WAfI+KXb/JMTEbr2bBoZsSY52o4m
         qsWSQ3/cMvF+yLiq55gRT3f0NYHLfzQi8HUrPni6nMKzbaPIowyFJ6DeXbr45HkjVaVj
         Ogi67+nYDNutShvI3vuTQf+qtsRzvWkpKGkup41zM7vbQ4mEHv3JRgx8BdWzvPOXGfxC
         iJRL1rzyAsOCIvwSxSyrPW2WFxIANUZl7PernalPsXUSnUvrdBNIbNckyHaaatyi8Irw
         Kqjg==
X-Gm-Message-State: AOAM532mD9tG1DTtDst+V48oHUr8ovuOrnEXLe+UHMZpoYQ98COfms3N
        t7tjDO/D/mVrHtrPP4S0zkBIKCohZV4luUqo4eJ9erpR84bBrOs9V54HTBuTJuE7uAdo7/6mFD7
        br29QTMaNa3zYpgSYjsLIPSzJoWvV/d+V7A==
X-Received: by 2002:a50:a447:: with SMTP id v7mr3754051edb.183.1624009272793;
        Fri, 18 Jun 2021 02:41:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz1WiDYFrsj6mJMQRLbXFqr/rU2eP2bom1b8TfxvYhAlycRQg2/g/+hXKY9QL0vEHNbGqcSMA==
X-Received: by 2002:a50:a447:: with SMTP id v7mr3754040edb.183.1624009272677;
        Fri, 18 Jun 2021 02:41:12 -0700 (PDT)
Received: from [192.168.1.115] (xdsl-188-155-177-222.adslplus.ch. [188.155.177.222])
        by smtp.gmail.com with ESMTPSA id kj1sm839242ejc.10.2021.06.18.02.41.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jun 2021 02:41:12 -0700 (PDT)
Subject: Re: [PATCH 5.4 031/184] modules: inherit TAINT_PROPRIETARY_MODULE
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>, Jessica Yu <jeyu@kernel.org>
References: <20210510101950.200777181@linuxfoundation.org>
 <20210510101951.249384110@linuxfoundation.org>
 <8edc6f45-6c42-19c7-6f40-6f1a49cc685b@canonical.com>
 <YMxlP2EMTaG9+2y6@kroah.com>
 <e56625df-dda3-01f3-0f9d-f4dffdbd6690@canonical.com>
 <YMxnXQzcP0g1F9Iw@kroah.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <0abfc041-571b-75ae-0d53-48f801aab043@canonical.com>
Date:   Fri, 18 Jun 2021 11:41:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YMxnXQzcP0g1F9Iw@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18/06/2021 11:29, Greg Kroah-Hartman wrote:
> On Fri, Jun 18, 2021 at 11:22:37AM +0200, Krzysztof Kozlowski wrote:
>> On 18/06/2021 11:19, Greg Kroah-Hartman wrote:
>>> On Fri, Jun 18, 2021 at 10:57:23AM +0200, Krzysztof Kozlowski wrote:
>>>> On 10/05/2021 12:18, Greg Kroah-Hartman wrote:
>>>>> From: Christoph Hellwig <hch@lst.de>
>>>>>
>>>>> commit 262e6ae7081df304fc625cf368d5c2cbba2bb991 upstream.
>>>>>
>>>>> If a TAINT_PROPRIETARY_MODULE exports symbol, inherit the taint flag
>>>>> for all modules importing these symbols, and don't allow loading
>>>>> symbols from TAINT_PROPRIETARY_MODULE modules if the module previously
>>>>> imported gplonly symbols.  Add a anti-circumvention devices so people
>>>>> don't accidentally get themselves into trouble this way.
>>>>>
>>>>> Comment from Greg:
>>>>>   "Ah, the proven-to-be-illegal "GPL Condom" defense :)"
>>>>
>>>> Patch got in to stable, so my comments are quite late, but can someone
>>>> explain me - how this is a stable material? What specific, real bug that
>>>> bothers people, is being fixed here? Or maybe it fixes serious issue
>>>> reported by a user of distribution kernel? IOW, how does this match
>>>> stable kernel rules at all?
>>>>
>>>> For sure it breaks some out-of-tree modules already present and used by
>>>> customers of downstream stable kernels. Therefore I wonder what is the
>>>> bug fixed here, so the breakage and annoyance of stable users is justified.
>>>
>>> It fixes a reported bug in that somehow symbols are being exported to
>>> modules that should not have been.  This has been in mainline and newer
>>> stable releases for quite some time, it should not be a suprise that
>>> this was backported further as well.
>>
>> This is vague. What exactly is the bug? How exporting symbols which
>> should not be exported, causes it? Is there OOPs? Some feature does not
>> work?
> 
> The bug/issue is that symbols were being incorrectly exported in ways
> that they should not have been and were available to users that should
> not have been able to use them.  That is what this patch series
> resolves.  I can go into details but they are boring and deal with
> closed source monstrosities that feel they are allowed to muck around in
> kernel internals at will, which causes a support burden on the kernel
> community.

Thanks Greg, I would prefer honest "we don't want others to do something
we don't like or approve and we can change it" :)

> If you object to this, that's fine, you are free to revert them in your
> local distro kernel after discussing it with your lawyers to get their
> approval to do so.


Best regards,
Krzysztof
