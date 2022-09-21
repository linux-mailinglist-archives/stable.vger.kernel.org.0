Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2F25BFE6B
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 14:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbiIUMwd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 08:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbiIUMwL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 08:52:11 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D658D95E73
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 05:50:23 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id n40-20020a05600c3ba800b003b49aefc35fso3692718wms.5
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 05:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=vJMrnlWIsNWeWYN8YHacPX0ArBJjqAyGF/BjcGaKPnw=;
        b=q7be6nMqyfGgNl/V+qFZPUp2UBRO4K9yDDdaOL7YEzDRaaIG+McG6mKoiFGqwSMNg3
         nEVVTmRxX2eR9rawn9ZO6Oa4RPW9TvVMAr42v+6/9xap2SPItL6u7w2yMtsTD8U7+KVq
         VJu8SQyfDlDdrf/9WFpzSIZF6aYcDBDo5wxCL7n3OYycb9WYi5syA58R/C6ZYcAQiGEy
         kGY6MIY6QpicpZSzRcdbQCd5zBBc4jslX0pbRsfBuptn29j9VnsKTKHL9eB0KTgfxZy/
         mLjwjUnlnQAqjAUxcWPQ8Y6bIzAocu5MroYDcSEXPZYmaiCoRNdaz5mDNMWJt7OjK2Ey
         F2aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=vJMrnlWIsNWeWYN8YHacPX0ArBJjqAyGF/BjcGaKPnw=;
        b=IUTBi/tZJHWa6dv+IaTKHflkebF3wuQdtMC8Nu50gKrlG12JJXGbsXjyIQwNQVDVi8
         pPG4bqqEL82dqNead8MjZdm7e3iDGBbVMP4IhsZiQDfaqQ9zYfzE5NnL3wtmP6cCUv61
         q0nmPwM+Ivkl1MbXtTWtoS2wGULIQfj1U4zaYGfQLJ+K+nsaNPrxpNZccaMkB1WNnuhh
         GyZSJRwdAy6rQQbEpFBRTE9GSsC7nqilY58kxkk1acCwNpsB9op6qlWhlKPV4fZ3B/Pr
         Tua40+uTwd5kckwEbJqbtVYMxDWqS7RaUYGElL7OGp0nRpsGuHZAt2Mp030ozoBHbl36
         2XiA==
X-Gm-Message-State: ACrzQf0kNUJu3ulBFyXeiuJciJ2NEzziY6+n1R3/M21cR97K3CcJSSlZ
        AyIFHk7QRb1/7qbO9kiAj9d3SsxxKTM62fgGXXzx1A==
X-Google-Smtp-Source: AMsMyM7vpB6vpet3ZiwTncBW3bfr50z9gxhKSdE4/PdQ1dL6VgKyU3i8XgKS9eid/rqu0hieRYhZ+JwQKlIWFRJ0W8s=
X-Received: by 2002:a1c:f406:0:b0:3a5:d667:10 with SMTP id z6-20020a1cf406000000b003a5d6670010mr5872114wma.70.1663764618771;
 Wed, 21 Sep 2022 05:50:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220914014010.2076169-1-briannorris@chromium.org>
In-Reply-To: <20220914014010.2076169-1-briannorris@chromium.org>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Wed, 21 Sep 2022 14:49:42 +0200
Message-ID: <CAPDyKFrm3Q0rYSMqMXcsMCxZSkohU9K+f+a4wMx4nWP3wrcn=A@mail.gmail.com>
Subject: Re: [PATCH] mmd: core: Terminate infinite loop in SD-UHS voltage switch
To:     Brian Norris <briannorris@chromium.org>
Cc:     Guenter Roeck <linux@roeck-us.net>, stable@vger.kernel.org,
        Arindam Nath <arindam.nath@amd.com>,
        Chris Ball <cjb@laptop.org>,
        Philip Rakity <prakity@marvell.com>,
        Zhangfei Gao <zhangfei.gao@marvell.com>,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 14 Sept 2022 at 03:40, Brian Norris <briannorris@chromium.org> wrote:
>
> This loop intends to retry a max of 10 times, with some implicit
> termination based on the SD_{R,}OCR_S18A bit. Unfortunately, the
> termination condition depends on the value reported by the SD card
> (*rocr), which may or may not correctly reflect what we asked it to do.
>
> Needless to say, it's not wise to rely on the card doing what we expect;
> we should at least terminate the loop regardless. So, check both the
> input and output values, so we ensure we will terminate regardless of
> the SD card behavior.
>
> Note that SDIO learned a similar retry loop in commit 0797e5f1453b
> ("mmc: core: Fixup signal voltage switch"), but that used the 'ocr'
> result, and so the current pre-terminating condition looks like:
>
>     rocr & ocr & R4_18V_PRESENT
>
> (i.e., it doesn't have the same bug.)
>
> This addresses a number of crash reports seen on ChromeOS that look
> like the following:
>
>     ... // lots of repeated: ...
>     <4>[13142.846061] mmc1: Skipping voltage switch
>     <4>[13143.406087] mmc1: Skipping voltage switch
>     <4>[13143.964724] mmc1: Skipping voltage switch
>     <4>[13144.526089] mmc1: Skipping voltage switch
>     <4>[13145.086088] mmc1: Skipping voltage switch
>     <4>[13145.645941] mmc1: Skipping voltage switch
>     <3>[13146.153969] INFO: task halt:30352 blocked for more than 122 seconds.
>     ...
>
> Fixes: f2119df6b764 mmc: sd: add support for signal voltage switch procedure
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Brian Norris <briannorris@chromium.org>

Wow, that was an ugly bug you fixed! Applied for fixes, thanks!

Kind regards
Uffe


> ---
>
>  drivers/mmc/core/sd.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
> index 06aa62ce0ed1..3662bf5320ce 100644
> --- a/drivers/mmc/core/sd.c
> +++ b/drivers/mmc/core/sd.c
> @@ -870,7 +870,8 @@ int mmc_sd_get_cid(struct mmc_host *host, u32 ocr, u32 *cid, u32 *rocr)
>          * the CCS bit is set as well. We deliberately deviate from the spec in
>          * regards to this, which allows UHS-I to be supported for SDSC cards.
>          */
> -       if (!mmc_host_is_spi(host) && rocr && (*rocr & SD_ROCR_S18A)) {
> +       if (!mmc_host_is_spi(host) && (ocr & SD_OCR_S18R) &&
> +           rocr && (*rocr & SD_ROCR_S18A)) {
>                 err = mmc_set_uhs_voltage(host, pocr);
>                 if (err == -EAGAIN) {
>                         retries--;
> --
> 2.37.2.789.g6183377224-goog
>
