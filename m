Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C87D95B86DB
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 12:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiINK6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 06:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbiINK6l (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 06:58:41 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC424F41;
        Wed, 14 Sep 2022 03:58:39 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id w4so11412345qvp.2;
        Wed, 14 Sep 2022 03:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=M+3+44F49oM4iIfwSY5dMxqTqeMQjRYAGFKRXH7fILM=;
        b=RTLEH4tnLUxxsXkknByr7ORhaSy8nGD9iq/AmO+LcChD4YPbVPvGWZiCvCov8tQ+z2
         4h+KkoaKLBdTpe37v0PWR3FO4PtZv6WGlsiZXhptlJk+AozlD83UWZ0FYn70OTI0l+HX
         pbHeM7l+xQ+O1VdCw7ZdA64xzwJrEIdsca1Xx8xyRHgOjqjEgtozGFoH5s6N9XuefYd6
         eCDLt0QEhnQnPsluVawvJqdyNk5AKGXRXbrKugRwOQXUdxliujH2bnv/j/DlPW2qC+K7
         W8VOoK+c7oVdtSKeSgvPyLM4O+qnMssoHvsRrr/PHOauVZpePuItlim0myb0CcNaEGMk
         rvuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=M+3+44F49oM4iIfwSY5dMxqTqeMQjRYAGFKRXH7fILM=;
        b=hfaXltxGPxu0UTvbHwSbQrTCAyPXHsF4P3QoptdyKV7KF4qXCXketnmwSEKqICPz+X
         mGsryw3Fb7KszSvyKSK3hFVyPNU8xfr92iZF/AK7UmDFD70OwCeaM5fUWYvfiA/OveOs
         rEOLGjljgftAzvE1NS7rVP95b8yHRwwscUBN3eVc135D1jIbZoevYaXfV/Fujs1XlBRR
         rS4u1GIIqI/w1q3LjbenbKvukiXc5m2egAQQ0Etz8hWYMwIywlwo7R2xh/1q8wgDOSX+
         h81RCYdmTTrZkXgHU3W7YrnL+ai/D/+rJ3RIKVdgHixAg5jXA74Drp14usXdkPtZkG7b
         4r3Q==
X-Gm-Message-State: ACgBeo3zDRlzTuNFednYCJ8CfhNpUnXdzvmDDdUgUn0Xd2bo3lM+XElP
        tEmgqA4QTSWZsPi4ygRVG6vOROo9dbML0EN3YgRMlv2Z5hLROQ==
X-Google-Smtp-Source: AA6agR5NBJmLkrzHIl3lhWiSwjcscpRIsiM9FUwCgYlQHK5F43yiSfAfRoIB2KVq9q+Ktg6Hz+7Xdr+0F9hwVc4LG40=
X-Received: by 2002:a05:6214:19cf:b0:4a9:4241:2399 with SMTP id
 j15-20020a05621419cf00b004a942412399mr30621295qvc.64.1663153119083; Wed, 14
 Sep 2022 03:58:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220912212743.37365-1-eajames@linux.ibm.com>
In-Reply-To: <20220912212743.37365-1-eajames@linux.ibm.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 14 Sep 2022 13:58:03 +0300
Message-ID: <CAHp75VfJdmeh54Us2P68sJ7qR8M+_AAByv8_hFPCk2QN0mTfig@mail.gmail.com>
Subject: Re: [PATCH v7 0/2] iio: pressure: dps310: Reset chip if MEAS_CFG is corrupt
To:     Eddie James <eajames@linux.ibm.com>
Cc:     jic23@kernel.org, lars@metafoo.de, linux-iio@vger.kernel.org,
        joel@jms.id.au, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 13, 2022 at 12:27 AM Eddie James <eajames@linux.ibm.com> wrote:
>
> The DPS310 chip has been observed to get "stuck" such that pressure
> and temperature measurements are never indicated as "ready" in the
> MEAS_CFG register. The only solution is to reset the device and try
> again. In order to avoid continual failures, use a boolean flag to
> only try the reset after timeout once if errors persist. Include a
> patch to move the startup procedure into a function.

Good enough, although having a couple of nit-picks.
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

> Changes since v6:
>  - Use helper instead of the lengthy regmap_read_poll_timeout twice
>  - Just return dps310_startup in dps310_reset_reinit
>
> Changes since v5:
>  - Completely rework the second patch to reset and reinit in any
>    timeout condition, if there haven't been previous timeouts that
>    failed to recover the chip.
>
> Changes since v4:
>  - Just check for rc rather than rc < 0 in some cases
>  - Split declaration and init of rc
>
> Changes since v3:
>  - Don't check regmap* return codes for < 0
>  - Fix comment spelling
>
> Changes since v2:
>  - Add some comments
>  - Fix the clunky control flow
>
> Changes since v1:
>  - Separate into two patches
>  - Rename 'dps310_verify_meas_cfg' to 'dps310_check_reset_meas_cfg'
>
> Eddie James (2):
>   iio: pressure: dps310: Refactor startup procedure
>   iio: pressure: dps310: Reset chip after timeout
>
>  drivers/iio/pressure/dps310.c | 266 +++++++++++++++++++++-------------
>  1 file changed, 167 insertions(+), 99 deletions(-)
>
> --
> 2.31.1
>


-- 
With Best Regards,
Andy Shevchenko
