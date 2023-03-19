Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5D9E6C0072
	for <lists+stable@lfdr.de>; Sun, 19 Mar 2023 10:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbjCSJ4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 05:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjCSJ4d (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 05:56:33 -0400
Received: from hyperium.qtmlabs.xyz (hyperium.qtmlabs.xyz [194.163.182.183])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D285423A7E;
        Sun, 19 Mar 2023 02:56:23 -0700 (PDT)
Received: from dong.kernal.eu (unknown [222.254.17.84])
        by hyperium.qtmlabs.xyz (Postfix) with ESMTPSA id B253C820068;
        Sun, 19 Mar 2023 10:56:21 +0100 (CET)
Received: from [172.20.10.2] (unknown [27.67.137.222])
        by dong.kernal.eu (Postfix) with ESMTPSA id 37D4044496AC;
        Sun, 19 Mar 2023 16:56:17 +0700 (+07)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qtmlabs.xyz; s=syka;
        t=1679219777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DJI5NqP+7UPBiESx9Y6xUHlCLtPOkNMX1Uu0kNfBbrk=;
        b=B+LOu8hbwgyeI82gMu/DdcpT2Wmc2CB+RCXcIDMGqCsecbSWz7233uAXkwYDs5RWsFKx0I
        Bke44w9C2XuiBbJfeIkanCfJT3Twdw2qGuhhhcjSUFjWXJ2SYJiKpiCW8BJFNTy2sSts0D
        hYkpGvFaTmijfE7lzUSCjWg9uDQgRarkiNLCx3MXtdnlsoHYpCCuNUKmpjcdlunaWz8FgQ
        ymhmD6hmYbdeoV3RviqLx7Q7w5nKJYmtCXBMEvkXfD556QxTkNYbmJAtJientZhLo5LzQc
        ZHPdIMuxgig9Qa47WgIPxUfb2LEg/hZ6+HnxYhHxOv7Rem4Jhf5PVOyuPV1yFw==
Message-ID: <1fd818c2-4e68-8760-9123-de4fa1920c6b@qtmlabs.xyz>
Date:   Sun, 19 Mar 2023 16:56:11 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] input: alps: fix compatibility with -funsigned-char
Content-Language: en-US
To:     =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>
Cc:     stable@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230318144206.14309-1-msizanoen@qtmlabs.xyz>
From:   msizanoen <msizanoen@qtmlabs.xyz>
In-Reply-To: <20230318144206.14309-1-msizanoen@qtmlabs.xyz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_SORBS_WEB,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Patch confirmed working as expected on real hardware.

Tested-by: msizanoen <msizanoen@qtmlabs.xyz>

On 3/18/23 21:42, msizanoen wrote:
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
> ---
>   drivers/input/mouse/alps.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
> index 989228b5a0a4..1c570d373b30 100644
> --- a/drivers/input/mouse/alps.c
> +++ b/drivers/input/mouse/alps.c
> @@ -2294,20 +2294,20 @@ static int alps_get_v3_v7_resolution(struct psmouse *psmouse, int reg_pitch)
>   	if (reg < 0)
>   		return reg;
>   
> -	x_pitch = (char)(reg << 4) >> 4; /* sign extend lower 4 bits */
> +	x_pitch = (signed char)(reg << 4) >> 4; /* sign extend lower 4 bits */
>   	x_pitch = 50 + 2 * x_pitch; /* In 0.1 mm units */
>   
> -	y_pitch = (char)reg >> 4; /* sign extend upper 4 bits */
> +	y_pitch = (signed char)reg >> 4; /* sign extend upper 4 bits */
>   	y_pitch = 36 + 2 * y_pitch; /* In 0.1 mm units */
>   
>   	reg = alps_command_mode_read_reg(psmouse, reg_pitch + 1);
>   	if (reg < 0)
>   		return reg;
>   
> -	x_electrode = (char)(reg << 4) >> 4; /* sign extend lower 4 bits */
> +	x_electrode = (signed char)(reg << 4) >> 4; /* sign extend lower 4 bits */
>   	x_electrode = 17 + x_electrode;
>   
> -	y_electrode = (char)reg >> 4; /* sign extend upper 4 bits */
> +	y_electrode = (signed char)reg >> 4; /* sign extend upper 4 bits */
>   	y_electrode = 13 + y_electrode;
>   
>   	x_phys = x_pitch * (x_electrode - 1); /* In 0.1 mm units */
