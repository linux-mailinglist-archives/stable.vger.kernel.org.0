Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 319BC49BDBB
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 22:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232960AbiAYVKt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 16:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232972AbiAYVKp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 16:10:45 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2CA6C061744
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 13:10:45 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id j10so7170237pgc.6
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 13:10:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oTajAjIFl5J5w/Rcv1Jq4D73n55d0RoAmCIghJOGibE=;
        b=ZKQNRGS2URon4bqAWx+sEDzRBBpV7Xe9BsY8G3Bdj8hiy3srRL2yAOY3wK3xdUHbhQ
         0GtR6dOnpon+k8KnmSACtLufwTDy8gBHWQiYf1LxuujlpoIUIvFaithyoKebbgqHAIQt
         3OZ+maPPLrzfTBfnzn5AE1b9pD2OhRxS81rImxOS8w3w6bbeV2gqEsWDYyZgUd4RHk/O
         ksrFBe9LlcwVzOiS0aUVrPn9lht/QyihBJGQsf4n9LXqyuOmIKcOOYjjiY0r4a8Frtm0
         Oh5+AWbbeo7rLoq6Is1010UTApCBKXhUIR18eR8fHEwLOJ8PzQAsxxp7brbXxAStC6+s
         g27A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oTajAjIFl5J5w/Rcv1Jq4D73n55d0RoAmCIghJOGibE=;
        b=8ML4brwy/SQrTM/HxUyyvTkm/1jZwn01nWFdBypRZ/fBdtVmcwNjy4gwpFmXiWujN6
         X/xjLIMJh504AxrcYGo2gOvKXjUkiGeVHA7EuyLmox3LfsnGtXHjK2PnR27XV/I31/qx
         kU9fbo5rZyaymzezgE4RaciGkoNcLQcqK55uVfqFnrYFB9vVnqOLJ57qWEL8KwNESdyI
         gLHv0B+jWo8028IdDJe4pz2hNA8K4rlz4ssLHPWFGmb1T5RQao4MSZndNLRziVe0ufLo
         5yy3Avv/C/ep2/4TWZlRRQxHtfvRZBKzlMeR5lS96C/jBDNkVITbXJIdvAdeb3KcFF5Y
         //xA==
X-Gm-Message-State: AOAM532lFjHLAgYoMTDjelU7NIh+8IT1YiIF4vp2BFty/Eh5vIY53wlo
        J7iyf3/ta8Wy1N6kkOpfZ9+rCw==
X-Google-Smtp-Source: ABdhPJwUGuw/olo0NQ+3jI3fshHSfEURm9sit3pjcxyIdakH1k4Of92wXKR2ERTDKbgL+HE+ZoRYzw==
X-Received: by 2002:a05:6a00:994:b0:4c9:d2a4:c5af with SMTP id u20-20020a056a00099400b004c9d2a4c5afmr9093566pfg.73.1643145044900;
        Tue, 25 Jan 2022 13:10:44 -0800 (PST)
Received: from google.com ([2620:15c:211:202:b678:e713:1931:1231])
        by smtp.gmail.com with ESMTPSA id l17sm7899369pfu.61.2022.01.25.13.10.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 13:10:43 -0800 (PST)
Date:   Tue, 25 Jan 2022 13:10:34 -0800
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     Alexander Sverdlin <alexander.sverdlin@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Russell King <linux@armlinux.org.uk>,
        Nikita Shubin <nikita.shubin@maquefel.me>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        kernel test robot <lkp@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH] ep93xx: clock: Fix UAF in ep93xx_clk_register_gate()
Message-ID: <YfBm/xBJLDtU/fo5@google.com>
References: <20220120133739.4170298-1-alexander.sverdlin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220120133739.4170298-1-alexander.sverdlin@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 20, 2022 at 02:37:38PM +0100, Alexander Sverdlin wrote:
> arch/arm/mach-ep93xx/clock.c:151:2: note: Taking true branch
> if (IS_ERR(clk))
> ^
> arch/arm/mach-ep93xx/clock.c:152:3: note: Memory is released
> kfree(psc);
> ^~~~~~~~~~
> arch/arm/mach-ep93xx/clock.c:154:2: note: Use of memory after it is freed
> return &psc->hw;
> ^ ~~~~~~~~
> 
> Link: https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org/thread/B5YCO2NJEXINCYE26Y255LCVMO55BGWW/
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: 9645ccc7bd7a ("ep93xx: clock: convert in-place to COMMON_CLK")
> Cc: stable@vger.kernel.org
> Signed-off-by: Alexander Sverdlin <alexander.sverdlin@gmail.com>
> ---
>  arch/arm/mach-ep93xx/clock.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-ep93xx/clock.c b/arch/arm/mach-ep93xx/clock.c
> index cc75087134d3..4aee14f18123 100644
> --- a/arch/arm/mach-ep93xx/clock.c
> +++ b/arch/arm/mach-ep93xx/clock.c
> @@ -148,8 +148,10 @@ static struct clk_hw *ep93xx_clk_register_gate(const char *name,
>  	psc->lock = &clk_lock;
>  
>  	clk = clk_register(NULL, &psc->hw);
> -	if (IS_ERR(clk))
> +	if (IS_ERR(clk)) {
>  		kfree(psc);
> +		return (void *)clk;

Prefer ERR_CAST to the raw cast. I think that's nicer when we're already
using the IS_ERR macros.

> +	}
>  
>  	return &psc->hw;
>  }
> -- 
> 2.34.1
> 
