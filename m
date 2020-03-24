Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71B811918CB
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 19:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbgCXSU3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 14:20:29 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:41275 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727398AbgCXSU2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 14:20:28 -0400
Received: by mail-lj1-f194.google.com with SMTP id n17so9338518lji.8
        for <stable@vger.kernel.org>; Tue, 24 Mar 2020 11:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XXFNaMHE865KFMf7/FD9eexyYGXX3J3mTbjMUnsz/XY=;
        b=PmXOw2hVAghdVL5iXAMxkoaQOE+md30LjhqAjxYJ0W/CrfPUFb9DkbSClQr2v0XkRu
         +1QNTt4UOHmA4kMT32VUr7hMvwaF7aWcEWSooM+wGtbTh+trTYZpFZEypw4045uy4tmw
         W/TYv3FFjfMQX6bS4Cwvu9l2M7/cZW2YuZaghLQRBJmpf3msgH+VRPmrgPf9I54LLSan
         kkiHcwMu0vIn5tLBbsNWuttaQaiShPjNvvcLVFJGIbwBcL0/EptqiOvKBI4q3SUS4PrW
         i1CFFacZaVTriv0A7ciYiBvsonVuqcD5odxeG8GUqZ6s5/g9pUkU7yaX95l7bzJTVAVC
         mE+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XXFNaMHE865KFMf7/FD9eexyYGXX3J3mTbjMUnsz/XY=;
        b=NBv5HRVfkPWqYWYcjW8f6ntVVCBb7bGhYaigUcIRA1XVtvAR6Y+rUblbZWsnKWHwEC
         2kDsOsClNq1D9NyabLkrIa6vYdEBfn4WTvD5iYEEVE/p58y2aPfrvPVkcgEe+d/W4WE9
         9R0xI/AzD+Cn7ULgy7M4B9VtVN65QQfYQ93y31gbr57doURUEJLMQUWvRMd5ro9py8ap
         vr3hv/plsQ6jZsIme9Dp6hLTyEeT2GIBq5bhUeujFBZnZxqAw/eIE0m9goUdt7QU5w8Y
         vHCBceNvC98C7eRE+KfFCzCflM0K1aU4XmMTQDLy7FMHDU9yo2ZD4X1gWPPDb9hmtFYp
         oW0g==
X-Gm-Message-State: ANhLgQ0EEKJ31JyE4fBau4mNUSBJDlfog0zuc6JSvTZG3HmGC4+uR4RA
        zHYLnInE6lqOqNgBvAKPoV0RymWdvfVXPTePD4fRZQ==
X-Google-Smtp-Source: ADFU+vssKk0TvsuhAuqLni5jz9W0bZI1fwWvOHj7M1YWG8xxniszV5r5PVzLod3GdiLOtsGj2xMpUys86huxeYmxjDE=
X-Received: by 2002:a2e:811a:: with SMTP id d26mr17755811ljg.128.1585074026561;
 Tue, 24 Mar 2020 11:20:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200324180650.28819-1-ulf.hansson@linaro.org>
In-Reply-To: <20200324180650.28819-1-ulf.hansson@linaro.org>
From:   Anders Roxell <anders.roxell@linaro.org>
Date:   Tue, 24 Mar 2020 19:20:15 +0100
Message-ID: <CADYN=9JsS-aTbun24PMOasBAK+2nwkkuvFZ6vSp88hjEnLQLmQ@mail.gmail.com>
Subject: Re: [PATCH 5.5.12 0/5] mmc: Fix some busy detect problems
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

On Tue, 24 Mar 2020 at 19:06, Ulf Hansson <ulf.hansson@linaro.org> wrote:
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
