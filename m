Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10DD5563467
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 15:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbiGANej (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 09:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiGANei (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 09:34:38 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EEEF15FD3;
        Fri,  1 Jul 2022 06:34:37 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id l7so1918834ljj.4;
        Fri, 01 Jul 2022 06:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=2Y+Ope7w/V5G5Sem3wdLuCzNNO1/PxyFpoEOiSLF82s=;
        b=ox3Fz/P/gciSZCXqQFBzj9HCYNl7nGLc1WS4NtTuCHjLAK3B/Tq40mWFCrp0JnSXHt
         UAB8PL830T5Y7tmVtKcugQysd9+nrWbGUYf+bes3wvQ5ciHiTc8wXmqj809lhH5uJUVg
         nlmAFib/DB7KzJKYL+pi+l47VzX3suvg7A3MUh2X5+U1LWpKSblYpuLa+5rAU6flJ6f7
         RSVt6nU+VA7cL25QlcSlxfZBPpE2BvAfECkqHZv8fYz8I7uxtaLhX9/17n+l6sht1oaA
         BCJAvUSmWLlIDjibaK0rzcWxYkrJo0mKYg1T4JQ2AdsXnfFuneNwu9K3CnBGQUZRcLOY
         byOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=2Y+Ope7w/V5G5Sem3wdLuCzNNO1/PxyFpoEOiSLF82s=;
        b=wdsD2O/hgsW+af+a00Ent+OUzNUZuvUo8dFxg2/zl5UHTPlpO1KnkiyjmhzyHyr7+u
         o7osiR2wM7NwaFeoCjcGNhLm9GXotWSKB8RU7s6MdtWV20EW4TlbV/Grh163CeEIaX1x
         QwqxwNvz5ZIy16H00AGV0uJbyZAT4hKyHyGc1NPpT9rDCpiTt+NOxFRxjMwxaqRPIW3i
         Dsw9Mqzo2gk5Fx9tPc1zzgWv4ij31PEbrm4+TSfYEfzciGgka/A7KaK65pe6f8hr7NiU
         SG/odaLQ2ZNZIGhapaeMoSJ3E3Sfhfgnmq1invYoriyskcWnE94CD2dn9Q21MlwESp5X
         L3/g==
X-Gm-Message-State: AJIora9HriM5qJD3jR/SUOFsdppR0+ZMyjupEtecp+1739hvAxheZUBw
        +WhqUCpKppdjvQTtSgQpwTP9PnFRNZJRWg5tvbG4W7GYk68=
X-Google-Smtp-Source: AGRyM1tsfndpT8+S5mM/RyObYkQH8UPIoNUH3cidFzeS3HipAAEDIc+26erP8eDNXyDc1PCLoK/Q3bNPfSHgJMBC2RU=
X-Received: by 2002:a2e:b703:0:b0:25a:93d0:8a57 with SMTP id
 j3-20020a2eb703000000b0025a93d08a57mr8423887ljo.487.1656682475566; Fri, 01
 Jul 2022 06:34:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220701115859.23975-1-ansuelsmth@gmail.com>
In-Reply-To: <20220701115859.23975-1-ansuelsmth@gmail.com>
Reply-To: cwchoi00@gmail.com
From:   Chanwoo Choi <cwchoi00@gmail.com>
Date:   Fri, 1 Jul 2022 22:33:59 +0900
Message-ID: <CAGTfZH2XkS4+YfnibzCPf0P5sVHXwKDvVfXkT3zRr6KfErpg_w@mail.gmail.com>
Subject: Re: [PATCH] PM / devfreq: fix exynos-bus NULL pointer dereference
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Chanwoo Choi <cw00.choi@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Christian,

Please change the patch title as following and resend it.
- PM / devfreq: exynos-bus: Fix NULL pointer dereference

I'll ask the next version to be merged directly into linux-pm.git.

Acked-by: Chanwoo Choi <cw00.choi@samsung.com>

On Fri, Jul 1, 2022 at 9:08 PM Christian Marangi <ansuelsmth@gmail.com> wrote:
>
> Fix exynos-bus NULL pointer dereference by correctly using the local
> generated freq_table to output the debug values instead of using the
> profile freq_table that is not used in the driver.
>
> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Fixes: b5d281f6c16d ("PM / devfreq: Rework freq_table to be local to devfreq struct")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
>  drivers/devfreq/exynos-bus.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/devfreq/exynos-bus.c b/drivers/devfreq/exynos-bus.c
> index b5615e667e31..79725bbb4bb0 100644
> --- a/drivers/devfreq/exynos-bus.c
> +++ b/drivers/devfreq/exynos-bus.c
> @@ -447,9 +447,9 @@ static int exynos_bus_probe(struct platform_device *pdev)
>                 }
>         }
>
> -       max_state = bus->devfreq->profile->max_state;
> -       min_freq = (bus->devfreq->profile->freq_table[0] / 1000);
> -       max_freq = (bus->devfreq->profile->freq_table[max_state - 1] / 1000);
> +       max_state = bus->devfreq->max_state;
> +       min_freq = (bus->devfreq->freq_table[0] / 1000);
> +       max_freq = (bus->devfreq->freq_table[max_state - 1] / 1000);
>         pr_info("exynos-bus: new bus device registered: %s (%6ld KHz ~ %6ld KHz)\n",
>                         dev_name(dev), min_freq, max_freq);
>
> --
> 2.36.1
>


-- 
Best Regards,
Chanwoo Choi
