Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6666BFD3
	for <lists+stable@lfdr.de>; Wed, 17 Jul 2019 18:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbfGQQs4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 12:48:56 -0400
Received: from mail-lj1-f181.google.com ([209.85.208.181]:43449 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbfGQQsz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Jul 2019 12:48:55 -0400
Received: by mail-lj1-f181.google.com with SMTP id 16so24295290ljv.10;
        Wed, 17 Jul 2019 09:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NgGtrv5SKEz++WGnlB/B3rFdiXYpyY07rfhEUYiUwH8=;
        b=MhVx2YaEcVUQ11yWhLge7sp5/jqEHDI9LwX1f7kbBfbqaM7o3uiYPPGBZjkDAy2qUF
         c2ZVP3Uz525C/YSfM0Jy916Ikg4yFoUVyxsKxpHEjxl8UwoJ7xZJ3FcNetIJAYSdjJyb
         DEIJRDQkMixS7AirdetBhDeUGPd5AGMq7zsL47Cxfb62l64UhW+7xnQZMkzIvMz7HyZX
         n7V8cRrHES0dnhqOuAFOanJd1jKkQp3I/U6fI1jfbAaW4O+sy/yLdlQRe5Lx0BnycI0V
         Ntk1tJ7bUe9nP7mefHHpPRTm8e0wDeMbcCp8iTldKBkZLc9H0xp0tRis4ncsM77NI+M4
         yEiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NgGtrv5SKEz++WGnlB/B3rFdiXYpyY07rfhEUYiUwH8=;
        b=JCsMxX8BoIJbDCwiDifWUBJL7J4gE0Pq9zI6XOoJRJv1mC0C06NRO05UY/tGwVBBW1
         Ome6WpFsRE30OlxamWP0C44sa9MIul4ao4k2IkByfwFcuM2Y3Qm3xQv8EFZ2xUabeZOP
         sg/b5FqTb/wSDPrLRgBgKKDn51bci1yV8I7Eug/yVCuEY4N9INhu5mmEcgZSKi5GRJku
         8sYfdgDqcQQHoUQG8xjxHICuO9J+k53lqTj5saAuQ2SlArAaG1FslAGTtnupIqyGSRpB
         foW2YsNXZPsXxL8a17dNSbn6Lw2VtCSvg48xChoIrRC7HM/IXPc+FQwuMTQrFeuO8PAu
         adEg==
X-Gm-Message-State: APjAAAWNOWZ9g4unIFN3YuMsSq8YIQnRPOe/reMIlpWlbHqmMOTMujBe
        DM0KcfGKU1apuxO79btjwhH0Mq+s/jUK566+XCzjIe18
X-Google-Smtp-Source: APXvYqzZRziD4tOV2evLHyib9pi+Lz6pPgFdw3aIoEAcs6WrhDBp/XFRW/fvkedarSqoyKSPHiydWYsSbR1K8gOXcRE=
X-Received: by 2002:a2e:a311:: with SMTP id l17mr20837046lje.214.1563382133648;
 Wed, 17 Jul 2019 09:48:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190717163014.429-1-oleksandr.suvorov@toradex.com> <20190717163014.429-3-oleksandr.suvorov@toradex.com>
In-Reply-To: <20190717163014.429-3-oleksandr.suvorov@toradex.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Wed, 17 Jul 2019 13:48:43 -0300
Message-ID: <CAOMZO5AgCqH+8W36vh4n3tCFvqUE=H+4Zp0jG1NQi5UFOsSSAQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/6] ASoC: sgtl5000: Improve VAG power and mute control
To:     Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Igor Opaniuk <igor.opaniuk@toradex.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Mark Brown <broonie@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Takashi Iwai <tiwai@suse.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 17, 2019 at 1:30 PM Oleksandr Suvorov
<oleksandr.suvorov@toradex.com> wrote:
>
> Change VAG power on/off control according to the following algorithm:
> - turn VAG power ON on the 1st incoming event.
> - keep it ON if there is any active VAG consumer (ADC/DAC/HP/Line-In).
> - turn VAG power OFF when there is the latest consumer's pre-down event
>   come.
> - always delay after VAG power OFF to avoid pop.
> - delay after VAG power ON if the initiative consumer is Line-In, this
>   prevents pop during line-in muxing.
>
> Also, according to the data sheet [1], to avoid any pops/clicks,
> the outputs should be muted during input/output
> routing changes.
>
> [1] https://www.nxp.com/docs/en/data-sheet/SGTL5000.pdf
>
> Signed-off-by: Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
> Reviewed-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
> Fixes: 9b34e6cc3bc2 ("ASoC: Add Freescale SGTL5000 codec support")

Reviewed-by: Fabio Estevam <festevam@gmail.com>

By the way, I prefer the description you put in the cover letter as it
explicitly talks about a bug being fixed.
