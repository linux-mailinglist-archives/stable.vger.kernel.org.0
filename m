Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54275193754
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 05:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbgCZEix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 00:38:53 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:35752 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbgCZEix (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Mar 2020 00:38:53 -0400
Received: by mail-lj1-f194.google.com with SMTP id k21so5021264ljh.2
        for <stable@vger.kernel.org>; Wed, 25 Mar 2020 21:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fGs2Fkq+JYwqsVvuiDWV5GE6EV18e6pUOVPfSl4Vkws=;
        b=BSsmzr6IQUuTjeowtedlu9tNNgVPDr+nYNScnZkr85pdX6ZmVQss+TJQopSDkzUeP1
         +MDVcvdFtmunqrK+0huuUuWRu0EytgvDvq1AWSOu3cmVzD/QMkrEopgaT3XMVRZm7rk8
         FALLNJ7rBV3mMyd5r4R7V4SIsR+f2FnCvYWvqro59pQ8N+VefOkZpshcYhSX/UVzmpAt
         lcJnQm3xCIYt/zYnfe7fiiuQLN+JpHdXQNp2DxAPWTcCJps6u6Qm5FQALtX/EIJ0ixrQ
         ey06pINwKwa5Wt4Jc4ltm12Qoa0kFbzwkgwKP6h4oi5GSI+NrC5JfUv/NajDR7fhq0wy
         PTvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fGs2Fkq+JYwqsVvuiDWV5GE6EV18e6pUOVPfSl4Vkws=;
        b=F89/nhR1FS6N7JjYPhF3fSwv3uelhZk39pYNli5hSTvF2LjHP1fMZYWnd8/GwTlJBD
         MfMYL3c2mrDdxddUjQVUszMn6ZkvfHt+zHDYAfpKfBKbkrEiJAf3swElSCT7LYrmYFVJ
         J8moLQJeY/E1H5vGIif7Iyqqs/QgDR14+8w4I5XfWSA6mY5yJov0u0ecgvuUoBA7ZKw/
         neLaD+MCqQKApC5dy27EsUoYH/ksC1Pd1mgRVuQtu0RmoQ6K8eUn87qFWoYRfTZBnuwX
         guRaCe6s0WZ7tOZmHDq3pSTcnkyrVH+oOYEV2NRxcg2PkGXGJTo+G8fMbvUJrz8jDrjS
         EaPg==
X-Gm-Message-State: AGi0PuZ6dVWOJOPde4l38lLVXfZxFEa01UG30xUDDhXRusaHsw/WEf9S
        eO9H3hCOdIb99BoUucX3161qxvMJIo+r1lflQfY15Q==
X-Google-Smtp-Source: APiQypKLx0qGen5VpCIUnaclGGr5pVb8zOTvau+T484s06BImCVFsm0HyLLdPILkq5Kr/8LBazJqb8ae9NZwH/fJsc8=
X-Received: by 2002:a2e:990b:: with SMTP id v11mr4095616lji.243.1585197531085;
 Wed, 25 Mar 2020 21:38:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200324180650.28819-1-ulf.hansson@linaro.org> <20200326025132.GA4189@sasha-vm>
In-Reply-To: <20200326025132.GA4189@sasha-vm>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 26 Mar 2020 10:08:39 +0530
Message-ID: <CA+G9fYvGbNuTY0rNh_W5HzxtTjUBb8YXkixG5DCseXppTVGJzA@mail.gmail.com>
Subject: Re: [PATCH 5.5.12 0/5] mmc: Fix some busy detect problems
To:     Sasha Levin <sashal@kernel.org>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux- stable <stable@vger.kernel.org>,
        linux-mmc@vger.kernel.org,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Faiz Abbas <faiz_abbas@ti.com>,
        Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 26 Mar 2020 at 08:21, Sasha Levin <sashal@kernel.org> wrote:
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

I think this was tested for 5.4 branch.
Not sure about 4.19

Anders and Ulf,
Was it validated against 4.19 branch ?

- Naresh
