Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59BF53E5A59
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 14:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238646AbhHJMtB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 08:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236583AbhHJMtB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 08:49:01 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 615E6C0613D3
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 05:48:39 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id h11so13813478ljo.12
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 05:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vrcMLWtfOeCXSMGpjMYNY3zEn4WCrRn/aqSB39sMZio=;
        b=eD3vQDsassz7bEN0mNbQhZAijheRKwqU+oK96s9ut4efsxy/pfcMMgLfN/39mBcNzA
         CWcAVe/mxoYkiw5lw9HAubl20qZcNVos3RgWK1m2BARdzZAuLzG/CDkcJg/YoPg6pxSO
         6pWektyrqQeFMs+3mYXfOkCXNiN4k44T+Av9Xfx5y9PLMvke9N7nIVdxG7ov3uqszD0G
         s+pKlKviR2OdDnoh4hi918VXhjTAb4W2zC/pe4xpQmBAlIe5/uu0nqio9njHt6C5sx0A
         nTPOCui2hn2g9N2pRraqtmMEHWvGpHUdOCSzjrh2QSS7U+ahTai2W/biKy52JtUBdbgL
         rUTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vrcMLWtfOeCXSMGpjMYNY3zEn4WCrRn/aqSB39sMZio=;
        b=e9ViE5zH37ebwZ1WukHur74Y98pNDOFTmLSc0brxZsRD4aphrb/97nuHccvW8xtHLO
         dNCnHbMch6O5+azSFggLeXmb7gKGhR+pOR8q28diJRihg0ykZAoE6l+XUIna8gAtn6j3
         Z6q8YwgkWKwpN5Qhwpi7xLYefGeFO1Y/Wgdc+/Eh7dRWa0H+l5adhF91wZY6FcZhg+ET
         YPS3KgrgtZ11+zIuAPj7MMu/dn+hxAs8ytss0fAl+XIA7ut4VBd6wXhJZ/Defj4lRXYC
         xiAMv8njbU187yQfSFUcHxvx0xSh1ID8RqRWK6Ztg3l2sxb1uHJOX7yJZ4dPgIY2MhC3
         75JQ==
X-Gm-Message-State: AOAM531qtHkwP+9iV4Ezuq9owyGTDT2sGj0PmbhV9/ExikubtkZe9Js6
        WMnsC7GapLGQ9w6FeMMiTDNdXuComXhUz480cubCGQ==
X-Google-Smtp-Source: ABdhPJyLep687DdIq4Uf7xmhfsYa46ZEV2mhNzCv+q7NsAgri4IdNPReJB6X5A+3utEOR+kjh7KGMkjlhyQd0vAmS5A=
X-Received: by 2002:a2e:a231:: with SMTP id i17mr9037133ljm.467.1628599717797;
 Tue, 10 Aug 2021 05:48:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210725180830.250218-1-maz@kernel.org>
In-Reply-To: <20210725180830.250218-1-maz@kernel.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 10 Aug 2021 14:48:26 +0200
Message-ID: <CACRpkdbAnvk2AyT=Gom=AHZacm7sDJONR=6EnHLZ+cEySqQ4KQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: stmfx: Fix hazardous u8[] to unsigned long cast
To:     Marc Zyngier <maz@kernel.org>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        stable <stable@vger.kernel.org>,
        Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 25, 2021 at 8:08 PM Marc Zyngier <maz@kernel.org> wrote:

> Casting a small array of u8 to an unsigned long is *never* OK:
>
> - it does funny thing when the array size is less than that of a long,
>   as it accesses random places in the stack
> - it makes everything even more fun with a BE kernel
>
> Fix this by building the unsigned long used as a bitmap byte by byte,
> in a way that works across endianess and has no undefined behaviours.
>
> An extra BUILD_BUG_ON() catches the unlikely case where the array
> would be larger than a single unsigned long.
>
> Fixes: 1490d9f841b1 ("pinctrl: Add STMFX GPIO expander Pinctrl/GPIO driver")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org
> Cc: Amelie Delaunay <amelie.delaunay@foss.st.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
> Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>

Patch applied!

Yours,
Linus Walleij
