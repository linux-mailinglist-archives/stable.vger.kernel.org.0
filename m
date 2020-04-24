Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D665F1B7674
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 15:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728461AbgDXNII (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 09:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728455AbgDXNII (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 09:08:08 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98EADC09B045;
        Fri, 24 Apr 2020 06:08:07 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id h26so7471476qtu.8;
        Fri, 24 Apr 2020 06:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WpO16Fh4Vkj+Jz9+k/K3SHUv6y5M8rpJ9u3d1xP87iQ=;
        b=ojutYVoW20IR21Ii+yHxCiIVuZjLAnSpviyJqrRtB1AXDxKi34/gfbD5YZKbWYtwfa
         VtIbsKDlnLZpAubziA/8HgiMc9Mj9XJJ6OZC+gTOA48qsoj4+mODmrDKwQjqD22vPxnl
         GZ5YfKzG6Zzxl6SYonQzTuaGu2s1dOWmx/znCX2nxkU5YO6yW2G/dnoaHpayM79RZHkT
         QQx6sJIxQRA2Ne4ZaddiD4YS+ELPWw/ewb4Nz87e3YwPRzXQiSkSJwELz6MFDq7nwwnd
         9o9nlV7ojny8Br1LXa7QRnFhZPjqFxx8J0//aCa7ibVE7TqLsOE5JrJN3wO2cD8KSnjq
         CVPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WpO16Fh4Vkj+Jz9+k/K3SHUv6y5M8rpJ9u3d1xP87iQ=;
        b=Dl7w7jm4pWqwSKMfTc3zIHY3Z4u6NSM98623BDTmDz1KTPJoII6GUOC7d9heCCl3cW
         dD2m49angjQpfYlof1o4Kj9Ulutyr7Fj0UTv9SNixV5K/Zz7Kpdaqi+tODX9Q/+a7bBT
         9mNLQaVHl9Wd8RWHmF56PPWAoX3rHmCk1caY1aPz6fPoR56TVCudqbTYrhvqA1DUQkbt
         8ArVQPDZmoc5PD4V1ksVfyLt9GPZ0oIU9PvtyrIGfFKADurisidrQR9EConNz9mxvpWz
         t5+iqQB0hQvkRb4Jzv3dhMzkf32IDJDXxqWXXudKQ3clpBHc15+CvzqoCp0yKFe0C/pS
         ZVHQ==
X-Gm-Message-State: AGi0PuY3UO8RMvSGd4uoiPn9woYIV20BfvCP+lunfyFLPCi02h5G9Oi2
        +hL498Un09/zgWEkSJ+DMk9Yf/k01Ik=
X-Google-Smtp-Source: APiQypJpZDwyHjgN54itxsNrMZrVIpxOA3qi8QTbRGVOxu+UucyIyPnmhEaXUQcn3pyz40IGA+ukFA==
X-Received: by 2002:ac8:3212:: with SMTP id x18mr9064538qta.247.1587733686397;
        Fri, 24 Apr 2020 06:08:06 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([179.97.37.151])
        by smtp.gmail.com with ESMTPSA id g3sm3607892qkk.24.2020.04.24.06.08.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 06:08:05 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id D1852409A3; Fri, 24 Apr 2020 10:08:03 -0300 (-03)
Date:   Fri, 24 Apr 2020 10:08:03 -0300
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 3/3] perf-probe: Do not show the skipped events
Message-ID: <20200424130803.GL19437@kernel.org>
References: <158763965400.30755.14484569071233923742.stgit@devnote2>
 <158763968263.30755.12800484151476026340.stgit@devnote2>
 <20200423140139.GG19437@kernel.org>
 <20200424083305.6bff9456650308ab7a4ab750@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424083305.6bff9456650308ab7a4ab750@kernel.org>
X-Url:  http://acmel.wordpress.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Em Fri, Apr 24, 2020 at 08:33:05AM +0900, Masami Hiramatsu escreveu:
> On Thu, 23 Apr 2020 11:01:39 -0300
> Arnaldo Carvalho de Melo <acme@kernel.org> wrote:
> 
> > Em Thu, Apr 23, 2020 at 08:01:22PM +0900, Masami Hiramatsu escreveu:
> > > When a probe point is expanded to several places (like inlined) and
> > > if some of them are skipped because of blacklisted or __init function,
> > > those trace_events has no event name. It must be skipped while showing
> > > results.
> > > 
> > > Without this fix, you can see "(null):(null)" on the list,
> > > ===========
> > 
> > Ok, you broke the patch in two, I think its better to combine both, ok?
> 
> No, if an inlined function is embedded in blacklisted areas, it also
> shows same "(null):(null)" without [2/3].
> 
> Reordering the patches is OK, but this is still an independent fix.

Ok, so I'll try reordering, so that we don't see it in the cset log for
the other fix.

Thanks for the clarification,

- Arnaldo
 
> Thank you,
> 
> > 
> > - Arnaldo
> > 
> > >   # ./perf probe request_resource
> > >   reserve_setup is out of .text, skip it.
> > >   Added new events:
> > >     (null):(null)        (on request_resource)
> > >     probe:request_resource (on request_resource)
> > > 
> > >   You can now use it in all perf tools, such as:
> > > 
> > >   	perf record -e probe:request_resource -aR sleep 1
> > > 
> > > ===========
> > > 
> > > With this fix, it is ignored.
> > > ===========
> > >   # ./perf probe request_resource
> > >   reserve_setup is out of .text, skip it.
> > >   Added new events:
> > >     probe:request_resource (on request_resource)
> > > 
> > >   You can now use it in all perf tools, such as:
> > > 
> > >   	perf record -e probe:request_resource -aR sleep 1
> > > 
> > > ===========
> > > 
> > > Fixes: 5a51fcd1f30c ("perf probe: Skip kernel symbols which is out of .text")
> > > Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> > > Cc: stable@vger.kernel.org
> > > ---
> > >  tools/perf/builtin-probe.c |    3 +++
> > >  1 file changed, 3 insertions(+)
> > > 
> > > diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
> > > index 70548df2abb9..6b1507566770 100644
> > > --- a/tools/perf/builtin-probe.c
> > > +++ b/tools/perf/builtin-probe.c
> > > @@ -364,6 +364,9 @@ static int perf_add_probe_events(struct perf_probe_event *pevs, int npevs)
> > >  
> > >  		for (k = 0; k < pev->ntevs; k++) {
> > >  			struct probe_trace_event *tev = &pev->tevs[k];
> > > +			/* Skipped events have no event name */
> > > +			if (!tev->event)
> > > +				continue;
> > >  
> > >  			/* We use tev's name for showing new events */
> > >  			show_perf_probe_event(tev->group, tev->event, pev,
> > > 
> > 
> > -- 
> > 
> > - Arnaldo
> 
> 
> -- 
> Masami Hiramatsu <mhiramat@kernel.org>

-- 

- Arnaldo
