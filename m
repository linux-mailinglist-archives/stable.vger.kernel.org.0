Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 322AA1956B8
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 13:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgC0MFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Mar 2020 08:05:06 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:34164 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbgC0MFG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Mar 2020 08:05:06 -0400
Received: by mail-lj1-f196.google.com with SMTP id p10so9686592ljn.1
        for <stable@vger.kernel.org>; Fri, 27 Mar 2020 05:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nT2zhNwcOafFqnYFSpGatjejS7IxPAm8/yEh3CXdsPY=;
        b=zhgIGlEoKw+cAWo+Jqd3KrqVzXRHeRu7li6fD3FIZl9qprJGaT3iCAZ67/cdKPtiIb
         mR7RCwndFg527pbV4/+zyBPu6yi/0YvbYDo8bs2ZZkxf4GMNHNjDf9btkiFBMwO51PVZ
         YnmxIC0noWv5cUyplQ+r2K0UdG++BdKmI4m8Hw3RV0aDPd2NkiE7hUxq/3vWLYSt2dFR
         6G38LBfAQmVMca69AenhO4cVEApmKrLBPiGnH/02dMST8DJ3FwfVPY7rFA5Y8De++rHE
         2ju3g1/id7xlMIKeX9WYXxNy2slqgwrKOEeGzONCJVJzcChc0v8H7RTXeHDMOXi3o+Ju
         uFkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nT2zhNwcOafFqnYFSpGatjejS7IxPAm8/yEh3CXdsPY=;
        b=ay4HxPhCnUBvdlauRSwG+nokURtDc6wfQeyGh3dPjIiMz7px97CJlz8swE+Pat+fb3
         p2tX8DpZspu6B3OemliAZChxEowQ0pnNdkgHKzgv0FHqyFurhjTn6cCvLkuMFbLCJEyH
         X433RNnAv8nYYZyBU0vKyieUDzFafUrZp45KuOwttDUjY6CF5ObCXhmF5kML1E7qcwUq
         D/8GreaF+7zpksqbsGSMySZHpt3ZRe/0ps1LlRD9cGm/z3roptE5PxZmNGWplaiVtFhe
         i5fK88NEyN2lY2RyWaKhZTnbSbrEzO54A4bdGzuK/WnNZah5vrwQX9C1q0+cXKFVKnx7
         XA1w==
X-Gm-Message-State: ANhLgQ2Rv8CNjJvTuepWxMDMJBjivfBnp9+9CZk4M0H6W6QsXcHjny/0
        93FpMxy6/6xa0B3l5m2F3lOEid9mTjY2+uaDRYn8Uw==
X-Google-Smtp-Source: APiQypKSlosFwhcP547B9yyV+9v9debIRBcW1YFFA0onUjgxmdxNlnbTfv7Iblp6w8GJUuholDXQIJiebxlEJeeBkUw=
X-Received: by 2002:a2e:730e:: with SMTP id o14mr8152197ljc.273.1585310704209;
 Fri, 27 Mar 2020 05:05:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200324180800.28953-1-ulf.hansson@linaro.org>
In-Reply-To: <20200324180800.28953-1-ulf.hansson@linaro.org>
From:   Anders Roxell <anders.roxell@linaro.org>
Date:   Fri, 27 Mar 2020 13:04:53 +0100
Message-ID: <CADYN=9JSbio1b5VuijifGSdA39-cf+J1hg5b3rcN5h4p0W2=xA@mail.gmail.com>
Subject: Re: [PATCH 4.19.113 0/5] mmc: Fix some busy detect problems
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

On Tue, 24 Mar 2020 at 19:08, Ulf Hansson <ulf.hansson@linaro.org> wrote:
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
