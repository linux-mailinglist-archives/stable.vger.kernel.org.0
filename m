Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3665727CF39
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 15:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728897AbgI2Nd7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 09:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728675AbgI2Nd7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 09:33:59 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A19C0613D0
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 06:33:58 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id w11so951890vsw.13
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 06:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EltL+J/Q1F5+mWF7g4qf+xcfPA5egjqaTP/RSUYOP3E=;
        b=lI7G256uQ7RDLq3ZlDG8s61EF4QOy+bpJNOYxVVZEjTyNAuw3U8N6SjsZaUIZasnjQ
         XNDW1g9JQ7yTzkw2wlPv0UzPoVVedlt+MCeDzulV7FNXw/BD4ZDC4RgIla8kugeQGMJi
         S0QqXrliG6afGkMeO53zkovWcJQc4aSXEUzRNnxAKTPnzCqrN2VqF7r1DjkDFJVg5Kt0
         jziAfhIAWjBf+BVApQo2ipCDqj5IPvolxUEJGQPrOkAY+Pp0+3vwMTzovQAY0qqOOyec
         Lnhk0DxpSDMj5BdkftYe7fzy9kUY4s7oGArl9qGIXOXNxj83ZsI9oFm6snQjUNDfSbFk
         KhIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EltL+J/Q1F5+mWF7g4qf+xcfPA5egjqaTP/RSUYOP3E=;
        b=cOimZIx7zjTO3vxlTGDpsUMOpI457lB0vgFIp5uTJtpIpWnLDUJVnzQXETkRzAV4Ed
         v9iUq/mBC8piDEy1AsxZvR0UOZadwkEWvJ6eYKvoz0nfClRwtChXqqenI4m97M5pmk6o
         +QzTtF+wOriAQKnPvc8oMOfyb0LoeRCUmMbFwuD/Gy5IkkVvSNVR8oJC/l6dFqWJumyh
         sWxAg86x2btAKZlp1vCVwTJq+9Q1rlIHjCiE8Rc1ru/Keb/bVZDg1SKNUMmicJ0Am6DN
         sWPMTWKPdT0ysI28EHTEf1geWP2T9Af45HaFStQUitApoAQK5HZpcb7xnWW8ZY/IAZhi
         iXGQ==
X-Gm-Message-State: AOAM531o5zxLrU0mBtD4YlBM9pfVgAlnd0HDFaKew3HdyO9IFkpoH6FH
        iDBfdF19QHi3k/DWNmSr9qj+s1VCpWYodO2m+lUqWA==
X-Google-Smtp-Source: ABdhPJw+UWARxsyFEWwL5peQBxGf6xI7fAmwaqXnexE8cgF05YYDnVBChPSxoX4AeXdRZPUhkT0+YRovYFgtjpixlQ8=
X-Received: by 2002:a67:bd12:: with SMTP id y18mr2838977vsq.45.1601386438022;
 Tue, 29 Sep 2020 06:33:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200929105946.978650816@linuxfoundation.org> <20200929105954.090876288@linuxfoundation.org>
In-Reply-To: <20200929105954.090876288@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 29 Sep 2020 19:03:46 +0530
Message-ID: <CA+G9fYs-gqkrwzFeMQ1NpV_BfYPrV2CCOKJv6QE7U3mhc56F9w@mail.gmail.com>
Subject: Re: [PATCH 4.19 146/245] perf stat: Force error in fallback on :k events
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux- stable <stable@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 29 Sep 2020 at 17:54, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Stephane Eranian <eranian@google.com>
>
> [ Upstream commit bec49a9e05db3dbdca696fa07c62c52638fb6371 ]
>
> When it is not possible for a non-privilege perf command to monitor at
> the kernel level (:k), the fallback code forces a :u. That works if the
> event was previously monitoring both levels.  But if the event was
> already constrained to kernel only, then it does not make sense to
> restrict it to user only.
>
> Given the code works by exclusion, a kernel only event would have:
>
>   attr->exclude_user = 1
>
> The fallback code would add:
>
>   attr->exclude_kernel = 1
>
> In the end the end would not monitor in either the user level or kernel
> level. In other words, it would count nothing.
>
> An event programmed to monitor kernel only cannot be switched to user
> only without seriously warning the user.
>
> This patch forces an error in this case to make it clear the request
> cannot really be satisfied.
>
> Behavior with paranoid 1:
>
>   $ sudo bash -c "echo 1 > /proc/sys/kernel/perf_event_paranoid"
>   $ perf stat -e cycles:k sleep 1
>
>    Performance counter stats for 'sleep 1':
>
>            1,520,413      cycles:k
>
>          1.002361664 seconds time elapsed
>
>          0.002480000 seconds user
>          0.000000000 seconds sys
>
> Old behavior with paranoid 2:
>
>   $ sudo bash -c "echo 2 > /proc/sys/kernel/perf_event_paranoid"
>   $ perf stat -e cycles:k sleep 1
>    Performance counter stats for 'sleep 1':
>
>                    0      cycles:ku
>
>          1.002358127 seconds time elapsed
>
>          0.002384000 seconds user
>          0.000000000 seconds sys
>
> New behavior with paranoid 2:
>
>   $ sudo bash -c "echo 2 > /proc/sys/kernel/perf_event_paranoid"
>   $ perf stat -e cycles:k sleep 1
>   Error:
>   You may not have permission to collect stats.
>
>   Consider tweaking /proc/sys/kernel/perf_event_paranoid,
>   which controls use of the performance events system by
>   unprivileged users (without CAP_PERFMON or CAP_SYS_ADMIN).
>
>   The current value is 2:
>
>     -1: Allow use of (almost) all events by all users
>         Ignore mlock limit after perf_event_mlock_kb without CAP_IPC_LOCK
>   >= 0: Disallow ftrace function tracepoint by users without CAP_PERFMON or CAP_SYS_ADMIN
>         Disallow raw tracepoint access by users without CAP_SYS_PERFMON or CAP_SYS_ADMIN
>   >= 1: Disallow CPU event access by users without CAP_PERFMON or CAP_SYS_ADMIN
>   >= 2: Disallow kernel profiling by users without CAP_PERFMON or CAP_SYS_ADMIN
>
>   To make this setting permanent, edit /etc/sysctl.conf too, e.g.:
>
>           kernel.perf_event_paranoid = -1
>
> v2 of this patch addresses the review feedback from jolsa@redhat.com.
>
> Signed-off-by: Stephane Eranian <eranian@google.com>
> Reviewed-by: Ian Rogers <irogers@google.com>
> Acked-by: Jiri Olsa <jolsa@redhat.com>
> Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Link: http://lore.kernel.org/lkml/20200414161550.225588-1-irogers@google.com
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

perf failed on stable rc branch 4.19 on all devices.

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

build warning and errors,
-----------------------------------
In file included from util/evlist.h:15:0,
                 from util/evsel.c:30:
util/evsel.c: In function 'perf_evsel__exit':
util/util.h:25:28: warning: passing argument 1 of 'free' discards
'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
 #define zfree(ptr) ({ free(*ptr); *ptr = NULL; })
                            ^
util/evsel.c:1293:2: note: in expansion of macro 'zfree'
  zfree(&evsel->pmu_name);
  ^~~~~
In file included from
/srv/oe/build/tmp-lkft-glibc/work/intel_corei7_64-linaro-linux/perf/1.0-r9/perf-1.0/tools/perf/arch/x86/include/perf_regs.h:5:0,
                 from util/perf_regs.h:27,
                 from util/event.h:11,
                 from util/callchain.h:8,
                 from util/evsel.c:26:
perf/1.0-r9/recipe-sysroot/usr/include/stdlib.h:563:13: note: expected
'void *' but argument is of type 'const char *'
 extern void free (void *__ptr) __THROW;
             ^~~~
util/evsel.c: In function 'perf_evsel__fallback':
util/evsel.c:2802:14: error: 'struct perf_evsel' has no member named
'core'; did you mean 'node'?
   if (evsel->core.attr.exclude_user)
              ^~~~
              node

> ---
>  tools/perf/util/evsel.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index 68c5ab0e1800b..e8586957562b3 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -2796,6 +2796,10 @@ bool perf_evsel__fallback(struct perf_evsel *evsel, int err,
>                 char *new_name;
>                 const char *sep = ":";
>
> +               /* If event has exclude user then don't exclude kernel. */
> +               if (evsel->core.attr.exclude_user)
> +                       return false;
> +
>                 /* Is there already the separator in the name. */
>                 if (strchr(name, '/') ||
>                     strchr(name, ':'))
> --
> 2.25.1
>
>
>
