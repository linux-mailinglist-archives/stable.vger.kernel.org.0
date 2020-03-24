Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9B91919F9
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 20:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbgCXTdh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 15:33:37 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40255 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbgCXTdh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 15:33:37 -0400
Received: by mail-lf1-f66.google.com with SMTP id j17so14276943lfe.7
        for <stable@vger.kernel.org>; Tue, 24 Mar 2020 12:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6HwMKM8KRrL+In6hzaRGTJmiiuE30tt/i54WWDy2zpg=;
        b=X1mH4818Nuc7tUpokWld/JdiOXe7Rs7x5uu7B9cAbKHsCkU5K3ARXW9ZPLovI371Tu
         qPw2ENfUin3GqvM4xulQCI0FZnbaQ8/obc7KyCfo6hfmdt5TnVLnzt03GihqmjHYQ6us
         ToKoYt/hVxSFkyXVozJ1I5JbsuaX6E39ROvTgyOYe/THieM6If28sSNmH+3HBDv3D6xw
         ZapaigFUm608dw2Gt19lYVoiHq7uf10FyrUMwMShtXEqC95PvXR9Z609lu3PPVXljVub
         Fi/hJnIQfegsLnDFkXIW2MoUpSBLxYg2oYmwj6yBWJpZoC2S2d5tY3OCpyT5whNnqqQO
         XPOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6HwMKM8KRrL+In6hzaRGTJmiiuE30tt/i54WWDy2zpg=;
        b=ci9Bg4LrmIV28hq93pM8oyn/PhYZ6z2m/VWWLE1+5DMqjdUZ6L0WNx5VqirXy7jVIt
         3JE8tFC/e9PbueTKdEz0MUW1h993gvuyXCzlOC92oqjcMW8W+LJNzM2BLLXsuY8QEG9v
         4bfA5kguBYtv7Z561pEp/zNXsqAfNwPa25uRwcU7rF37YLyqS8ZtMZod1AqPtXQQOCfh
         eCcxTG3QimEAyw8RhxcpfeM/w+HWxufBqqFarDu1hTfNvfi1wjESbqwLAErdXbVxj/Q4
         tZm6xI7mlsE5Om5pfiWVZ8vt4buLghTUPYM3kXbz5P/VrDhFgPtOSYHjShjDN4yDpUSd
         XhhQ==
X-Gm-Message-State: ANhLgQ3fQ/jgBqZmuOwnaO0KIvWjvxXFWNhHU00CptyTdGF95oNDAy1H
        5mzA2nwORnWZCCRQ+MF+Cll7cBF1pF73NoWTVD+JVQ==
X-Google-Smtp-Source: ADFU+vu4cpZOlo6jp54+jfss6TXf+5d17promk+DinZo5kAignxOjo4HgAji1Uhblbjq022OiWVG6a01cLVmSk7G9xw=
X-Received: by 2002:a05:6512:1106:: with SMTP id l6mr17705731lfg.12.1585078414650;
 Tue, 24 Mar 2020 12:33:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200324180738.28892-1-ulf.hansson@linaro.org>
In-Reply-To: <20200324180738.28892-1-ulf.hansson@linaro.org>
From:   Anders Roxell <anders.roxell@linaro.org>
Date:   Tue, 24 Mar 2020 20:33:23 +0100
Message-ID: <CADYN=9JNsOw9SqJOS4JwQvjxrp0OPx-RX1PTHtC3Kurgh7OUaQ@mail.gmail.com>
Subject: Re: [PATCH 5.4.28 0/5] mmc: Fix some busy detect problems
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        linux-mmc@vger.kernel.org,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Faiz Abbas <faiz_abbas@ti.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 24 Mar 2020 at 19:07, Ulf Hansson <ulf.hansson@linaro.org> wrote:
>
> This series provides a couple of manually backported mmc changes that fixes some
> busy detect issues, for a couple of mmc host drivers (sdhci-tegra|omap).
>
> Ulf Hansson (5):
>   mmc: core: Allow host controllers to require R1B for CMD6
>   mmc: core: Respect MMC_CAP_NEED_RSP_BUSY for erase/trim/discard
>   mmc: core: Respect MMC_CAP_NEED_RSP_BUSY for eMMC sleep command
>   mmc: sdhci-omap: Fix busy detection by enabling MMC_CAP_NEED_RSP_BUSY
>   mmc: sdhci-tegra: Fix busy detection by enabling MMC_CAP_NEED_RSP_BUSY

Tested-by: Anders Roxell <anders.roxell@linaro.org>

I tested it on a beagleboard x15.

Cheers,
Anders

>
>  drivers/mmc/core/core.c        | 5 ++++-
>  drivers/mmc/core/mmc.c         | 7 +++++--
>  drivers/mmc/core/mmc_ops.c     | 8 +++++---
>  drivers/mmc/host/sdhci-omap.c  | 3 +++
>  drivers/mmc/host/sdhci-tegra.c | 3 +++
>  include/linux/mmc/host.h       | 1 +
>  6 files changed, 21 insertions(+), 6 deletions(-)
>
> --
> 2.20.1
>
