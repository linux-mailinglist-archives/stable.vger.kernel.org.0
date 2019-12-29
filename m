Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 364C412CA62
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfL2ScU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:32:20 -0500
Received: from mx1.yrkesakademin.fi ([85.134.45.194]:15805 "EHLO
        mx1.yrkesakademin.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbfL2ScU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Dec 2019 13:32:20 -0500
Subject: Re: [PATCH 5.4 248/434] perf probe: Fix to probe an inline function
 which has no entry pc
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <stable@vger.kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
References: <20191229172702.393141737@linuxfoundation.org>
 <20191229172718.360610159@linuxfoundation.org>
From:   Thomas Backlund <tmb@mageia.org>
Message-ID: <5d71d994-9fa1-9d99-b045-751f8a48c51a@mageia.org>
Date:   Sun, 29 Dec 2019 20:32:16 +0200
MIME-Version: 1.0
In-Reply-To: <20191229172718.360610159@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-WatchGuard-Spam-ID: str=0001.0A0C0207.5E08F132.008E,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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
> [ Upstream commit eb6933b29d20bf2c3053883d409a53f462c1a3ac ]
> 
> Fix perf probe to probe an inlne function which has no entry pc
> or low pc but only has ranges attribute.
> 
> This seems very rare case, but I could find a few examples, as
> same as probe_point_search_cb(), use die_entrypc() to get the
> entry address in probe_point_inline_cb() too.
> 
> Without this patch:
> 
>    # perf probe -D __amd_put_nb_event_constraints
>    Failed to get entry address of __amd_put_nb_event_constraints.
>    Probe point '__amd_put_nb_event_constraints' not found.
>      Error: Failed to add events.
> 
> With this patch:
> 
>    # perf probe -D __amd_put_nb_event_constraints
>    p:probe/__amd_put_nb_event_constraints amd_put_event_constraints+43
> 
> Committer testing:
> 
> Before:
> 
>    [root@quaco ~]# perf probe -D __amd_put_nb_event_constraints
>    Failed to get entry address of __amd_put_nb_event_constraints.
>    Probe point '__amd_put_nb_event_constraints' not found.
>      Error: Failed to add events.
>    [root@quaco ~]#
> 
> After:
> 
>    [root@quaco ~]# perf probe -D __amd_put_nb_event_constraints
>    p:probe/__amd_put_nb_event_constraints _text+33789
>    [root@quaco ~]#
> 
> Fixes: 4ea42b181434 ("perf: Add perf probe subcommand, a kprobe-event setup helper")
> Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Link: http://lore.kernel.org/lkml/157199320336.8075.16189530425277588587.stgit@devnote2
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   tools/perf/util/probe-finder.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
> index 7c8d30fb2b99..7857ae7a10b7 100644
> --- a/tools/perf/util/probe-finder.c
> +++ b/tools/perf/util/probe-finder.c
> @@ -942,7 +942,7 @@ static int probe_point_inline_cb(Dwarf_Die *in_die, void *data)
>   		ret = find_probe_point_lazy(in_die, pf);
>   	else {
>   		/* Get probe address */
> -		if (dwarf_entrypc(in_die, &addr) != 0) {
> +		if (die_entrypc(in_die, &addr) != 0) {
>   			pr_warning("Failed to get entry address of %s.\n",
>   				   dwarf_diename(in_die));
>   			return -ENOENT;
> 



Still broken...

/usr/bin/ld: perf-in.o: in function `probe_point_inline_cb':
/work/rpmbuild/BUILD/kernel-x86_64/linux-5.4/tools/perf/util/probe-finder.c:960: 
undefined reference to `die_entrypc'
collect2: error: ld returned 1 exit status
make[2]: *** [Makefile.perf:609: perf] Error 1

--
Thomas
