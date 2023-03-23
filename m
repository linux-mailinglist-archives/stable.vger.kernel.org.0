Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8478D6C6A1D
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 14:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbjCWN51 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Mar 2023 09:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjCWN51 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Mar 2023 09:57:27 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2023A3C0C
        for <stable@vger.kernel.org>; Thu, 23 Mar 2023 06:57:26 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id hf2so22409580qtb.3
        for <stable@vger.kernel.org>; Thu, 23 Mar 2023 06:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679579845;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0UGsNG9W2UNoFjKyA3o9SiIejcO47eu8yFQSpE9OdRs=;
        b=PzDrElI8d//E88KzlNQY0S7DnaQI6jMaVTRjxQG2/24vqEDUl3v8eOFIFLbEhlMiCY
         xbKk/iVjjqH17t43fDNG9ZxrXsA0fOomC6/jDawCYMHxOB9Y7gIKhYanOa0NdgQd0Tir
         AP0ntaA0L5934i17YnX7azpE4YgRy7QRCNYTnWIWpvwmfCTMzxM/vU+LnRalrf4ykVQO
         ++YP02zeGsmVJtvlXStzv3aQwkBQUAsCOTXqo3HDlOI3ohkDjPhv+JClrKOxx6zCvw9n
         wpLRmjvaOhwjGJPe2E6CL+RS1Hn1k3pBWn0ufI+CQEN8t4zfATsciu3w+r2fbK6xcjZv
         nVoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679579845;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0UGsNG9W2UNoFjKyA3o9SiIejcO47eu8yFQSpE9OdRs=;
        b=Uw+Ukb9JP/CkeVVOlQzKCBN8kzj5K8jJ+50KBSzEI5niEwbZOLEqE17io9s86D1ng7
         5Wsy5cVT3dOlXn1Qy88X8WM8D+/OSUiNTvHBXXhbtIn8xjYBmbupCk/txvjFTphuu1VU
         nIPGJZfgYbUUV9orc3ExaJ2uDNx25QSW6H6hv05QLAhnQlJJRjcmKFhfmPOsA3Hcj2nw
         KVG8sAnzPDxATosMySPq8XZQelHlO+keO8/maMGnQehA33yJHxqBOQDEzu0dI3fTRpSy
         SR5o48BFc4iEdb/VbqXvqNHhVN7IioF86wYx1ab1EascKfLT8g1YJYam0RcET92quOT5
         gR3A==
X-Gm-Message-State: AO0yUKVccuJw5b1ixGWBHj7vu4t30h71zOkWZIbGeEQ+yl8lvJqVVGPU
        xC4xcfzXxdUvQfA4YhvZsv4GQxaKsopRto3Uv0vb6w==
X-Google-Smtp-Source: AK7set+ocAuMC9Lw34FR+ipU4tXGRuA5/YrqvfJbPUY/bllTbULe/XpImra+yz2e8OVOj3Ln8NUQqtOTrPqiteXXVKY=
X-Received: by 2002:a05:622a:34d:b0:3e3:8a0e:495f with SMTP id
 r13-20020a05622a034d00b003e38a0e495fmr2368502qtw.13.1679579845233; Thu, 23
 Mar 2023 06:57:25 -0700 (PDT)
MIME-Version: 1.0
References: <20230323110125.23790-1-srinivas.kandagatla@linaro.org>
In-Reply-To: <20230323110125.23790-1-srinivas.kandagatla@linaro.org>
From:   Amit Pundir <amit.pundir@linaro.org>
Date:   Thu, 23 Mar 2023 19:26:49 +0530
Message-ID: <CAMi1Hd0Zg2nydXu0J_zGbcd9AwLbTWU2h_YNAb8ZRSOBRTWQbg@mail.gmail.com>
Subject: Re: [RESEND PATCH] ASoC: codecs: lpass: fix the order or clks turn
 off during suspend
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc:     broonie@kernel.org, perex@perex.cz, tiwai@suse.com,
        lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 23 Mar 2023 at 16:31, Srinivas Kandagatla
<srinivas.kandagatla@linaro.org> wrote:
>
> The order in which clocks are stopped matters as some of the clock
> like NPL are derived from MCLK.
>
> Without this patch, Dragonboard RB5 DSP would crash with below error:
>  qcom_q6v5_pas 17300000.remoteproc: fatal error received:
>  ABT_dal.c:278:ABTimeout: AHB Bus hang is detected,
>  Number of bus hang detected := 2 , addr0 = 0x3370000 , addr1 = 0x0!!!
>
> Turn off  fsgen first, followed by npl and then finally mclk, which is exactly
> the opposite order of enable sequence.
>

Tested-by: Amit Pundir <amit.pundir@linaro.org>
CC: stable@vger.kernel.org # v6.1.y


> Fixes: 1dc3459009c3 ("ASoC: codecs: lpass: register mclk after runtime pm")
> Reported-by: Amit Pundir <amit.pundir@linaro.org>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> ---
>
> Sorry for noise, resending this one, as I missed the asoc mailing list in my previous send.
>
>
>  sound/soc/codecs/lpass-rx-macro.c  | 4 ++--
>  sound/soc/codecs/lpass-tx-macro.c  | 4 ++--
>  sound/soc/codecs/lpass-wsa-macro.c | 4 ++--
>  3 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/sound/soc/codecs/lpass-rx-macro.c b/sound/soc/codecs/lpass-rx-macro.c
> index 9e0a4e8a46c3..372bea8b3525 100644
> --- a/sound/soc/codecs/lpass-rx-macro.c
> +++ b/sound/soc/codecs/lpass-rx-macro.c
> @@ -3668,9 +3668,9 @@ static int __maybe_unused rx_macro_runtime_suspend(struct device *dev)
>         regcache_cache_only(rx->regmap, true);
>         regcache_mark_dirty(rx->regmap);
>
> -       clk_disable_unprepare(rx->mclk);
> -       clk_disable_unprepare(rx->npl);
>         clk_disable_unprepare(rx->fsgen);
> +       clk_disable_unprepare(rx->npl);
> +       clk_disable_unprepare(rx->mclk);
>
>         return 0;
>  }
> diff --git a/sound/soc/codecs/lpass-tx-macro.c b/sound/soc/codecs/lpass-tx-macro.c
> index b044c9c6f89b..d9318799f6b7 100644
> --- a/sound/soc/codecs/lpass-tx-macro.c
> +++ b/sound/soc/codecs/lpass-tx-macro.c
> @@ -2096,9 +2096,9 @@ static int __maybe_unused tx_macro_runtime_suspend(struct device *dev)
>         regcache_cache_only(tx->regmap, true);
>         regcache_mark_dirty(tx->regmap);
>
> -       clk_disable_unprepare(tx->mclk);
> -       clk_disable_unprepare(tx->npl);
>         clk_disable_unprepare(tx->fsgen);
> +       clk_disable_unprepare(tx->npl);
> +       clk_disable_unprepare(tx->mclk);
>
>         return 0;
>  }
> diff --git a/sound/soc/codecs/lpass-wsa-macro.c b/sound/soc/codecs/lpass-wsa-macro.c
> index 728f26d12ab0..6484c335bd5d 100644
> --- a/sound/soc/codecs/lpass-wsa-macro.c
> +++ b/sound/soc/codecs/lpass-wsa-macro.c
> @@ -2504,9 +2504,9 @@ static int __maybe_unused wsa_macro_runtime_suspend(struct device *dev)
>         regcache_cache_only(wsa->regmap, true);
>         regcache_mark_dirty(wsa->regmap);
>
> -       clk_disable_unprepare(wsa->mclk);
> -       clk_disable_unprepare(wsa->npl);
>         clk_disable_unprepare(wsa->fsgen);
> +       clk_disable_unprepare(wsa->npl);
> +       clk_disable_unprepare(wsa->mclk);
>
>         return 0;
>  }
> --
> 2.21.0
>
