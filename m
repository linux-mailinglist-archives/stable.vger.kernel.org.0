Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6B013EDFFF
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 00:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbhHPWib (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 18:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232448AbhHPWib (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 18:38:31 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4177C0613C1
        for <stable@vger.kernel.org>; Mon, 16 Aug 2021 15:37:58 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id h17so29611437ljh.13
        for <stable@vger.kernel.org>; Mon, 16 Aug 2021 15:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=39HL+1BSTEP9McF8N5wJpHZqTmDxGof61S5w7T18t2c=;
        b=PIs+rFO4pY8Mv2zPiP7V6q/9YBvqlbSQNI7cVts9VvV0Hz3CkLMBnig1HrU7GnFYCE
         O0Q4VRNvYIVl119B7gJPknlTEUx+o0PWLDRPKeaE+JF0RKf6O01d+ztmYDR3LJ/5BZLK
         7aYlfzKganWO6Zz/nbb5QGdMwAmcFJ7YNW/EFtn8uVSguA0SKqkNu7u1yTFx760GaryM
         pJugUZKI8rd1dAmUwiCsf1Wm7L2TAcWTw/LSngxpoeua5nKPQoWX0dspsKulFQ0ntlCj
         QRhfsrxl6bi0Yqc0tXysl1ZoKWnjIEYeZMQHApP5C6ATdIyZ1qR+GBZy/BCrs8N5He8N
         H69w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=39HL+1BSTEP9McF8N5wJpHZqTmDxGof61S5w7T18t2c=;
        b=ijneOZrJL/vOtTA8Vq2C4W7txMzy5U1XILSqaz88Q0xTs+nVtvmY+Jo8M5Rxi+eB4v
         stp9dPfyndt+5D+or/8Pujtf9wwAC5bYpWGtZFU/VQOcCP3hPFYD5cJfjQsn0r9K4BBn
         JZE8kg6N0mxlfg/qIrHx/9lIRmP0G8cnZa7aU0B0EiOQYgKSZHqDZFxRJEePVRrrDEQL
         zPxf3TvNjyESmjHcmC0a1iTg9aGR7+eRA8e1rgXtctpl4DkL8xYCwy5lWiZZ9hD6gkPu
         JfZpnhsj3XmIhjlJk1Nknv0W52C2iE7Mjk9JZu5iQigL5uTr8OxTz2f6V5rP5SXZXP78
         NQhg==
X-Gm-Message-State: AOAM532YcEDXK7o1pxSb6UJwHoeEjNaB7ErLJ3Usb/TU6ZswBsBWQpMj
        +b9H+18MkpQ3UaTNpKcn4ZHtuDK8WMNWKljXlCXBJg==
X-Google-Smtp-Source: ABdhPJxzmodtRFtigSTsXW3Hjcueq6Q1d1XD/3P7zoYrskkwNMcxgNm5kFyqkanm5Fu3lKOWWYYYiaLrR2KTWatt1+Q=
X-Received: by 2002:a05:651c:1507:: with SMTP id e7mr426852ljf.368.1629153476979;
 Mon, 16 Aug 2021 15:37:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210720144115.1525257-1-linus.walleij@linaro.org> <2f449f6e-bca0-3c70-4255-26619e957d44@foss.st.com>
In-Reply-To: <2f449f6e-bca0-3c70-4255-26619e957d44@foss.st.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 17 Aug 2021 00:37:46 +0200
Message-ID: <CACRpkdY2GnqNYqPPctqa_t5ax1SDo7nEc3a1jSncF8N-V-Da-g@mail.gmail.com>
Subject: Re: [PATCH v3] mmc: core: Add a card quirk for non-hw busy detection
To:     Yann Gautier <yann.gautier@foss.st.com>
Cc:     linux-mmc <linux-mmc@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        stable <stable@vger.kernel.org>, phone-devel@vger.kernel.org,
        Ludovic Barre <ludovic.barre@st.com>,
        Stephan Gerhold <stephan@gerhold.net>,
        Stefan Hansson <newbyte@disroot.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 16, 2021 at 4:03 PM Yann Gautier <yann.gautier@foss.st.com> wrote:

> I was just testing your patch on top of mmc/next.
> Whereas mmc/next is fine, with your patch I fail to pass MMC test 5
> (Multi-block write).
> I've got this error on STM32MP157C-EV1 board:
> [  108.956218] mmc0: Starting tests of card mmc0:aaaa...
> [  108.959862] mmc0: Test case 5. Multi-block write...
> [  108.995615] mmc0: Warning: Host did not wait for busy state to end.
> [  109.000483] mmc0: Result: ERROR (-110)
> Then nothing more happens.
>
> The test was done on an SD-card Sandisk Extreme Pro SDXC UHS-I mark 3,
> in DDR50 mode.
>
> I'll try to add more traces to see what happens.

What I think happens is:
- You are using the MMCI driver (correct?)
- My patch augments the driver to not use busydetect until we have
  determined that the card can do it (after reading extcsd etc)
- Before this patch, the MMCI would unconditionally use HW
  busy detect on any card.

Either we have managed to wire the MMCI driver so that it doesn't
work without HW busy detect anymore, you can easily test this
by doing this:

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 3765e2f4ad98..3a35f65491c8 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -270,10 +270,10 @@ static struct variant_data variant_stm32_sdmmc = {
        .datactrl_any_blocksz   = true,
        .datactrl_mask_sdio     = MCI_DPSM_ST_SDIOEN,
        .stm32_idmabsize_mask   = GENMASK(12, 5),
-       .busy_timeout           = true,
-       .busy_detect            = true,
-       .busy_detect_flag       = MCI_STM32_BUSYD0,
-       .busy_detect_mask       = MCI_STM32_BUSYD0ENDMASK,
+       //.busy_timeout         = true,
+       //.busy_detect          = true,
+       //.busy_detect_flag     = MCI_STM32_BUSYD0,
+       //.busy_detect_mask     = MCI_STM32_BUSYD0ENDMASK,
        .init                   = sdmmc_variant_init,
 };

@@ -297,10 +297,10 @@ static struct variant_data variant_stm32_sdmmcv2 = {
        .datactrl_mask_sdio     = MCI_DPSM_ST_SDIOEN,
        .stm32_idmabsize_mask   = GENMASK(16, 5),
        .dma_lli                = true,
-       .busy_timeout           = true,
-       .busy_detect            = true,
-       .busy_detect_flag       = MCI_STM32_BUSYD0,
-       .busy_detect_mask       = MCI_STM32_BUSYD0ENDMASK,
+       //.busy_timeout         = true,
+       //.busy_detect          = true,
+       //.busy_detect_flag     = MCI_STM32_BUSYD0,
+       //.busy_detect_mask     = MCI_STM32_BUSYD0ENDMASK,
        .init                   = sdmmc_variant_init,

Or else there is a card that cannot work without busy detect which
I find unlikely.

Yours,
Linus Walleij
