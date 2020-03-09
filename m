Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C51917E194
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 14:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbgCINof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 09:44:35 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:37144 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbgCINof (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Mar 2020 09:44:35 -0400
Received: by mail-qt1-f196.google.com with SMTP id l20so5324584qtp.4;
        Mon, 09 Mar 2020 06:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=D6cXat42hj47od4O3YYRkfc6ydOCCt1WIPX2GeSiPA8=;
        b=dQx67vi8EfXyUq0/64+oIGZy1P1ALvt/9kWj65TgZKzXxjwlrJS06mGtVtqi0bNUdx
         m9dObpOjMO8fJZOkiURuyB6adPlF56NUdElmMnLryNrN3V+4klanIP6tGEvADSDk0x1t
         sG2sWJDJ4zMIvesErqzpU+Xt+ZLQepyjR71GJ3DdRrWtyKuP/RDgBg4GHlVMG5WWuk66
         tCTXsD5xv5hmR2GRpgW5AvuRnNGd/fUhzKupuyfLtupuHRdfcegA22F7+8PbIxQtHx6V
         VHl2Lv2EZIDLbl2ct3/FblQOhYXfWgryPWh0dY04u5IKO9I3adQz//9XWlLyamoC5eFO
         CCgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=D6cXat42hj47od4O3YYRkfc6ydOCCt1WIPX2GeSiPA8=;
        b=cI1S30es62037TwV0bjgv34f1tZss4oM4B1LHF/QY43cpw7qjmxDFJVour2glvFm7R
         ghcLzaPlxbIwxdnQLb86jrmBDvmtVvtYyyWm+uOLNIxqIQwZvSnHsfXHzlG85ab3ZQ6x
         TU74GYSo012xN5n5dcIfM1kq2l4tvtudfQlSRYrJdkQpGqjziNtDtQKNrsZBZyMxq+fv
         D3y0zVqdU02d8lgvAHovuLMqMu3wiQn4mCNGXNgB3PHUryEZWbvdvM1C1FwUOKk3xlvD
         B40euHDNxLacpcFfgsKtm0FFccnQEd/q1e5P5GcvAeX4hESbxiPPaQWtfMHbvQe2NX2M
         UPTQ==
X-Gm-Message-State: ANhLgQ0hmp19kXLVgn7MjZreGfsqcAqulsv+TC8+ykdrti1WNGdtmxyd
        +DI9WC4LnCL0wJfdD1CjwhQ=
X-Google-Smtp-Source: ADFU+vvJLunTyPwIkpuxQglgVQSjM8WsdfHHO4oWoKh+k9FOa6zpm2+G2He/3R9IklZN3wpAHqotxQ==
X-Received: by 2002:ac8:4e2e:: with SMTP id d14mr11937429qtw.179.1583761474284;
        Mon, 09 Mar 2020 06:44:34 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([179.97.37.151])
        by smtp.gmail.com with ESMTPSA id m65sm2098791qke.109.2020.03.09.06.44.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 06:44:33 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id F3CEC40009; Mon,  9 Mar 2020 10:44:30 -0300 (-03)
Date:   Mon, 9 Mar 2020 10:44:30 -0300
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Alexandre Ghiti <alex@ghiti.fr>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [BUGFIX PATCH] perf probe: Do not depend on dwfl_module_addrsym()
Message-ID: <20200309134430.GE477@kernel.org>
References: <20200228002553.31b82876b705aaabbd717131@kernel.org>
 <158281812176.476.14164573830975116234.stgit@devnote2>
 <787c2915-c868-358a-481d-1ffd355d92db@ghiti.fr>
 <20200228085238.84d53d6b753efb4cc18d20cb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200228085238.84d53d6b753efb4cc18d20cb@kernel.org>
X-Url:  http://acmel.wordpress.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Em Fri, Feb 28, 2020 at 08:52:38AM +0900, Masami Hiramatsu escreveu:
> On Thu, 27 Feb 2020 17:20:39 +0100
> Alexandre Ghiti <alex@ghiti.fr> wrote:
> 
> > On 2/27/20 4:42 PM, Masami Hiramatsu wrote:
> > > Do not depend on dwfl_module_addrsym() because it can fail
> > > on user-space shared libraries.
> > > 
> > > Actually, same bug was fixed by commit 664fee3dc379 ("perf
> > > probe: Do not use dwfl_module_addrsym if dwarf_diename finds
> > > symbol name"), but commit 07d369857808 ("perf probe: Fix
> > > wrong address verification) reverted to get actual symbol
> > > address from symtab.
> > > 
> > > This fixes it again by getting symbol address from DIE,
> > > and only if the DIE has only address range, it uses
> > > dwfl_module_addrsym().
> > > 
> > > Fixes: 07d369857808 ("perf probe: Fix wrong address verification)
> > > Reported-by: Alexandre Ghiti <alex@ghiti.fr>
> > > Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> > > ---
> > >   tools/perf/util/probe-finder.c |   11 ++++++++---
> > >   1 file changed, 8 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
> > > index 1c817add6ca4..e4cff49384f4 100644
> > > --- a/tools/perf/util/probe-finder.c
> > > +++ b/tools/perf/util/probe-finder.c
> > > @@ -637,14 +637,19 @@ static int convert_to_trace_point(Dwarf_Die *sp_die, Dwfl_Module *mod,
> > >   		return -EINVAL;
> > >   	}
> > >   
> > > -	/* Try to get actual symbol name from symtab */
> > > -	symbol = dwfl_module_addrsym(mod, paddr, &sym, NULL);
> > > +	if (dwarf_entrypc(sp_die, &eaddr) == 0) {
> > > +		/* If the DIE has entrypc, use it. */
> > > +		symbol = dwarf_diename(sp_die);
> > > +	} else {
> > > +		/* Try to get actual symbol name and address from symtab */
> > > +		symbol = dwfl_module_addrsym(mod, paddr, &sym, NULL);
> > > +		eaddr = sym.st_value;
> > > +	}
> > >   	if (!symbol) {
> > >   		pr_warning("Failed to find symbol at 0x%lx\n",
> > >   			   (unsigned long)paddr);
> > >   		return -ENOENT;
> > >   	}
> > > -	eaddr = sym.st_value;
> > >   
> > >   	tp->offset = (unsigned long)(paddr - eaddr);
> > >   	tp->address = (unsigned long)paddr;
> > > 
> > 
> > I have just tested your patch, that fixes the issue, so you can add:
> > 
> > Tested-by: Alexandre Ghiti <alex@ghiti.fr>
> 
> Thanks Alexandre,
> Arnaldo, could you also pick this for fix?


Thanks, applied.

- Arnaldo
