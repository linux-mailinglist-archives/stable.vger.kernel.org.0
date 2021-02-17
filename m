Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2AE31DB5B
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 15:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233445AbhBQOWf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 09:22:35 -0500
Received: from mail-ot1-f48.google.com ([209.85.210.48]:41530 "EHLO
        mail-ot1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233441AbhBQOWc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Feb 2021 09:22:32 -0500
Received: by mail-ot1-f48.google.com with SMTP id s107so12115712otb.8;
        Wed, 17 Feb 2021 06:22:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b+TzfADeGi3HDQ8XGZOMO0js+fOojwy6Y8D60U3mdPI=;
        b=DUL7DGX736FaDP5vw+LcsluyxQSliH9tqNKOasWTmZzWyOLv10bFy60OerFosq3n3j
         WW+iE3yJS3LG6XVpG00jAZCwlF0tUNhNzMo5TJME4iwYvKw52xKy60MyPGp4B/djBjaZ
         6+gI7jEZU8TGaT+/2QoYnGSjqwXCLYZAXD2qSWqhvg3PQc18vTSUBhYOu7dM2T0itEMG
         n3Td7VNrH+8mFAYNbDNBxBHMEpo3c+MDrjA+YDb1mW65fBs+wcBf8S5quWNGoso4mfHC
         xflYfGz5HDpni01Zqt+0em+c9Hpm9z5kECkL31MBo7Z01CIfgtVHY4HnC82JQFfmaRxd
         lyAA==
X-Gm-Message-State: AOAM532qAGzQyOnBJAERRtkP1I2iE8b3OdGne3Uf1Q94fQvlaBmpWx+J
        LjlbZ4OYkzD/vO1rxKT/MHlyreJzU8CR4f6swZw=
X-Google-Smtp-Source: ABdhPJxjSNjDuZN4yajz7YXRlYSVb9awtxgr0yG9mVPak+GsBbPtXRayRi1KBzsKQUoz1ebFMlW+5cwGxyxvJ+fJU+M=
X-Received: by 2002:a05:6830:2106:: with SMTP id i6mr17665831otc.260.1613571711364;
 Wed, 17 Feb 2021 06:21:51 -0800 (PST)
MIME-Version: 1.0
References: <b2b7e84944937390256669df5a48ce5abba0c1ef.1613540713.git.viresh.kumar@linaro.org>
In-Reply-To: <b2b7e84944937390256669df5a48ce5abba0c1ef.1613540713.git.viresh.kumar@linaro.org>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 17 Feb 2021 15:21:38 +0100
Message-ID: <CAJZ5v0gWkrR=NZdMCMc9pKvUZ5T6xO9KhiHDKt76xibMv=8Yxw@mail.gmail.com>
Subject: Re: [PATCH] thermal: cpufreq_cooling: freq_qos_update_request()
 returns < 0 on error
To:     Viresh Kumar <viresh.kumar@linaro.org>
Cc:     Amit Daniel Kachhap <amit.kachhap@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Javi Merino <javi.merino@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Amit Kucheria <amitk@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "v5 . 7+" <stable@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 17, 2021 at 6:50 AM Viresh Kumar <viresh.kumar@linaro.org> wrote:
>
> freq_qos_update_request() returns 1 if the effective constraint value
> has changed, 0 if the effective constraint value has not changed, or a
> negative error code on failures.
>
> The frequency constraints for CPUs can be set by different parts of the
> kernel. If the maximum frequency constraint set by other parts of the
> kernel are set at a lower value than the one corresponding to cooling
> state 0, then we will never be able to cool down the system as
> freq_qos_update_request() will keep on returning 0 and we will skip
> updating cpufreq_state and thermal pressure.
>
> Fix that by doing the updates even in the case where
> freq_qos_update_request() returns 0, as we have effectively set the
> constraint to a new value even if the consolidated value of the
> actual constraint is unchanged because of external factors.
>
> Cc: v5.7+ <stable@vger.kernel.org> # v5.7+
> Reported-by: Thara Gopinath <thara.gopinath@linaro.org>
> Fixes: f12e4f66ab6a ("thermal/cpu-cooling: Update thermal pressure in case of a maximum frequency capping")
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
> Hi Guys,
>
> This needs to go in 5.12-rc.
>
> Thara, please give this a try and give your tested-by :).
>
>  drivers/thermal/cpufreq_cooling.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/thermal/cpufreq_cooling.c b/drivers/thermal/cpufreq_cooling.c
> index f5af2571f9b7..10af3341e5ea 100644
> --- a/drivers/thermal/cpufreq_cooling.c
> +++ b/drivers/thermal/cpufreq_cooling.c
> @@ -485,7 +485,7 @@ static int cpufreq_set_cur_state(struct thermal_cooling_device *cdev,
>         frequency = get_state_freq(cpufreq_cdev, state);
>
>         ret = freq_qos_update_request(&cpufreq_cdev->qos_req, frequency);
> -       if (ret > 0) {
> +       if (ret >= 0) {
>                 cpufreq_cdev->cpufreq_state = state;
>                 cpus = cpufreq_cdev->policy->cpus;
>                 max_capacity = arch_scale_cpu_capacity(cpumask_first(cpus));
> --
> 2.25.0.rc1.19.g042ed3e048af
>
