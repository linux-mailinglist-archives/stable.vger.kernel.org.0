Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1391D196068
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 22:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727548AbgC0V2c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Mar 2020 17:28:32 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:42126 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727444AbgC0V2b (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Mar 2020 17:28:31 -0400
Received: by mail-lf1-f67.google.com with SMTP id t21so9063072lfe.9
        for <stable@vger.kernel.org>; Fri, 27 Mar 2020 14:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AKs2wUFl9mGzanJxstXyv3eIv3rgDvp5GN7P4hoUxzU=;
        b=bXvaM7O2ssMqHhYhwo6oK1Jw53UiTWSKEt1XglHA8CnPQ1fyd+ZI62/7aMfqESwZTe
         Xi/NInkuT/diSkGzzsziGL/kvqGwV/x5KpPlSLyI9EqIwJ7On3chcc4GlbVTgUzk3miE
         2r1OaW9CDcCesVopTtnBJ0O+A4i8bd9Vxnj7VEoss22QmJJ0KqWCw5zyIZsh2Qn4WD+z
         OwMCNsUjsbIrUpQLan32VNbK5Kih8QTdImTcN1PKw8nhsjgqa2sDUptAtKtwcclxQ5Sh
         2WXwSYmX4x7jr3wqpzvmb3Ma8eT5hVWACOCLyGLznxWB2t/W7oOPPXl/+5Y2Wsy12XlI
         N9ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AKs2wUFl9mGzanJxstXyv3eIv3rgDvp5GN7P4hoUxzU=;
        b=HXQu+1V/vemzetO1wfGCdYL5gmZP45F+93UXGOtnO736vG0pw2ujPuP4efMNPTWuOi
         0xC+zhRc4ha52pc/9Qd9H8VHfOMEVzrMFIsoi+LVJzjkOvPHq7ZyCDspKGHxaW6fA7sw
         wsQS/swjmFXOS9fMiA7aisqXOvIbahb9EZvI/jPcAi8ZTLiVKsHPq+z0REs3pP4qYnyN
         3Q+xCMAVhay/AVP72KtoERKHHFfMvqb2JDHwAS8+m4iPrJ0U1JvsQ6FYCEKWxP27/wxf
         0AvooQMFLJA4maS7QdYhveB7QZbP5VjxhH7MW5PajKtZeujzL8/6drSh4ZQQplHuu1q6
         LszQ==
X-Gm-Message-State: AGi0PuapUCs4psY+I1InEhFozwijRt/O7Heimv5E9+saxSG5lsMKMDfF
        yLhRlZomMNDISpInuuyRFz4ybeYWYMg3ATw2nySlVftsDvk=
X-Google-Smtp-Source: APiQypKqfkkJWo0LyofqKXzbQiZeKqIvwRaDCBJui4ScAZ7ROxscEufS43eqyhCR13YrShZVlst0oCy4cgAUK1mRC50=
X-Received: by 2002:a19:6502:: with SMTP id z2mr763585lfb.47.1585344509130;
 Fri, 27 Mar 2020 14:28:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200325103154.32235-1-anssi.hannula@bitwise.fi>
In-Reply-To: <20200325103154.32235-1-anssi.hannula@bitwise.fi>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Fri, 27 Mar 2020 22:28:17 +0100
Message-ID: <CACRpkdafCsx+Q+L0q2j-=Q-5PY3yJx=JCmhPmDiDkt6p3YK2RA@mail.gmail.com>
Subject: Re: [PATCH] tools: gpio: Fix out-of-tree build regression
To:     Anssi Hannula <anssi.hannula@bitwise.fi>
Cc:     Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Laura Abbott <labbott@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 25, 2020 at 11:33 AM Anssi Hannula <anssi.hannula@bitwise.fi> wrote:

> Commit 0161a94e2d1c7 ("tools: gpio: Correctly add make dependencies for
> gpio_utils") added a make rule for gpio-utils-in.o but used $(output)
> instead of the correct $(OUTPUT) for the output directory, breaking
> out-of-tree build (O=xx) with the following error:
>
>   No rule to make target 'out/tools/gpio/gpio-utils-in.o', needed by 'out/tools/gpio/lsgpio-in.o'.  Stop.
>
> Fix that.
>
> Fixes: 0161a94e2d1c ("tools: gpio: Correctly add make dependencies for gpio_utils")
> Cc: <stable@vger.kernel.org>
> Cc: Laura Abbott <labbott@redhat.com>
> Signed-off-by: Anssi Hannula <anssi.hannula@bitwise.fi>

Patch applied with Bartosz' review tag.

Yours,
Linus Walleij
