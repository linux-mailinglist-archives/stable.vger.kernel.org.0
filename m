Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 853F75BA68A
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 07:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbiIPFvw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 01:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiIPFvv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 01:51:51 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C73D9E8A9;
        Thu, 15 Sep 2022 22:51:50 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id f26so12734767qto.11;
        Thu, 15 Sep 2022 22:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=kggedIvIRcJ9fW7Igti3Aql/4k9JWgjH7PUpussM7vs=;
        b=hQQaWLQ8iZG5QN/0DW3UtKJ2IuUmIaam9fihoRTY5kWbSrMvL2zGffjw/y27ZIvciB
         hq7dB23Uie5SdvfmOdXax5mvT45FjtlS6jbhA7r1BdCKA6iPMWkbuT/BckPIlgiTI1mN
         lrOWsbQ1KJN0jzPjRt24sC97XRCtp+Ezkrk5npVKNd6yOz2i4yos+ESXwMNgKmapW05T
         W5WeAnPW/UkhRkuJAiWUplMjaKFg0tF920fgLGdYROqHxJ5bk3/4Qgb9IOR8aKyzV91a
         CYPjth7a0W9Kad3wLOYzp2KtiB3uzXFbOhIE9fVkV8URqHbhqBQMYYX6zoxI99WvCIZ2
         rN1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=kggedIvIRcJ9fW7Igti3Aql/4k9JWgjH7PUpussM7vs=;
        b=VvUGJ0LLXrgO7o0MHpNwL/+yRG7byHTXA6soWsBb3p7HsZ5+xGGhKLIjy2mqqWth2z
         6Byy67akUoUhWycTtLRBtHnbwgeFwtf8HUReU49tIpcSBJVgM2yc9EfrCdkIxiLMzIG5
         ISzdctCDstA79I88THou62W7i4UYK5zHSiRD9E7CDYfG0yXfPMPHrqbDuRN70O2dLhU/
         evT/idiOC1EnD6Dukd0pjNyweyFCZRDlZINRcqNSfKZxBvUqbSn9grTHaBX8pWQfNbVR
         j3xykflVMuD5lmDR6ROXrzIvd1mQer4z5qWNzF038Cfn4p8ugvHpNFCHUcMQxPCwJ/QR
         4hiA==
X-Gm-Message-State: ACrzQf2rj2WR/rp683UGCMMSi6e/56xSu5PyFnzp0akj8Y2orNF7Bspm
        bksx2uWcVF5+5bv+enniasZLP8NIQuKzwI4mKcqmrPw75zE=
X-Google-Smtp-Source: AMsMyM6ChniVrKH1pwNnF1z/D15EMOmEgjkuKdLHxx/9vovYMjBGmdhd6F6iqGR2QQiMZsHK8yKn7INL3MTo2Uls0kU=
X-Received: by 2002:a05:622a:1701:b0:35b:b3bb:7c4e with SMTP id
 h1-20020a05622a170100b0035bb3bb7c4emr2939434qtk.195.1663307509413; Thu, 15
 Sep 2022 22:51:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220915195719.136812-1-eajames@linux.ibm.com> <20220915195719.136812-3-eajames@linux.ibm.com>
In-Reply-To: <20220915195719.136812-3-eajames@linux.ibm.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 16 Sep 2022 08:51:13 +0300
Message-ID: <CAHp75VfEktq10YcQMF9D9cQWtVsR+gx+3_PAq1YNoKUWEZaC1Q@mail.gmail.com>
Subject: Re: [PATCH v8 2/2] iio: pressure: dps310: Reset chip after timeout
To:     Eddie James <eajames@linux.ibm.com>
Cc:     jic23@kernel.org, lars@metafoo.de, linux-iio@vger.kernel.org,
        joel@jms.id.au, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 15, 2022 at 10:57 PM Eddie James <eajames@linux.ibm.com> wrote:
>
> The DPS310 chip has been observed to get "stuck" such that pressure
> and temperature measurements are never indicated as "ready" in the
> MEAS_CFG register. The only solution is to reset the device and try
> again. In order to avoid continual failures, use a boolean flag to
> only try the reset after timeout once if errors persist.

...

> +static int dps310_ready(struct dps310_data *data, int ready_bit, int timeout)
> +{
> +       int rc;
> +
> +       rc = dps310_ready_status(data, ready_bit, timeout);
> +       if (rc) {

> +               if (rc == -ETIMEDOUT && !data->timeout_recovery_failed) {

Here you compare rc with a certain error code...

> +                       /* Reset and reinitialize the chip. */
> +                       if (dps310_reset_reinit(data)) {
> +                               data->timeout_recovery_failed = true;
> +                       } else {
> +                               /* Try again to get sensor ready status. */

> +                               if (dps310_ready_status(data, ready_bit, timeout))

...but here you assume that the only error code is -ETIMEDOUT. It's
kinda inconsistent (if you rely on internals of ready_status, then why
to check the certain error code, or otherwise why not to return a real
second error code). That's why I asked about re-using rc here.

In any case I don't think this justifies a v9, let's wait for your
answer and Jonathan's opinion.

> +                                       data->timeout_recovery_failed = true;
> +                               else
> +                                       return 0;
> +                       }
> +               }
> +
> +               return rc;
> +       }
> +
> +       data->timeout_recovery_failed = false;
> +       return 0;
> +}

-- 
With Best Regards,
Andy Shevchenko
