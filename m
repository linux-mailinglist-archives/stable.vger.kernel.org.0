Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21388553098
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 13:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348880AbiFULTc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 07:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348993AbiFULTb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 07:19:31 -0400
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321642A267
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 04:19:30 -0700 (PDT)
Received: by mail-ej1-f48.google.com with SMTP id h23so26722791ejj.12
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 04:19:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6GT3pTetXf6hbaKxFB1K/Bvj+tAXWxjXhsuH42cKoLI=;
        b=aGM6Hxjy36WtrC345EZ59/McX3cMJ6vaI/erHJPgoNnY8d7nI7AaPi+EuR/PGxrjPN
         g0WpeXAGdG5ykSaxz7IJflOkaPuOK45oYTb0EYPLnnFqr9bRP+MAugv/Oi98ycDGKR9z
         R8qM+MuBdxEM4X41ZlN+pShL+DZ0sjjE9lOEgJoF7RRgCzgUNDN4t5wFiY0IbEZV6giQ
         rh01dT7MOZiyxSdkIH4JOJzN0hSewJhVka/NGIJVWZzJ5LGrXZVUg3TBR6xBCzMVU/5R
         w/kgAjAieX4CfVRN6WPTEakWYsePDkpakrbobek4CJnun0iJ7p8PvZUha2E8Zi5W28Vb
         kkrQ==
X-Gm-Message-State: AJIora920Ioxb9FqsjUk7wsu387yipDsnIdWpQ+zmJ6BUAx7yB++z716
        GtJQ558ioHQykDnL1Lg3366k7kuPM6jgJQ==
X-Google-Smtp-Source: AGRyM1u1J+kNTkEXAdpYu8b29eIyNCh84jpe3jQQxT1OzcAUSu0uq62Mw1pWF1leiIZ415dQVWsXAw==
X-Received: by 2002:a17:906:d7:b0:718:df95:985 with SMTP id 23-20020a17090600d700b00718df950985mr24653634eji.582.1655810368765;
        Tue, 21 Jun 2022 04:19:28 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id k11-20020a17090632cb00b00705cdfec71esm7475131ejk.7.2022.06.21.04.19.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jun 2022 04:19:28 -0700 (PDT)
Message-ID: <d323af21-74a7-f4bf-a379-f7d48ad4263b@kernel.org>
Date:   Tue, 21 Jun 2022 13:19:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: patch request for 5.18-stable to fix gcc-12 build (hopefully
 last)
Content-Language: en-US
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stable <stable@vger.kernel.org>
References: <YrGZxGoKgKxcvVTG@debian>
 <ce23efa0-70d3-41f4-eb4a-ea047e0dfb91@kernel.org>
 <CADVatmN869Y6r7=ds2s_K0yXGN4RYKnZZy5413V+V8Eq+3WHuw@mail.gmail.com>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <CADVatmN869Y6r7=ds2s_K0yXGN4RYKnZZy5413V+V8Eq+3WHuw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21. 06. 22, 13:14, Sudip Mukherjee wrote:
> On Tue, Jun 21, 2022 at 11:39 AM Jiri Slaby <jirislaby@kernel.org> wrote:
>>
>> On 21. 06. 22, 12:13, Sudip Mukherjee wrote:
>>> Hi Greg,
>>>
>>> The following will be needed for the gcc-12 builds:
>>>
>>> ee3db469dd31 ("wifi: rtlwifi: remove always-true condition pointed out by GCC 12")
>>> 32329216ca1d ("eth: sun: cassini: remove dead code")
>>> dbbc7d04c549 ("net: wwan: iosm: remove pointless null check")
>>>
>>>
>>> With this 3 applied on top of v5.18.6-rc1 allmodconfig for x86_64, riscv
>>> and mips passes. (not checked other arch yet)
>>>
>>> Will request you to add these to 5.18-stable queue please.
>>
>> On the top of that, I had to apply this too:
>> aeb84412037b x86/boot: Wrap literal addresses in absolute_pointer()
> 
> uhhh... I thought -Warray-bounds has been disabled by:
> f0be87c42cbd ("gcc-12: disable '-Warray-bounds' universally for now")
> which is in v5.18.6-rc1 now.
> 
> Are you sure you still need that ?

Yes -- I'd say realmode doesn't copy KBUILD_CFLAGS.

-- 
js
suse labs
