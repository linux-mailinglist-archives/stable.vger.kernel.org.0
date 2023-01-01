Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85EA265AA0C
	for <lists+stable@lfdr.de>; Sun,  1 Jan 2023 14:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbjAANCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Jan 2023 08:02:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjAANCp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Jan 2023 08:02:45 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC7FE1E5;
        Sun,  1 Jan 2023 05:02:44 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id o1-20020a17090a678100b00219cf69e5f0so30283307pjj.2;
        Sun, 01 Jan 2023 05:02:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=o5DKSRtYYoBVcOhHWl5VP1x3jhe6l3NBa32LdFJWJag=;
        b=aDJnIECZVGpr+fOqasEjbRxOjV7WznfcNROS1eKBguzxeagrBLsf76ZivPRbs1ZMZA
         jSnyv55NSR9mNPWFwxjAuvHjN4qFC4ly4kl9JwWkEHwzA2k/HYktxBu0jqdP1sLTFj5J
         AS+c2xhTjsfae54t1nNhh0E7bsg1n6l6b1o94qU1lEXJTs6BIYxZuWvKtjSBhyqHpNJT
         SwQgtrtw2lYfeYMv2AcbNEcwIModcOlBvlKfReGUPxQUyxcGnFwbQd1sjmZ3lbHpI5dJ
         KzkgotZ/YpFQ677/Xg9PYwUD/OnALrgCYptShpUYqNcsOl1apgBM5F81Hx+E/Q84ZSDl
         jluQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o5DKSRtYYoBVcOhHWl5VP1x3jhe6l3NBa32LdFJWJag=;
        b=XEWHvPwSwA+JHEchq7XTCMJrLR2sZ+pK5ZNIduN7SbdkNWxgJEmxJZfRfizKqT3V6z
         +19dsIVvxqCqG75zJXOECN/tN917vvuAAgIs8Tlks8BX6mXar5faZUtE0SBH4KJfKWIA
         ht6hU3cj9Ad1wH5Mfk825noiwgyypYBFsfW33hi53PjDwv1xOjbKMZe/rUa2HSTFA5qW
         HAeMAxDUr57qv3r8Kh0Sv7O/huLE7lAQs8+VG7E3zfs83kPTTAyUmlvSXub3w5UtcqXu
         VMyFWFsDDiudRXJt8Uup2R29idDmoGqmOh4rch42LG9V2dA9M8ayoMCwBFcQxnhd6LMA
         i7IA==
X-Gm-Message-State: AFqh2kraKft6VAzmC8ERs3+c0jBKhfi1jCl6nIMoPquWkEbeuQX5LUH5
        Ye3St8CqLHKtDH5rTqKMF8/hCcWTB9uLreKe8uqg2oQvsCMLqg==
X-Google-Smtp-Source: AMrXdXsaarcadnpX0fAXMjWTOlNJ8Xsr8M0m34s9ZOn+lU+evQCuYay8F1Lyj9aSjdHzEDeMPc8msLfcCk49F0cBwww=
X-Received: by 2002:a17:90a:9f42:b0:219:5f5a:7192 with SMTP id
 q2-20020a17090a9f4200b002195f5a7192mr2737064pjv.144.1672578164344; Sun, 01
 Jan 2023 05:02:44 -0800 (PST)
MIME-Version: 1.0
References: <20230101061555.278129-1-joel@joelfernandes.org>
In-Reply-To: <20230101061555.278129-1-joel@joelfernandes.org>
From:   Zhouyi Zhou <zhouzhouyi@gmail.com>
Date:   Sun, 1 Jan 2023 21:02:33 +0800
Message-ID: <CAABZP2wSoEzfMWRdxGb6TmWVeN4xDUu5qjnG0d8RfaO7AovGZQ@mail.gmail.com>
Subject: Re: [PATCH] torture: Fix hang during kthread shutdown phase
To:     "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc:     linux-kernel@vger.kernel.org, Paul McKenney <paulmck@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        stable@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>,
        Josh Triplett <josh@joshtriplett.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NORMAL_HTTP_TO_IP,
        NUMERIC_HTTP_ADDR,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 1, 2023 at 2:16 PM Joel Fernandes (Google)
<joel@joelfernandes.org> wrote:
>
> During shutdown of rcutorture, the shutdown thread in
> rcu_torture_cleanup() calls torture_cleanup_begin() which sets fullstop
> to FULLSTOP_RMMOD. This is enough to cause the rcutorture threads for
> readers and fakewriters to breakout of their main while loop and start
> shutting down.
>
> Once out of their main loop, they then call torture_kthread_stopping()
> which in turn waits for kthread_stop() to be called, however
> rcu_torture_cleanup() has not even called kthread_stop() on those
> threads yet, it does that a bit later.  However, before it gets a chance
> to do so, torture_kthread_stopping() calls
> schedule_timeout_interruptible(1) in a tight loop. Tracing confirmed
> this makes the timer softirq constantly execute timer callbacks, while
> never returning back to the softirq exit path and is essentially "locked
> up" because of that. If the softirq preempts the shutdown thread,
> kthread_stop() may never be called.
>
> This commit improves the situation dramatically, by increasing timeout
> passed to schedule_timeout_interruptible() 1/20th of a second. This
> causes the timer softirq to not lock up a CPU and everything works fine.
> Testing has shown 100 runs of TREE07 passing reliably, which was not the
> case before because of RCU stalls.
On my Dell PowerEdge R720 with two Intel(R) Xeon(R) CPU E5-2660 128G memory:
1) before this patch:
3 of 80 rounds failed with "rcu: INFO: rcu_sched detected stalls on
CPUs/tasks" [1]
2) after this patch
all 80 rounds passed

Tested-by: Zhouyi Zhou <zhouzhouyi@gmail.com>

Thanks
Zhouyi

[1] http://154.220.3.115/logs/20230101/console.log
>
> Cc: Paul McKenney <paulmck@kernel.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Zhouyi Zhou <zhouzhouyi@gmail.com>
> Cc: <stable@vger.kernel.org> # 6.0.x
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> ---
>  kernel/torture.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/torture.c b/kernel/torture.c
> index 29afc62f2bfe..d024f3b7181f 100644
> --- a/kernel/torture.c
> +++ b/kernel/torture.c
> @@ -915,7 +915,7 @@ void torture_kthread_stopping(char *title)
>         VERBOSE_TOROUT_STRING(buf);
>         while (!kthread_should_stop()) {
>                 torture_shutdown_absorb(title);
> -               schedule_timeout_uninterruptible(1);
> +               schedule_timeout_uninterruptible(HZ/20);
>         }
>  }
>  EXPORT_SYMBOL_GPL(torture_kthread_stopping);
> --
> 2.39.0.314.g84b9a713c41-goog
>
