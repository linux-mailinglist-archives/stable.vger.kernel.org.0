Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB3BC4EC868
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 17:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348305AbiC3PkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 11:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348298AbiC3PkT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 11:40:19 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183C917ABB
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 08:38:32 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id i11so20793514plr.1
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 08:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=dufzbpkHBtIosdYvXPq5aCkAsTTFd9aQy7cYiJ4ew3Y=;
        b=Y7EukbdXStul398GhlZnxyY4HqdFcREKqD/1VRvRxECJbh4apJCK22oBXPaCq//tZs
         uMEZFOXkOBVey+EvUoxWHcIeFvNld7mWPYcCl92G03NVyJAOZy2PvQmY7ZT7mDSJV330
         GF1YtKctoYuTo328AdrM7OtlewoZrlHlynrQRs7yUIQpFafypF3nQIT1ulTfQZJLfezZ
         bt6OdBVHD3ZQ0y8Bqie8G6ywIEjYZ89gW4iOeNSBVTWJ24E6wXT2LCAWndWtHZeWa3RR
         Q6+wctO4fn2ydhlQE+MCxs44aKfXfsiErEs0uycgGTEHWfXMliCDfXSocSlKOCbECe/q
         OMiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dufzbpkHBtIosdYvXPq5aCkAsTTFd9aQy7cYiJ4ew3Y=;
        b=laek6xepAEnHf51qS9Za2SZtzoMZN0EZBKxI0orBS/igW0pyvmmOuaxOpSmOG+vT8P
         LoSfeFW8sPnoLxxZ42l+IKAkdMugth4tqpCxAMFr2KHrA4ulwiSsL2thFNOhQ74VPQyO
         O1VqoCvnx3U58OnAtca94p/eWaOaveheX62CC8z4fAWStl9DT73Lruk9WjZAjiQ2DO9h
         5Lxgy52otazVaO+3dSSizaZkQ3baY5iCgqatV6ySTz61ZTRPXRsZkYfRQsVJj0LtCPWJ
         6OVZvZUN8mzZuUz+PA2DfaQwRHMlySpxwzQnwEcPkgHoVaCOR8yuqVg13yMD0YAfr5O3
         gJHQ==
X-Gm-Message-State: AOAM531V/qCjgQVWopldIq/LIHXHaX40X7/ISQ5ElrwrjfC0zOrQHDSu
        hWJyexvjEWX1GMbE0sWPYPHLpwiQWSoOe9tugFM=
X-Google-Smtp-Source: ABdhPJwUMEH+IxxUK1ioIgooeNPxlpwV4Gi04O6nypjkYk3ZpHreh5cY2lPozMIaQYaABI7gWlxV8g==
X-Received: by 2002:a17:903:110c:b0:14d:8859:5c8 with SMTP id n12-20020a170903110c00b0014d885905c8mr35689381plh.156.1648654712085;
        Wed, 30 Mar 2022 08:38:32 -0700 (PDT)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id bw17-20020a056a00409100b004fadad3b93esm23291961pfb.142.2022.03.30.08.38.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Mar 2022 08:38:31 -0700 (PDT)
Message-ID: <350124a3-ce06-7310-d22b-bba146551344@linaro.org>
Date:   Wed, 30 Mar 2022 08:38:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 2/2] skbuff: Extract list pointers to silence compiler
 warnings
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <20220329220256.72283-1-tadeusz.struk@linaro.org>
 <20220329220256.72283-2-tadeusz.struk@linaro.org>
 <YkRtWs7ieUA/7Xg9@kroah.com>
 <7f3c25f5-33ac-b5f6-9c2e-17e2310a6377@linaro.org>
 <YkR3Qdao7cSf7sjV@kroah.com>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <YkR3Qdao7cSf7sjV@kroah.com>
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

On 3/30/22 08:29, Greg KH wrote:
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
> Ok, again, that was not obvious, it seemed like you only needed this for
> build warnings.

The original commit message was already long so I only added short statement
about UBSAN. I was afraid that if I add more details nobody would ready it ;)

Thanks!

-- 
Thanks,
Tadeusz
