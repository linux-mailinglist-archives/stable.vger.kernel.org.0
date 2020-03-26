Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8593193D4D
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 11:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbgCZKv6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 06:51:58 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:35812 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgCZKv6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Mar 2020 06:51:58 -0400
Received: by mail-lf1-f67.google.com with SMTP id t16so3573949lfl.2
        for <stable@vger.kernel.org>; Thu, 26 Mar 2020 03:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rIU/xURtDLn8PFigh0qvNQ4+V3T/fDVQQZYd8JhofKo=;
        b=bwW61sstDbKkr/nUVOTF/i+ve5q3YImVYIpUJ7NdpBsb2hQNqKmATfrut8TgCdpN0I
         6P+nYk0rSuiiKsFPDio/U5y2qk0J/Nq13fX1tbhwXczUjszuSSX7P7310txLNa7kqFNW
         6ounHw6bF+toLDPHYN8Dgr4kyKzzoYC9ugHQuQuhJYEC14FsN5C2x52ZSOqifbtoDdRd
         k+fOiAPlFg2WyLlotATTyDCdsn/3NpM8KZT64zh5sRGHFtGgW5q7aFeoZa4vxIWox/pD
         ZaLxFowV4I6e7egotXJvScE2RvZ22GP15fgaEsQ4gHQJuMlqCpHSzG5LdO4X9pTavVAG
         kwCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rIU/xURtDLn8PFigh0qvNQ4+V3T/fDVQQZYd8JhofKo=;
        b=kVV+3AcwMFyuihM+H574uEwQiVqozwOKwVd9xTYuebH+h2sSrSI9YbJetiTRvi8nhs
         1wZEHR9wVHKpD7A+AYhMgo7RSUnX5UQyg4ks8TrhUR7OVJXX7H0WmWiy1qEBluCh2Uvf
         u43tCaVCyrehVQUoti1eRvYA/sYV3rTEZB/HlQw3wkfgQ8wEfHDJozzy/sN/mCkGTbdw
         h7WmuYe9PYTbOAGXBS+brNPgjw87gxJLv4x3LQfhqPqHBkohLLjwPZw04HHb+mZ9Nu59
         VwfkJFCq8eI+A9k81qeyvfzz65QicrfmH3PDVuRfEeIKdxV781y0UYtXv2Ah4quMHkFl
         Or7w==
X-Gm-Message-State: ANhLgQ13fZUNRvmr/20FSlZVNVmXPQiNiQ8ARKHITAt6LILfNAFasBbN
        l9L9KByE/3JgHlC/7g3hIzJqX2sTpmZNjuywQIPX2w==
X-Google-Smtp-Source: ADFU+vuc4u7Qq9hYKCXaP8KUhEDGcotTGV7qQ007wzkMl1hiLyHact9qf+t2BAOgG8Q5wJOE3MAb0Zd1AmKzabFfN7E=
X-Received: by 2002:a19:234f:: with SMTP id j76mr5401178lfj.105.1585219915896;
 Thu, 26 Mar 2020 03:51:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200324180650.28819-1-ulf.hansson@linaro.org> <20200326025132.GA4189@sasha-vm>
In-Reply-To: <20200326025132.GA4189@sasha-vm>
From:   Anders Roxell <anders.roxell@linaro.org>
Date:   Thu, 26 Mar 2020 11:51:44 +0100
Message-ID: <CADYN=9JS0fcM-B5XR9fCHiQGP1i7RSh2zUtJA+BSASGctDkJJg@mail.gmail.com>
Subject: Re: [PATCH 5.5.12 0/5] mmc: Fix some busy detect problems
To:     Sasha Levin <sashal@kernel.org>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-mmc@vger.kernel.org,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Faiz Abbas <faiz_abbas@ti.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 26 Mar 2020 at 03:51, Sasha Levin <sashal@kernel.org> wrote:
>
> On Tue, Mar 24, 2020 at 07:06:45PM +0100, Ulf Hansson wrote:
> >This series provides a couple of manually backported mmc changes that fixes some
> >busy detect issues, for a couple of mmc host drivers (sdhci-tegra|omap).
> >
> >Ulf Hansson (5):
> >  mmc: core: Allow host controllers to require R1B for CMD6
> >  mmc: core: Respect MMC_CAP_NEED_RSP_BUSY for erase/trim/discard
> >  mmc: core: Respect MMC_CAP_NEED_RSP_BUSY for eMMC sleep command
> >  mmc: sdhci-omap: Fix busy detection by enabling MMC_CAP_NEED_RSP_BUSY
> >  mmc: sdhci-tegra: Fix busy detection by enabling MMC_CAP_NEED_RSP_BUSY
> >
> > drivers/mmc/core/core.c        | 5 ++++-
> > drivers/mmc/core/mmc.c         | 7 +++++--
> > drivers/mmc/core/mmc_ops.c     | 8 +++++---
> > drivers/mmc/host/sdhci-omap.c  | 3 +++
> > drivers/mmc/host/sdhci-tegra.c | 3 +++
> > include/linux/mmc/host.h       | 1 +
> > 6 files changed, 21 insertions(+), 6 deletions(-)
>
> I've queued this, the 5.4, and the 4.19 series. Thanks!

Hi Sasha,

I've tested all three kernels, but replied to 5.5 and 5.4 with "Tested-by".
I did not reply "Tested-by" on 4.19 because I did not get a good result there.
I'm investigating why it did not boot. I'm not sure if you should
apply the patches
yet to 4.19, and if you do, please do not add my "Tested-by" on 4.19.

Cheers,
Anders
