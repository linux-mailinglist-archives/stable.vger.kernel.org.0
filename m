Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0563F1B69DE
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgDWXdJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:33:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726060AbgDWXdJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Apr 2020 19:33:09 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF58120736;
        Thu, 23 Apr 2020 23:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587684789;
        bh=eOH8otZNBa35EahXHMyUuKwMSkdWrQwp8Sr98YxOspw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qlb/v6AnJJnQsYbkp4vlbhpaoOVQfoei+UqBfVMMSmK8ugUvdfKzoycXG+Jfn7A74
         hE3e4s2653BuRPYTyRkWMydupaiKX7tzOAHGb6pmRPQXxEcTyTeZclLq3Y62WBsT8U
         HpxMgrP8h8ynCzxAMUVoVtykjUd5VoOLQOMKW0MQ=
Date:   Fri, 24 Apr 2020 08:33:05 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 3/3] perf-probe: Do not show the skipped events
Message-Id: <20200424083305.6bff9456650308ab7a4ab750@kernel.org>
In-Reply-To: <20200423140139.GG19437@kernel.org>
References: <158763965400.30755.14484569071233923742.stgit@devnote2>
        <158763968263.30755.12800484151476026340.stgit@devnote2>
        <20200423140139.GG19437@kernel.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 23 Apr 2020 11:01:39 -0300
Arnaldo Carvalho de Melo <acme@kernel.org> wrote:

> Em Thu, Apr 23, 2020 at 08:01:22PM +0900, Masami Hiramatsu escreveu:
> > When a probe point is expanded to several places (like inlined) and
> > if some of them are skipped because of blacklisted or __init function,
> > those trace_events has no event name. It must be skipped while showing
> > results.
> > 
> > Without this fix, you can see "(null):(null)" on the list,
> > ===========
> 
> Ok, you broke the patch in two, I think its better to combine both, ok?

No, if an inlined function is embedded in blacklisted areas, it also
shows same "(null):(null)" without [2/3].

Reordering the patches is OK, but this is still an independent fix.

Thank you,

> 
> - Arnaldo
> 
> >   # ./perf probe request_resource
> >   reserve_setup is out of .text, skip it.
> >   Added new events:
> >     (null):(null)        (on request_resource)
> >     probe:request_resource (on request_resource)
> > 
> >   You can now use it in all perf tools, such as:
> > 
> >   	perf record -e probe:request_resource -aR sleep 1
> > 
> > ===========
> > 
> > With this fix, it is ignored.
> > ===========
> >   # ./perf probe request_resource
> >   reserve_setup is out of .text, skip it.
> >   Added new events:
> >     probe:request_resource (on request_resource)
> > 
> >   You can now use it in all perf tools, such as:
> > 
> >   	perf record -e probe:request_resource -aR sleep 1
> > 
> > ===========
> > 
> > Fixes: 5a51fcd1f30c ("perf probe: Skip kernel symbols which is out of .text")
> > Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> > Cc: stable@vger.kernel.org
> > ---
> >  tools/perf/builtin-probe.c |    3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
> > index 70548df2abb9..6b1507566770 100644
> > --- a/tools/perf/builtin-probe.c
> > +++ b/tools/perf/builtin-probe.c
> > @@ -364,6 +364,9 @@ static int perf_add_probe_events(struct perf_probe_event *pevs, int npevs)
> >  
> >  		for (k = 0; k < pev->ntevs; k++) {
> >  			struct probe_trace_event *tev = &pev->tevs[k];
> > +			/* Skipped events have no event name */
> > +			if (!tev->event)
> > +				continue;
> >  
> >  			/* We use tev's name for showing new events */
> >  			show_perf_probe_event(tev->group, tev->event, pev,
> > 
> 
> -- 
> 
> - Arnaldo


-- 
Masami Hiramatsu <mhiramat@kernel.org>
