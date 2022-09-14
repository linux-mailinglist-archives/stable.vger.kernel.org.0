Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F00D5B81B0
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 08:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbiINGwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 02:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiINGwq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 02:52:46 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C3A6744F;
        Tue, 13 Sep 2022 23:52:45 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id m10-20020a17090a730a00b001fa986fd8eeso17986670pjk.0;
        Tue, 13 Sep 2022 23:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=4ODUVD1mcXWe7gBOsFOiDmJcOhv1IVWlguZotwIBftc=;
        b=hyg6gOvOM4+woDFtgP0pnABwWLumEzTXPtcQPNm81+6EBCo6VIcl/hKtx57jt+KoHc
         HyWz/ZtJ34vmU/bl2NLg0vvt/2AYpyHAKNbhVsKrAIX17obNmW9XMQFjc/KMNOzSXAxn
         16ALPrxmxdBvm5R4h6I/uGI/j+KIy44rP0CTBQvh884Qrvn4gNcCXQRyMQg/b8Cf3Ajb
         ZGYoMJRFV+22AvrJa+0xIk/ALVWODByou5ohx65vRw7MBFH9AzZkA1FGgvMjFDkt4pzJ
         y0/JBVbZYTi7ePDqJQisZpnj9s9gOSiUBxg3F2DxAd9c7DxnGl4mXG/sNJMRUDWod3MP
         nTEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=4ODUVD1mcXWe7gBOsFOiDmJcOhv1IVWlguZotwIBftc=;
        b=X7SkbiNe9F96x4jh6dR220qBCklq5wmIzC+A5KYde42gUofk4Cmv4KozTZRTOg4ig5
         OKOts+0gd+29cuYhCDP99eg0auha4LhEV6iM3BNM+XBcDNsEQCR2B3mzSN1wuv73A5mh
         laoiGT3YXAOD8REZU44HWcrXivGl1X7GmKVOJvfte3GkbVArKSgUVOkCHAmg0DKWwSRJ
         8pu/QDiavujPPzCXIq1gQ7t0F3kyr/bsVOz9X1YBVPw3yLH/vP7eypAOz7WdkW2BRPZr
         F94Phd//2g7FxhJBg26zyKH9beSxN0OP2d7Ym63zAahdj7LWCkQO9y0zA0gfse2Y3RdI
         rsxA==
X-Gm-Message-State: ACgBeo0en6uYGKHkT71DUk1bKGNjLyAuloA0qUTtz1JFbS/OZUDKrlDn
        N/N68yONZ2fp/ojOLuDiotA=
X-Google-Smtp-Source: AA6agR4wL/Ujw0bI90QfyMDeBvjdUnPTT+pN4CqTFQBGj2DIJT0Gf4QdaNAcI2ZgBiR2+LrdD79IlQ==
X-Received: by 2002:a17:903:24f:b0:172:7d68:cf1 with SMTP id j15-20020a170903024f00b001727d680cf1mr35213268plh.55.1663138365395;
        Tue, 13 Sep 2022 23:52:45 -0700 (PDT)
Received: from hyeyoo ([114.29.91.56])
        by smtp.gmail.com with ESMTPSA id k72-20020a62844b000000b0053e8368ec34sm9147565pfd.32.2022.09.13.23.52.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 23:52:44 -0700 (PDT)
Date:   Wed, 14 Sep 2022 15:52:39 +0900
From:   Hyeonggon Yoo <42.hyeyoo@gmail.com>
To:     Peter Collingbourne <pcc@google.com>
Cc:     Andrey Konovalov <andreyknvl@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        vbabka@suse.cz, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] kasan: call kasan_malloc() from __kmalloc_*track_caller()
Message-ID: <YyF6N8uHGVrqpoDM@hyeyoo>
References: <20220914020001.2846018-1-pcc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220914020001.2846018-1-pcc@google.com>
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 13, 2022 at 07:00:01PM -0700, Peter Collingbourne wrote:
> We were failing to call kasan_malloc() from __kmalloc_*track_caller()
> which was causing us to sometimes fail to produce KASAN error reports
> for allocations made using e.g. devm_kcalloc(), as the KASAN poison was
> not being initialized. Fix it.
> 
> Signed-off-by: Peter Collingbourne <pcc@google.com>
> Cc: <stable@vger.kernel.org> # 5.15
> ---
> The same problem is being fixed upstream in:
> https://lore.kernel.org/all/20220817101826.236819-6-42.hyeyoo@gmail.com/
> as part of a larger patch series, but this more targeted fix seems
> more suitable for the stable kernel. Hyeonggon, maybe you can add
> this patch to the start of your series and it can be picked up
> by the stable maintainers.
> 
>  mm/slub.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 862dbd9af4f5..875c569c5cbe 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -4926,6 +4926,8 @@ void *__kmalloc_track_caller(size_t size, gfp_t gfpflags, unsigned long caller)
>  	/* Honor the call site pointer we received. */
>  	trace_kmalloc(caller, ret, s, size, s->size, gfpflags);
>  
> +	ret = kasan_kmalloc(s, ret, size, gfpflags);
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL(__kmalloc_track_caller);
> @@ -4957,6 +4959,8 @@ void *__kmalloc_node_track_caller(size_t size, gfp_t gfpflags,
>  	/* Honor the call site pointer we received. */
>  	trace_kmalloc_node(caller, ret, s, size, s->size, gfpflags, node);
>  
> +	ret = kasan_kmalloc(s, ret, size, gfpflags);
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL(__kmalloc_node_track_caller);
> -- 
> 2.37.2.789.g6183377224-goog
>

Ah, I should have sent it to stable team ;)

I think "Option 3" in Documentation/process/stable-kernel-rules.rst will be appropriate,
So will resend this after the series goes to Linus's tree.

Thank you Peter!

-- 
Thanks,
Hyeonggon
