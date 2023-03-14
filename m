Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5786BA347
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 00:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbjCNXD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 19:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbjCNXD6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 19:03:58 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3EF11D931
        for <stable@vger.kernel.org>; Tue, 14 Mar 2023 16:03:56 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id e65so8712926ybh.10
        for <stable@vger.kernel.org>; Tue, 14 Mar 2023 16:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google; t=1678835036;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+M/wJAcMOPDypo34VuMZysKjW37fet4aHdhyCFRkO50=;
        b=JFMvFsDkDX4N6+R2NB/BVGGCNkl4a/iQBFHOdlyiVy3dHZ2FRp3IA9rDVkaAWnQejv
         iVWxJy88Q2Gb8ay1tG2EY0O7XnQSjlkjJCNlnXxhTgRPMyp5J4eI5KJb/joS+JO8y8AP
         0bjymXmuvgpndNDI+8R7gAOOY5Yw9XDE4VDwM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678835036;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+M/wJAcMOPDypo34VuMZysKjW37fet4aHdhyCFRkO50=;
        b=IC0ujL2hGOCHIK6YyAjYgFy5khqI/xKPDu6h0YGw02m+N6BSHg0/lz/8YTPzuuAplr
         2VxRkGQLLjEkI9N4J8s83Xg2Qn+DybXMSVFju1ad1W2qD4TgV04fIr2ag3qa7ap3l8io
         l/Zi4jbOhpbs107XePEmVazvKsdDDUqq+kNQ9QlkqaqHtgFACmRTzkdeJQQcNfe0Ay8P
         dUkLuvjfJw3CegV8g8M1bqGahWRKhq0Qb8BtL0DnVbkSw8WFYbfqzCSFERvkn+PwWpks
         fWvaGGFhoAgGbVbipFIQ0cDz7V38Y0/24dsnVIq7LK7HEZRG5pTQ4hygyDELJ/CXYlio
         KX1A==
X-Gm-Message-State: AO0yUKUUfCgFurKQ14j/D8eoH5kn2MHFT0KOE73yz9toFMVVhHEODg5z
        JKkDXCru9dPK/S+QA4zCbLmNrFWcLtngoteJvJWrYg==
X-Google-Smtp-Source: AK7set/EqPgzTvragippGHLnm3Quj4y4xpXczhtAu3Hn0zlNlQh6+GH1BfN+FyjvWPzdYVJXVGr/HIC0rL2KuEiLCNM=
X-Received: by 2002:a5b:6c4:0:b0:b26:d140:5f74 with SMTP id
 r4-20020a5b06c4000000b00b26d1405f74mr10387224ybq.1.1678835035784; Tue, 14 Mar
 2023 16:03:55 -0700 (PDT)
MIME-Version: 1.0
References: <20230314190236.203370742@goodmis.org> <20230314190310.486609095@goodmis.org>
In-Reply-To: <20230314190310.486609095@goodmis.org>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Tue, 14 Mar 2023 19:03:44 -0400
Message-ID: <CAEXW_YRzVhbm2mNc04Fop7cud4kujgjT5sZR1paqkLeeNJvgHA@mail.gmail.com>
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
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 14, 2023 at 3:03=E2=80=AFPM Steven Rostedt <rostedt@goodmis.org=
> wrote:
>
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
>
> A while ago where the trace events had the following:
>
>    rcu_read_lock_sched_notrace();
>    rcu_dereference_sched(...);
>    rcu_read_unlock_sched_notrace();
>
> If the tracepoint is enabled, it could trigger RCU issues if called in
> the wrong place. And this warning was only triggered if lockdep was
> enabled. If the tracepoint was never enabled with lockdep, the bug would
> not be caught. To handle this, the above sequence was done when lockdep
> was enabled regardless if the tracepoint was enabled or not (although the
> always enabled code really didn't do anything, it would still trigger a
> warning).
>
> But a lot has changed since that lockdep code was added. One is, that
> sequence no longer triggers any warning. Another is, the tracepoint when
> enabled doesn't even do that sequence anymore.

I agree with the change but I am confused by the commit message a bit
due to "Another is, the tracepoint when enabled doesn't even do that
sequence anymore.".

Whether the tracepoint was enabled or disabled, it is always doing the
old sequence because we were skipping the tracepoint's static key test
before running the sequence. Right?

So how was it not doing the old sequence before?

Other than that,
Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>

 - Joel


> The main check we care about today is whether RCU is "watching" or not.
> So if lockdep is enabled, always check if rcu_is_watching() which will
> trigger a warning if it is not (tracepoints require RCU to be watching).
>
> Note, that old sequence did add a bit of overhead when lockdep was enable=
d,
> and with the latest kernel updates, would cause the system to slow down
> enough to trigger kernel "stalled" warnings.
>
> Link: http://lore.kernel.org/lkml/20140806181801.GA4605@redhat.com
> Link: http://lore.kernel.org/lkml/20140807175204.C257CAC5@viggo.jf.intel.=
com
> Link: https://lore.kernel.org/lkml/20230307184645.521db5c9@gandalf.local.=
home/
> Link: https://lore.kernel.org/linux-trace-kernel/20230310172856.77406446@=
gandalf.local.home
>
> Cc: stable@vger.kernel.org
> Cc: Masami Hiramatsu <mhiramat@kernel.org>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: "Paul E. McKenney" <paulmck@kernel.org>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Joel Fernandes <joel@joelfernandes.org>
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Fixes: e6753f23d961 ("tracepoint: Make rcuidle tracepoint callers use SRC=
U")
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  include/linux/tracepoint.h | 15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
>
> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index fa1004fcf810..2083f2d2f05b 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -231,12 +231,11 @@ static inline struct tracepoint *tracepoint_ptr_der=
ef(tracepoint_ptr_t *p)
>   * not add unwanted padding between the beginning of the section and the
>   * structure. Force alignment to the same alignment as the section start=
.
>   *
> - * When lockdep is enabled, we make sure to always do the RCU portions o=
f
> - * the tracepoint code, regardless of whether tracing is on. However,
> - * don't check if the condition is false, due to interaction with idle
> - * instrumentation. This lets us find RCU issues triggered with tracepoi=
nts
> - * even when this tracepoint is off. This code has no purpose other than
> - * poking RCU a bit.
> + * When lockdep is enabled, we make sure to always test if RCU is
> + * "watching" regardless if the tracepoint is enabled or not. Tracepoint=
s
> + * require RCU to be active, and it should always warn at the tracepoint
> + * site if it is not watching, as it will need to be active when the
> + * tracepoint is enabled.
>   */
>  #define __DECLARE_TRACE(name, proto, args, cond, data_proto)           \
>         extern int __traceiter_##name(data_proto);                      \
> @@ -249,9 +248,7 @@ static inline struct tracepoint *tracepoint_ptr_deref=
(tracepoint_ptr_t *p)
>                                 TP_ARGS(args),                          \
>                                 TP_CONDITION(cond), 0);                 \
>                 if (IS_ENABLED(CONFIG_LOCKDEP) && (cond)) {             \
> -                       rcu_read_lock_sched_notrace();                  \
> -                       rcu_dereference_sched(__tracepoint_##name.funcs);=
\
> -                       rcu_read_unlock_sched_notrace();                \
> +                       WARN_ON_ONCE(!rcu_is_watching());               \
>                 }                                                       \
>         }                                                               \
>         __DECLARE_TRACE_RCU(name, PARAMS(proto), PARAMS(args),          \
> --
> 2.39.1
