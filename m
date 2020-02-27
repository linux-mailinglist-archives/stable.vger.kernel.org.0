Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 919B6172C8C
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 00:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729812AbgB0Xwn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 18:52:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:50492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728993AbgB0Xwn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 18:52:43 -0500
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30DD3246A3;
        Thu, 27 Feb 2020 23:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582847562;
        bh=Q1QtOwbC003YNSLbIfjhBZHYUDdAcC8iJBFmWd+xTmU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MenvHWpBg8j7UtPwiKrnvksbuyTBGlKLV0EF0wjLe8JN+fiZiInOoQJ+6ilnEMwQS
         hKibr9tkI6MmXXMhllBNBou5+zqIll2N5li4fbTZub/3eIluUHsyOUVkg+RoNvPwve
         gFT4RgFui4khaC6BHFHtJW3xCeMVBnxffa7N/sQM=
Date:   Fri, 28 Feb 2020 08:52:38 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Alexandre Ghiti <alex@ghiti.fr>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [BUGFIX PATCH] perf probe: Do not depend on
 dwfl_module_addrsym()
Message-Id: <20200228085238.84d53d6b753efb4cc18d20cb@kernel.org>
In-Reply-To: <787c2915-c868-358a-481d-1ffd355d92db@ghiti.fr>
References: <20200228002553.31b82876b705aaabbd717131@kernel.org>
        <158281812176.476.14164573830975116234.stgit@devnote2>
        <787c2915-c868-358a-481d-1ffd355d92db@ghiti.fr>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 27 Feb 2020 17:20:39 +0100
Alexandre Ghiti <alex@ghiti.fr> wrote:

> On 2/27/20 4:42 PM, Masami Hiramatsu wrote:
> > Do not depend on dwfl_module_addrsym() because it can fail
> > on user-space shared libraries.
> > 
> > Actually, same bug was fixed by commit 664fee3dc379 ("perf
> > probe: Do not use dwfl_module_addrsym if dwarf_diename finds
> > symbol name"), but commit 07d369857808 ("perf probe: Fix
> > wrong address verification) reverted to get actual symbol
> > address from symtab.
> > 
> > This fixes it again by getting symbol address from DIE,
> > and only if the DIE has only address range, it uses
> > dwfl_module_addrsym().
> > 
> > Fixes: 07d369857808 ("perf probe: Fix wrong address verification)
> > Reported-by: Alexandre Ghiti <alex@ghiti.fr>
> > Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> > ---
> >   tools/perf/util/probe-finder.c |   11 ++++++++---
> >   1 file changed, 8 insertions(+), 3 deletions(-)
> > 
> > diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
> > index 1c817add6ca4..e4cff49384f4 100644
> > --- a/tools/perf/util/probe-finder.c
> > +++ b/tools/perf/util/probe-finder.c
> > @@ -637,14 +637,19 @@ static int convert_to_trace_point(Dwarf_Die *sp_die, Dwfl_Module *mod,
> >   		return -EINVAL;
> >   	}
> >   
> > -	/* Try to get actual symbol name from symtab */
> > -	symbol = dwfl_module_addrsym(mod, paddr, &sym, NULL);
> > +	if (dwarf_entrypc(sp_die, &eaddr) == 0) {
> > +		/* If the DIE has entrypc, use it. */
> > +		symbol = dwarf_diename(sp_die);
> > +	} else {
> > +		/* Try to get actual symbol name and address from symtab */
> > +		symbol = dwfl_module_addrsym(mod, paddr, &sym, NULL);
> > +		eaddr = sym.st_value;
> > +	}
> >   	if (!symbol) {
> >   		pr_warning("Failed to find symbol at 0x%lx\n",
> >   			   (unsigned long)paddr);
> >   		return -ENOENT;
> >   	}
> > -	eaddr = sym.st_value;
> >   
> >   	tp->offset = (unsigned long)(paddr - eaddr);
> >   	tp->address = (unsigned long)paddr;
> > 
> 
> I have just tested your patch, that fixes the issue, so you can add:
> 
> Tested-by: Alexandre Ghiti <alex@ghiti.fr>

Thanks Alexandre,
Arnaldo, could you also pick this for fix?

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
