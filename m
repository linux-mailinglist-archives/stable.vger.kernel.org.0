Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 393D0401EE5
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 19:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236854AbhIFRIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 13:08:54 -0400
Received: from mail-ot1-f51.google.com ([209.85.210.51]:39632 "EHLO
        mail-ot1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbhIFRIy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Sep 2021 13:08:54 -0400
Received: by mail-ot1-f51.google.com with SMTP id m7-20020a9d4c87000000b0051875f56b95so9471435otf.6;
        Mon, 06 Sep 2021 10:07:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=++LIn4BzMT/yfmvrIHegIKxrKLsnvbzGkInouRJvYyc=;
        b=sdOhagY2NnJFq9Zu4txDwO2MJasD0eDPshize9cDIkkrIHE5cIoM0Cy04k5qtXWGF4
         HHLMPR8ATQ1Ao55yRVs4N2bDglCoYwJQFEoFBO9S9olI0pB3Hw5GjQrtpjKL7qyqKNcF
         Y72DhBq8Y2c12btnUMCZaX+zmBbAETZjfbOGkxS+Bjfyr7KS1PdHD8lrswbyk4QiQ4rZ
         zKFiZWWerYRBW7KrAX16GPO2sSaCzSd0QETsIa1P9O/B2oVRbvtjOS2/duhI0cUr9eBB
         qtNf102f61ZMoPmsfT7xCL0U2eLKiP8OhFjc+QOwa5jSHb/nexqStjGegsN1DcmLtXWV
         60iA==
X-Gm-Message-State: AOAM5301BCwx9jUbpCJliG5qtJAEDSmsoJVKTz91zOfbRkX47+3YRU89
        S7F9tMu6H6pSF9Cfi+eEfAiZR91LuFo93/SW/9Q=
X-Google-Smtp-Source: ABdhPJxFe+shqvt53iInVBtVbEwgHxwTsvQqM7BZ8tlMMEWr+cag6cxnMCqsopLy1hSSKR9VzP0DVY4VLq48C4xu4fg=
X-Received: by 2002:a9d:4d93:: with SMTP id u19mr11579566otk.86.1630948068687;
 Mon, 06 Sep 2021 10:07:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210903084937.19392-1-jgross@suse.com> <20210903084937.19392-2-jgross@suse.com>
 <YTHjPbklWVDVaBfK@kroah.com> <1b6a8f9c-2a5f-e97e-c89d-5983ceeb20e5@suse.com>
In-Reply-To: <1b6a8f9c-2a5f-e97e-c89d-5983ceeb20e5@suse.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Mon, 6 Sep 2021 19:07:37 +0200
Message-ID: <CAJZ5v0g_WVFqDKCBYnoPtqR5VzH-eBMk+7M1bAmgGsyX0XGpgw@mail.gmail.com>
Subject: Re: [PATCH 1/2] PM: base: power: don't try to use non-existing RTC
 for storing data
To:     Juergen Gross <jgross@suse.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        xen-devel@lists.xenproject.org,
        Linux PM <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 3, 2021 at 11:02 AM Juergen Gross <jgross@suse.com> wrote:
>
> On 03.09.21 10:56, Greg Kroah-Hartman wrote:
> > On Fri, Sep 03, 2021 at 10:49:36AM +0200, Juergen Gross wrote:
> >> In there is no legacy RTC device, don't try to use it for storing trace
> >> data across suspend/resume.
> >>
> >> Cc: <stable@vger.kernel.org>
> >> Signed-off-by: Juergen Gross <jgross@suse.com>
> >> ---
> >>   drivers/base/power/trace.c | 10 ++++++++++
> >>   1 file changed, 10 insertions(+)
> >>
> >> diff --git a/drivers/base/power/trace.c b/drivers/base/power/trace.c
> >> index a97f33d0c59f..b7c80849455c 100644
> >> --- a/drivers/base/power/trace.c
> >> +++ b/drivers/base/power/trace.c
> >> @@ -13,6 +13,7 @@
> >>   #include <linux/export.h>
> >>   #include <linux/rtc.h>
> >>   #include <linux/suspend.h>
> >> +#include <linux/init.h>
> >>
> >>   #include <linux/mc146818rtc.h>
> >>
> >> @@ -165,6 +166,9 @@ void generate_pm_trace(const void *tracedata, unsigned int user)
> >>      const char *file = *(const char **)(tracedata + 2);
> >>      unsigned int user_hash_value, file_hash_value;
> >>
> >> +    if (!x86_platform.legacy.rtc)
> >> +            return 0;
> >
> > Why does the driver core code here care about a platform/arch-specific
> > thing at all?  Did you just break all other arches?
>
> This file is only compiled for x86. It depends on CONFIG_PM_TRACE_RTC,
> which has a "depends on X86" attribute.

This feature uses the CMOS RTC memory to store data, so if that memory
is not present, it's better to avoid using it.

Please feel free to add

Reviewed-by: Rafael J. Wysocki <rafael@kernel.org>

to this patch or let me know if you want me to take it.
