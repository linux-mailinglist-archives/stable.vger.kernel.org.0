Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1218129C537
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1824826AbgJ0SGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 14:06:08 -0400
Received: from mail-oo1-f68.google.com ([209.85.161.68]:35077 "EHLO
        mail-oo1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1824820AbgJ0SGG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Oct 2020 14:06:06 -0400
Received: by mail-oo1-f68.google.com with SMTP id n16so553304ooj.2;
        Tue, 27 Oct 2020 11:06:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SuhC8loLLZ4GddGhED6vncxGC/AxylOHh4IaC5CHeek=;
        b=NVX2eyquHohQI2QoYLCwVSA9grwNRZ7nff0vs4dWgT4YM1qjVxAmfDL7X9kxbdFAz8
         lhL3HuZhkXIAP9Avup34wcV3U4f1mn+1UW36z8CegeOV55giib89GqR9mk0i6pj86p1E
         s/I80HACXVyW6nz/BI0KIO4QML1QBW9MCzBIjVD8p0hNtXVtExy2qWIJkBlmlv/TfxGc
         MLE3JAGzENgAynGk4USHMqg9xfxcM6NMGqRv8ZX4TN/EQxNx0Sq0oDy8OTXOopOa+RMf
         2q/jtOPGmaHFT137eXmZdEeSB4UVFH2gTq9R8oKN9ucMHZ9hGRKytN3JP4Kw08eslg1A
         gY6g==
X-Gm-Message-State: AOAM531CjdixUD4UcH/ZCpT4pYT4qMcyjdjya5k9jmScn/aU4NZTNpv5
        ne/XKDFChW3lBQaUruvXTuF7h5OUW6ZgJbCUJ7MrjK6K
X-Google-Smtp-Source: ABdhPJyCdtYfVXXF9X4r2SVnKQmuBXnQPQo7IGbXfQKPqHATp8t4XBO2M0sLHcAFUi6F+L5BoAvStq8y2isg8brEt5U=
X-Received: by 2002:a4a:d815:: with SMTP id f21mr2748244oov.44.1603821965678;
 Tue, 27 Oct 2020 11:06:05 -0700 (PDT)
MIME-Version: 1.0
References: <20201024162953.14142-1-yu.c.chen@intel.com>
In-Reply-To: <20201024162953.14142-1-yu.c.chen@intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 27 Oct 2020 19:05:54 +0100
Message-ID: <CAJZ5v0g6jA0zM6yVZAuXjk49ckOokd+8fdxR+ENCvNu8W6ZJuQ@mail.gmail.com>
Subject: Re: [PATCH] intel_idle: Fix max_cstate for processor models without
 C-state tables
To:     Chen Yu <yu.c.chen@intel.com>
Cc:     Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "5 . 6+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 24, 2020 at 6:27 PM Chen Yu <yu.c.chen@intel.com> wrote:
>
> Currently intel_idle driver gets the c-state information from ACPI
> _CST if the processor model is not recognized by it. However the
> c-state in _CST starts with index 1 which is different from the
> index in intel_idle driver's internal c-state table. While
> intel_idle_max_cstate_reached() was previously introduced to
> deal with intel_idle driver's internal c-state table, re-using
> this function directly on _CST might get wrong. Fix this by
> subtracting the index by 1 when checking max cstate via _CST.
> For example, append intel_idle.max_cstate=1 in boot command line,
> Before the patch:
> grep . /sys/devices/system/cpu/cpu0/cpuidle/state*/name
> POLL
> After the patch:
> grep . /sys/devices/system/cpu/cpu0/cpuidle/state*/name
> /sys/devices/system/cpu/cpu0/cpuidle/state0/name:POLL
> /sys/devices/system/cpu/cpu0/cpuidle/state1/name:C1_ACPI
>
> Fixes: 18734958e9bf ("intel_idle: Use ACPI _CST for processor models without C-state tables")
> Reported-by: Pengfei Xu <pengfei.xu@intel.com>
> Cc: 5.6+ <stable@vger.kernel.org> # 5.6+
> Signed-off-by: Chen Yu <yu.c.chen@intel.com>
> ---
>  drivers/idle/intel_idle.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
> index 9a810e4a7946..dbd4be1c271b 100644
> --- a/drivers/idle/intel_idle.c
> +++ b/drivers/idle/intel_idle.c
> @@ -1236,7 +1236,7 @@ static void __init intel_idle_init_cstates_acpi(struct cpuidle_driver *drv)
>                 struct acpi_processor_cx *cx;
>                 struct cpuidle_state *state;
>
> -               if (intel_idle_max_cstate_reached(cstate))
> +               if (intel_idle_max_cstate_reached(cstate - 1))
>                         break;
>
>                 cx = &acpi_state_table.states[cstate];
> --

Applied as 5.10-rc material with some changelog edits, thanks!
