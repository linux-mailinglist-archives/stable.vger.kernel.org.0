Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4227D304072
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 15:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390928AbhAZNZ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 08:25:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391758AbhAZJ4Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 04:56:24 -0500
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2286EC06174A
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 01:55:44 -0800 (PST)
Received: by mail-vs1-xe29.google.com with SMTP id p20so8705541vsq.7
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 01:55:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=arxHqUjVCPMGGo+kdWhr5qA09DPzoA8oDcXRjdjMesU=;
        b=EcShE3WriMxg/Eue+lluAhZy6XFdaiE7q/zIsBoYY7Ag15pVcIAPm2Rt5omAdELLCc
         11mz6CsjnLhyj61t/GIlOHf/TvdxS3gxdXSFfStT0k870nQbJoQ9eSIIYNuucpdWD8/S
         Sw/hzDKeBM6ISYAhYAe2Lw3q1xaBQtNpijQLFlW35bgeheAvsC77lBYtyV4oVcHveh1s
         3mcs8sn6PHPe4ll+5zwuh/wDZZFvTa6fkB1RVZgsUwDAgARuLfkdcz9/RPCFOQ0/UuW7
         /8XScZGzxB7cHdgTdkOiUb9Ll6WPzk2b+hSIWlPzYClk0yitUo36hYJGl2aqUGZPViDE
         uldw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=arxHqUjVCPMGGo+kdWhr5qA09DPzoA8oDcXRjdjMesU=;
        b=sn6Xvzs+RtHzlbDWEjVuUb7JvUd+fWNlW4C8Cg2WotqM804GXZz1BJuijUoI2fWGg3
         0p/cJ8BOrpX8/jwrA//pwO/pS9seSY3JPPAITu2oUTcuoMDvnlqRl4hmFE3JPEYQ1sB3
         lQAspNUQ4y2alZ3ubFCo3HdXi4bCfHXBEA5JR8kJjvkjbSsZebve4hgNip2qKORleKkw
         wi4JJO6Qj6U46CT88qMc2RJd36cDa89+EzcLlND6rOE2Qjjcxz3k26jzaMAE+uEYAYRK
         3bWs+KD2q2+R5d/6ivC1CKSFLHDyGTZkX+R4Afq/ALpr3ILSJdOsLotvgb+JV7FGXUeS
         GoYw==
X-Gm-Message-State: AOAM533YcVln/3gNbkbgAkxnoOEfBxfINV78FVLb+ws2u769BDRuFgLJ
        YkXt3qKjGV3O9sN7hr2siFnLgzrgQSJ3Q+ImvSnjWA==
X-Google-Smtp-Source: ABdhPJz0yZvD2Kri9nEUdn+/MXiaY91SPbRIkAAb7URMZZAOXugfNTa0Bn9xEPlfbJnKhse7FqsZsh1vyYupSyURNt8=
X-Received: by 2002:a05:6102:67b:: with SMTP id z27mr2242407vsf.19.1611654943282;
 Tue, 26 Jan 2021 01:55:43 -0800 (PST)
MIME-Version: 1.0
References: <20210125125050.102605-1-arnd@kernel.org> <f671f5d2-36c4-ded5-c4b9-93c5c57cc9f2@gmail.com>
In-Reply-To: <f671f5d2-36c4-ded5-c4b9-93c5c57cc9f2@gmail.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Tue, 26 Jan 2021 10:55:07 +0100
Message-ID: <CAPDyKFoGDHtE8JgLurwuN-W6CmmyBB3GP+7Z-bWqJiWw+TJEaQ@mail.gmail.com>
Subject: Re: [PATCH] mmc: brcmstb: Fix sdhci_pltfm_suspend link error
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Arnd Bergmann <arnd@kernel.org>,
        Nicolas Schichan <nschichan@freebox.fr>
Cc:     Al Cooper <alcooperx@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        BCM Kernel Feedback <bcm-kernel-feedback-list@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "# 4.0+" <stable@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 25 Jan 2021 at 18:40, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> +Nicolas,
>
> On 1/25/2021 4:50 AM, Arnd Bergmann wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> > sdhci_pltfm_suspend() is only available when CONFIG_PM_SLEEP
> > support is built into the kernel, which caused a regression
> > in a recent bugfix:
> >
> > ld.lld: error: undefined symbol: sdhci_pltfm_suspend
> >>>> referenced by sdhci-brcmstb.c
> >>>>               mmc/host/sdhci-brcmstb.o:(sdhci_brcmstb_shutdown) in archive drivers/built-in.a
> >
> > Making the call conditional on the symbol fixes the link
> > error.
> >
> > Fixes: 5b191dcba719 ("mmc: sdhci-brcmstb: Fix mmc timeout errors on S5 suspend")
> > Fixes: e7b5d63a82fe ("mmc: sdhci-brcmstb: Add shutdown callback")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> > It would be helpful if someone could test this to ensure that the
> > driver works correctly even when CONFIG_PM_SLEEP is disabled
>
> Why not create stubs for sdhci_pltfm_suspend() when CONFIG_PM_SLEEP=n? I
> don't think this is going to be a functional issue given that the
> purpose of having the .shutdown() function is to save power if we cannot
> that is fine, too.
> --
> Florian

I would prefer this approach - we shouldn't leave stub functions
unimplemented, which is what looks to me.

I just posted a new patch for this, please have a look and test it.

Kind regards
Uffe
