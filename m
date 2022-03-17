Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A88C4DCC1D
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 18:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbiCQRLL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 13:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233524AbiCQRLK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 13:11:10 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E0F41B5391
        for <stable@vger.kernel.org>; Thu, 17 Mar 2022 10:09:54 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 6so3122810pgg.0
        for <stable@vger.kernel.org>; Thu, 17 Mar 2022 10:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ade7f1P1CSAQaJzbV2GQaUiWTEvAUMAARtQaqGEvAO0=;
        b=U47RVH59vYPLRXxwfWP5arR1fEoVUd2RCRndUdOqEkTYGWWbpeIMWYxrCcVhJcmw6B
         SgONUEEAUFFRuH1HiuLB1747+SZ0A7cB+RrOWG5M3tWoeHXD9pgsE1QEG90NHwoW5mdN
         4c4XdxxaO387sLqcUS7YY9mRu1b5yEvCjYDib6/6j10a2uX/dKuPcJKklR4DOlfjROKA
         mfv1quCk6Jt/K7RmKppgAnXrzoqy1xNWN5THte17nN/9GxSf76hcWIb88/3xxqeky5wn
         uKxKggYFK2+KZJf5cT0DkyyZz6p/Ti58Mu4sfsoNOnd2sdIGgr3AYP4pQL38bBmN0x5I
         rG8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ade7f1P1CSAQaJzbV2GQaUiWTEvAUMAARtQaqGEvAO0=;
        b=WvogMRJqLLZPaPdLGw3vGkhiXAk6WmNDZgENYOxg4J1W8mrKKMYxFnPqLF6nKfx7yi
         aQqncj1/ziSqUt1KLI3Q2ugKBsZewRAsXw124VMZyGm3H2TADiS+wkvx+pH1FlA9xIq9
         TldhZ24Q1nV4POlHEy+Np1flBirrJohFUPj8lNnrtnspsxre2wdhqbZeSJJDPecK1s03
         PzqjyKxuBBAXjMXyAmyPmD3KmHfdvAqu1iDIXwEf3f0pJOPflS9Q+DYDss1kWUoCr6SH
         PFD0yN9gTZGISqe17ozY1MKsPnCIfyFyLxw875777xUX9y4staVyfhUqJqHNklLIzSrx
         kL6w==
X-Gm-Message-State: AOAM532JpuAs4FGGi4vSQBpMowyUL8whH3ZsNmkjfNu+3kXuYPGsR+vn
        mXPsngOPLCDkB2L8tEinIrnXAw==
X-Google-Smtp-Source: ABdhPJyGFkEKhZGmDMyOF+1TAm/ClL+yJUY5wohKP1Fj8TGGbVjs+Vw2WaXTdxDquLhD4uiMtlbD2A==
X-Received: by 2002:a63:5c5c:0:b0:382:2812:9d9d with SMTP id n28-20020a635c5c000000b0038228129d9dmr258467pgm.227.1647536993643;
        Thu, 17 Mar 2022 10:09:53 -0700 (PDT)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id d15-20020a056a00198f00b004f7109da1c4sm7215618pfl.205.2022.03.17.10.09.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Mar 2022 10:09:53 -0700 (PDT)
Message-ID: <d4041c47-73e9-a9f4-cffc-327dcf1e668c@linaro.org>
Date:   Thu, 17 Mar 2022 10:09:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH 5.10] esp: Fix possible buffer overflow in ESP
 transformation
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     sec@valis.email, stable@vger.kernel.org,
        steffen.klassert@secunet.com,
        syzbot+93ab2623dcb5c73eda9f@syzkaller.appspotmail.com
References: <164724987520346@kroah.com>
 <20220317164159.1916929-1-tadeusz.struk@linaro.org>
 <YjNoIEs7+qTgq7XE@kroah.com>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <YjNoIEs7+qTgq7XE@kroah.com>
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

On 3/17/22 09:56, Greg KH wrote:
> On Thu, Mar 17, 2022 at 09:41:59AM -0700, Tadeusz Struk wrote:
>> From: Steffen Klassert <steffen.klassert@secunet.com>
>>
>> Plese apply this on 5.10.y stable as well as it fixes the following
>> syzbot issues:
>>
>> LINK: https://syzkaller.appspot.com/bug?id=517fa734b92b7db404c409b924cf5c997640e324
>> LINK: https://syzkaller.appspot.com/bug?id=57375340ab81a369df5da5eb16cfcd4aef9dfb9d
>>
>> Here is a working patch.
>> ---8<---
>>
>> The maximum message size that can be send is bigger than
>> the  maximum site that skb_page_frag_refill can allocate.
>> So it is possible to write beyond the allocated buffer.
>>
>> Fix this by doing a fallback to COW in that case.
>>
>> Fixes: cac2661c53f3 ("esp4: Avoid skb_cow_data whenever possible")
>> Fixes: 03e2a30f6a27 ("esp6: Avoid skb_cow_data whenever possible")
>> Reported-by: valis <sec@valis.email>
>> Reported-by: <syzbot+93ab2623dcb5c73eda9f@syzkaller.appspotmail.com>
>> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
>> Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
>> ---
>>   include/net/esp.h  | 2 ++
>>   include/net/sock.h | 1 +
>>   net/ipv4/esp4.c    | 5 +++++
>>   net/ipv6/esp6.c    | 5 +++++
>>   4 files changed, 13 insertions(+)
> 
> What is the git commit id of this commit in Linus's tree?
> 

It's this one:

ebe48d368e97 ("esp: Fix possible buffer overflow in ESP transformation")

Sorry I forgot to include it in the backport.

-- 
Thanks,
Tadeusz
