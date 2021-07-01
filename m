Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FAC43B95E3
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 20:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233877AbhGASHx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Jul 2021 14:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbhGASHw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Jul 2021 14:07:52 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AFDAC061762
        for <stable@vger.kernel.org>; Thu,  1 Jul 2021 11:05:22 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id j14so3410652qvu.6
        for <stable@vger.kernel.org>; Thu, 01 Jul 2021 11:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9sry5yh6hFwbO7goNoNg2p5o0YK2a4m6sQdpiVroOOk=;
        b=XqvLW2+carEHFRGciDKOMNsfd1DfPKbFfVSwHFjcBZCM5546Vs+AuQdEm0lb51RqWV
         Z4psb3gNzXB5dH/RZugURlWdofKT4clwoYyYtX3fjShPVZOGkNpQj7cQvJq1BNkhV0C7
         5WHggiLqG7KbB4LrVbc7eIU0vxYKbbpoBNMXi/Kie7bNAcisqXxQMQyR1QaEF6SRnhoJ
         WPQdKeXynwAzfXwP8OnG4/YKvc8o+JWqDdD96r9nmq3gwDQKgcaVYbq05NO8+gaqzKOF
         ZPgUA1oIRgtdzyBCrstVEJ/5yg0cfInCtlOV1/zJqFyhBx7055f6bfyJkgxe4c4f1at1
         02+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9sry5yh6hFwbO7goNoNg2p5o0YK2a4m6sQdpiVroOOk=;
        b=QQXCdtrOUElEgPPQCEVHM0r+YejSJS5e2RsMQTCWvy1H1HMriDcyT7mQbm82vvIRLD
         I5ZS+vxK8l9tQRmQ3DdmAieQ5fypV4yB9qyonYIcUl9E2809xb48FwsWMIjGkGSIVT8H
         P0/wnGIOPN8GWQCdF84AD9+QooZ4/IDaC+gQgak0ItBT4WeHGiJsQr9VXx8GLz57u4Mn
         90Wo1DpANczz9RWAbhhClkLy+Bbg0rlR+xb2fLHRStevNQlaK7khqCn26kzr2iykcPoY
         7BrqP04d4Qf6CrnVf+p/CXGl9Y96b4JLsI4cNmcnd1g75tWrdqdV34AIjTF77gXCR1kW
         Lamw==
X-Gm-Message-State: AOAM533XvG9kUdHvlZAnbV3kmOJe5LUyJgTEpxma9756AMXSQ7A5tnhP
        vb4LOiPNM/180Ko5VVrsut41BPsJiOkp+cj6S+2Wtg==
X-Google-Smtp-Source: ABdhPJzAUgwtpe5peydzDA4vwVNBPokPkptHdSEzRf4pWSWZ3KM9GZLIPfsy+rm8vOlfwqJORAMoGoSbeKAh6Zjkkfg=
X-Received: by 2002:a0c:fbc6:: with SMTP id n6mr1103638qvp.35.1625162721056;
 Thu, 01 Jul 2021 11:05:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210630003406.4013668-1-paulburton@google.com>
 <CAJWu+ooRQ6hFtaA4tr3BNs9Btss1yan8taua=VMWMopGmEVhSA@mail.gmail.com> <YN38D3dg0fLzL0Ia@google.com>
In-Reply-To: <YN38D3dg0fLzL0Ia@google.com>
From:   Joel Fernandes <joelaf@google.com>
Date:   Thu, 1 Jul 2021 14:05:10 -0400
Message-ID: <CAJWu+oo0Zyt7eARgPr7hKt8WKJSw0GdisM7PJcGXrZ7PpxYJUQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] tracing: Simplify & fix saved_tgids logic
To:     Paul Burton <paulburton@google.com>
Cc:     linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 1, 2021 at 1:32 PM Paul Burton <paulburton@google.com> wrote:
>
> Hi Joel,
>
> On Wed, Jun 30, 2021 at 06:29:55PM -0400, Joel Fernandes wrote:
> > On Tue, Jun 29, 2021 at 8:34 PM Paul Burton <paulburton@google.com> wrote:
> > >
> > > The tgid_map array records a mapping from pid to tgid, where the index
> > > of an entry within the array is the pid & the value stored at that index
> > > is the tgid.
> > >
> > > The saved_tgids_next() function iterates over pointers into the tgid_map
> > > array & dereferences the pointers which results in the tgid, but then it
> > > passes that dereferenced value to trace_find_tgid() which treats it as a
> > > pid & does a further lookup within the tgid_map array. It seems likely
> > > that the intent here was to skip over entries in tgid_map for which the
> > > recorded tgid is zero, but instead we end up skipping over entries for
> > > which the thread group leader hasn't yet had its own tgid recorded in
> > > tgid_map.
> > >
> > > A minimal fix would be to remove the call to trace_find_tgid, turning:
> > >
> > >   if (trace_find_tgid(*ptr))
> > >
> > > into:
> > >
> > >   if (*ptr)
> > >
> > > ..but it seems like this logic can be much simpler if we simply let
> > > seq_read() iterate over the whole tgid_map array & filter out empty
> > > entries by returning SEQ_SKIP from saved_tgids_show(). Here we take that
> > > approach, removing the incorrect logic here entirely.
> >
> > Looks reasonable except for one nit:
> >
> > > Signed-off-by: Paul Burton <paulburton@google.com>
> > > Fixes: d914ba37d714 ("tracing: Add support for recording tgid of tasks")
> > > Cc: Steven Rostedt <rostedt@goodmis.org>
> > > Cc: Ingo Molnar <mingo@redhat.com>
> > > Cc: Joel Fernandes <joelaf@google.com>
> > > Cc: <stable@vger.kernel.org>
> > > ---
> > >  kernel/trace/trace.c | 38 +++++++++++++-------------------------
> > >  1 file changed, 13 insertions(+), 25 deletions(-)
> > >
> > > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > > index d23a09d3eb37b..9570667310bcc 100644
> > > --- a/kernel/trace/trace.c
> > > +++ b/kernel/trace/trace.c
> > > @@ -5608,37 +5608,20 @@ static const struct file_operations tracing_readme_fops = {
> > >
> > >  static void *saved_tgids_next(struct seq_file *m, void *v, loff_t *pos)
> > >  {
> > > -       int *ptr = v;
> > > +       int pid = ++(*pos);
> > >
> > > -       if (*pos || m->count)
> > > -               ptr++;
> > > -
> > > -       (*pos)++;
> > > -
> > > -       for (; ptr <= &tgid_map[PID_MAX_DEFAULT]; ptr++) {
> > > -               if (trace_find_tgid(*ptr))
> > > -                       return ptr;
> >
> > It would be great if you can add back the check for !tgid_map to both
> > next() and show() as well, for added robustness (since the old code
> > previously did it).
>
> That condition cannot happen, because both next() & show() are called to
> iterate through the content of the seq_file & by definition their v
> argument is non-NULL (else seq_file would have finished iterating
> already). That argument came from either start() or an earlier call to
> next(), which would only have returned a non-NULL pointer into tgid_map
> if tgid_map is non-NULL.

Hmm, You do have a point. Alright then. You could add my Reviewed-by
tag for this patch to subsequent postings.

thanks,
-Joel
