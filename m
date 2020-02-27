Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF81A172319
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 17:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728993AbgB0QUr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 11:20:47 -0500
Received: from relay10.mail.gandi.net ([217.70.178.230]:43437 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728963AbgB0QUr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 11:20:47 -0500
Received: from [10.30.1.20] (lneuilly-657-1-5-103.w81-250.abo.wanadoo.fr [81.250.144.103])
        (Authenticated sender: alex@ghiti.fr)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id E9614240011;
        Thu, 27 Feb 2020 16:20:39 +0000 (UTC)
Subject: Re: [BUGFIX PATCH] perf probe: Do not depend on dwfl_module_addrsym()
To:     Masami Hiramatsu <mhiramat@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20200228002553.31b82876b705aaabbd717131@kernel.org>
 <158281812176.476.14164573830975116234.stgit@devnote2>
From:   Alexandre Ghiti <alex@ghiti.fr>
Message-ID: <787c2915-c868-358a-481d-1ffd355d92db@ghiti.fr>
Date:   Thu, 27 Feb 2020 17:20:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <158281812176.476.14164573830975116234.stgit@devnote2>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/27/20 4:42 PM, Masami Hiramatsu wrote:
> Do not depend on dwfl_module_addrsym() because it can fail
> on user-space shared libraries.
> 
> Actually, same bug was fixed by commit 664fee3dc379 ("perf
> probe: Do not use dwfl_module_addrsym if dwarf_diename finds
> symbol name"), but commit 07d369857808 ("perf probe: Fix
> wrong address verification) reverted to get actual symbol
> address from symtab.
> 
> This fixes it again by getting symbol address from DIE,
> and only if the DIE has only address range, it uses
> dwfl_module_addrsym().
> 
> Fixes: 07d369857808 ("perf probe: Fix wrong address verification)
> Reported-by: Alexandre Ghiti <alex@ghiti.fr>
> Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> ---
>   tools/perf/util/probe-finder.c |   11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
> index 1c817add6ca4..e4cff49384f4 100644
> --- a/tools/perf/util/probe-finder.c
> +++ b/tools/perf/util/probe-finder.c
> @@ -637,14 +637,19 @@ static int convert_to_trace_point(Dwarf_Die *sp_die, Dwfl_Module *mod,
>   		return -EINVAL;
>   	}
>   
> -	/* Try to get actual symbol name from symtab */
> -	symbol = dwfl_module_addrsym(mod, paddr, &sym, NULL);
> +	if (dwarf_entrypc(sp_die, &eaddr) == 0) {
> +		/* If the DIE has entrypc, use it. */
> +		symbol = dwarf_diename(sp_die);
> +	} else {
> +		/* Try to get actual symbol name and address from symtab */
> +		symbol = dwfl_module_addrsym(mod, paddr, &sym, NULL);
> +		eaddr = sym.st_value;
> +	}
>   	if (!symbol) {
>   		pr_warning("Failed to find symbol at 0x%lx\n",
>   			   (unsigned long)paddr);
>   		return -ENOENT;
>   	}
> -	eaddr = sym.st_value;
>   
>   	tp->offset = (unsigned long)(paddr - eaddr);
>   	tp->address = (unsigned long)paddr;
> 

I have just tested your patch, that fixes the issue, so you can add:

Tested-by: Alexandre Ghiti <alex@ghiti.fr>

I added stable in cc.

Thanks,

Alex
