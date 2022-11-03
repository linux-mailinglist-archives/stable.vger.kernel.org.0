Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE3B61770B
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 08:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbiKCHAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 03:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiKCHAt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 03:00:49 -0400
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 401EFD6C;
        Thu,  3 Nov 2022 00:00:48 -0700 (PDT)
Received: by mail-wr1-f53.google.com with SMTP id z14so1246118wrn.7;
        Thu, 03 Nov 2022 00:00:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZzC5Szvl9Z156jo9Kk2FZH3TgN7ESH0pPMiGv9zWSJ4=;
        b=2aHEO2wNnJf/AElXEPg/H7Mt3/nGMraYofWctx95iaMUvgwA5h6KA/wQEwX+wBZRv1
         XzFdglS+IZv9IL5JOZp2+A4WIU0nWmN//kzlF8AFEE7sH+9DxWyNMI/UNvp8dLKeeK7i
         watcvsKQgmSuMu4UC/GD+X1LTQ1VX1/j1JRAk7mj3W/WMNIe+LnEJkmB4CmGlP/nQrwA
         t74tIODVaFjQZIVc2UuQJeVi+rslq8WTRovOPCV+pYi0wgkIMLWa2L6OB2I3EMHGvDsJ
         y0ZraCRnWyZni4okVvKqqYK57WMYVNrZ2/2XP7OrOgp683L0/GSNDVZWR4UPHJs02cxG
         HJGQ==
X-Gm-Message-State: ACrzQf3v5bzrc0ZMI5EIVvOeRjWFwO/qQzDqg+LukbLqFkmjh+RFGryx
        sTURYcFUFCItBp1ohJhbULU=
X-Google-Smtp-Source: AMsMyM6xw0QHAkUXApjyJZC+j6LAWfgFrD/lIVeC5Ca1XFZn7Bgxel16XfmUpugktKve2N5lflM+qQ==
X-Received: by 2002:adf:e446:0:b0:236:773b:c6f0 with SMTP id t6-20020adfe446000000b00236773bc6f0mr17826832wrm.55.1667458846552;
        Thu, 03 Nov 2022 00:00:46 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id q7-20020a05600c46c700b003b492753826sm279286wmo.43.2022.11.03.00.00.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Nov 2022 00:00:46 -0700 (PDT)
Message-ID: <79db9616-a2ee-9a1a-9a35-b82f65b6d15e@kernel.org>
Date:   Thu, 3 Nov 2022 08:00:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH] unicode: don't write -1 after NULL terminator
Content-Language: en-US
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        krisman@collabora.com
Cc:     stable@vger.kernel.org
References: <20221103012411.86537-1-Jason@zx2c4.com>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20221103012411.86537-1-Jason@zx2c4.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 03. 11. 22, 2:24, Jason A. Donenfeld wrote:
> If the intention is to overwrite the first NULL with a -1, s[strlen(s)]
> is the first NULL, not s[strlen(s)+1].

This caught my attention. You mix NULL (void *) with NUL (\0) in the 
changelog & subject. That occurs rather confusing to me.

> Cc: Gabriel Krisman Bertazi <krisman@collabora.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>   fs/unicode/mkutf8data.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/unicode/mkutf8data.c b/fs/unicode/mkutf8data.c
> index bc1a7c8b5c8d..61800e0d3226 100644
> --- a/fs/unicode/mkutf8data.c
> +++ b/fs/unicode/mkutf8data.c
> @@ -3194,7 +3194,7 @@ static int normalize_line(struct tree *tree)
>   	/* Second test: length-limited string. */
>   	s = buf2;
>   	/* Replace NUL with a value that will cause an error if seen. */
> -	s[strlen(s) + 1] = -1;
> +	s[strlen(s)] = -1;
>   	t = buf3;
>   	if (utf8cursor(&u8c, tree, s))
>   		return -1;

-- 
js
suse labs

