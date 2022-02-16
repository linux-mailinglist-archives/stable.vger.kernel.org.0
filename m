Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 371EC4B8F1B
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 18:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237083AbiBPR2u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 12:28:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236544AbiBPR2u (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 12:28:50 -0500
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AD3120206E
        for <stable@vger.kernel.org>; Wed, 16 Feb 2022 09:28:37 -0800 (PST)
Received: by mail-oo1-xc2d.google.com with SMTP id f11-20020a4abb0b000000b002e9abf6bcbcso3313926oop.0
        for <stable@vger.kernel.org>; Wed, 16 Feb 2022 09:28:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9MTakSYd53t34R0cyYVe+0pdA5hAXTrGisq8/AtE8bY=;
        b=DPPjIZfSFOecn19FZTl4ORN4p58dli1n1BuYxmImPMtl4+gJTi3k5+lzdQHdsvkTv1
         dWP0bjICnHBFUQcMIMSelizKfRsRlgStn07af7cm1qRqbwU+n0P0D2GX+TldIYbIxWaJ
         fwoCuTxMOzWU8Y1jydUF/08UpstaObnClmFlw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9MTakSYd53t34R0cyYVe+0pdA5hAXTrGisq8/AtE8bY=;
        b=hSnXawBpOHdDqJPf5GX1YuMRTx2XL0dgJCToYVH7PLb87WN5I6JvutyyEgL3zLwlpX
         ucPNieYzq4rD8USzYsYRc8Vyd9UH0IP4xrsmxdPUmnx8PtK9eix2tsC4bkeKNgoY1Q9N
         38Z7moEwuzrPs1j1LPwgwa7R1iXYXklYbRu/QwUWYB7ooCOHGF3TiQHYLLBsftRqs8jJ
         GXTkx3B7W6f+u8bPTtOi73C8QbCMaiAk9bFyTTfYbEHLZwC+Eu+jpDHB3Y2nGMIjHFT4
         WQEMoeDNCJRyMHNmv2h57SrapkGia8uI63vIkPVJKUtvFkayqFR3r7zHxz/qMJ0jrozP
         Ku7Q==
X-Gm-Message-State: AOAM532nH7SSzaatk+/Nc94+irpjescLDZVq9LbgAyeUeg+IOaUAVoWQ
        zT2fu5XD16c3pH6XfgHp0ylNSA==
X-Google-Smtp-Source: ABdhPJyShlU/g48khtcUjhWKWDzQCiVsyvmr+ae3Lat2Rc9hLmhLqeYcshScLBld5g+g0YPNzqlUhg==
X-Received: by 2002:a05:6870:d620:b0:d0:ee38:dd65 with SMTP id a32-20020a056870d62000b000d0ee38dd65mr889156oaq.301.1645032516474;
        Wed, 16 Feb 2022 09:28:36 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id ek4sm17407139oab.23.2022.02.16.09.28.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Feb 2022 09:28:36 -0800 (PST)
Subject: Re: [PATCH v2 5/5] ucounts: Handle wrapping in is_ucounts_overlimit
To:     "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Cc:     Alexey Gladkov <legion@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Solar Designer <solar@openwall.com>,
        Ran Xiaokai <ran.xiaokai@zte.com.cn>,
        containers@lists.linux-foundation.org,
        =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>,
        linux-api@vger.kernel.org, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <87ilteiz4a.fsf_-_@email.froward.int.ebiederm.org>
 <20220216155832.680775-5-ebiederm@xmission.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <a616b08c-dcec-4a00-ca55-a333063157e9@linuxfoundation.org>
Date:   Wed, 16 Feb 2022 10:28:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220216155832.680775-5-ebiederm@xmission.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/16/22 8:58 AM, Eric W. Biederman wrote:
> While examining is_ucounts_overlimit and reading the various messages
> I realized that is_ucounts_overlimit fails to deal with counts that
> may have wrapped.
> 
> Being wrapped should be a transitory state for counts and they should
> never be wrapped for long, but it can happen so handle it.
> 
> Cc: stable@vger.kernel.org
> Fixes: 21d1c5e386bc ("Reimplement RLIMIT_NPROC on top of ucounts")
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>   kernel/ucount.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/ucount.c b/kernel/ucount.c
> index 65b597431c86..06ea04d44685 100644
> --- a/kernel/ucount.c
> +++ b/kernel/ucount.c
> @@ -350,7 +350,8 @@ bool is_ucounts_overlimit(struct ucounts *ucounts, enum ucount_type type, unsign
>   	if (rlimit > LONG_MAX)
>   		max = LONG_MAX;
>   	for (iter = ucounts; iter; iter = iter->ns->ucounts) {
> -		if (get_ucounts_value(iter, type) > max)
> +		long val = get_ucounts_value(iter, type);
> +		if (val < 0 || val > max)
>   			return true;
>   		max = READ_ONCE(iter->ns->ucount_max[type]);
>   	}
> 

This addresses the concerns about overflow.

Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
