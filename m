Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D35C4B30BC
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 23:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239207AbiBKWgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 17:36:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237194AbiBKWgi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 17:36:38 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84AA6D4E;
        Fri, 11 Feb 2022 14:36:35 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id r18-20020a05683001d200b005ac516aa180so7070ota.6;
        Fri, 11 Feb 2022 14:36:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WrQU9kPhTmMT0JRjFGnOOsQus5ycZcO8eaHkc9H/feM=;
        b=jMgkG8SOtXPubi3dkZAAOA5uWohAGoFh5fwlc18aVLdpeQqoEwONp+sRhN/luGJeQf
         ylbfLxnl4BUo4RuBiEDOEiTru3K9aMVoe/nEtFSpxjsfZwSqTNUXQwhkdt75URLdjBgW
         X7SdrH7Ta+8hIXpU5+Ql/0YYw0O+RvLhegQv/jzK0JgTtP6iJ9WEmpB4Yo4o1h0nw35U
         2kRVFXhZkLU7FClnHgvgY9Kn19AfQdZUZU/J8QQqaSmp5FdjYXDSlevlzvcJjoNtYxQr
         eJtrcHieWSZZMalajbenSKec6V97OKF/GzS8iocps/YkQfi6Ff4qzoQEc2vTOuZdj0SM
         S4yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WrQU9kPhTmMT0JRjFGnOOsQus5ycZcO8eaHkc9H/feM=;
        b=RtvmN2UBKideNiaAOZ523TqZGWa+QkbRUhJiQkFDUxUUZVw+ZuowcfmD4a7ccQ7TU4
         V71K9SiL0E4nlmts10YA4DojukXEFJk0b56X5imT2LHLG7wH2CY4C8IoteqzeBAtpK85
         4fgGYyosVgI4yiDuHKSpSukY31egCA68GKy/ADhMLaq74kLSSb0HuHEsM9WilLqDkpW7
         FP5XCJ80Aaq7uChhhpV9PWUV0rIitb05Xar4eEYqlw4AlKPxZc1hMisTiiUW4myiDHDV
         58yfSsktF2t5khXaXHI3ynIDYex3butN/rL1Cjo3yQOWYQS+Sh5YF8vyAlZDnS5HDpNn
         Am5Q==
X-Gm-Message-State: AOAM530SFvd6Pn3/IvcIy+ZEfQV6O9KIZ3LiK1onENyUIC9gavlTUFqA
        h6AU1ySzX3e/ppy7YpSEtGZdzSnP/TcnRbg4QVU=
X-Google-Smtp-Source: ABdhPJyOhyYlzGFY9SbnMJlo6NVxz1wof4C0E0HUqAqA26wcjYkxPW1erEqe97d0n/2oKUEN1N0XjmaIVwiLs9bp84M=
X-Received: by 2002:a05:6830:4422:: with SMTP id q34mr1370577otv.312.1644618994685;
 Fri, 11 Feb 2022 14:36:34 -0800 (PST)
MIME-Version: 1.0
References: <20211217153555.9413-1-marcelo.jimenez@gmail.com> <CACRpkdbzk55pmK9XMwc470O8vJFUBQ6zs35shOYCFKr+YaOezw@mail.gmail.com>
In-Reply-To: <CACRpkdbzk55pmK9XMwc470O8vJFUBQ6zs35shOYCFKr+YaOezw@mail.gmail.com>
From:   Marcelo Roberto Jimenez <marcelo.jimenez@gmail.com>
Date:   Fri, 11 Feb 2022 19:36:08 -0300
Message-ID: <CACjc_5q247Yb8t8PfJcudVAPFYQcioREAE3zj8OtPR-Ug_x=tA@mail.gmail.com>
Subject: Re: [PATCH] gpio: Revert regression in sysfs-gpio (gpiolib.c)
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     stable <stable@vger.kernel.org>, regressions@lists.linux.dev,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Thierry Reding <treding@nvidia.com>,
        Vidya Sagar <vidyas@nvidia.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Edmond Chung <edmondchung@google.com>,
        Andrew Chant <achant@google.com>,
        Will McVicker <willmcvicker@google.com>,
        Sergio Tanzilli <tanzilli@acmesystems.it>
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

On Thu, Feb 10, 2022 at 9:02 PM Linus Walleij <linus.walleij@linaro.org> wrote:
>
> On Fri, Dec 17, 2021 at 4:36 PM Marcelo Roberto Jimenez
> <marcelo.jimenez@gmail.com> wrote:
>
> > My system is ARM926EJ-S rev 5 (v5l) (AT91SAM9G25), the board is an ACME Systems Arietta.
>
> Which devicetree or boardfile in the upstream Linux kernel is this system
> using?

arch/arm/boot/dts/at91-ariettag25.dts

But it is worth noting that the first lines in this file are:
/*
 * Device Tree file for Arietta G25
 * This device tree is minimal, to activate more peripherals, see:
 * http://dts.acmesystems.it/arietta/
 */

And also that the URL in the comment above is old and now it should
read: http://linux.tanzilli.com/

In any case, the upstream file should be enough to test the issue reported here.

> Yours,
> Linus Walleij

Regards,
Marcelo.
