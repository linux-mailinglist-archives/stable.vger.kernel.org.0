Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B16CB66B6ED
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 06:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbjAPFoO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 00:44:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231689AbjAPFoN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 00:44:13 -0500
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD234EF9
        for <stable@vger.kernel.org>; Sun, 15 Jan 2023 21:44:12 -0800 (PST)
Received: by mail-wm1-f48.google.com with SMTP id f25-20020a1c6a19000000b003da221fbf48so5008742wmc.1
        for <stable@vger.kernel.org>; Sun, 15 Jan 2023 21:44:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7zRCfVXAHn6QI7MUc3yzNddVItUeMkttZMVHdMI9lzI=;
        b=1W4osr9lR7YybB5lxRDEEP2ek5qKpjWSAQq5n2rom1ou2Se2rY/f9QBP4rE0T0Pu1W
         pkEJTWVLIV2hMF+npURQjgz/hI/4E4eQdRvrwhjBDiIB+NOXtsZFxzCYHoP8VglUO0GS
         GWFEFue1SifV7omiIQb3Ov0RlS8NFiX4FQOTn9XJlDze05mcRXvmlja7hVqISsB9AEjH
         7PXelWdENj32qhyX98ZkhpLnt47ng8JYR9uY6orrhKcyxjm+NOL1542W6qbK8XqojD7O
         rue1LoMYeZbC2lo9MUcx1w9GN+7csEEDUlWcVbME9bvmbHrir9njOskT72zbTElSRzIt
         gmig==
X-Gm-Message-State: AFqh2kq83ZUXxe8c+baBvsSHqhq9I68951P10jGfx18/iQB2/i64yUsf
        aO7d91VH8CxhqkEQn1nDChpLgmELiEU=
X-Google-Smtp-Source: AMrXdXs/lEjg0thvylnDtAtEHXTD/Wa8S6KWaDuNlRMVx6agb9MEQayHgLF1TjfYsEn8WR01Jr08cQ==
X-Received: by 2002:a05:600c:1c1b:b0:3da:fada:e38a with SMTP id j27-20020a05600c1c1b00b003dafadae38amr2395835wms.24.1673847851170;
        Sun, 15 Jan 2023 21:44:11 -0800 (PST)
Received: from ?IPV6:2a0b:e7c0:0:107::aaaa:49? ([2a0b:e7c0:0:107::aaaa:49])
        by smtp.gmail.com with ESMTPSA id 2-20020a05600c020200b003d9ef8ad6b2sm24204067wmi.13.2023.01.15.21.44.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Jan 2023 21:44:10 -0800 (PST)
Message-ID: <7ecae85c-7562-aee6-a174-5d12af3c64b1@kernel.org>
Date:   Mon, 16 Jan 2023 06:44:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 6.1 09/10] gcc: disable -Warray-bounds for gcc-11 too
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, Kees Cook <kees@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Guenter Roeck <linux@roeck-us.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20230112135326.981869724@linuxfoundation.org>
 <20230112135327.373332907@linuxfoundation.org>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20230112135327.373332907@linuxfoundation.org>
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

On 12. 01. 23, 14:56, Greg Kroah-Hartman wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> 
> commit 5a41237ad1d4b62008f93163af1d9b1da90729d8 upstream.
> 
> We had already disabled this warning for gcc-12 due to bugs in the value
> range analysis, but it turns out we end up having some similar problems
> with gcc-11.3 too, so let's disable it there too.
> 
> Older gcc versions end up being increasingly less relevant, and
> hopefully clang and newer version of gcc (ie gcc-13) end up working
> reliably enough that we still get the build coverage even when we
> disable this for some versions.

No, this did not happen and I sent a patch for gcc 13 long time ago (it 
was not applied):
https://lore.kernel.org/all/20221031114212.10266-1-jirislaby@kernel.org/

So should we simply make it CC_IS_GCC && GCC_VERSION >= 110000 until 
this gets resolved eventually?

> Link: https://lore.kernel.org/all/20221227002941.GA2691687@roeck-us.net/
> Link: https://lore.kernel.org/all/D8BDBF66-E44C-45D4-9758-BAAA4F0C1998@kernel.org/
> Cc: Kees Cook <kees@kernel.org>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   init/Kconfig |    6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -892,13 +892,17 @@ config CC_IMPLICIT_FALLTHROUGH
>   	default "-Wimplicit-fallthrough=5" if CC_IS_GCC && $(cc-option,-Wimplicit-fallthrough=5)
>   	default "-Wimplicit-fallthrough" if CC_IS_CLANG && $(cc-option,-Wunreachable-code-fallthrough)
>   
> -# Currently, disable gcc-12 array-bounds globally.
> +# Currently, disable gcc-11,12 array-bounds globally.
>   # We may want to target only particular configurations some day.
> +config GCC11_NO_ARRAY_BOUNDS
> +	def_bool y
> +
>   config GCC12_NO_ARRAY_BOUNDS
>   	def_bool y
>   
>   config CC_NO_ARRAY_BOUNDS
>   	bool
> +	default y if CC_IS_GCC && GCC_VERSION >= 110000 && GCC_VERSION < 120000 && GCC11_NO_ARRAY_BOUNDS
>   	default y if CC_IS_GCC && GCC_VERSION >= 120000 && GCC_VERSION < 130000 && GCC12_NO_ARRAY_BOUNDS
>   
>   #
> 
> 

-- 
js
suse labs

