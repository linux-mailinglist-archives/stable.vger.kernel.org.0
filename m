Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A418D6BA356
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 00:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbjCNXHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 19:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbjCNXHy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 19:07:54 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E539D360A3
        for <stable@vger.kernel.org>; Tue, 14 Mar 2023 16:07:52 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id j7so6622090ybg.4
        for <stable@vger.kernel.org>; Tue, 14 Mar 2023 16:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google; t=1678835272;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d+0qOiCrrtnzpEUqVtaCFakO5fXS/poOQvsYo+FCHmA=;
        b=WO6LjRsaXmY9Mv/QJfbCuUr3Aamf85UqstL5DJBoKnXtPj42haARaUWmYDICn2PuTB
         YI2Ko8kzoHOEYkTJ7Y1bfyDP1bJzOd7NzTSG8hc22ugCuIeDtJeALrQoCYbMLs/ol/t3
         GBGhKRBtlEnT2KgRq8u7BlKOWKS1MyD3z9YTs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678835272;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d+0qOiCrrtnzpEUqVtaCFakO5fXS/poOQvsYo+FCHmA=;
        b=5T7wzI6MfT3Fg/ieq4Q1hbL9EYxRWtWFl7TsgOmb9/4An0h7mtSeW76A2QZ0gNSHI5
         +WwD+9sC09CNA65jBiEk7PE9d3ZoNfzT6B+5dHZ8FvZGbjg8bfZxERZPnz4ooI+bvEnf
         kuDbWmOU4DYKIsT0vDlcLYHpxyrfcUWjXfQEeOG8qGEqva9dRsPRceSAqPOVNep6ahJ/
         WrtBa9F9zBh5HmKU9eM358euhdLIyxCGzOB1jGzqeq2LAvVCq4KBMeGsEKTDqdIlvuPA
         hCQIdkPiTuDKL4U2X+hMZQ8xDMl0lNEHUi87DwKhH0lBVmDKMJo9Dv0cW31bUtEE3aD2
         Hqiw==
X-Gm-Message-State: AO0yUKVs8NfNRqZMqbGOVMV/fc5O6ON+XHmWjsVQZGQ6Hadl51sE70uv
        6LG7mJjJ7KDvszCmv0LJxKPT5cRtDYHNJ+2BB0BLRjVzHjbSVEiQ
X-Google-Smtp-Source: AK7set+X/LpQwH8KN2IMQfrBAo+d6z4hLAotEpM2muvUjSzQfHpzDSOWwmb7QWLYwbIRJx5TgCaJf0KKb9xBxjtTjsg=
X-Received: by 2002:a25:8f82:0:b0:b39:be7e:30c8 with SMTP id
 u2-20020a258f82000000b00b39be7e30c8mr5617003ybl.2.1678835272044; Tue, 14 Mar
 2023 16:07:52 -0700 (PDT)
MIME-Version: 1.0
References: <20230314190236.203370742@goodmis.org> <20230314190310.486609095@goodmis.org>
 <CAEXW_YRzVhbm2mNc04Fop7cud4kujgjT5sZR1paqkLeeNJvgHA@mail.gmail.com>
In-Reply-To: <CAEXW_YRzVhbm2mNc04Fop7cud4kujgjT5sZR1paqkLeeNJvgHA@mail.gmail.com>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Tue, 14 Mar 2023 19:07:41 -0400
Message-ID: <CAEXW_YTjkaYKo6OP_=82bh6kfgW0ROE2tF+fd7eOrZGhdzh+vg@mail.gmail.com>
Subject: Re: [for-linus][PATCH 5/5] tracing: Make tracepoint lockdep check
 actually test something
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 14, 2023 at 7:03=E2=80=AFPM Joel Fernandes <joel@joelfernandes.=
org> wrote:
>
> On Tue, Mar 14, 2023 at 3:03=E2=80=AFPM Steven Rostedt <rostedt@goodmis.o=
rg> wrote:
> >
> > From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> >
> > A while ago where the trace events had the following:
> >
> >    rcu_read_lock_sched_notrace();
> >    rcu_dereference_sched(...);
> >    rcu_read_unlock_sched_notrace();
> >
> > If the tracepoint is enabled, it could trigger RCU issues if called in
> > the wrong place. And this warning was only triggered if lockdep was
> > enabled. If the tracepoint was never enabled with lockdep, the bug woul=
d
> > not be caught. To handle this, the above sequence was done when lockdep
> > was enabled regardless if the tracepoint was enabled or not (although t=
he
> > always enabled code really didn't do anything, it would still trigger a
> > warning).
> >
> > But a lot has changed since that lockdep code was added. One is, that
> > sequence no longer triggers any warning. Another is, the tracepoint whe=
n
> > enabled doesn't even do that sequence anymore.
>
> I agree with the change but I am confused by the commit message a bit
> due to "Another is, the tracepoint when enabled doesn't even do that
> sequence anymore.".
>
> Whether the tracepoint was enabled or disabled, it is always doing the
> old sequence because we were skipping the tracepoint's static key test
> before running the sequence. Right?
>
> So how was it not doing the old sequence before?

Ah I see, you meant "It was doing a dummy de-ref", not that "it was
_not_ doing anything". ;-)

So it is good then, but perhaps (optionally) call the code as a dummy
RCU deref which was supposed to trigger a warning. ;-)

 - Joel


>
> Other than that,
> Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
>
>  - Joel
>
>
> > The main check we care about today is whether RCU is "watching" or not.
> > So if lockdep is enabled, always check if rcu_is_watching() which will
> > trigger a warning if it is not (tracepoints require RCU to be watching)=
.
> >
> > Note, that old sequence did add a bit of overhead when lockdep was enab=
led,
> > and with the latest kernel updates, would cause the system to slow down
> > enough to trigger kernel "stalled" warnings.
> >
> > Link: http://lore.kernel.org/lkml/20140806181801.GA4605@redhat.com
> > Link: http://lore.kernel.org/lkml/20140807175204.C257CAC5@viggo.jf.inte=
l.com
> > Link: https://lore.kernel.org/lkml/20230307184645.521db5c9@gandalf.loca=
l.home/
> > Link: https://lore.kernel.org/linux-trace-kernel/20230310172856.7740644=
6@gandalf.local.home
> >
> > Cc: stable@vger.kernel.org
> > Cc: Masami Hiramatsu <mhiramat@kernel.org>
> > Cc: Dave Hansen <dave.hansen@linux.intel.com>
> > Cc: "Paul E. McKenney" <paulmck@kernel.org>
> > Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > Cc: Joel Fernandes <joel@joelfernandes.org>
> > Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > Fixes: e6753f23d961 ("tracepoint: Make rcuidle tracepoint callers use S=
RCU")
> > Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> > ---
> >  include/linux/tracepoint.h | 15 ++++++---------
> >  1 file changed, 6 insertions(+), 9 deletions(-)
> >
> > diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> > index fa1004fcf810..2083f2d2f05b 100644
> > --- a/include/linux/tracepoint.h
> > +++ b/include/linux/tracepoint.h
> > @@ -231,12 +231,11 @@ static inline struct tracepoint *tracepoint_ptr_d=
eref(tracepoint_ptr_t *p)
> >   * not add unwanted padding between the beginning of the section and t=
he
> >   * structure. Force alignment to the same alignment as the section sta=
rt.
> >   *
> > - * When lockdep is enabled, we make sure to always do the RCU portions=
 of
> > - * the tracepoint code, regardless of whether tracing is on. However,
> > - * don't check if the condition is false, due to interaction with idle
> > - * instrumentation. This lets us find RCU issues triggered with tracep=
oints
> > - * even when this tracepoint is off. This code has no purpose other th=
an
> > - * poking RCU a bit.
> > + * When lockdep is enabled, we make sure to always test if RCU is
> > + * "watching" regardless if the tracepoint is enabled or not. Tracepoi=
nts
> > + * require RCU to be active, and it should always warn at the tracepoi=
nt
> > + * site if it is not watching, as it will need to be active when the
> > + * tracepoint is enabled.
> >   */
> >  #define __DECLARE_TRACE(name, proto, args, cond, data_proto)          =
 \
> >         extern int __traceiter_##name(data_proto);                     =
 \
> > @@ -249,9 +248,7 @@ static inline struct tracepoint *tracepoint_ptr_der=
ef(tracepoint_ptr_t *p)
> >                                 TP_ARGS(args),                         =
 \
> >                                 TP_CONDITION(cond), 0);                =
 \
> >                 if (IS_ENABLED(CONFIG_LOCKDEP) && (cond)) {            =
 \
> > -                       rcu_read_lock_sched_notrace();                 =
 \
> > -                       rcu_dereference_sched(__tracepoint_##name.funcs=
);\
> > -                       rcu_read_unlock_sched_notrace();               =
 \
> > +                       WARN_ON_ONCE(!rcu_is_watching());              =
 \
> >                 }                                                      =
 \
> >         }                                                              =
 \
> >         __DECLARE_TRACE_RCU(name, PARAMS(proto), PARAMS(args),         =
 \
> > --
> > 2.39.1
