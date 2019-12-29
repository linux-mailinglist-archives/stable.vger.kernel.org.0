Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9A4212CA64
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbfL2Sew (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:34:52 -0500
Received: from mx1.yrkesakademin.fi ([85.134.45.194]:15928 "EHLO
        mx1.yrkesakademin.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726455AbfL2Sew (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Dec 2019 13:34:52 -0500
Subject: Re: [PATCH 5.4 249/434] perf probe: Fix to show ranges of variables
 in functions without entry_pc
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <stable@vger.kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
References: <20191229172702.393141737@linuxfoundation.org>
 <20191229172718.427913832@linuxfoundation.org>
From:   Thomas Backlund <tmb@mageia.org>
Message-ID: <52cea79f-324f-983d-e3d3-a4ee928a1ff3@mageia.org>
Date:   Sun, 29 Dec 2019 20:34:48 +0200
MIME-Version: 1.0
In-Reply-To: <20191229172718.427913832@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-WatchGuard-Spam-ID: str=0001.0A0C0204.5E08F1CA.0038,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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
> [ Upstream commit af04dd2f8ebaa8fbd46f698714acbf43da14da45 ]
> 
> Fix to show ranges of variables (--range and --vars option) in functions
> which DIE has only ranges but no entry_pc attribute.
> 
> Without this fix:
> 
>    # perf probe --range -V clear_tasks_mm_cpumask
>    Available variables at clear_tasks_mm_cpumask
>    	@<clear_tasks_mm_cpumask+0>
>    		(No matched variables)
> 
> With this fix:
> 
>    # perf probe --range -V clear_tasks_mm_cpumask
>    Available variables at clear_tasks_mm_cpumask
> 	@<clear_tasks_mm_cpumask+0>
> 		[VAL]	int	cpu	@<clear_tasks_mm_cpumask+[0-35,317-317,2052-2059]>
> 
> Committer testing:
> 
> Before:
> 
>    [root@quaco ~]# perf probe --range -V clear_tasks_mm_cpumask
>    Available variables at clear_tasks_mm_cpumask
>            @<clear_tasks_mm_cpumask+0>
>                    (No matched variables)
>    [root@quaco ~]#
> 
> After:
> 
>    [root@quaco ~]# perf probe --range -V clear_tasks_mm_cpumask
>    Available variables at clear_tasks_mm_cpumask
>            @<clear_tasks_mm_cpumask+0>
>                    [VAL]   int     cpu     @<clear_tasks_mm_cpumask+[0-23,23-105,105-106,106-106,1843-1850,1850-1862]>
>    [root@quaco ~]#
> 
> Using it:
> 
>    [root@quaco ~]# perf probe clear_tasks_mm_cpumask cpu
>    Added new event:
>      probe:clear_tasks_mm_cpumask (on clear_tasks_mm_cpumask with cpu)
> 
>    You can now use it in all perf tools, such as:
> 
>    	perf record -e probe:clear_tasks_mm_cpumask -aR sleep 1
> 
>    [root@quaco ~]# perf probe -l
>      probe:clear_tasks_mm_cpumask (on clear_tasks_mm_cpumask@kernel/cpu.c with cpu)
>    [root@quaco ~]#
>    [root@quaco ~]# perf trace -e probe:*cpumask
>    ^C[root@quaco ~]#
> 
> Fixes: 349e8d261131 ("perf probe: Add --range option to show a variable's location range")
> Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Link: http://lore.kernel.org/lkml/157199323018.8075.8179744380479673672.stgit@devnote2
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   tools/perf/util/dwarf-aux.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
> index 929b7c0567f4..4b1890204e99 100644
> --- a/tools/perf/util/dwarf-aux.c
> +++ b/tools/perf/util/dwarf-aux.c
> @@ -997,7 +997,7 @@ static int die_get_var_innermost_scope(Dwarf_Die *sp_die, Dwarf_Die *vr_die,
>   	bool first = true;
>   	const char *name;
>   
> -	ret = dwarf_entrypc(sp_die, &entry);
> +	ret = die_entrypc(sp_die, &entry);
>   	if (ret)
>   		return ret;
>   
> @@ -1060,7 +1060,7 @@ int die_get_var_range(Dwarf_Die *sp_die, Dwarf_Die *vr_die, struct strbuf *buf)
>   	bool first = true;
>   	const char *name;
>   
> -	ret = dwarf_entrypc(sp_die, &entry);
> +	ret = die_entrypc(sp_die, &entry);
>   	if (ret)
>   		return ret;
>   
> 

Still broken...

/usr/bin/ld: perf-in.o: in function `die_get_var_range':
/work/rpmbuild/BUILD/kernel-x86_64/linux-5.4/tools/perf/util/dwarf-aux.c:1085: 
undefined reference to `die_entrypc'
/usr/bin/ld: perf-in.o: in function `die_get_var_innermost_scope':
/work/rpmbuild/BUILD/kernel-x86_64/linux-5.4/tools/perf/util/dwarf-aux.c:1022: 
undefined reference to `die_entrypc'
collect2: error: ld returned 1 exit status

--
Thomas
