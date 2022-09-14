Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30F445B86D7
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 12:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiINK6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 06:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiINK57 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 06:57:59 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D50B04;
        Wed, 14 Sep 2022 03:57:57 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id w2so7172993qtv.9;
        Wed, 14 Sep 2022 03:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=VXqeZNDwuddQ69zEr78QRQZs4hRIQp4UvJ0xD8IfB4E=;
        b=ja16G3hlNROnLQ89Ts82e/sNzorvDWE0AzfoUXsW1n9Y4cpNqIG41Ss64donlVdhHo
         32ClPPU1zP6hal/R1ZAcIEC0Y4tRgOZvmWv0b9pb/XqfsEz97SjGlfbLWwF4RiEbnR47
         9Ol+bWCYf96FOA7KaMQ36MZ+pHSGW3d/quTF2BWW+wOpxhU8KbZetCRbB+ikgtT3Wnm1
         UPBPuuRh+0UAuk7RKQ89ZF/ZVNn6U0eeZCPN8lXvSmPu3Yw7GPrkTJSCm62LP9/iyrZd
         N57KsJ2ljvy5IasWSiZutN+TTkAgJrfmsDEgXVZC4AwBf2FljdtWBl4hwGmcOqRyEv5u
         0Tkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=VXqeZNDwuddQ69zEr78QRQZs4hRIQp4UvJ0xD8IfB4E=;
        b=edku/LXIbBiAKYIgmLNGmEmkpQH/+TrG8g89KMXMES4+G1SwziCgCR1WG36V8X5bBL
         rXO+W5iCKmqIjaxxX95/bma076lerNZUm2GQilfYU3pWXZwi6LBcpt0YS5hrUL1MIBeK
         GaiWfTI6w0SrUA2vBE4sFgvZdo6NeVwpBwt8s0E5XEu6LKMurjO5LLm6kCiY1s8I3UXm
         /2/FvUyUPK+vTBs2nlEprA80gvH0dexZDwLrnn9LRiIz2n8gQrwNo0WkL1onAvcgAUbs
         11CeeyCTTVpiwhW39dUh7ttKhRa/P06vG4+d++3DtXXR1pLR97fz+n/MV4WP4TlEPRRq
         0f3A==
X-Gm-Message-State: ACgBeo0mNSOHASLRgh5nzGFvW+/KToQjqQxehOOCQb3Sy35K3lRS3zO+
        cse8wbkfXH120orxJDrAwty0buVR5abQ/LiVKbs=
X-Google-Smtp-Source: AA6agR7ACG2IpcCo/COMlzVhleq0fXRcR/7Ddpg9g1emjHR0DCb1yao5dwtqu4B+26ezK3zdONa1FUCvW1sMzvG2S+A=
X-Received: by 2002:a05:622a:40a:b0:343:77ba:727f with SMTP id
 n10-20020a05622a040a00b0034377ba727fmr32433810qtx.481.1663153076699; Wed, 14
 Sep 2022 03:57:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220912212743.37365-1-eajames@linux.ibm.com> <20220912212743.37365-3-eajames@linux.ibm.com>
In-Reply-To: <20220912212743.37365-3-eajames@linux.ibm.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 14 Sep 2022 13:57:20 +0300
Message-ID: <CAHp75Vfo4Ke9d-ZJ-BffYDbT9ppEQVOQbVpu1y_F2vXd+52YPQ@mail.gmail.com>
Subject: Re: [PATCH v7 2/2] iio: pressure: dps310: Reset chip after timeout
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
> only try the reset after timeout once if errors persist.

...

> +static int dps310_ready_status(struct dps310_data *data, int ready_bit, int timeout)
> +{
> +       int ready;
> +       int sleep = DPS310_POLL_SLEEP_US(timeout);

Longer line first?

> +       return regmap_read_poll_timeout(data->regmap, DPS310_MEAS_CFG, ready, ready & ready_bit,
> +                                       sleep, timeout);
> +}

...

> +static int dps310_ready(struct dps310_data *data, int ready_bit, int timeout)
> +{
> +       int rc;
> +
> +       rc = dps310_ready_status(data, ready_bit, timeout);
> +       if (rc) {
> +               if (rc == -ETIMEDOUT && !data->timeout_recovery_failed) {
> +                       int rc2;
> +
> +                       /* Reset and reinitialize the chip. */
> +                       rc2 = dps310_reset_reinit(data);
> +                       if (rc2) {

With below in mind this might become

  if (dps310_reset_init(...))
    ... = true;

> +                               data->timeout_recovery_failed = true;
> +                       } else {
> +                               /* Try again to get sensor ready status. */

> +                               rc2 = dps310_ready_status(data, ready_bit, timeout);
> +                               if (rc2)
> +                                       data->timeout_recovery_failed = true;

Shouldn't you re-use rc here again?

> +                               else
> +                                       return 0;
> +                       }
> +               }
> +
> +               return rc;
> +       }

-- 
With Best Regards,
Andy Shevchenko
