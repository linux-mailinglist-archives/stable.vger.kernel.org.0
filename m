Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0485A7926
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 10:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbiHaIg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Aug 2022 04:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbiHaIg0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Aug 2022 04:36:26 -0400
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54958A6C04;
        Wed, 31 Aug 2022 01:36:22 -0700 (PDT)
Received: by mail-ed1-f43.google.com with SMTP id e18so9869016edj.3;
        Wed, 31 Aug 2022 01:36:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=eoBdlz3UxAt4OJMWcqBIsQb2pG1LV+gZCLEcEgMHwN4=;
        b=07XtgExLMSqvbaO/CTrJODH9vY4cjThLx5llHCsW0prW/5zTTzEITdwfFG68pJB+VK
         Y0sde8gjhOuuGNtwcyw865txY5cI6SPzvzj+B5+pbxKtvwTq2J1VPQ2evOA72va30sJv
         2UsJY89RverWKdUD1j/7n/g5s7/m9zCOe5F9FYrB3+j7R+3WerQLjmUCnTEjDJyzGhsc
         nNHBs/UkozvZIk7zHHPkDlTSTwlSA8JJ3kGD146LLwKMWrSO1xm3TIc1HapyaVnkP44F
         fZcSULAaFaUGtXUzufi9Aa0Qmm4SGq+3GytGOq05V7Gw71TYnuNWV+Kd2e/J+IUHM2oM
         UzBg==
X-Gm-Message-State: ACgBeo2/9aP8U8f1aF8Ek4ggpqhXtI/4FfUglfKbiz7Mjp7AWxTuTXOF
        3U5e34L2vMLm5wn3yUTj/EtZv6m6UU6zjg==
X-Google-Smtp-Source: AA6agR6cmMBIoZNnMIkivEC0hdZ5VeAguL/55mnTtG0s0HBAXx2Tpj/+yrYjFOdr5DhXEOMt2gLDSQ==
X-Received: by 2002:a05:6402:1911:b0:448:da24:5f23 with SMTP id e17-20020a056402191100b00448da245f23mr5020370edz.61.1661934980602;
        Wed, 31 Aug 2022 01:36:20 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id h7-20020a17090634c700b0073dde62713asm6786756ejb.89.2022.08.31.01.36.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Aug 2022 01:36:20 -0700 (PDT)
Message-ID: <863b4190-9b38-ed5a-0a18-74505702da21@kernel.org>
Date:   Wed, 31 Aug 2022 10:36:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH 1/2] USB: serial: ch341: fix lost character on LCR updates
Content-Language: en-US
To:     Johan Hovold <johan@kernel.org>,
        Jonathan Woithe <jwoithe@just42.net>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20220831081525.30557-1-johan@kernel.org>
 <20220831081525.30557-2-johan@kernel.org>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20220831081525.30557-2-johan@kernel.org>
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

On 31. 08. 22, 10:15, Johan Hovold wrote:
> Disable LCR updates for pre-0x30 devices which use a different (unknown)
> protocol for line control and where the current register write causes
> the next received character to be lost.
> 
> Note that updating LCR using the INIT command has no effect on these
> devices either.
> 
> Reported-by: Jonathan Woithe <jwoithe@just42.net>
> Link: https://lore.kernel.org/r/Ys1iPTfiZRWj2gXs@marvin.atrad.com.au
> Fixes: 4e46c410e050 ("USB: serial: ch341: reinitialize chip on reconfiguration")
> Fixes: 55fa15b5987d ("USB: serial: ch341: fix baud rate and line-control handling")
> Cc: stable@vger.kernel.org      # 4.10
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>   drivers/usb/serial/ch341.c | 10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
> index 2798fca71261..2bcce172355b 100644
> --- a/drivers/usb/serial/ch341.c
> +++ b/drivers/usb/serial/ch341.c
> @@ -97,7 +97,10 @@ struct ch341_private {
>   	u8 mcr;
>   	u8 msr;
>   	u8 lcr;
> +
>   	unsigned long quirks;
> +	u8 version;

Could you move version above quirks? That would not create another 
7-byte padding in here. Actually it would not make ch341_private larger 
on 64bit at all, if I am looking correctly.

Other than that, looks good.

thanks,
-- 
js
suse labs

