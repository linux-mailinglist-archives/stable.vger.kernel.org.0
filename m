Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11E4D4ECFD2
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 00:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233858AbiC3Wyy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 18:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233713AbiC3Wyx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 18:54:53 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2BC968320
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 15:53:07 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id y10so16881442pfa.7
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 15:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fYsRr1x7gYgb8Ir409fmcxRuiLNNSnsiOywQxxoh1Ao=;
        b=FdZcaaJLZRKBXudLRA9FZiiVh/NTx7WcH26Z8Q7KKX0RtmYFoTrG1UX7XLqzDxsR4r
         1N81xTjacCxbfc8Zcr6jCcgrq9MdiiXdO+FQjd7zCUO/IyWoFJnsAgilVkRvOneYmKbb
         Ww6n22JYJ5lopv1c5zcEsXkwwNl72KIELpsdY78XQ8S2Sx50EqDEQZYRe/GevvbCw5Kr
         NUREztC1qjTt870POa/a+anoSglZih20yUbKlz47U4PYbYjratwl6gZJbmVOazr20yPl
         PRdQM7mAni+BD/IrgwQgj6Nn5H7URh1CIGKsB0IGyQidpBz9wq2yJKYnKKw0iFe+HJIs
         iWPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fYsRr1x7gYgb8Ir409fmcxRuiLNNSnsiOywQxxoh1Ao=;
        b=xGvvO5nHmXzmnAselda2oIsjhC/WGNidTy30GQYh84eF53b4oHGaqVaumWVfVI2lbx
         hIntAT3tS8BAgJu9NkHI1JzApgtdoZiXWiAOyEg9oEI2zbmzfRCAG5TwjN4x3ZDOt8Ba
         jYgC618lQIugGG//sDMI+mlqg9FfbTdJEw0kPsb3+++1O4Op296boDquqSxMP7/SISXj
         w4ZO2Gw1i+dX111j9TFKEvfU20KWtrOiqEfPsTiSoHLd/wv5FYoSb403i+VHLAw35MrU
         zf46ztVXOcPVPGWRNKYCvYmWBKhvdhwgQTXpB6j2hD2SKnXjqsg/VmVkrQWwwqRNswWx
         blVw==
X-Gm-Message-State: AOAM530F4/6o+sIFdxSG0MWWD3rk+hhLYknf/Q0aOVarl62p7Ti7rPGB
        2JM9XIUll6q6Wn3sUntOzooAs1nOLUkFplwX
X-Google-Smtp-Source: ABdhPJykL88T8ccffzDqNRUYQ1kVuDB3HwhGFKH/FypK7kVcs+uDSSTYSAvv7q/GCZeuRA7aF8fYzw==
X-Received: by 2002:a63:f40e:0:b0:380:6a04:4335 with SMTP id g14-20020a63f40e000000b003806a044335mr8137966pgi.523.1648680787404;
        Wed, 30 Mar 2022 15:53:07 -0700 (PDT)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id s20-20020aa78d54000000b004fac74c83b3sm24087581pfe.186.2022.03.30.15.53.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Mar 2022 15:53:06 -0700 (PDT)
Message-ID: <830e43a2-5c18-d26e-30ca-11a4dc59bb8b@linaro.org>
Date:   Wed, 30 Mar 2022 15:53:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 2/2] skbuff: Extract list pointers to silence compiler
 warnings
Content-Language: en-US
To:     Kees Cook <keescook@chromium.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
References: <20220329220256.72283-1-tadeusz.struk@linaro.org>
 <20220329220256.72283-2-tadeusz.struk@linaro.org>
 <YkRtWs7ieUA/7Xg9@kroah.com>
 <7f3c25f5-33ac-b5f6-9c2e-17e2310a6377@linaro.org>
 <202203301444.78CE208@keescook>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <202203301444.78CE208@keescook>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/30/22 14:46, Kees Cook wrote:
> On Wed, Mar 30, 2022 at 07:59:57AM -0700, Tadeusz Struk wrote:
>> On 3/30/22 07:46, Greg KH wrote:
>>> On Tue, Mar 29, 2022 at 03:02:56PM -0700, Tadeusz Struk wrote:
>>>> Please apply this to stable 5.10.y, and 5.15.y
>>>> ---8<---
>>>>
>>>> From: Kees Cook<keescook@chromium.org>
>>>>
>>>> Upstream commit: 1a2fb220edca ("skbuff: Extract list pointers to silence compiler warnings")
>>>>
>>>> Under both -Warray-bounds and the object_size sanitizer, the compiler is
>>>> upset about accessing prev/next of sk_buff when the object it thinks it
>>>> is coming from is sk_buff_head. The warning is a false positive due to
>>>> the compiler taking a conservative approach, opting to warn at casting
>>>> time rather than access time.
>>>>
>>>> However, in support of enabling -Warray-bounds globally (which has
>>>> found many real bugs), arrange things for sk_buff so that the compiler
>>>> can unambiguously see that there is no intention to access anything
>>>> except prev/next.  Introduce and cast to a separate struct sk_buff_list,
>>>> which contains_only_  the first two fields, silencing the warnings:
>>> We don't have -Warray-bounds enabled on any stable kernel tree, so why
>>> is this needed?
>>>
>>> Where is this showing up as a problem?
>>
>> The issue shows up and hinders testing stable kernels in test automations
>> like syzkaller:
>>
>> https://syzkaller.appspot.com/text?tag=Error&x=12b3aac3700000
>>
>> Applying it to stable would enable more test coverage.
> 
> Hi! I think a better solution may be to backport this change instead:
> 
> 69d0db01e210 ("ubsan: remove CONFIG_UBSAN_OBJECT_SIZE")
> 
> i.e. remove CONFIG_UBSAN_OBJECT_SIZE entirely, which is the cause of
> these syzkaller splats.

That works for me. I will test it and send a request or a backport soon.

-- 
Thanks,
Tadeusz
