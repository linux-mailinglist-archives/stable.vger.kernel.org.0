Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD10E3B958A
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 19:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232593AbhGARei (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Jul 2021 13:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbhGAReg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Jul 2021 13:34:36 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31B3EC061762
        for <stable@vger.kernel.org>; Thu,  1 Jul 2021 10:32:05 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso6242193pjx.1
        for <stable@vger.kernel.org>; Thu, 01 Jul 2021 10:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BbJUiUUe8T9b2PK6TM2EJq7HBKzquI9DW1+aUliaiPo=;
        b=CVBp7SxkahiNSc/6amQlsQrupBIvPGzMuT+qFHMb8J+fEgPmJ+jSNCObUz3UPwYwDh
         96U0UYYZnKH2aWE3M+lvXivMBhfaVSK+gjY5ur0I4ocShvUctW+KnLGvoFzWfrQslIk6
         qhd/uIEmUd5jSNYfWvz65ylCrTmu0PcSVOlxbZrg1xHtLdgXfIko/5vmpmtm3li2QbnP
         Y0moswHricRpt+NVr5AWm0QclZ+uXuMmIJKEWZ9wiXx/T/+XpZgl7Z/SMudxcLfqBcNP
         TTnrGYRIDdk4Nea4OFwd9s1bwBi4xFDWbYXNUIWUbl0VP7GQ9CetjiSW63t0JNc8CgD3
         wD7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BbJUiUUe8T9b2PK6TM2EJq7HBKzquI9DW1+aUliaiPo=;
        b=ArYl+hU2bd4ckRk5iHGSUWaYHBbUu22yDS0AISuu1gi/w1hs5mTnXKiefIhlNZy9gK
         OiDNuk3YYm76JCBE1eIm7Kq950HxmX1ApUdwcyu5S6HZv6wCf8v11Bv5N73k+/62Og7Q
         ucjS/QlUEZhbBZc29wrQ7E5QFyjs/fLzZlomipxVVWYmSt+2Er9majbtJPaYavdEOjzJ
         DemStY3QlCF6jJN9l2estPmConkZgjjgJEfuwpmaB2/5Sw/hrgXB1DiaaSg1+GivqBP6
         vrbFmN/bFelUO6tZRgpJcVJEdaiFcw9Tsd1F2MXRTz5UM6iHMY74OgHUexZ8KW99wCQT
         J6MA==
X-Gm-Message-State: AOAM5334L5hrQfUr1rvwsCXJcE6CwIgmn3v9v4ENaV/LH2R146CVHjsx
        TSOLD2GjVut1eWtmjRI7NFnknvtEKlZpTA==
X-Google-Smtp-Source: ABdhPJwaRu6TdRHiOXUsrbUGWmqyGU/c31E1IgwClXw1IEA4MbKdQrnpni+2qvPFr+yjvDGvNmfw+Q==
X-Received: by 2002:a17:902:8503:b029:127:8abc:191c with SMTP id bj3-20020a1709028503b02901278abc191cmr845772plb.21.1625160724477;
        Thu, 01 Jul 2021 10:32:04 -0700 (PDT)
Received: from google.com ([2620:15c:280:201:558a:406a:d453:dbe5])
        by smtp.gmail.com with ESMTPSA id y13sm444667pgp.16.2021.07.01.10.32.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 10:32:04 -0700 (PDT)
Date:   Thu, 1 Jul 2021 10:31:59 -0700
From:   Paul Burton <paulburton@google.com>
To:     Joel Fernandes <joelaf@google.com>
Cc:     linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] tracing: Simplify & fix saved_tgids logic
Message-ID: <YN38D3dg0fLzL0Ia@google.com>
References: <20210630003406.4013668-1-paulburton@google.com>
 <CAJWu+ooRQ6hFtaA4tr3BNs9Btss1yan8taua=VMWMopGmEVhSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJWu+ooRQ6hFtaA4tr3BNs9Btss1yan8taua=VMWMopGmEVhSA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Joel,

On Wed, Jun 30, 2021 at 06:29:55PM -0400, Joel Fernandes wrote:
> On Tue, Jun 29, 2021 at 8:34 PM Paul Burton <paulburton@google.com> wrote:
> >
> > The tgid_map array records a mapping from pid to tgid, where the index
> > of an entry within the array is the pid & the value stored at that index
> > is the tgid.
> >
> > The saved_tgids_next() function iterates over pointers into the tgid_map
> > array & dereferences the pointers which results in the tgid, but then it
> > passes that dereferenced value to trace_find_tgid() which treats it as a
> > pid & does a further lookup within the tgid_map array. It seems likely
> > that the intent here was to skip over entries in tgid_map for which the
> > recorded tgid is zero, but instead we end up skipping over entries for
> > which the thread group leader hasn't yet had its own tgid recorded in
> > tgid_map.
> >
> > A minimal fix would be to remove the call to trace_find_tgid, turning:
> >
> >   if (trace_find_tgid(*ptr))
> >
> > into:
> >
> >   if (*ptr)
> >
> > ..but it seems like this logic can be much simpler if we simply let
> > seq_read() iterate over the whole tgid_map array & filter out empty
> > entries by returning SEQ_SKIP from saved_tgids_show(). Here we take that
> > approach, removing the incorrect logic here entirely.
> 
> Looks reasonable except for one nit:
> 
> > Signed-off-by: Paul Burton <paulburton@google.com>
> > Fixes: d914ba37d714 ("tracing: Add support for recording tgid of tasks")
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: Joel Fernandes <joelaf@google.com>
> > Cc: <stable@vger.kernel.org>
> > ---
> >  kernel/trace/trace.c | 38 +++++++++++++-------------------------
> >  1 file changed, 13 insertions(+), 25 deletions(-)
> >
> > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > index d23a09d3eb37b..9570667310bcc 100644
> > --- a/kernel/trace/trace.c
> > +++ b/kernel/trace/trace.c
> > @@ -5608,37 +5608,20 @@ static const struct file_operations tracing_readme_fops = {
> >
> >  static void *saved_tgids_next(struct seq_file *m, void *v, loff_t *pos)
> >  {
> > -       int *ptr = v;
> > +       int pid = ++(*pos);
> >
> > -       if (*pos || m->count)
> > -               ptr++;
> > -
> > -       (*pos)++;
> > -
> > -       for (; ptr <= &tgid_map[PID_MAX_DEFAULT]; ptr++) {
> > -               if (trace_find_tgid(*ptr))
> > -                       return ptr;
> 
> It would be great if you can add back the check for !tgid_map to both
> next() and show() as well, for added robustness (since the old code
> previously did it).

That condition cannot happen, because both next() & show() are called to
iterate through the content of the seq_file & by definition their v
argument is non-NULL (else seq_file would have finished iterating
already). That argument came from either start() or an earlier call to
next(), which would only have returned a non-NULL pointer into tgid_map
if tgid_map is non-NULL.

I've added comments to this effect in v2, though the second patch in v2
does wind up effectively adding back the check in next() anyway in order
to reuse some code.

I was tempted to just add the redundant checks anyway (pick your battles
and all) but for show() in particular it wound up making things seem
non-sensical to me ("display the value describing this non-NULL pointer
into tgid_map only if tgid_map is not NULL?").

Thanks,
    Paul

> With that change:
> Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> 
> thanks,
> 
> -Joel
> 
> 
> > -       }
> > +       if (pid > PID_MAX_DEFAULT)
> > +               return NULL;
> >
> > -       return NULL;
> > +       return &tgid_map[pid];
> >  }
> >
> >  static void *saved_tgids_start(struct seq_file *m, loff_t *pos)
> >  {
> > -       void *v;
> > -       loff_t l = 0;
> > -
> > -       if (!tgid_map)
> > +       if (!tgid_map || *pos > PID_MAX_DEFAULT)
> >                 return NULL;
> >
> > -       v = &tgid_map[0];
> > -       while (l <= *pos) {
> > -               v = saved_tgids_next(m, v, &l);
> > -               if (!v)
> > -                       return NULL;
> > -       }
> > -
> > -       return v;
> > +       return &tgid_map[*pos];
> >  }
> >
> >  static void saved_tgids_stop(struct seq_file *m, void *v)
> > @@ -5647,9 +5630,14 @@ static void saved_tgids_stop(struct seq_file *m, void *v)
> >
> >  static int saved_tgids_show(struct seq_file *m, void *v)
> >  {
> > -       int pid = (int *)v - tgid_map;
> > +       int *entry = (int *)v;
> > +       int pid = entry - tgid_map;
> > +       int tgid = *entry;
> > +
> > +       if (tgid == 0)
> > +               return SEQ_SKIP;
> >
> > -       seq_printf(m, "%d %d\n", pid, trace_find_tgid(pid));
> > +       seq_printf(m, "%d %d\n", pid, tgid);
> >         return 0;
> >  }
> >
> >
> > base-commit: 62fb9874f5da54fdb243003b386128037319b219
> > --
> > 2.32.0.93.g670b81a890-goog
> >
