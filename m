Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A0B1E7AB3
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 12:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbgE2Kgb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 May 2020 06:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbgE2Kga (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 May 2020 06:36:30 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E5CC08C5C9
        for <stable@vger.kernel.org>; Fri, 29 May 2020 03:36:29 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id c1so1171833vsc.11
        for <stable@vger.kernel.org>; Fri, 29 May 2020 03:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HmjuhvsPi7i8QqafSrWT+BKWCrvyW72ZyBBet/hxqD0=;
        b=n6OtqtRiLbTORvfYG6+bQXzcgCH/G6pkw+zSMMdxMxkDlpoVqcIbqFNyv3NrrCz5UM
         FYu3A0S/YnIkMA6bPm3usBVBl4ZBaVa7R9KMWxUFhoNB1G2oMSEiymI0XafYge8Sf0Vw
         RE5rWLK+Ax0x/TMsslPBgGo/gJ7BZJ07OXg/tMJlBcLFWiVx5N0oeSsxW8LMHfj2MWbF
         TrE2E2NBmbZV50QHjMp5wcPnnKffF5IPTYZFS6YILUdLLHlTJ9jvyGuKXuiOblPE7urJ
         eKL9W0/yjaSHd7EMkRbmYeRpkPUCJZWIWARpOLgbdPj+Lxi4usxtZkAfc6wHgLFUil1t
         8jGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HmjuhvsPi7i8QqafSrWT+BKWCrvyW72ZyBBet/hxqD0=;
        b=V6BQKAk7joOauu0VVpINGh8hWCIkLe/JjgXu6TrzBM1otjaqAUVos6XEhDBdwuARok
         9JmUn5hzzPBxNU4sIMVhBtiNxoeIWZbKPGYSxSNmMAPOUYQqGgT1yzTDcfqrX6EU6mD4
         dn5791hu2/GUbgaKAoKsZviN+szRFjztTcqG3SaKXozs0lChIWHmb8txqm8+JHBuhLhX
         rJQeYw2tkC8AlmOf68FLheJsZ7GF384sH8eUYuvn5SQ0e5QuC+q6JKd+77ko7DS6OFnf
         9Lgyr9z65HMEUpnD6SFwWTiQsigK3Qx728fBHCxIqHfzvZnUT50DQ6FL4byvjDhwet4q
         /VwA==
X-Gm-Message-State: AOAM531R3IcCHnYCfHYffYJRilJ11219WFIqL2PON2vZP4+wc+tSrf0k
        IlknNuPGhvkLzPCFxX0eJToEtU86+6hV6B1UUbS2dQ==
X-Google-Smtp-Source: ABdhPJzBQ0zlzWRM+H9Ii1EWbIJoP5vdLRB7231T5LWWfcHEbqkYTyRcxm7AJOljOxCsWsLh6iMLrbF8H2nC95j2LAE=
X-Received: by 2002:a67:1486:: with SMTP id 128mr5150038vsu.191.1590748585116;
 Fri, 29 May 2020 03:36:25 -0700 (PDT)
MIME-Version: 1.0
References: <1590678838-18099-1-git-send-email-vbadigan@codeaurora.org>
In-Reply-To: <1590678838-18099-1-git-send-email-vbadigan@codeaurora.org>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Fri, 29 May 2020 12:35:48 +0200
Message-ID: <CAPDyKFpC+C32oa4ucNLWeEGJ8PDwzi+X55Lp7UqrHR--Yc47mw@mail.gmail.com>
Subject: Re: [PATCH V1] mmc: sdhci-msm: Clear tuning done flag while hs400 tuning
To:     Veerabhadrarao Badiganti <vbadigan@codeaurora.org>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>, Andy Gross <agross@kernel.org>,
        Ritesh Harjani <riteshh@codeaurora.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 28 May 2020 at 17:14, Veerabhadrarao Badiganti
<vbadigan@codeaurora.org> wrote:
>
> Clear tuning_done flag while executing tuning to ensure vendor
> specific HS400 settings are applied properly when the controller
> is re-initialized in HS400 mode.
>
> Without this, re-initialization of the qcom SDHC in HS400 mode fails
> while resuming the driver from runtime-suspend or system-suspend.
>
> Fixes: ff06ce4 ("mmc: sdhci-msm: Add HS400 platform support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Veerabhadrarao Badiganti <vbadigan@codeaurora.org>

Applied for next, thanks!

Kind regards
Uffe

> ---
>  drivers/mmc/host/sdhci-msm.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
> index 95cd973..b277dd7 100644
> --- a/drivers/mmc/host/sdhci-msm.c
> +++ b/drivers/mmc/host/sdhci-msm.c
> @@ -1174,6 +1174,12 @@ static int sdhci_msm_execute_tuning(struct mmc_host *mmc, u32 opcode)
>         msm_host->use_cdr = true;
>
>         /*
> +        * Clear tuning_done flag before tuning to ensure proper
> +        * HS400 settings.
> +        */
> +       msm_host->tuning_done = 0;
> +
> +       /*
>          * For HS400 tuning in HS200 timing requires:
>          * - select MCLK/2 in VENDOR_SPEC
>          * - program MCLK to 400MHz (or nearest supported) in GCC
> --
> Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc., is a member of Code Aurora Forum, a Linux Foundation Collaborative Project
>
