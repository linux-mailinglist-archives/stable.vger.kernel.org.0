Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0B5912CA7F
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727131AbfL2Smc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:42:32 -0500
Received: from mx1.yrkesakademin.fi ([85.134.45.194]:16298 "EHLO
        mx1.yrkesakademin.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726455AbfL2Smc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Dec 2019 13:42:32 -0500
Subject: Re: [PATCH 5.4 245/434] perf probe: Fix to list probe event with
 correct line number
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <stable@vger.kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
References: <20191229172702.393141737@linuxfoundation.org>
 <20191229172718.158972713@linuxfoundation.org>
From:   Thomas Backlund <tmb@mageia.org>
Message-ID: <689591f8-0798-af22-9a04-4a1e6e894a55@mageia.org>
Date:   Sun, 29 Dec 2019 20:42:28 +0200
MIME-Version: 1.0
In-Reply-To: <20191229172718.158972713@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-WatchGuard-Spam-ID: str=0001.0A0C0210.5E08F396.0055,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-WatchGuard-Spam-Score: 0, clean; 0, virus threat unknown
X-WatchGuard-Mail-Client-IP: 85.134.45.194
X-WatchGuard-Mail-From: tmb@mageia.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Den 29-12-2019 kl. 19:24, skrev Greg Kroah-Hartman:
> From: Masami Hiramatsu <mhiramat@kernel.org>
> 
> [ Upstream commit 3895534dd78f0fd4d3f9e05ee52b9cdd444a743e ]
> 
> Since debuginfo__find_probe_point() uses dwarf_entrypc() for finding the
> entry address of the function on which a probe is, it will fail when the
> function DIE has only ranges attribute.
> 
> To fix this issue, use die_entrypc() instead of dwarf_entrypc().
> 
> Without this fix, perf probe -l shows incorrect offset:
> 
>    # perf probe -l
>      probe:clear_tasks_mm_cpumask (on clear_tasks_mm_cpumask+18446744071579263632@work/linux/linux/kernel/cpu.c)
>      probe:clear_tasks_mm_cpumask_1 (on clear_tasks_mm_cpumask+18446744071579263752@work/linux/linux/kernel/cpu.c)
> 
> With this:
> 
>    # perf probe -l
>      probe:clear_tasks_mm_cpumask (on clear_tasks_mm_cpumask@work/linux/linux/kernel/cpu.c)
>      probe:clear_tasks_mm_cpumask_1 (on clear_tasks_mm_cpumask:21@work/linux/linux/kernel/cpu.c)
> 
> Committer testing:
> 
> Before:
> 
>    [root@quaco ~]# perf probe -l
>      probe:clear_tasks_mm_cpumask (on clear_tasks_mm_cpumask+18446744071579765152@kernel/cpu.c)
>    [root@quaco ~]#
> 
> After:
> 
>    [root@quaco ~]# perf probe -l
>      probe:clear_tasks_mm_cpumask (on clear_tasks_mm_cpumask@kernel/cpu.c)
>    [root@quaco ~]#
> 
> Fixes: 1d46ea2a6a40 ("perf probe: Fix listing incorrect line number with inline function")
> Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Link: http://lore.kernel.org/lkml/157199321227.8075.14655572419136993015.stgit@devnote2
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   tools/perf/util/probe-finder.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
> index cd9f95e5044e..7c8d30fb2b99 100644
> --- a/tools/perf/util/probe-finder.c
> +++ b/tools/perf/util/probe-finder.c
> @@ -1578,7 +1578,7 @@ int debuginfo__find_probe_point(struct debuginfo *dbg, unsigned long addr,
>   		/* Get function entry information */
>   		func = basefunc = dwarf_diename(&spdie);
>   		if (!func ||
> -		    dwarf_entrypc(&spdie, &baseaddr) != 0 ||
> +		    die_entrypc(&spdie, &baseaddr) != 0 ||
>   		    dwarf_decl_line(&spdie, &baseline) != 0) {
>   			lineno = 0;
>   			goto post;
> @@ -1595,7 +1595,7 @@ int debuginfo__find_probe_point(struct debuginfo *dbg, unsigned long addr,
>   		while (die_find_top_inlinefunc(&spdie, (Dwarf_Addr)addr,
>   						&indie)) {
>   			/* There is an inline function */
> -			if (dwarf_entrypc(&indie, &_addr) == 0 &&
> +			if (die_entrypc(&indie, &_addr) == 0 &&
>   			    _addr == addr) {
>   				/*
>   				 * addr is at an inline function entry.
> 


still broken

/usr/bin/ld: perf-in.o: in function `debuginfo__find_probe_point':
/work/rpmbuild/BUILD/kernel-x86_64/linux-5.4/tools/perf/util/probe-finder.c:1616: 
undefined reference to `die_entrypc'

--
Thomas
