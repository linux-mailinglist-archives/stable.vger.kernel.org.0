Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4FF4936D2
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 10:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352352AbiASJIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 04:08:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237075AbiASJIj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 04:08:39 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93883C061574
        for <stable@vger.kernel.org>; Wed, 19 Jan 2022 01:08:38 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id bu18so6687730lfb.5
        for <stable@vger.kernel.org>; Wed, 19 Jan 2022 01:08:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yk6ZU06f8iQAnFUq/Y5YZD/opTVQaQ5S7MbGVdU6/a8=;
        b=J7oQTI/b0sE2aAgFehOjzBf85bwowWQizUpHYHenltV5UItibFerb9OxPzIrQYk7lD
         XNpsqCV/x96//VVlmOubcFo7fnT6bFRXM057B3eTI2TjbK+/fkB9Ulj+0wTSiWpajgmX
         sBgPYUCQBkhUQqTGLjpBi3b/T5s7fda1qNAOz0g/tlB+TJnRxQXNNYyGvEZdOIffPTfw
         WlsjYDhG515tCD4kWKdp1VpBZPIXvyibzgC63qw5PZi3LAXiFqRIO8xjn/vy8YfQ/urU
         LQ6biKJujGkPHvJETu2sk7mqJpYuMZb45P1QQqJP6CJYk2yJY/ExBLWdITtgX7VSRSgt
         tV3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yk6ZU06f8iQAnFUq/Y5YZD/opTVQaQ5S7MbGVdU6/a8=;
        b=Lt6/RDGqThVjdfkUlhMkFICF1/ZwiUK9DsFR5rwo9uR06L/Wia3NH2q0BzmJhTSCM7
         6rrZBzBIFy5MkJ4BJoVaxGBhnZ3mUa/JzeJdDqKqrpXOX363QZGlMgZ0KAMOkXQxhVhr
         BJrClaFPCTOWUtDLOneD5TrPNcNAlUk90Y93xy376Q/d2XAO0CQpn7GPFBjOyA6yxTBp
         6mbMxJepXJmPGl/Bp8idsUyT10O0IZAXzlN177Qwd7LjVEb7CwS9M72lAspQyERC3Abe
         z/1Ff74gvK+plFUWhnBcMT6X5bkjw4eaIA4kIVyFT43xEUscwAOp06y7f08P3AuIYgNm
         a0mQ==
X-Gm-Message-State: AOAM530+oIWKlkozwjIJT6FR8qYgpp80UgWj7l5RNCwQgjv1lTOewvMQ
        c+5g4ZZVA9d9mCUceUWuLs+0rsyO1k7Jh5quANrvdA==
X-Google-Smtp-Source: ABdhPJzojTYk1yjHC3AoabmS/fVnihuhK7j6tVcTY3t1b2Hv+mtzWQcHdYSOP0rTvdO+DWYyvY8n3/d0kAanMWYWwI0=
X-Received: by 2002:a2e:908e:: with SMTP id l14mr13581522ljg.266.1642583316905;
 Wed, 19 Jan 2022 01:08:36 -0800 (PST)
MIME-Version: 1.0
References: <20220119012417.299060-1-tadeusz.struk@linaro.org>
In-Reply-To: <20220119012417.299060-1-tadeusz.struk@linaro.org>
From:   Vincent Guittot <vincent.guittot@linaro.org>
Date:   Wed, 19 Jan 2022 10:08:25 +0100
Message-ID: <CAKfTPtAxz4T++_1ZrqRFzdLo-r6CsF9iUECcpeghWwDHjeUhrQ@mail.gmail.com>
Subject: Re: [PATCH] sched/fair: Fix fault in reweight_entity
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     mingo@redhat.com, Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Zhang Qiao <zhangqiao22@huawei.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 19 Jan 2022 at 02:24, Tadeusz Struk <tadeusz.struk@linaro.org> wrote:
>
> Syzbot found a GPF in reweight_entity. This has been bisected to commit
> c85c6fadbef0 ("kernel/sched: Fix sched_fork() access an invalid sched_task_group")
> Looks like after this change there is a time window, when
> task_struct->se.cfs_rq can be NULL. This can be exploited to trigger
> null-ptr-deref by calling setpriority on that task.
>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Juri Lelli <juri.lelli@redhat.com>
> Cc: Vincent Guittot <vincent.guittot@linaro.org>
> Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ben Segall <bsegall@google.com>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Daniel Bristot de Oliveira <bristot@redhat.com>
> Cc: Zhang Qiao <zhangqiao22@huawei.com>
> Cc: stable@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
>
> Link: https://syzkaller.appspot.com/bug?id=9d9c27adc674e3a7932b22b61c79a02da82cbdc1
> Fixes: c85c6fadbef0 ("kernel/sched: Fix sched_fork() access an invalid sched_task_group")

The sha1 doesn't look correct.

> Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
> ---
>  kernel/sched/fair.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 095b0aa378df..196f8cee3f9b 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3042,6 +3042,9 @@ dequeue_load_avg(struct cfs_rq *cfs_rq, struct sched_entity *se) { }
>  static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
>                             unsigned long weight)
>  {
> +       if (!cfs_rq)
> +               return;
> +
>         if (se->on_rq) {
>                 /* commit outstanding execution time */
>                 if (cfs_rq->curr == se)
> --
> 2.34.1
>
