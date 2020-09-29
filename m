Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37EAF27D108
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 16:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728699AbgI2O1N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 10:27:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:39484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727543AbgI2O1N (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 10:27:13 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 276C220739;
        Tue, 29 Sep 2020 14:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601389631;
        bh=N22FwIdH98oW9vtKFTALgnJGDqMt/w7VFFG1kFRSiAY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NQb0lKqG2f8od92Iaa7rEiYe9W0Rr2XtetonmHgbG+COIsTqiayRP4KOpv6xAXgwk
         22ax2NH7fETrDC4Jfb+jOWd/meTqThQLMiijTA9PEkP+REU8iwsbaCXmSdE5jRvKMV
         bsxSVZQYdhnX7FUI4rzQp3G3dgIBKSGjHYOtwgeA=
Date:   Tue, 29 Sep 2020 16:27:17 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux- stable <stable@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        open list <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 146/245] perf stat: Force error in fallback on :k
 events
Message-ID: <20200929142717.GB1203131@kroah.com>
References: <20200929105946.978650816@linuxfoundation.org>
 <20200929105954.090876288@linuxfoundation.org>
 <CA+G9fYs-gqkrwzFeMQ1NpV_BfYPrV2CCOKJv6QE7U3mhc56F9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYs-gqkrwzFeMQ1NpV_BfYPrV2CCOKJv6QE7U3mhc56F9w@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 29, 2020 at 07:03:46PM +0530, Naresh Kamboju wrote:
> On Tue, 29 Sep 2020 at 17:54, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Stephane Eranian <eranian@google.com>
> >
> > [ Upstream commit bec49a9e05db3dbdca696fa07c62c52638fb6371 ]
> >
> > When it is not possible for a non-privilege perf command to monitor at
> > the kernel level (:k), the fallback code forces a :u. That works if the
> > event was previously monitoring both levels.  But if the event was
> > already constrained to kernel only, then it does not make sense to
> > restrict it to user only.
> >
> > Given the code works by exclusion, a kernel only event would have:
> >
> >   attr->exclude_user = 1
> >
> > The fallback code would add:
> >
> >   attr->exclude_kernel = 1
> >
> > In the end the end would not monitor in either the user level or kernel
> > level. In other words, it would count nothing.
> >
> > An event programmed to monitor kernel only cannot be switched to user
> > only without seriously warning the user.
> >
> > This patch forces an error in this case to make it clear the request
> > cannot really be satisfied.
> >
> > Behavior with paranoid 1:
> >
> >   $ sudo bash -c "echo 1 > /proc/sys/kernel/perf_event_paranoid"
> >   $ perf stat -e cycles:k sleep 1
> >
> >    Performance counter stats for 'sleep 1':
> >
> >            1,520,413      cycles:k
> >
> >          1.002361664 seconds time elapsed
> >
> >          0.002480000 seconds user
> >          0.000000000 seconds sys
> >
> > Old behavior with paranoid 2:
> >
> >   $ sudo bash -c "echo 2 > /proc/sys/kernel/perf_event_paranoid"
> >   $ perf stat -e cycles:k sleep 1
> >    Performance counter stats for 'sleep 1':
> >
> >                    0      cycles:ku
> >
> >          1.002358127 seconds time elapsed
> >
> >          0.002384000 seconds user
> >          0.000000000 seconds sys
> >
> > New behavior with paranoid 2:
> >
> >   $ sudo bash -c "echo 2 > /proc/sys/kernel/perf_event_paranoid"
> >   $ perf stat -e cycles:k sleep 1
> >   Error:
> >   You may not have permission to collect stats.
> >
> >   Consider tweaking /proc/sys/kernel/perf_event_paranoid,
> >   which controls use of the performance events system by
> >   unprivileged users (without CAP_PERFMON or CAP_SYS_ADMIN).
> >
> >   The current value is 2:
> >
> >     -1: Allow use of (almost) all events by all users
> >         Ignore mlock limit after perf_event_mlock_kb without CAP_IPC_LOCK
> >   >= 0: Disallow ftrace function tracepoint by users without CAP_PERFMON or CAP_SYS_ADMIN
> >         Disallow raw tracepoint access by users without CAP_SYS_PERFMON or CAP_SYS_ADMIN
> >   >= 1: Disallow CPU event access by users without CAP_PERFMON or CAP_SYS_ADMIN
> >   >= 2: Disallow kernel profiling by users without CAP_PERFMON or CAP_SYS_ADMIN
> >
> >   To make this setting permanent, edit /etc/sysctl.conf too, e.g.:
> >
> >           kernel.perf_event_paranoid = -1
> >
> > v2 of this patch addresses the review feedback from jolsa@redhat.com.
> >
> > Signed-off-by: Stephane Eranian <eranian@google.com>
> > Reviewed-by: Ian Rogers <irogers@google.com>
> > Acked-by: Jiri Olsa <jolsa@redhat.com>
> > Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> > Cc: Jiri Olsa <jolsa@redhat.com>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Cc: Namhyung Kim <namhyung@kernel.org>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Link: http://lore.kernel.org/lkml/20200414161550.225588-1-irogers@google.com
> > Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> perf failed on stable rc branch 4.19 on all devices.
> 
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> 
> build warning and errors,
> -----------------------------------
> In file included from util/evlist.h:15:0,
>                  from util/evsel.c:30:
> util/evsel.c: In function 'perf_evsel__exit':
> util/util.h:25:28: warning: passing argument 1 of 'free' discards
> 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
>  #define zfree(ptr) ({ free(*ptr); *ptr = NULL; })
>                             ^
> util/evsel.c:1293:2: note: in expansion of macro 'zfree'
>   zfree(&evsel->pmu_name);
>   ^~~~~
> In file included from
> /srv/oe/build/tmp-lkft-glibc/work/intel_corei7_64-linaro-linux/perf/1.0-r9/perf-1.0/tools/perf/arch/x86/include/perf_regs.h:5:0,
>                  from util/perf_regs.h:27,
>                  from util/event.h:11,
>                  from util/callchain.h:8,
>                  from util/evsel.c:26:
> perf/1.0-r9/recipe-sysroot/usr/include/stdlib.h:563:13: note: expected
> 'void *' but argument is of type 'const char *'
>  extern void free (void *__ptr) __THROW;
>              ^~~~
> util/evsel.c: In function 'perf_evsel__fallback':
> util/evsel.c:2802:14: error: 'struct perf_evsel' has no member named
> 'core'; did you mean 'node'?
>    if (evsel->core.attr.exclude_user)
>               ^~~~
>               node

I thought Sasha had dropped all of the offending patches.  I'll go drop
this one and push out a new 4.19-rc release.

But note, the latest 4.19.y tree doesn't even build perf for me, so I
can't really check this locally :(

thanks,

greg k-h
