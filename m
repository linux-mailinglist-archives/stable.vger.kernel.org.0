Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCBB663B388
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 21:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234043AbiK1Umq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 15:42:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234049AbiK1Uma (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 15:42:30 -0500
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F18C2A249
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 12:42:29 -0800 (PST)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-3cbdd6c00adso24753877b3.11
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 12:42:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9XNZWTdwXKMxfdvP8XVrQ3AwvmDQFwgMMk54i8ewFlQ=;
        b=NFaDxuhSPxiblhrcutZ+DlS8yXONDE32MflzeG2qIsWQqksFRmnsqhCPxhgCWKkmDE
         iWkhKkP4yzQvGVcQSvf+QnrgguMe4tM/QGzeMlS6U5+DMLEnz/SCNT2HUFh+aWCMK5FK
         auKnCuncKzsBtmHE+5KB9Epg4PDdLzcJwpcy/VfApVNPhEE2giswd5objQxrNHBSkqgN
         kOEMNxczo7tj9GI3n21nkrLhY+2kq8jZVdtB8hm0U2l6HXtuv6Ce35H0IrF+svbymciW
         Ybt8MwNWlV1aliIGbhy9jhO/tqq8F699EKGRtbfCrHvJ1Rhx4e9FoGCPMk+66d8vpdou
         9/Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9XNZWTdwXKMxfdvP8XVrQ3AwvmDQFwgMMk54i8ewFlQ=;
        b=aLP6Dv2lfsOF9gpQxN6QDv0reUCh6eh65YSMS9XimEtXrJ72gs4WTVCMml5a27ME+J
         IuXQfEgPIxwqtmclNCvKlIKtQCq2ZVeTR9umnrxI007JRgGKr80yvPfIfDZtoGcpjGav
         m69KvMzLhixv+yxUYT2yLngPOuD77HmnZZJorxHBQFj6gx29HXIcejY4A5b472ey0fzI
         kwoxaWtT0NoL/ESGTlsQ05C2z9cqOov9gLiyuDjtFcUQxnzF0X8Zfb6LGWJH3uDl832p
         jQWzmjhJ2OLPZUMLVxZPQcHMp7GQI+hvUS3w0vSP0akNJQlCvuq54B21mlD13zP0w6V5
         sNvg==
X-Gm-Message-State: ANoB5pnPZf9gumPBoTw6HHmuX3141tB5oqQhNYhpymPb4tzwgzKryzvI
        KzmfXfsw7qx3HB6/e3Xmg0JYTIWJ9yoXcT8ma6FbpZ7mH6U=
X-Google-Smtp-Source: AA0mqf4EmE+lBmfS6cyx7PEKMJy3ChRF933leTXIgvZ5dLEbEdOAVVJpVULFQtWBQhgUQZ52/kYbSXj5dEx0yoW0jQE=
X-Received: by 2002:a81:5748:0:b0:3b1:eee3:32a with SMTP id
 l69-20020a815748000000b003b1eee3032amr23603644ywb.325.1669668148485; Mon, 28
 Nov 2022 12:42:28 -0800 (PST)
MIME-Version: 1.0
References: <20221124222926.72326-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20221124222926.72326-1-andriy.shevchenko@linux.intel.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 28 Nov 2022 21:42:16 +0100
Message-ID: <CACRpkda1sdqxnP0Lc2qnWOq5PH4_8vTvNiwn3ibE7+uZwLv0Gg@mail.gmail.com>
Subject: Re: [PATCH v1 1/1] pinctrl: intel: Save and restore pins in "direct
 IRQ" mode
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andy@kernel.org>, stable@vger.kernel.org,
        Dale Smith <dalepsmith@gmail.com>,
        John Harris <jmharris@gmail.com>
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

On Thu, Nov 24, 2022 at 11:29 PM Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:

> The firmware on some systems may configure GPIO pins to be
> an interrupt source in so called "direct IRQ" mode. In such
> cases the GPIO controller driver has no idea if those pins
> are being used or not. At the same time, there is a known bug
> in the firmwares that don't restore the pin settings correctly
> after suspend, i.e. by an unknown reason the Rx value becomes
> inverted.
>
> Hence, let's save and restore the pins that are configured
> as GPIOs in the input mode with GPIROUTIOXAPIC bit set.
>
> Cc: stable@vger.kernel.org
> Reported-and-tested-by: Dale Smith <dalepsmith@gmail.com>
> Reported-and-tested-by: John Harris <jmharris@gmail.com>
> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=214749
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>
> Linus, I hope that this can still make v6.1 release. I'm not going to
> send a PR for this change unless you insist.

Patch applied for fixes, plan is to get it to Torvalds
ASAP!

Yours,
Linus Walleij
