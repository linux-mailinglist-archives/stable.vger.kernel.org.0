Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65790B8C93
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 10:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395234AbfITIWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 04:22:34 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43008 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395228AbfITIWe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 04:22:34 -0400
Received: by mail-lj1-f196.google.com with SMTP id n14so1168409ljj.10
        for <stable@vger.kernel.org>; Fri, 20 Sep 2019 01:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/Y0dVg0rkJK+8ZRofkpbBt2xSCy2wZHIwHwOHo3SAF4=;
        b=ijM79mHPeghORpgUUpSTuQqXqvtIACE0riFZ3nYDpc7/JUA+ll2naj/N+DHS02awJw
         OniheqFSOFHPSooSh0bgBiyzFsuOXTRYpEMCETKNwyTJSBtUwC/J0gXUK14oLL5diJzK
         UTTDsVF+fEvrLh6Jx3Yh9ddZazJDlygia+Pv1NJ4DAJQPC/LRaRb96Kg8T4rFQ7JRQhD
         V3wmSB1E8e4lkLsBD5Fdhe9QRWMrh6VaXkErzyu38LWRLUY8G3SbCo/Bd/tr8fmGuca6
         gezS2HqWJwtcIrSj95vLbF50pdpCfwssPGNI48JgGfEQPicD3R/4wmNhYazixE/codC8
         zygg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/Y0dVg0rkJK+8ZRofkpbBt2xSCy2wZHIwHwOHo3SAF4=;
        b=ajdz9AvNwm3qeaE3TYIJYBcwfY1gCMOxkX8elpEYntZy4zCe94ehIaMulpDBypnI3Z
         IP0h93j06qY+R/emNexiM0j3+m/1MWeel81sZQhv74OC3N9hddhdsZIc3bJwq3yxI4bN
         WgO7Baiab1btNBHJg+HlVEJ4MlMTS22i+CzVke8lOlU8npxXAJe2O8314vIUPuMO0NRK
         GAz6wf67oJIh77bNLMDG79KB+CFp9pYY89SD9Gi2bg5RKtTwG32de1RdgMSEigf8BI6C
         IxTaYSULTeoINawEXNoxl+WY2L/KqaSnDp57CTYLNhRzhNibYWXpIcM/zKH7WDskHLax
         mKPw==
X-Gm-Message-State: APjAAAV905zAuT2rBv0srmRj8z3GfghdmlOL9TD8bAqxUqBalAeYjd/K
        OSWH04GdsEN6UVXpjoT/x9TtCXCpkvTfnYCa52i1Pw==
X-Google-Smtp-Source: APXvYqxO/HYaho83HxZXL87Foe1xgGVU5sQjvCOZPhZImVv2TthQt26ZN5SvNOQQR4SC29BcqRjlR1d06awwiiwTB0g=
X-Received: by 2002:a2e:9ccb:: with SMTP id g11mr4454624ljj.62.1568967752338;
 Fri, 20 Sep 2019 01:22:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190918155200.12614-1-dqfext@gmail.com>
In-Reply-To: <20190918155200.12614-1-dqfext@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Fri, 20 Sep 2019 10:22:21 +0200
Message-ID: <CACRpkda30tm0cVHpZHnjQki86m_4ZfGiufg8e=6Rx-S+zFHF_g@mail.gmail.com>
Subject: Re: [PATCH] spi: spi-gpio: fix crash when num-chipselects is 0
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     linux-spi <linux-spi@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 18, 2019 at 5:52 PM DENG Qingfang <dqfext@gmail.com> wrote:

> The cause is spi_gpio_setup() did not check if the spi-gpio has chipselect pins
> before setting their direction and results in derefing an invalid pointer.
>
> The bug is spotted in kernel 4.19.72 on OpenWrt, and does not occur in 4.14.
>
> There is a similar fix upstream 249e2632dcd0509b8f8f296f5aabf4d48dfd6da8.

So since this is fixed upstream I assume you mean that this should be for
stable v4.19?

I think the stable people want a special commit message structure,
see:
https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

Yours,
Linus Walleij
