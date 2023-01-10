Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C232F664A54
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239047AbjAJScE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:32:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235385AbjAJSb0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:31:26 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A41384BF5
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:26:38 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id s25so13465878lji.2
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:26:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=umnoYAX8D2Tr68PlIYbZPWDjCMAMX/1KvuLyQtZeqK8=;
        b=jsqv4DOK15Rk14o6RJoHQIf+I8wV5JPFwEOyN3HkV6hcVYU6PH5ZG5I3H5RKC6hQ+6
         jk23DcxEegDUq96itVTOypxgkbghGveZ9+hqVEPvVKzHzECbTMIrPBqnGaBJ3Gu1+7EY
         By5vDoTvy41uWgJplf+l+0r3MwX+yb9vzA1Zw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=umnoYAX8D2Tr68PlIYbZPWDjCMAMX/1KvuLyQtZeqK8=;
        b=pgmMLJ63wc+elY04hK+gY/2sO5FHTfpeWthsv+J8CNwDVeu0WHbH7GhzEw/BVmbTH/
         687lRwlmkOcHM0F9ceaLx0LGGakCJu1gfM53TzpJIkr+IGBx9+7AACuEmEw/uVJr4V3g
         KJcHzhqGY1IrX0mPtwiMSoSx2cTqRRV1anOTB19reX3PnEPT25tl/40WVj4x8ANG56Sb
         YumMLfC8AHinjm0XyLEQKE3BK0jVSP7xkqemcLJ1c8eCJyumsBGQOTkdRps58e4dgMjv
         CDLkLTtV+E8Pzp5DgFCJR8t5N+dLg9UNTonZ1b7TDx2chCU0keGZKKoMPnorNIGliw6n
         6TpA==
X-Gm-Message-State: AFqh2krQVDZLJpamR/bbbjR20sGTIwaVoIUHoqZ3Z6tIPirK4nYDWL9R
        VE1Yc2X1ghanqHtuHrFM3BxdafspABTKAcf1OvTIiw==
X-Google-Smtp-Source: AMrXdXtYN53tGqW+tV4hYqOK9gKGVooKMivQbY8+mErrwYDnvZs612fyy7mOAbc325wj81E4ab8ADcirvi1AYbWkRXc=
X-Received: by 2002:a2e:3c15:0:b0:27f:dca1:8584 with SMTP id
 j21-20020a2e3c15000000b0027fdca18584mr3488840lja.313.1673375196818; Tue, 10
 Jan 2023 10:26:36 -0800 (PST)
MIME-Version: 1.0
References: <20230110180031.620810905@linuxfoundation.org> <20230110180033.597780936@linuxfoundation.org>
In-Reply-To: <20230110180033.597780936@linuxfoundation.org>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Tue, 10 Jan 2023 13:26:25 -0500
Message-ID: <CAEXW_YQhoJkCNaBKRSLh5OCYn1ObA8dy63ZrgmRgpEaVorBnnQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 057/290] rcu-tasks: Simplify trc_read_check_handler()
 atomic operations
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        "Paul E. McKenney" <paulmck@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 10, 2023 at 1:23 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Paul E. McKenney <paulmck@kernel.org>
>
> commit 96017bf9039763a2e02dcc6adaa18592cd73a39d upstream.

Thanks Greg, I had sent the same patch earlier for 5.15. Just so I
learn, anything I did wrong or should have done differently?

 - Joel


>
> Currently, trc_wait_for_one_reader() atomically increments
> the trc_n_readers_need_end counter before sending the IPI
> invoking trc_read_check_handler().  All failure paths out of
> trc_read_check_handler() and also from the smp_call_function_single()
> within trc_wait_for_one_reader() must carefully atomically decrement
> this counter.  This is more complex than it needs to be.
>
> This commit therefore simplifies things and saves a few lines of
> code by dispensing with the atomic decrements in favor of having
> trc_read_check_handler() do the atomic increment only in the success case.
> In theory, this represents no change in functionality.
>
> Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> Cc: Joel Fernandes <joel@joelfernandes.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  kernel/rcu/tasks.h |   20 +++-----------------
>  1 file changed, 3 insertions(+), 17 deletions(-)
>
> --- a/kernel/rcu/tasks.h
> +++ b/kernel/rcu/tasks.h
> @@ -892,32 +892,24 @@ static void trc_read_check_handler(void
>
>         // If the task is no longer running on this CPU, leave.
>         if (unlikely(texp != t)) {
> -               if (WARN_ON_ONCE(atomic_dec_and_test(&trc_n_readers_need_end)))
> -                       wake_up(&trc_wait);
>                 goto reset_ipi; // Already on holdout list, so will check later.
>         }
>
>         // If the task is not in a read-side critical section, and
>         // if this is the last reader, awaken the grace-period kthread.
>         if (likely(!READ_ONCE(t->trc_reader_nesting))) {
> -               if (WARN_ON_ONCE(atomic_dec_and_test(&trc_n_readers_need_end)))
> -                       wake_up(&trc_wait);
> -               // Mark as checked after decrement to avoid false
> -               // positives on the above WARN_ON_ONCE().
>                 WRITE_ONCE(t->trc_reader_checked, true);
>                 goto reset_ipi;
>         }
>         // If we are racing with an rcu_read_unlock_trace(), try again later.
> -       if (unlikely(READ_ONCE(t->trc_reader_nesting) < 0)) {
> -               if (WARN_ON_ONCE(atomic_dec_and_test(&trc_n_readers_need_end)))
> -                       wake_up(&trc_wait);
> +       if (unlikely(READ_ONCE(t->trc_reader_nesting) < 0))
>                 goto reset_ipi;
> -       }
>         WRITE_ONCE(t->trc_reader_checked, true);
>
>         // Get here if the task is in a read-side critical section.  Set
>         // its state so that it will awaken the grace-period kthread upon
>         // exit from that critical section.
> +       atomic_inc(&trc_n_readers_need_end); // One more to wait on.
>         WARN_ON_ONCE(READ_ONCE(t->trc_reader_special.b.need_qs));
>         WRITE_ONCE(t->trc_reader_special.b.need_qs, true);
>
> @@ -1017,21 +1009,15 @@ static void trc_wait_for_one_reader(stru
>                 if (per_cpu(trc_ipi_to_cpu, cpu) || t->trc_ipi_to_cpu >= 0)
>                         return;
>
> -               atomic_inc(&trc_n_readers_need_end);
>                 per_cpu(trc_ipi_to_cpu, cpu) = true;
>                 t->trc_ipi_to_cpu = cpu;
>                 rcu_tasks_trace.n_ipis++;
> -               if (smp_call_function_single(cpu,
> -                                            trc_read_check_handler, t, 0)) {
> +               if (smp_call_function_single(cpu, trc_read_check_handler, t, 0)) {
>                         // Just in case there is some other reason for
>                         // failure than the target CPU being offline.
>                         rcu_tasks_trace.n_ipis_fails++;
>                         per_cpu(trc_ipi_to_cpu, cpu) = false;
>                         t->trc_ipi_to_cpu = cpu;
> -                       if (atomic_dec_and_test(&trc_n_readers_need_end)) {
> -                               WARN_ON_ONCE(1);
> -                               wake_up(&trc_wait);
> -                       }
>                 }
>         }
>  }
>
>
