Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9AE204A59
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 09:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730862AbgFWHBK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 03:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730694AbgFWHBJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 03:01:09 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65481C061573
        for <stable@vger.kernel.org>; Tue, 23 Jun 2020 00:01:09 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id o2so11126237vsr.0
        for <stable@vger.kernel.org>; Tue, 23 Jun 2020 00:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=verdurent-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tNknlx6Ufr4DWfMISHSoJrnftbpeT1xGDs0QoxzhfH8=;
        b=tGYEFKdSH7NsWOXZSNUaTeDlMRH6Ao1ZPvP5UMXJOQx9DQYGhFIAFQxX/aosulqAbz
         4C0PqSIkyqGZT6ctFd8x7UOzH+u4nNtMV0ZjrD+XLGDW4FhivwknNOJQRNU2T4Mszv5B
         u0hXJkhGy3FKNFlZzu1fMplnbkCT+ILr7rU7AfA3H0J8WkPJ7zEUaeR4WIJYaorC1Fbx
         Rkn9rbGUUF/uMbo4/rbxR5h//Du6Z4TjMFAQ4/qjuFKHHwshccnSjTRxoyBGaa6mf6Mg
         oS6D2SfX83tuAiiLxtsgqVyR8v5zYfr+nPibKDgLPuxN019gGiqbquPLl3ldA2e6Xpbw
         LwFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tNknlx6Ufr4DWfMISHSoJrnftbpeT1xGDs0QoxzhfH8=;
        b=oIwXJnhnCMmWROAb9kxYQqSXVPXoJ1XWw4/GXmRj2uwhMkJf/jlbM7POShx7fMkFKF
         Pr8KTCnMtPiOgJgCx9pIos3RSl2wpIsJDKUO4KXtFzXJOj3nbxNyQWiUUK8BCsxG4hpu
         zHDCAYC3ODaDQxfgHomkrRUIJDcplyPPF/VPV5QlIiV2tMyTwsNavBcU+fnPuowprpNq
         MXXMCSgALHB4UiIseKDsf7tlBJ1kXdSRBHl5Hh6AdTWGrZu1FPtL8gL/NnMrtxC0fxxL
         BN6rWflHrAD7WvB68hWgcAETxQApsZXH1M/6LZkAhKkiVDqDYs4lcYgVz+PeHagTjis2
         TzXQ==
X-Gm-Message-State: AOAM5330QU/LNb+Da+uCLvqrxQwXKuWPG76bJKIvV6pi4Tqmi+C0X/Dx
        d98VHKzm9V+ZkVJEVNQ2ee13ryGcOLBa6o8oVtGAmA==
X-Google-Smtp-Source: ABdhPJwe6XrRkaoRDtNEiWkt/nPkZaZjWPzOzO3TjxtVEN2Y18f0AL4LpVVA86UMbyEiGIAP/Q8wd7JmRpMUNg1ACFE=
X-Received: by 2002:a67:e10d:: with SMTP id d13mr19083478vsl.27.1592895668303;
 Tue, 23 Jun 2020 00:01:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200619090825.32747-1-finley.xiao@rock-chips.com>
In-Reply-To: <20200619090825.32747-1-finley.xiao@rock-chips.com>
From:   Amit Kucheria <amit.kucheria@verdurent.com>
Date:   Tue, 23 Jun 2020 12:30:57 +0530
Message-ID: <CAHLCerPpen0ckEnZPvmECVQixN=rBfneP4mK6rPAAu3vjSg_QQ@mail.gmail.com>
Subject: Re: [PATCH] thermal/drivers/cpufreq_cooling: Fix wrong frequency
 converted from power
To:     Finley Xiao <finley.xiao@rock-chips.com>
Cc:     Heiko Stuebner <heiko@sntech.de>,
        Amit Daniel Kachhap <amit.kachhap@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Javi Merino <javi.merino@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        linux-rockchip@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        stable@vger.kernel.org, huangtao@rock-chips.com,
        tony.xie@rock-chips.com, cl@rock-chips.com
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Finley,

Please use versioning (v2) when resending a patch.

On Fri, Jun 19, 2020 at 2:39 PM Finley Xiao <finley.xiao@rock-chips.com> wrote:
>
> The function cpu_power_to_freq is used to find a frequency and set the
> cooling device to consume at most the power to be converted. For example,
> if the power to be converted is 80mW, and the em table is as follow.
> struct em_cap_state table[] = {
>         /* KHz     mW */
>         { 1008000, 36, 0 },
>         { 1200000, 49, 0 },
>         { 1296000, 59, 0 },
>         { 1416000, 72, 0 },
>         { 1512000, 86, 0 },
> };
> The target frequency should be 1416000KHz, not 1512000KHz.
>
> Fixes: 349d39dc5739 ("thermal: cpu_cooling: merge frequency and power tables")
> Cc: <stable@vger.kernel.org> # v4.13+
> Signed-off-by: Finley Xiao <finley.xiao@rock-chips.com>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Reviewed-by: Amit Kucheria <amit.kucheria@linaro.org>

> ---
>  drivers/thermal/cpufreq_cooling.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/thermal/cpufreq_cooling.c b/drivers/thermal/cpufreq_cooling.c
> index 9e124020519f..6c0e1b053126 100644
> --- a/drivers/thermal/cpufreq_cooling.c
> +++ b/drivers/thermal/cpufreq_cooling.c
> @@ -123,12 +123,12 @@ static u32 cpu_power_to_freq(struct cpufreq_cooling_device *cpufreq_cdev,
>  {
>         int i;
>
> -       for (i = cpufreq_cdev->max_level - 1; i >= 0; i--) {
> -               if (power > cpufreq_cdev->em->table[i].power)
> +       for (i = cpufreq_cdev->max_level; i >= 0; i--) {
> +               if (power >= cpufreq_cdev->em->table[i].power)
>                         break;
>         }
>
> -       return cpufreq_cdev->em->table[i + 1].frequency;
> +       return cpufreq_cdev->em->table[i].frequency;
>  }
>
>  /**
> --
> 2.11.0
>
>
>
