Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD91450C5E2
	for <lists+stable@lfdr.de>; Sat, 23 Apr 2022 03:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiDWBGV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Apr 2022 21:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiDWBGR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Apr 2022 21:06:17 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A375B177D58
        for <stable@vger.kernel.org>; Fri, 22 Apr 2022 18:03:22 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id bu29so17107973lfb.0
        for <stable@vger.kernel.org>; Fri, 22 Apr 2022 18:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g096DpfSCcf8IWJKS1josNtXLu3tIDY7masJQNFWcAg=;
        b=AQYaKU5/J5+aM5TlCj8JWxqEyNRrWADeSBitRwGal1ELDw+cu8iXPNVIYHG5rXsFKr
         EttNL829nFI/wGAfiIXCY1eNMdjdRPK/3HU5lHecTvmamw0HZg8jKDTcyxWmvbvs+/HQ
         Zc3NjzjDRQt7nWoj0trGeL7HrH1BccrnLvfSg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g096DpfSCcf8IWJKS1josNtXLu3tIDY7masJQNFWcAg=;
        b=UaFqkR40dPsdVyWB/erSmYiT/0OcVGhjrBXtQZv0Y2Zn7ZU8RVaX94XCrnLtcb8FLY
         /f8zm1EZHprJKw7D/La2hrJMuksULTgkr7TAkc8KWAaP/mKGKTUHVwZAcX23avZJj/cE
         qDSWj5NqvXXjHHeHFtG9xoE9dSY/JHH774rhUyfr8rK9DcinaK7QOFXN2Sog7VBWziOw
         JbpBu1dZP/K/BFP9oubXCHfytj1x7v8CZyz5w3lPoTYtTB72E8L0EKKhuuWgeoA+TiCB
         tiIxHB+HVQqobk/6mGDHyeqtUMuvwkDfx6XgfRSmVulVFUtPaNRUc5vu9bUQiCO5q4l4
         SgQg==
X-Gm-Message-State: AOAM531w3LQ8m4yk8W2Vwbv2UI33Dz6IKP9Y4unxeVco9aRIzsW1ymye
        EV6fO1bj+Gx6cVGhREiZlhTuDFxwI6sqaGpldJQ=
X-Google-Smtp-Source: ABdhPJwD9I/VkERHPpG7WGcvv9RUUXM4k8Oq8rxh+hswYOO/OrjK4fSglQU/CXWqHC0RGp901lR2OA==
X-Received: by 2002:a05:6512:2082:b0:443:4236:5f57 with SMTP id t2-20020a056512208200b0044342365f57mr4894333lfr.335.1650675800747;
        Fri, 22 Apr 2022 18:03:20 -0700 (PDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id g15-20020ac24d8f000000b0046d9f95d245sm412366lfe.88.2022.04.22.18.03.17
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Apr 2022 18:03:17 -0700 (PDT)
Received: by mail-lj1-f179.google.com with SMTP id y19so252699ljd.4
        for <stable@vger.kernel.org>; Fri, 22 Apr 2022 18:03:17 -0700 (PDT)
X-Received: by 2002:a2e:9041:0:b0:24a:ce83:dcb4 with SMTP id
 n1-20020a2e9041000000b0024ace83dcb4mr4454046ljg.291.1650675796759; Fri, 22
 Apr 2022 18:03:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220422131452.20757-1-mario.limonciello@amd.com>
In-Reply-To: <20220422131452.20757-1-mario.limonciello@amd.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 22 Apr 2022 18:03:00 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh-F2KtXkQueVJRNqWr7O737NzN=8mYA_r-h-16=VxLQA@mail.gmail.com>
Message-ID: <CAHk-=wh-F2KtXkQueVJRNqWr7O737NzN=8mYA_r-h-16=VxLQA@mail.gmail.com>
Subject: Re: [PATCH v2 0/1] Fix regression in 5.18 for GPIO
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     Natikar Basavaraj <Basavaraj.Natikar@amd.com>,
        Gong Richard <Richard.Gong@amd.com>,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Greg KH <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Shreeya Patel <shreeya.patel@collabora.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 22, 2022 at 6:15 AM Mario Limonciello
<mario.limonciello@amd.com> wrote:
>
> This patch is being sent directly to you because there has been
> a regression in 5.18 that I identified and sent a fix up that has been
> reviewed/tested/acked for nearly a week but the current subsystem
> maintainer (Bartosz) hasn't picked it up to send to you.

Applied.

I'm not sure the "cc: stable" makes much sense since the bug was
introduced in this release, but I assume you added it because the
problem commit was also marked for stable.

The "Fixes:" tag should take care of it, but I left that cc:stable alone.

           Linus
