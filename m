Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC61507C5A
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 00:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357183AbiDSWFM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 18:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245501AbiDSWFM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 18:05:12 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 469E740E72
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 15:02:28 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-2eba37104a2so22597b3.0
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 15:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CnSoh+ZD8DR5nKk6CV9UyrxaQEV9KgNslgMO1bDltQg=;
        b=Yqp9wQBCWbWPglTxek38iaFNVPN4Zk+RjRomb858O7NzPfSZ+56DcTmtbbra8cwo8A
         51LXzN/RhH4+O0qrKK90KipDzYk0rjXH0fWgauClW+t4NGUHEgy+QmXTqGliJ7ZrFAMo
         fyyaKKW3Nkt+GpV/6fmKo89PXd1xCQz8RXD9uQJtIgvvcwQDmo9JieU4vft39lVG7Akt
         EBG1oVJHmTxwINgk2kTxL9uYGLrCfT5FGn6QKAHpfvtDhDtE/kNyEKA6I/ESzJq6rvT7
         3qCxECIIz8g/Hpac47uzFVgZwz15uhtU4EDCj69W7Jd/qxQac3Irst/sGaDuFPswElMM
         FSBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CnSoh+ZD8DR5nKk6CV9UyrxaQEV9KgNslgMO1bDltQg=;
        b=WDk+RT/x4DGSEP1uYpEIufgcPHcmzNAe2uN6qWNMkymjO8K4WU5cXG3v0G89WqXl/F
         0cz/2NENO4lqI9wQa/QH89Mb2CKETLg1dk6xsKRJfnremnmKfkUJ/xVdx8Y4tKmRBL21
         m7uule0Db8LNTADMS/OZrm8ePWzOS1jtA4nq6N7golYZYygZabjXf763KRDB7sbqcc6n
         xSPPRmihRPt9Un+mttOQYuMDNfKJXdRszR5PgJHgdMDu0IQwwy7cqYL5U1Y8DJtT8D93
         AGM69SANUYDiV0kO3/usP9dde14b86wvE8NCHC/M+i2jCi7xm77EYMgFZLQX8w7pdLc3
         b1uw==
X-Gm-Message-State: AOAM530b0L7oMNQAdhncJrFqG29+ix9W1PDng+Ogass1RBZ1FbRcOPFb
        dczepz2LQ4E/IMenViNP2g6ehiEd6FPVj4caBOoa6A==
X-Google-Smtp-Source: ABdhPJykrSD9spRkBNNbl3jZqUx8W2pxKdem4xATAM88TeGKzKQGRYCeHgf3K2yq3M35hvoxd/8Cjlx/QFKC/zbTbBk=
X-Received: by 2002:a81:5dc5:0:b0:2eb:3feb:686c with SMTP id
 r188-20020a815dc5000000b002eb3feb686cmr18267528ywb.268.1650405747502; Tue, 19
 Apr 2022 15:02:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220414025705.598-1-mario.limonciello@amd.com>
 <20966c6b-9045-9f8b-ba35-bf44091ce380@gmail.com> <67df4178-5943-69d8-0d61-f533671a1248@amd.com>
In-Reply-To: <67df4178-5943-69d8-0d61-f533671a1248@amd.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 20 Apr 2022 00:02:16 +0200
Message-ID: <CACRpkdbvN0ZJnn+N=Vt2n_aO4CnM=E4qpe_3dmu-c8_Ufp8ZzQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: Request interrupts after IRQ is initialized
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     firew4lker <firew4lker@gmail.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Shreeya Patel <shreeya.patel@collabora.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Basavaraj.Natikar@amd.com, Richard.Gong@amd.com,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 18, 2022 at 6:34 AM Mario Limonciello
<mario.limonciello@amd.com> wrote:

> Linus Walleij,
>
> As this is backported to 5.15.y, 5.16.y, 5.17.y and those all had point
> releases a bunch of people are hitting it now.  If you choose to adopt
> this patch instead of revert the broken one, you can add to the commit
> message too:
>
> Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1976

I am on parental leave kind of, but Bartosz knows what to do,
in this case, since it is ACPI-related, Andy knows best what
to do, and I see he also replied.

Yours,
Linus Walleij
