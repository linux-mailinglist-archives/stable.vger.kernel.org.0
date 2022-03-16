Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 526164DB800
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 19:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357725AbiCPSio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 14:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241347AbiCPSin (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 14:38:43 -0400
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D00F6E295;
        Wed, 16 Mar 2022 11:37:28 -0700 (PDT)
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-2e59939b862so33408787b3.10;
        Wed, 16 Mar 2022 11:37:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S7CD9ymBGSUH9xoh9EuGWgSN+WocwcNmiO6ecrAxwYQ=;
        b=0Pxt3atUoFC0+JWCJVRTtpPjrEB8rhRRsNl0bynn9FnjbGczrKaWan+96XpVey+KGV
         dsxppYI99Mgro3f/lSS3SnaaP07Wmc+ZvBXWcxYj1wP7yJ2i+GP7vr2Hog5jg9Hf0A1C
         ModXY2UCCtL3hrKF7StmQDLXYmjvzH8nE+Uc2T2hNZF1Fd2rOHYhw5PPJ3U4mqK3va9U
         JC8j0DiBPGNibCYAqo2KUXO9lOjGS5MbcV9Tb1WxhEvECz6rgI6XuF477BAKGpgsnS10
         YVFR4Kse/C9vOnrsb20NlO3XGIN89kjw9I3JJAuNFI/pOkKgDeJsEUNtaMCAlo8KzDAH
         G0oA==
X-Gm-Message-State: AOAM530GMA2fhuD1lQPW765H8INX3KD4jDIEEUx/s9vGO2EmJid0LwTg
        z51O0rfyh9/ngczKOFCbNk9E7moAP/ulMNcORx1o+8yE
X-Google-Smtp-Source: ABdhPJxhctPM1paCg3U/d9lI9xrFtrHRF4X2UhxMkcjRi9OXvU0gaJ8deNpRnMDeZicvOJIkfB4GLX9JHFukxmEiBy8=
X-Received: by 2002:a81:1b97:0:b0:2db:640f:49d8 with SMTP id
 b145-20020a811b97000000b002db640f49d8mr1600322ywb.326.1647455847918; Wed, 16
 Mar 2022 11:37:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220314220855.939823-1-srinivas.pandruvada@linux.intel.com>
In-Reply-To: <20220314220855.939823-1-srinivas.pandruvada@linux.intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 16 Mar 2022 19:37:17 +0100
Message-ID: <CAJZ5v0hdRTHPeg9wVudHAwgBhRb0Enj34t_9+2HcpBs1yWXiyg@mail.gmail.com>
Subject: Re: [PATCH v2] thermal: int340x: Increase bitmap size
To:     Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Laight <David.Laight@aculab.com>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 14, 2022 at 11:09 PM Srinivas Pandruvada
<srinivas.pandruvada@linux.intel.com> wrote:
>
> The number of policies are 10, so can't be supported by the bitmap size
> of u8. Even though there are no platfoms with these many policies, but
> as correctness increase to u32.
>
> Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> Fixes: 16fc8eca1975 ("thermal/int340x_thermal: Add additional UUIDs")
> Cc: stable@vger.kernel.org
> ---
> v2
> - Changed u16 to u32 for better alignment as suggested by David
>
>  drivers/thermal/intel/int340x_thermal/int3400_thermal.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> index 72acb1f61849..348b1f4ef801 100644
> --- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> +++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> @@ -53,7 +53,7 @@ struct int3400_thermal_priv {
>         struct art *arts;
>         int trt_count;
>         struct trt *trts;
> -       u8 uuid_bitmap;
> +       u32 uuid_bitmap;
>         int rel_misc_dev_res;
>         int current_uuid_index;
>         char *data_vault;
> --

Applied as 5.18 material, thanks!
