Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2DCF57E7FF
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 22:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236830AbiGVUJT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 16:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236788AbiGVUI5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 16:08:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 12A53AF733
        for <stable@vger.kernel.org>; Fri, 22 Jul 2022 13:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658520534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9a81zK1rXqyZqW0NexaO3ZE6gbfBHT1L7oOMOxkQ2f4=;
        b=IQS/JUl1uusSgyUoZx49lyqZ5PFxHteVmbNRlSlYFiVHt1l/x3eDeU9jpzdTurhmvgKW+D
        Pp3PndhpyNi2MROUykhwYJX3WAArIscJ9Zx8bbOXeDX3AGPgdKoxnMrDthti6xvuZujg9k
        IEaxbpVPIdXSl5yHmQxnCoyA9dMEypo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-377-qwIATS50PMCNbyLUGxvrpA-1; Fri, 22 Jul 2022 16:08:52 -0400
X-MC-Unique: qwIATS50PMCNbyLUGxvrpA-1
Received: by mail-wm1-f72.google.com with SMTP id c126-20020a1c3584000000b003a02fa133ceso2967891wma.2
        for <stable@vger.kernel.org>; Fri, 22 Jul 2022 13:08:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=9a81zK1rXqyZqW0NexaO3ZE6gbfBHT1L7oOMOxkQ2f4=;
        b=Tw8GylGKcTrTsZ6MTB3A+5rl2G861r1M9fiMOjIsi9VYnvKOPaYjNoZYmVPituhCfi
         +cw0+o6eEMrFyaACRnIXlKMRwyqQksK9wwo8rvCfYisiz+Zo5ZoZvaWTekq6JSCn+iq1
         bJl7ztXBuG3djClFOMkUzqSGPKjrMdgmu00YZRwGZCEvgYrT0Xf4GCf4v61+xPJ/aN7/
         S1hvd7Ngc+dIgXb23b4XaMvxmf8hi00X64RMwxvA3v45nTjVF/ZyPbWTodhJ6uU4CCxn
         0PZxXPYGpkLmE/mLfp6yIoffN0h7g4laf5O76BTvH/73fS1kKe/Xmi0Hz05JMpLhR44n
         6SNg==
X-Gm-Message-State: AJIora+lFDPe/Z+JmCQ+D2a3/UFIkf00998wKCVAZeePjJh07SIRLwC2
        kZ3BmaKMYvB8gXIaZOqwHZ9jtL9TEUMpqJBbHZ0gDh8WrJmCdLbCmktIDrwaGqdny/H99L0do9/
        UL1cOOypj7cDzSdKb
X-Received: by 2002:a7b:c8d3:0:b0:3a2:fe0d:ba2e with SMTP id f19-20020a7bc8d3000000b003a2fe0dba2emr13994332wml.115.1658520531780;
        Fri, 22 Jul 2022 13:08:51 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sQRY/qa4aHPYDods+ZCnZ3soQnYNBNfi4qRBz8v8FDMPquyo1CIoSCjj68nw4yGhy/3aDsBw==
X-Received: by 2002:a7b:c8d3:0:b0:3a2:fe0d:ba2e with SMTP id f19-20020a7bc8d3000000b003a2fe0dba2emr13994318wml.115.1658520531447;
        Fri, 22 Jul 2022 13:08:51 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id p20-20020a1c5454000000b003a30c3d0c9csm10115170wmi.8.2022.07.22.13.08.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 13:08:50 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-wireless@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Kalle Valo <kvalo@kernel.org>,
        Rui Salvaterra <rsalvaterra@gmail.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        stable@vger.kernel.org, Gregory Erwin <gregerwin256@gmail.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v10] ath9k: let sleep be interrupted when unregistering
 hwrng
In-Reply-To: <20220719201108.264322-1-Jason@zx2c4.com>
References: <CAHmME9qrd25vfRYYvCWtPg+wVC5joEzzJiihCN+L4rqMfTL4Rg@mail.gmail.com>
 <20220719201108.264322-1-Jason@zx2c4.com>
Date:   Fri, 22 Jul 2022 21:08:49 +0100
Message-ID: <xhsmhfsisgbam.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 19/07/22 22:11, Jason A. Donenfeld wrote:

> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index c46f3a63b758..f164098fb614 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1936,6 +1936,7 @@ extern struct task_struct *find_get_task_by_vpid(pid_t nr);
>
>  extern int wake_up_state(struct task_struct *tsk, unsigned int state);
>  extern int wake_up_process(struct task_struct *tsk);
> +extern int wake_up_task_interruptible(struct task_struct *tsk);
>  extern void wake_up_new_task(struct task_struct *tsk);
>
>  #ifdef CONFIG_SMP
> diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
> index cafbe03eed01..56a15f35e7b3 100644
> --- a/include/linux/sched/signal.h
> +++ b/include/linux/sched/signal.h
> @@ -364,7 +364,7 @@ static inline void clear_notify_signal(void)
>  static inline bool __set_notify_signal(struct task_struct *task)
>  {
>       return !test_and_set_tsk_thread_flag(task, TIF_NOTIFY_SIGNAL) &&
> -	       !wake_up_state(task, TASK_INTERRUPTIBLE);
> +	       !wake_up_task_interruptible(task);
>  }
>
>  /*
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index da0bf6fe9ecd..b178940185d7 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4280,6 +4280,12 @@ int wake_up_process(struct task_struct *p)
>  }
>  EXPORT_SYMBOL(wake_up_process);
>
> +int wake_up_task_interruptible(struct task_struct *p)
> +{
> +	return try_to_wake_up(p, TASK_INTERRUPTIBLE, 0);
> +}
> +EXPORT_SYMBOL_GPL(wake_up_task_interruptible);
> +
>  int wake_up_state(struct task_struct *p, unsigned int state)
>  {
>       return try_to_wake_up(p, state, 0);
> --
> 2.35.1


The sched changes are unfortunate, as I had understood it the alternative
would be fixing all sleeping hwrng's to make them have a proper wait
pattern that doesn't require being sent a signal to avoid missing events,
i.e. instead of 

  hwrng->read():                               devm_hwrng_unregister():
    schedule_timeout_interruptible(x);           set_notify_signal(waiting_reader);

do

  hwrng->read():                               devm_hwrng_unregister():
    set_current_state(TASK_INTERRUPTIBLE)        rng->dying = true;
    if (!rng->dying)                             wake_up_process(waiting_reader);
        schedule_timeout(x);

I had initially convinced myself this would be somewhat involved, but
writing the above I thought maybe not... The below is applied on top of
your v10, would you be able to test whether it actually works?

I apologize for telling you to do one thing and then suggesting something else...

IMO set_notify_signal() is for interrupting tasks that are in a wait-loop
that has nothing to do with the calling code (e.g. task_work, I assume
livepatching does that for the same reason), but here it's hwrng core code
interrupting a sleeping hwrng device.

It does however mean patching up any sleeping hwrng (a quick search tells
me there are more, e.g. npcm-rng does readb_poll_timeout())

---

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index df45c265878e..40a73490bfdc 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -522,9 +522,12 @@ static int hwrng_fillfn(void *unused)
 			break;
 
 		if (rc <= 0) {
-			if (kthread_should_stop())
+			set_current_state(TASK_INTERRUPTIBLE);
+			if (kthread_should_stop()) {
+				__set_current_state(TASK_RUNNING);
 				break;
-			schedule_timeout_interruptible(HZ * 10);
+			}
+			schedule_timeout(HZ * 10);
 			continue;
 		}
 
@@ -581,6 +584,8 @@ int hwrng_register(struct hwrng *rng)
 	init_completion(&rng->cleanup_done);
 	complete(&rng->cleanup_done);
 
+	rng->unregistering = false;
+
 	if (!current_rng ||
 	    (!cur_rng_set_by_user && rng->quality > current_rng->quality)) {
 		/*
@@ -630,8 +635,10 @@ void hwrng_unregister(struct hwrng *rng)
 
 	rcu_read_lock();
 	waiting_reader = xchg(&current_waiting_reader, UNREGISTERING_READER);
-	if (waiting_reader && waiting_reader != UNREGISTERING_READER)
-		set_notify_signal(waiting_reader);
+	if (waiting_reader && waiting_reader != UNREGISTERING_READER) {
+		rng->unregistering = true;
+		wake_up_process(waiting_reader);
+	}
 	rcu_read_unlock();
 	old_rng = current_rng;
 	list_del(&rng->list);
diff --git a/drivers/net/wireless/ath/ath9k/rng.c b/drivers/net/wireless/ath/ath9k/rng.c
index 8980dc36509e..35cac38054b5 100644
--- a/drivers/net/wireless/ath/ath9k/rng.c
+++ b/drivers/net/wireless/ath/ath9k/rng.c
@@ -75,9 +75,17 @@ static int ath9k_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 			bytes_read += max & 3UL;
 			memzero_explicit(&word, sizeof(word));
 		}
-		if (!wait || !max || likely(bytes_read) || fail_stats > 110 ||
-		    ((current->flags & PF_KTHREAD) && kthread_should_stop()) ||
-		    schedule_timeout_interruptible(ath9k_rng_delay_get(++fail_stats)))
+		if (!wait || !max || likely(bytes_read) || fail_stats > 110)
+			break;
+
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (rng->unregistering ||
+		    ((current->flags & PF_KTHREAD) && kthread_should_stop())) {
+			__set_current_state(TASK_RUNNING);
+			break;
+		}
+
+		if (schedule_timeout(ath9k_rng_delay_get(++fail_stats)))
 			break;
 	}
 
diff --git a/include/linux/hw_random.h b/include/linux/hw_random.h
index aa1d4da03538..778f10dfa12b 100644
--- a/include/linux/hw_random.h
+++ b/include/linux/hw_random.h
@@ -45,6 +45,7 @@ struct hwrng {
 	int (*read)(struct hwrng *rng, void *data, size_t max, bool wait);
 	unsigned long priv;
 	unsigned short quality;
+	int unregistering;
 
 	/* internal. */
 	struct list_head list;
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 56a15f35e7b3..9b94a8f18b04 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -364,7 +364,7 @@ static inline void clear_notify_signal(void)
 static inline bool __set_notify_signal(struct task_struct *task)
 {
 	return !test_and_set_tsk_thread_flag(task, TIF_NOTIFY_SIGNAL) &&
-	       !wake_up_task_interruptible(task);
+		!wake_up_state(task, TASK_INTERRUPTIBLE);
 }
 
 /*
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e3e675eef63d..a463dbc92fcd 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4279,12 +4279,6 @@ int wake_up_process(struct task_struct *p)
 }
 EXPORT_SYMBOL(wake_up_process);
 
-int wake_up_task_interruptible(struct task_struct *p)
-{
-	return try_to_wake_up(p, TASK_INTERRUPTIBLE, 0);
-}
-EXPORT_SYMBOL_GPL(wake_up_task_interruptible);
-
 int wake_up_state(struct task_struct *p, unsigned int state)
 {
 	return try_to_wake_up(p, state, 0);

