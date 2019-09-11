Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6F89AF581
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 07:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbfIKFz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Sep 2019 01:55:27 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:34422 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbfIKFz1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Sep 2019 01:55:27 -0400
Received: by mail-oi1-f194.google.com with SMTP id 12so1950607oiq.1
        for <stable@vger.kernel.org>; Tue, 10 Sep 2019 22:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YM9Kdr6pR5ir7duMfXwKDarzHXJpHvXrhgqbZfkgyPo=;
        b=qsq1GMF2ulu4HYjpmfNjkU+svPULNKsFBDnfrbqvgBAt0sI3P5hnPGDp+PXIxN5Qnr
         ULHtUiLC7YYgwecrpKkiJOHZSgj8ZS9+lGTJlH9LBByDp3iieP138pzF1dUR3GL8QKCf
         ujLaU2k4LfPVymsjQlPCjPjKxQxNppnzV1pi4c3AbsOny/l+quvwbyWQGPac9xW1bEZg
         wFUhmqHdPJLbBs5zSYwfEashUsHkRLqckbQI+v3jN+b/YB18JBJ43IAbPYqaUIL9ffcs
         E8pI++hXavPOnHIApgP4tuwuxRu2I5+I+BLVB5Jeylihn3eNTKKVXs/e7+ndw8nygvZC
         cg0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YM9Kdr6pR5ir7duMfXwKDarzHXJpHvXrhgqbZfkgyPo=;
        b=dscPUqxYwh4TrzWMFwbb5m1+Neo47kIVlvnakfG120V79MjfKfy+rVjqs9RNsgCUuV
         pC6XTmjPP/sfkH7jZBTPBEj/kNRmrszZsCeFiUIcP/WXj3S9IrSyXP6+MOQtMVlAl64G
         WoOry8IcRtstGP53jD1rysmzeoexxJ0Gq4FtnuLiQGkIywsPJ6TT4q3n9aPcBol9ltJE
         QQT6TNCYL3qM3oNNEGP/m+teDOYFuBEg9w4taJYY6U07psmYl8NO22dr6tgnzJFfBtB+
         iG8AZxu+DBtkR6oA89Jc/AMR3wQ1xcRdauOvCB8/s1Znpm5KWjWS9voCOMqpdLQGyuTH
         RmWw==
X-Gm-Message-State: APjAAAV39cWaUk7DQJvolSM366kw4yYm7q3j2qWNw9A5qF6J6v4SgxWX
        +hJMC16cUEjMS6TEAWU1uFEf6wYRlr7YzZkdP1i/+A==
X-Google-Smtp-Source: APXvYqz0CXlFQ4QKcgT2lV5sbnXYFZ+y9GQ1tRvJmX8PPD/t7utrccBcs5DQOstgiQUvQmjfaq7+K9YdmeYUA14R33g=
X-Received: by 2002:a54:4f8a:: with SMTP id g10mr2667440oiy.147.1568181326176;
 Tue, 10 Sep 2019 22:55:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190910082138.30193-1-brgl@bgdev.pl> <20190910104829.983FE2067B@mail.kernel.org>
In-Reply-To: <20190910104829.983FE2067B@mail.kernel.org>
From:   Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date:   Wed, 11 Sep 2019 07:55:15 +0200
Message-ID: <CAMpxmJW0gd9vVp-UXeRBsrLuvYiOJNo=mcLZi8DLCQKNNXgO2A@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: don't clear FLAG_IS_OUT when emulating open-drain/open-source
To:     Sasha Levin <sashal@kernel.org>
Cc:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio <linux-gpio@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Stable # 4 . 20+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

wt., 10 wrz 2019 o 12:48 Sasha Levin <sashal@kernel.org> napisa=C5=82(a):
>
> Hi,
>
> [This is an automated email]
>
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: c663e5f56737 gpio: support native single-ended hardware dr=
ivers.
>
> The bot has tested the following trees: v5.2.13, v4.19.71, v4.14.142, v4.=
9.191.
>
> v5.2.13: Build OK!
> v4.19.71: Build OK!
> v4.14.142: Failed to apply! Possible dependencies:
>     02e479808b5d ("gpio: Alter semantics of *raw* operations to actually =
be raw")
>     fac9d8850a0c ("gpio: Get rid of _prefix and __prefixes")
>
> v4.9.191: Failed to apply! Possible dependencies:
>     02e479808b5d ("gpio: Alter semantics of *raw* operations to actually =
be raw")
>     0db0f26c2c5d ("pinctrl-sx150x: Convert driver to use regmap API")
>     2956b5d94a76 ("pinctrl / gpio: Introduce .set_config() callback for G=
PIO chips")
>     46a5c112a401 ("gpio: merrifield: Implement gpio_get_direction callbac=
k")
>     6489677f86c3 ("pinctrl-sx150x: Replace sx150x_*_cfg by means of regma=
p API")
>     6697546d650d ("pinctrl-sx150x: Add SX1503 specific data")
>     9e80f9064e73 ("pinctrl: Add SX150X GPIO Extender Pinctrl Driver")
>     e3ba81206811 ("pinctrl-sx150x: Improve OF device matching code")
>     e7a718f9b1c1 ("gpio: merrifield: Add support for hardware debouncer")
>
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?
>

Once it's accepted, I'll prepare backports.

Bart
