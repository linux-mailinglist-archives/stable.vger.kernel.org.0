Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF081472ADF
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 12:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234125AbhLMLIn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 06:08:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbhLMLIm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 06:08:42 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC8EC061574;
        Mon, 13 Dec 2021 03:08:41 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id x15so51589033edv.1;
        Mon, 13 Dec 2021 03:08:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q/71yqqSgNIZY+ASO/n4MTXd5OJrAF/rcrUjXVCQ3Vo=;
        b=pG+Fe/DF1MAjTp8W4mjSC5umQah8vLr+W58OxtCphHCku/XW/mw2mDENc97DL6vJoJ
         AvNho+lk+zY+Kmvq+tW7Vz/Oj7Q8V2S63f72RdTtZuggyBlAj0kQQCl4zF+NnkDDx8tE
         U2PeMYNYFCiobGiUgUfRxqeCFK1tHwdEIA4dfLOnujJRKxRMCP0pztpBM2Bo2Cx0O7nQ
         UyNvjvezFb3XSzMyH8qi8QcS66rBMsXM/CHhrPY5icMLVtFF7DooED8u6g3Q9LjjcHZa
         4Gwr5GHtEH7NN8xA+63rhbVps8kTzb2tM5O3/olZPNx7u0hHTH26Jw/wHHGwAqK5CVZc
         MJew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q/71yqqSgNIZY+ASO/n4MTXd5OJrAF/rcrUjXVCQ3Vo=;
        b=EpoFjEzszhcIsvXPbvdEF9vDz812AijQEGzCocRpbtAZk3vIOSWjWjGaR3gvLnIhlv
         ii+FK22h+RolZK5DdKwiCYXCSDNM3upRe9wYEDv4yJiJlAF9inxQeIdhjzBaElslkM+F
         fPhBkLqMdMQ+r8sbkEZGURRvtfYGQRi12t2/4M7HeffG4ILH6hB0hG6UkS3OTPHW9c0+
         Lp3e2I4komCVEjDTpBIkp5TP28UyU58xkbmJ9TvK11yvEeVc5ZYZ2N6PaaGGmIGJtDdj
         5Q+Lav4Rr9KxFJdoF2ah6FpWX7M3cfcHk8ytRi2/q64JZS+acaBWkj3S6fYdylpy/ALw
         2RuA==
X-Gm-Message-State: AOAM530VJtDapqaWQtX36KPe74tjJ/Ieoj1f3krmIqvbfZLDrrtGco9R
        r/yvg2TeMUgP8SphD56wXYXhEZn/XjOv/wt+0HcqoVBvVzDGnQ==
X-Google-Smtp-Source: ABdhPJzL1y0aaGhWlq/0p1S9UngoP0zJdWnPNaed7hNmKpnDhz8uHEI7MMCIYP6c7MxET9hcARFowiUtaGTMlJ/8iaE=
X-Received: by 2002:a17:906:489b:: with SMTP id v27mr42396720ejq.567.1639393720218;
 Mon, 13 Dec 2021 03:08:40 -0800 (PST)
MIME-Version: 1.0
References: <20211210143529.10594-1-mario.limonciello@amd.com>
In-Reply-To: <20211210143529.10594-1-mario.limonciello@amd.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 13 Dec 2021 13:07:10 +0200
Message-ID: <CAHp75VfkK++Knyj1D85BbJQL_AYhByAN-wQcH6qfKgC8O1CZ=Q@mail.gmail.com>
Subject: Re: [PATCH] platform/x86: amd-pmc: only use callbacks for suspend
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        "open list:X86 PLATFORM DRIVERS" 
        <platform-driver-x86@vger.kernel.org>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 10, 2021 at 9:06 PM Mario Limonciello
<mario.limonciello@amd.com> wrote:
>
> This driver is intended to be used exclusively for suspend to idle
> so callbacks to send OS_HINT during hibernate and S5 will set OS_HINT
> at the wrong time leading to an undefined behavior.

...

>  static const struct dev_pm_ops amd_pmc_pm_ops = {
> -       SET_NOIRQ_SYSTEM_SLEEP_PM_OPS(amd_pmc_suspend, amd_pmc_resume)
> +       .suspend_noirq = amd_pmc_suspend,
> +       .resume_noirq = amd_pmc_resume,

Can you simply switch to SET_NOIRQ_SYSTEM_SLEEP_PM_OPS()?

>  };


-- 
With Best Regards,
Andy Shevchenko
