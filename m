Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB842C2042
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 09:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730776AbgKXImD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 03:42:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730772AbgKXImC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Nov 2020 03:42:02 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52DAAC0613D6
        for <stable@vger.kernel.org>; Tue, 24 Nov 2020 00:42:01 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id d20so11823422lfe.11
        for <stable@vger.kernel.org>; Tue, 24 Nov 2020 00:42:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wvJieEgip1g2WEMiOdWtOXx++qG4HU5IWILT3U6RFgs=;
        b=mJUb4iGMJjIWX8lPMq4tIdVYYwCQ67pBbsA+TPEjhQUqZSAatFbBhuCBKyZsKh8fCc
         JGpV0Cc2ww5FVkjK63FldrCA9Ig/lclWUIkH+vU/D421GHQ60WDTVS7RhVSTyJmRPPbm
         vlKNUUw+ltheJYgTJ6WBZ/vKeTtoG5+fj2fyzvIPf8kBhK4gxu6qfLs/P1Qgksfm4fvE
         gCqb1lv58LleBY/hA5uwf9esy/7WwKX1IeTsIZVNuXTpHvrVix6x+q/3uc+HHz85ECOP
         7c8+s1vq6e5L2fQCf1ooqPCMlZ5x42ijySwcRxEE/jL/qA+EjXMtSGYmuBEFllkrARzE
         mNtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wvJieEgip1g2WEMiOdWtOXx++qG4HU5IWILT3U6RFgs=;
        b=doO1ycMOlM5mT6FX9WNVxx4V/aspQpeFLavA7TzRKU8kQNbj5emF7AJiWCpsQYJTsA
         9VpWrGnAFi0sBtoKoqlIzoV4Z2SfVlTNAdtKQlTRCdmx4sQw5H4mak8+Wu9uBugnv5Wu
         b6dMEpxIgrnRc8ezODpjVZVDfCcqQxXsnRaOh4mqIPDD0fvnPGlt+5/yDigRLpuUENFf
         Yl5Dk8o/846KdWGNyIZmTX8Qrp7IMpJnwA/yOy/9zWq/MkVwiMT2fxTr8T5Lm6dJWaKt
         RZGJ2+4r3IBMX+D6xV/WgZiIwZ4ov2f5GtGJCd6hjeWoZjUW59mVpop5MiOFPPtvWyDM
         a5zw==
X-Gm-Message-State: AOAM530hlqJyMb+hGYGElPZO8UxMMXMZMJI9d3cpZshe3sGOV888Hj3T
        bdSBV++3JTs/5ZwqJAfcaiV73AKp/L+Eocfluj4tvyglSnrpfQ==
X-Google-Smtp-Source: ABdhPJwq8vXwP1njCi8d7YRqNvXM/K6scFYWCwRR28xF1q8lPLVDfnosAP2q9vjrVciFTOlk0Ez/FkVcAKgB/NO8E4k=
X-Received: by 2002:a19:7b06:: with SMTP id w6mr1430812lfc.260.1606207319854;
 Tue, 24 Nov 2020 00:41:59 -0800 (PST)
MIME-Version: 1.0
References: <cover.1604988979.git.frank@allwinnertech.com> <85263ce8b058e80cea25c6ad6383eb256ce96cc8.1604988979.git.frank@allwinnertech.com>
In-Reply-To: <85263ce8b058e80cea25c6ad6383eb256ce96cc8.1604988979.git.frank@allwinnertech.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 24 Nov 2020 09:41:49 +0100
Message-ID: <CACRpkdbYe7dRLn=-+f0KPu_gzfaOKwz+=2VwzQKOS7xFHu0qPA@mail.gmail.com>
Subject: Re: [RESEND PATCH 03/19] pinctrl: sunxi: Always call
 chained_irq_{enter, exit} in sunxi_pinctrl_irq_handler
To:     Frank Lee <frank@allwinnertech.com>
Cc:     Frank Lee <tiny.windzz@gmail.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 10, 2020 at 7:24 AM Frank Lee <frank@allwinnertech.com> wrote:

> From: Yangtao Li <frank@allwinnertech.com>
>
> It is found on many allwinner soc that there is a low probability that
> the interrupt status cannot be read in sunxi_pinctrl_irq_handler. This
> will cause the interrupt status of a gpio bank to always be active on
> gic, preventing gic from responding to other spi interrupts correctly.
>
> So we should call the chained_irq_* each time enter sunxi_pinctrl_irq_handler().
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Yangtao Li <frank@allwinnertech.com>

Patch applied.

Yours,
Linus Walleij
