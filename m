Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 235FE5BCA07
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 12:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbiISKyI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 06:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbiISKxq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 06:53:46 -0400
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DFDFF16;
        Mon, 19 Sep 2022 03:49:47 -0700 (PDT)
Received: by mail-ej1-f42.google.com with SMTP id y3so63547289ejc.1;
        Mon, 19 Sep 2022 03:49:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=meC2VdD2Xd6s7HoqRo+q1lRDIcjErU1huloDKPbW78w=;
        b=Suqt+mqAiopwOKoqmx34ip/cKUJMEKRclkMu5uXSm08IIKWrURv9Cj6/IYbkY02UY5
         gtHD5xSHKUtdLzNc7X+BLR3sXDicTl+d48F0r7jxT5eo+OePJLNMaw6eEgPxVixl5puM
         AKYkHPuMKn1ee4eCoAlVlmkb4Bq258UIPYnlBx2GhFutxwJUX/Jr7/i3qexlQC4HtNlG
         /TJNkoddsDqicEO6NLCUXPF+sGAvPeiMFS3eKN8IM74HVX4QS3UMK5cnP+zL3F50KZr5
         2FwQ0+tUFF/Ige/ZUla6NyI6px8NBr2k9kjFKUKwpQfe/FPFhDYIQMzIm7rKE8uIJNG4
         Czfg==
X-Gm-Message-State: ACrzQf24Xw2Gr1mb66u4y5TLGp/HtLwWyr7CnB+imDr4Vqp3v15G2i/9
        E1BdcYd5pE92il7LmH8GYxCZtqIjfqM=
X-Google-Smtp-Source: AMsMyM7uh0UiLJZl9j8MB8GqN87EqKECdAWsrEdxOEUpih4Fa2RdQHSOFWRGFeOn4fJabGx1O9owBg==
X-Received: by 2002:a17:907:2cf3:b0:77d:89da:499c with SMTP id hz19-20020a1709072cf300b0077d89da499cmr11998463ejc.694.1663584585322;
        Mon, 19 Sep 2022 03:49:45 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id 9-20020a170906200900b0072b41776dd1sm15313750ejo.24.2022.09.19.03.49.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Sep 2022 03:49:44 -0700 (PDT)
Message-ID: <ec300579-9565-a96a-2e8e-a42363fd9ad7@kernel.org>
Date:   Mon, 19 Sep 2022 12:49:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 1/2] serial: 8250: Let drivers request full 16550A feature
 probing
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Anders Blomdell <anders.blomdell@control.lth.se>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <alpine.DEB.2.21.2209162317180.19473@angie.orcam.me.uk>
 <alpine.DEB.2.21.2209171043270.31781@angie.orcam.me.uk>
 <8fa701a1-3f34-9152-daf6-1618dd0e7727@kernel.org>
 <alpine.DEB.2.21.2209190911540.14808@angie.orcam.me.uk>
Content-Language: en-US
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <alpine.DEB.2.21.2209190911540.14808@angie.orcam.me.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 19. 09. 22, 10:18, Maciej W. Rozycki wrote:
> On Mon, 19 Sep 2022, Jiri Slaby wrote:
> 
>>> --- linux-macro.orig/include/linux/serial_core.h
>>> +++ linux-macro/include/linux/serial_core.h
>>> @@ -414,7 +414,7 @@ struct uart_icount {
>>>    	__u32	buf_overrun;
>>>    };
>>>    -typedef unsigned int __bitwise upf_t;
>>> +typedef __u64 __bitwise upf_t;
>>
>> Why __u64 and not u64?
> 
>   For consistency as there's `__u32' used elsewhere in this file.  It's not
> clear to me what our rules WRT the use of `s*'/`u*' vs `__s*'/`__u*' are.
> I don't think we have it mentioned under Documentation/.  Please clarify
> if you know and I can update the change accordingly.

The rule is, AFAICT, use __u*/__s* in user (uapi) headers. Everywhere 
else, use u*/s*.

>>> @@ -522,6 +522,7 @@ struct uart_port {
>>>    #define UPF_FIXED_PORT		((__force upf_t) (1 << 29))
>>>    #define UPF_DEAD		((__force upf_t) (1 << 30))
>>>    #define UPF_IOREMAP		((__force upf_t) (1 << 31))
>>> +#define UPF_FULL_PROBE		((__force upf_t) (1ULL << 32))
>>
>> This looks like a perfect time to switch them all to BIT_ULL().
> 
>   Good point, I keep forgetting about that macro.  I'll keep this part
> unchanged for the purpose of backporting and add 3/3 to switch all the
> macros over.

OK.

thanks,
-- 
js
suse labs

