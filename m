Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B93C912CA78
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbfL2ShH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:37:07 -0500
Received: from mx1.yrkesakademin.fi ([85.134.45.194]:16030 "EHLO
        mx1.yrkesakademin.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726455AbfL2ShH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Dec 2019 13:37:07 -0500
Subject: Re: [PATCH 5.4 250/434] perf probe: Fix to show inlined function
 callsite without entry_pc
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <stable@vger.kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
References: <20191229172702.393141737@linuxfoundation.org>
 <20191229172718.511624671@linuxfoundation.org>
From:   Thomas Backlund <tmb@mageia.org>
Message-ID: <b4fdeac8-ea95-9bcd-3761-65b08f2d5bf5@mageia.org>
Date:   Sun, 29 Dec 2019 20:37:04 +0200
MIME-Version: 1.0
In-Reply-To: <20191229172718.511624671@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-WatchGuard-Spam-ID: str=0001.0A0C0209.5E08F252.004A,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-WatchGuard-Spam-Score: 0, clean; 0, virus threat unknown
X-WatchGuard-Mail-Client-IP: 85.134.45.194
X-WatchGuard-Mail-From: tmb@mageia.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Den 29-12-2019 kl. 19:25, skrev Greg Kroah-Hartman:
> From: Masami Hiramatsu <mhiramat@kernel.org>
> 
> [ Upstream commit 18e21eb671dc87a4f0546ba505a89ea93598a634 ]
> 
> Fix 'perf probe --line' option to show inlined function callsite lines
> even if the function DIE has only ranges.
> 
> Without this:
> 
>    # perf probe -L amd_put_event_constraints
>    ...
>        2  {
>        3         if (amd_has_nb(cpuc) && amd_is_nb_event(&event->hw))
>                          __amd_put_nb_event_constraints(cpuc, event);
>        5  }
> 
> With this patch:
> 
>    # perf probe -L amd_put_event_constraints
>    ...
>        2  {
>        3         if (amd_has_nb(cpuc) && amd_is_nb_event(&event->hw))
>        4                 __amd_put_nb_event_constraints(cpuc, event);
>        5  }
> 
> Committer testing:
> 
> Before:
> 
>    [root@quaco ~]# perf probe -L amd_put_event_constraints
>    <amd_put_event_constraints@/usr/src/debug/kernel-5.2.fc30/linux-5.2.18-200.fc30.x86_64/arch/x86/events/amd/core.c:0>
>          0  static void amd_put_event_constraints(struct cpu_hw_events *cpuc,
>                                                  struct perf_event *event)
>          2  {
>          3         if (amd_has_nb(cpuc) && amd_is_nb_event(&event->hw))
>                            __amd_put_nb_event_constraints(cpuc, event);
>          5  }
> 
>             PMU_FORMAT_ATTR(event, "config:0-7,32-35");
>             PMU_FORMAT_ATTR(umask, "config:8-15"   );
> 
>    [root@quaco ~]#
> 
> After:
> 
>    [root@quaco ~]# perf probe -L amd_put_event_constraints
>    <amd_put_event_constraints@/usr/src/debug/kernel-5.2.fc30/linux-5.2.18-200.fc30.x86_64/arch/x86/events/amd/core.c:0>
>          0  static void amd_put_event_constraints(struct cpu_hw_events *cpuc,
>                                                  struct perf_event *event)
>          2  {
>          3         if (amd_has_nb(cpuc) && amd_is_nb_event(&event->hw))
>          4                 __amd_put_nb_event_constraints(cpuc, event);
>          5  }
> 
>             PMU_FORMAT_ATTR(event, "config:0-7,32-35");
>             PMU_FORMAT_ATTR(umask, "config:8-15"   );
> 
>    [root@quaco ~]# perf probe amd_put_event_constraints:4
>    Added new event:
>      probe:amd_put_event_constraints (on amd_put_event_constraints:4)
> 
>    You can now use it in all perf tools, such as:
> 
>    	perf record -e probe:amd_put_event_constraints -aR sleep 1
> 
>    [root@quaco ~]#
> 
>    [root@quaco ~]# perf probe -l
>      probe:amd_put_event_constraints (on amd_put_event_constraints:4@arch/x86/events/amd/core.c)
>      probe:clear_tasks_mm_cpumask (on clear_tasks_mm_cpumask@kernel/cpu.c)
>    [root@quaco ~]#
> 
> Using it:
> 
>    [root@quaco ~]# perf trace -e probe:*
>    ^C[root@quaco ~]#
> 
> Ok, Intel system here... :-)
> 
> Fixes: 4cc9cec636e7 ("perf probe: Introduce lines walker interface")
> Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Link: http://lore.kernel.org/lkml/157199322107.8075.12659099000567865708.stgit@devnote2
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   tools/perf/util/dwarf-aux.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
> index 4b1890204e99..08aba015e072 100644
> --- a/tools/perf/util/dwarf-aux.c
> +++ b/tools/perf/util/dwarf-aux.c
> @@ -673,7 +673,7 @@ static int __die_walk_funclines_cb(Dwarf_Die *in_die, void *data)
>   	if (dwarf_tag(in_die) == DW_TAG_inlined_subroutine) {
>   		fname = die_get_call_file(in_die);
>   		lineno = die_get_call_lineno(in_die);
> -		if (fname && lineno > 0 && dwarf_entrypc(in_die, &addr) == 0) {
> +		if (fname && lineno > 0 && die_entrypc(in_die, &addr) == 0) {
>   			lw->retval = lw->callback(fname, lineno, addr, lw->data);
>   			if (lw->retval != 0)
>   				return DIE_FIND_CB_END;
> 


Still broken...

util/dwarf-aux.c: In function '__die_walk_funclines_cb':
util/dwarf-aux.c:683:30: warning: implicit declaration of function 
'die_entrypc'; did you mean 'dwarf_entrypc'? 
[-Wimplicit-function-declaration]
   683 |   if (fname && lineno > 0 && die_entrypc(in_die, &addr) == 0) {


--
Thomas
