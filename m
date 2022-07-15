Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0C4D5764B4
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 17:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235080AbiGOPph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 11:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235179AbiGOPp1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 11:45:27 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C6D65CD;
        Fri, 15 Jul 2022 08:45:25 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id k25-20020a056830169900b0061c6f68f451so3749318otr.9;
        Fri, 15 Jul 2022 08:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=655e0l8Ufrzl8KZoLGS7moHsWbNQ4DYiyVxrPdbF/BQ=;
        b=h8zBD1fhNJJnThqKgZTCwZxoabS7jOccDS5Mf8PetFktQOc1QrWq3yvZG+ES2KQQk7
         xOn36wdZpR/uJCo0yeqmy/A1hEc/7n2a+cBOZ9dzQ8mUu4u9t7dI2avVHEf8WOrxKpNy
         vDxnyn5dNBiBhHrYrbcH9ThsFPANGBaK95X/qp3wBgLymQoWTJDywJ+kco4RCZ3SicIO
         cBGNjTSZtYk16okRH9yHcgXwePIT5u9Eqm4A0xUb/Ng9ntxB7A27noBR9I6zYgzs5sD0
         YRlEekMGAW7NNpr53LHBrZhi6+8gzQCHPTpu+8fBDrHm+xXCDutKaomTV42DrDnFFgrC
         Ymew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=655e0l8Ufrzl8KZoLGS7moHsWbNQ4DYiyVxrPdbF/BQ=;
        b=ss//8hWLBk8qAxheyjgk7pENPM4B1/nXswpB+L5gYhAAW+ctkc7qe9SaV3B3ild0iJ
         eG0goh4FIv2xw04xi+9wWxIZa3XR3see5cnTouUoJtgco4o38k6/nXUlKVaTD2z0iuUo
         /UoABdbVNq14hv49Se8NRKsE3363hL4lCJyUm906wjYIOLAESZPyS3Yn4oYcmKVuMa2R
         V1Y18IBCyB6tpVG29J+HUG2E097M4LdMQuHvGwSKa4OaSN4/Mdzx7znAEITiv4trp8oJ
         A7ZYp79FY06RHoX7PCtRsHBOQEFmlHqLo9ErErWZtVMLik/QoOTdFX5eOIiuDiiIwqrr
         CySg==
X-Gm-Message-State: AJIora8WhZPYArmRLrFaoBQomaW2GILBjFzKQT38QDPoaJg8ASc2uJnB
        5HbC0qmDAnwPMYzUvtY0d8U=
X-Google-Smtp-Source: AGRyM1vEUgGJ3EUP8mxug2fVc4afhtvaqapY7HeD1isLY14NNpAMBaQVy7Ob398UzvOj5TWP7aE+Kg==
X-Received: by 2002:a9d:7858:0:b0:61c:412b:c789 with SMTP id c24-20020a9d7858000000b0061c412bc789mr5523448otm.185.1657899924394;
        Fri, 15 Jul 2022 08:45:24 -0700 (PDT)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id e16-20020a0568301e5000b0060603221255sm2037477otj.37.2022.07.15.08.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 08:45:24 -0700 (PDT)
Date:   Fri, 15 Jul 2022 08:45:23 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        platform-driver-x86@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] x86/olpc: fix 'logical not is only applied to the left
 hand side'
Message-ID: <YtGLkx1E8ZifiUQo@yury-laptop>
References: <20220715151536.67401-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220715151536.67401-1-alexandr.lobakin@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 15, 2022 at 05:15:36PM +0200, Alexander Lobakin wrote:
> The bitops compile-time optimization series revealed one more
> problem in olpc-xo1-sci.c:send_ebook_state(), resulted in GCC
> warnings:
> 
> arch/x86/platform/olpc/olpc-xo1-sci.c: In function 'send_ebook_state':
> arch/x86/platform/olpc/olpc-xo1-sci.c:83:63: warning: logical not is only applied to the left hand side of comparison [-Wlogical-not-parentheses]
>    83 |         if (!!test_bit(SW_TABLET_MODE, ebook_switch_idev->sw) == state)
>       |                                                               ^~
> arch/x86/platform/olpc/olpc-xo1-sci.c:83:13: note: add parentheses around left hand side expression to silence this warning
> 
> Despite this code working as intended, this redundant double
> negation of boolean value, together with comparing to `char`
> with no explicit conversion to bool, makes compilers think
> the author made some unintentional logical mistakes here.
> Make it the other way around and negate the char instead
> to silence the warnings.
> 
> Fixes: d2aa37411b8e ("x86/olpc/xo1/sci: Produce wakeup events for buttons and switches")
> Cc: stable@vger.kernel.org # 3.5+
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Reported-by: kernel test robot <lkp@intel.com>
> Reviewed-and-tested-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>

Applied, thanks!

> ---
>  arch/x86/platform/olpc/olpc-xo1-sci.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/platform/olpc/olpc-xo1-sci.c b/arch/x86/platform/olpc/olpc-xo1-sci.c
> index f03a6883dcc6..89f25af4b3c3 100644
> --- a/arch/x86/platform/olpc/olpc-xo1-sci.c
> +++ b/arch/x86/platform/olpc/olpc-xo1-sci.c
> @@ -80,7 +80,7 @@ static void send_ebook_state(void)
>  		return;
>  	}
>  
> -	if (!!test_bit(SW_TABLET_MODE, ebook_switch_idev->sw) == state)
> +	if (test_bit(SW_TABLET_MODE, ebook_switch_idev->sw) == !!state)
>  		return; /* Nothing new to report. */
>  
>  	input_report_switch(ebook_switch_idev, SW_TABLET_MODE, state);
> -- 
> 2.36.1
