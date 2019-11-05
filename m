Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B066EF787
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 09:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbfKEIul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 03:50:41 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:34486 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbfKEIuk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Nov 2019 03:50:40 -0500
Received: by mail-oi1-f196.google.com with SMTP id l202so16817369oig.1;
        Tue, 05 Nov 2019 00:50:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=28cLkO7qegUXgPQi+0pfqva0QbshEF6+bTVBbn3xupU=;
        b=flWNQfm20hm5Q+6wLgi2WrmuHQSSs8cGCsqJrwXEwsJqkt3ycOur9R8KxdB4/ApMl6
         pCwfZcQUpQYPkPGBEWHVaeTeKNPIUtw6hHBQaUBStHMIzcV4XG2lMosxJrJeBSCZmHyO
         BDy1bHE5RtsFpvHovbDw8jngSpVOI7qiTUtCqMNEYW9It4iBMg9SE3kTn1rQu9y6N1A7
         Rq817JWct1q8zVfvVF/uf9MjUiI94/sn98kKO5zvomg5tSP4EO5FLf47BMMQiWU6xcTR
         yF1AS/0r03KbUppupuHHgVAymXkD5O2ze1zcjPAGmIVLoQc42mYNK/EqZ3Ns7wbTFLs+
         eaHw==
X-Gm-Message-State: APjAAAXn/IodrUzY/exHf4z8lA03mzVcDOJzbzyRQbQS9svkJqR3po3Z
        iSlOXl6O57hJoYnDy9C7JVXhvftJfGCdzHDvjKA=
X-Google-Smtp-Source: APXvYqzY+/r35RxnrCGRPbLEHBoOldup6xEf5d/zLZxfI5uFO2HR3uPbyGccVA/YpjpAorRLWycguxBnBBaij0CMeak=
X-Received: by 2002:aca:3a86:: with SMTP id h128mr2870878oia.131.1572943839669;
 Tue, 05 Nov 2019 00:50:39 -0800 (PST)
MIME-Version: 1.0
References: <1572922092-12323-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <1572922092-12323-3-git-send-email-yoshihiro.shimoda.uh@renesas.com>
In-Reply-To: <1572922092-12323-3-git-send-email-yoshihiro.shimoda.uh@renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 5 Nov 2019 09:50:28 +0100
Message-ID: <CAMuHMdWrQs49BFaN49odrG3k91d2rsRLPpCSvDcj5DhKeHPPaA@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] PCI: rcar: Fix missing MACCTLR register setting in
 initialize sequence
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     Marek Vasut <marek.vasut+renesas@gmail.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Shimoda-san,

On Tue, Nov 5, 2019 at 3:48 AM Yoshihiro Shimoda
<yoshihiro.shimoda.uh@renesas.com> wrote:
> According to the R-Car Gen2/3 manual, "Be sure to write the initial
> value (= H'80FF 0000) to MACCTLR before enabling PCIETCTLR.CFINIT".
> To avoid unexpected behaviors, this patch fixes it. Note that
> the SPCHG bit of MACCTLR register description said "Only writing 1
> is valid and writing 0 is invalid" but this "invalid" means
> "ignored", not "prohibited". So, any documentation conflict doesn't
> exist about writing the MACCTLR register.
>
> Reported-by: Eugeniu Rosca <erosca@de.adit-jv.com>
> Fixes: c25da4778803 ("PCI: rcar: Add Renesas R-Car PCIe driver")
> Fixes: be20bbcb0a8c ("PCI: rcar: Add the initialization of PCIe link in resume_noirq()")
> Cc: <stable@vger.kernel.org> # v5.2+
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

Thanks for your patch!

> --- a/drivers/pci/controller/pcie-rcar.c
> +++ b/drivers/pci/controller/pcie-rcar.c
> @@ -91,8 +91,12 @@
>  #define  LINK_SPEED_2_5GTS     (1 << 16)
>  #define  LINK_SPEED_5_0GTS     (2 << 16)
>  #define MACCTLR                        0x011058
> +#define  MACCTLR_RESERVED23_16 GENMASK(23, 16)

MACCTLR_NFTS_MASK?

>  #define  SPEED_CHANGE          BIT(24)
>  #define  SCRAMBLE_DISABLE      BIT(27)
> +#define  LTSMDIS               BIT(31)
> +        /* Be sure to write the initial value (H'80FF 0000) to MACCTLR */

Do we need this comment?

> +#define  MACCTLR_INIT_VAL      (LTSMDIS | MACCTLR_RESERVED23_16)
>  #define PMSR                   0x01105c
>  #define MACS2R                 0x011078
>  #define MACCGSPSETR            0x011084

With the above fixed:
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
