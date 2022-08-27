Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7415A35B3
	for <lists+stable@lfdr.de>; Sat, 27 Aug 2022 09:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbiH0HvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Aug 2022 03:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbiH0HvO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Aug 2022 03:51:14 -0400
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39D425C40;
        Sat, 27 Aug 2022 00:51:12 -0700 (PDT)
Received: by mail-ed1-f44.google.com with SMTP id b44so4515099edf.9;
        Sat, 27 Aug 2022 00:51:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=9aJASg3DbmlcvW4GqcDsy2Ha1OLvo6SjlyAb3ozLG2I=;
        b=SbvmZXc38Uck8opcapveH9Z0A7q2Y0XlhfUVPCOc7rTvCVDD9jIK/12mbjL2kknzQ/
         zePMZ1XhOzKzQD5nbcwQJo+Bhhh4eCeongFizUvzXbEahkXMEq+ClqeqFu1EyCnI/gxC
         KoWNBFKi9S4McxFSpBeGzVbS7r8C04foUz8gj5qPyqXwh/ungGyL+taRuIDgXLsrkHBZ
         FoQNCN4RhXI50zx4sXzcwFDLEiZYzw//vydpxTGW83cxk05HwzTj2fZmtQc6QRUGc0o0
         qTK5NZCmeJMI1LaIA59g4K5nyVh8gUwPoU66FdohVrU0lcM6FpzGA1m7JK4Atxgq3eZ4
         yeMg==
X-Gm-Message-State: ACgBeo1Xj2HEsO7YfNdnp0LpbXUcD18kJGSb61UyPKQLiDv5vvH9Djke
        ePTN+8jHj1v2tVdsBzn/DGXMeEPFfEs=
X-Google-Smtp-Source: AA6agR47VKAWPvE5G/lnfjA1jqUxY7uPHYKkjKqYUsGzraZ5F2Rark6IIDKsFOShSY8nS9YwNx7r7A==
X-Received: by 2002:aa7:ca46:0:b0:447:af0a:be68 with SMTP id j6-20020aa7ca46000000b00447af0abe68mr8898417edt.327.1661586671021;
        Sat, 27 Aug 2022 00:51:11 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::49? ([2a0b:e7c0:0:107::49])
        by smtp.gmail.com with ESMTPSA id a8-20020aa7cf08000000b0044604ad8b41sm2380616edy.23.2022.08.27.00.51.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Aug 2022 00:51:10 -0700 (PDT)
Message-ID: <9996285f-5a50-e56a-eb1c-645598381a20@kernel.org>
Date:   Sat, 27 Aug 2022 09:51:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH 5.19 145/365] kbuild: dummy-tools: avoid tmpdir leak in
 dummy gcc
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>,
        Masahiro Yamada <masahiroy@kernel.org>
References: <20220823080118.128342613@linuxfoundation.org>
 <20220823080124.294570326@linuxfoundation.org>
Content-Language: en-US
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20220823080124.294570326@linuxfoundation.org>
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

On 23. 08. 22, 10:00, Greg Kroah-Hartman wrote:
> From: Ondrej Mosnacek <omosnace@redhat.com>
> 
> commit aac289653fa5adf9e9985e4912c1d24a3e8cbab2 upstream.
> 
> When passed -print-file-name=plugin, the dummy gcc script creates a
> temporary directory that is never cleaned up. To avoid cluttering
> $TMPDIR, instead use a static directory included in the source tree.

This breaks our (SUSE) use of dummy tools (GCC_PLUGINS became =n). I 
will investigate whether this is stable-only and the root cause later.

> Fixes: 76426e238834 ("kbuild: add dummy toolchains to enable all cc-option etc. in Kconfig")
> Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   .../dummy-tools/dummy-plugin-dir/include/plugin-version.h | 0
>   scripts/dummy-tools/gcc |    8 ++------
>   1 file changed, 2 insertions(+), 6 deletions(-)
>   create mode 100644 scripts/dummy-tools/dummy-plugin-dir/include/plugin-version.h
> 
> --- a/scripts/dummy-tools/gcc
> +++ b/scripts/dummy-tools/gcc
> @@ -96,12 +96,8 @@ fi
>   
>   # To set GCC_PLUGINS
>   if arg_contain -print-file-name=plugin "$@"; then
> -	plugin_dir=$(mktemp -d)
> -
> -	mkdir -p $plugin_dir/include
> -	touch $plugin_dir/include/plugin-version.h
> -
> -	echo $plugin_dir
> +	# Use $0 to find the in-tree dummy directory
> +	echo "$(dirname "$(readlink -f "$0")")/dummy-plugin-dir"
>   	exit 0
>   fi
>   
> 
> 

-- 
js
suse labs

