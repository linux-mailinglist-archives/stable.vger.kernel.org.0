Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A435B6BFB83
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 17:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjCRQ0I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 12:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjCRQ0I (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 12:26:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E65CD515
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 09:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679156724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RMLleG2DXcNogGAuAWxYrgTG9bG50WKJ62cIAjwjdNE=;
        b=B7UJAcBAjpdi1GSanRznzEFjKgfyeT4DDcUt8RlRgnDfRoJr4pP0PlUpv55NaQJ16fXKeT
        fnoQI2H81rmtG4l1WoZwS6hTgYIaaWO66NDT8yQHLJN6RLQtyvGB+MaGBOoRBSRjebpa1I
        ahODhs1voZTDkr84NVeMCCCwSTs9gJA=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-244-fCPpl2VcOqa90PlOs_ZmCw-1; Sat, 18 Mar 2023 12:25:23 -0400
X-MC-Unique: fCPpl2VcOqa90PlOs_ZmCw-1
Received: by mail-ed1-f71.google.com with SMTP id e18-20020a056402191200b004fa702d64b3so11984040edz.23
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 09:25:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679156722;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RMLleG2DXcNogGAuAWxYrgTG9bG50WKJ62cIAjwjdNE=;
        b=7mit3x/4d4hiyq8fCNRG/runTyweAAi3krSE5f4cspXCGyjIDN7pzp0b82IOMh/x0U
         qdP8VgpLRMCH15BTlWLrzZ/l8XwcBFr2soFG4xpBL3L5vy+AdecZ6QuoQ4LYKFFjkZWd
         V1MnN4z/Pafzr5/Y5wwek07KbkPI4ek7xbccHxzkiZVzJYPNjsKgXWR3ekq4Yc1i+ulf
         Dee/LxmMa6yII+XAszSezvsdLrGZOy1Tm6BTpCnbZGFYQQeyiLEbb/VveGCfd64Y7k2J
         Cu39XP6mCU3jCVmsYES5PjLF7xPylHE2sAHXnm63R0KYM/Ou/RQdqLKmoClc5tQkC2bp
         cciQ==
X-Gm-Message-State: AO0yUKWLCl4QJ4hx8AlXRBDgFktnt9CpDo9YU4itARUQz5dRE9LwEYIa
        jjIFCAUFO2/e57ymsvURtUkyNVDl4mRP1nZw2fYd7KRJggmjh8LANDTQSpW1k56cEl/8KbMLUWi
        l6TbNX1m2Vy4N312Y
X-Received: by 2002:a17:907:8690:b0:933:3a65:67ed with SMTP id qa16-20020a170907869000b009333a6567edmr2477142ejc.75.1679156721977;
        Sat, 18 Mar 2023 09:25:21 -0700 (PDT)
X-Google-Smtp-Source: AK7set/0JZzssF+//gwBugYtJOfPoHdL9gBfMtdVZPgFd+DEMg4E7q1aCuABo4Gc7m0xJc3btkS1Og==
X-Received: by 2002:a17:907:8690:b0:933:3a65:67ed with SMTP id qa16-20020a170907869000b009333a6567edmr2477124ejc.75.1679156721688;
        Sat, 18 Mar 2023 09:25:21 -0700 (PDT)
Received: from ?IPV6:2001:1c00:c32:7800:5bfa:a036:83f0:f9ec? (2001-1c00-0c32-7800-5bfa-a036-83f0-f9ec.cable.dynamic.v6.ziggo.nl. [2001:1c00:c32:7800:5bfa:a036:83f0:f9ec])
        by smtp.gmail.com with ESMTPSA id qq24-20020a17090720d800b008df7d2e122dsm2318909ejb.45.2023.03.18.09.25.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Mar 2023 09:25:21 -0700 (PDT)
Message-ID: <bbb03157-d1e4-4db0-82ef-03e339ca30e6@redhat.com>
Date:   Sat, 18 Mar 2023 17:25:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] input: alps: fix compatibility with -funsigned-char
To:     msizanoen <msizanoen@qtmlabs.xyz>,
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     stable@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230318144206.14309-1-msizanoen@qtmlabs.xyz>
Content-Language: en-US, nl
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20230318144206.14309-1-msizanoen@qtmlabs.xyz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 3/18/23 15:42, msizanoen wrote:
> The AlpsPS/2 code previously relied on the assumption that `char` is a
> signed type, which was true on x86 platforms (the only place where this
> driver is used) before kernel 6.2. However, on 6.2 and later, this
> assumption is broken due to the introduction of -funsigned-char as a new
> global compiler flag.
> 
> Fix this by explicitly specifying the signedness of `char` when sign
> extending the values received from the device.
> 
> Fixes: f3f33c677699 ("Input: alps - Rushmore and v7 resolution support")
> Cc: stable@vger.kernel.org
> Signed-off-by: msizanoen <msizanoen@qtmlabs.xyz>

Thanks, patch looks good to me:

Reviewed-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans


> ---
>  drivers/input/mouse/alps.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
> index 989228b5a0a4..1c570d373b30 100644
> --- a/drivers/input/mouse/alps.c
> +++ b/drivers/input/mouse/alps.c
> @@ -2294,20 +2294,20 @@ static int alps_get_v3_v7_resolution(struct psmouse *psmouse, int reg_pitch)
>  	if (reg < 0)
>  		return reg;
>  
> -	x_pitch = (char)(reg << 4) >> 4; /* sign extend lower 4 bits */
> +	x_pitch = (signed char)(reg << 4) >> 4; /* sign extend lower 4 bits */
>  	x_pitch = 50 + 2 * x_pitch; /* In 0.1 mm units */
>  
> -	y_pitch = (char)reg >> 4; /* sign extend upper 4 bits */
> +	y_pitch = (signed char)reg >> 4; /* sign extend upper 4 bits */
>  	y_pitch = 36 + 2 * y_pitch; /* In 0.1 mm units */
>  
>  	reg = alps_command_mode_read_reg(psmouse, reg_pitch + 1);
>  	if (reg < 0)
>  		return reg;
>  
> -	x_electrode = (char)(reg << 4) >> 4; /* sign extend lower 4 bits */
> +	x_electrode = (signed char)(reg << 4) >> 4; /* sign extend lower 4 bits */
>  	x_electrode = 17 + x_electrode;
>  
> -	y_electrode = (char)reg >> 4; /* sign extend upper 4 bits */
> +	y_electrode = (signed char)reg >> 4; /* sign extend upper 4 bits */
>  	y_electrode = 13 + y_electrode;
>  
>  	x_phys = x_pitch * (x_electrode - 1); /* In 0.1 mm units */

