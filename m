Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C159457A735
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 21:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237590AbiGST0J convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 19 Jul 2022 15:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232214AbiGST0J (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 15:26:09 -0400
Received: from out03.mta.xmission.com (out03.mta.xmission.com [166.70.13.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A791E13FAF;
        Tue, 19 Jul 2022 12:26:07 -0700 (PDT)
Received: from in02.mta.xmission.com ([166.70.13.52]:59664)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oDsr7-00H1eU-N9; Tue, 19 Jul 2022 13:26:05 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:52288 helo=email.froward.int.ebiederm.org.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oDsr6-00HRN0-ED; Tue, 19 Jul 2022 13:26:05 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-wireless@vger.kernel.org, Kalle Valo <kvalo@kernel.org>,
        Rui Salvaterra <rsalvaterra@gmail.com>,
        Valentin Schneider <vschneid@redhat.com>,
        stable@vger.kernel.org, Gregory Erwin <gregerwin256@gmail.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Herbert Xu <herbert@gondor.apana.org.au>
References: <YtboFNL+YsHxTHrN@zx2c4.com>
        <20220719173354.232365-1-Jason@zx2c4.com>
Date:   Tue, 19 Jul 2022 14:25:38 -0500
In-Reply-To: <20220719173354.232365-1-Jason@zx2c4.com> (Jason A. Donenfeld's
        message of "Tue, 19 Jul 2022 19:33:54 +0200")
Message-ID: <878rooucp9.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=1oDsr6-00HRN0-ED;;;mid=<878rooucp9.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX19cEJZfGT+suJokgmot7sU1yulaFlxom1w=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa08 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;"Jason A. Donenfeld" <Jason@zx2c4.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 725 ms - load_scoreonly_sql: 0.06 (0.0%),
        signal_user_changed: 15 (2.1%), b_tie_ro: 13 (1.7%), parse: 1.97
        (0.3%), extract_message_metadata: 30 (4.2%), get_uri_detail_list: 6
        (0.8%), tests_pri_-1000: 36 (5.0%), tests_pri_-950: 1.43 (0.2%),
        tests_pri_-900: 1.19 (0.2%), tests_pri_-90: 159 (21.9%), check_bayes:
        149 (20.6%), b_tokenize: 16 (2.2%), b_tok_get_all: 18 (2.5%),
        b_comp_prob: 6 (0.8%), b_tok_touch_all: 103 (14.2%), b_finish: 1.61
        (0.2%), tests_pri_0: 464 (63.9%), check_dkim_signature: 0.62 (0.1%),
        check_dkim_adsp: 3.0 (0.4%), poll_dns_idle: 1.08 (0.1%), tests_pri_10:
        2.2 (0.3%), tests_pri_500: 10 (1.4%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v9] ath9k: let sleep be interrupted when unregistering
 hwrng
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

"Jason A. Donenfeld" <Jason@zx2c4.com> writes:

> There are two deadlock scenarios that need addressing, which cause
> problems when the computer goes to sleep, the interface is set down, and
> hwrng_unregister() is called. When the deadlock is hit, sleep is delayed
> for tens of seconds, causing it to fail. These scenarios are:
>
> 1) The hwrng kthread can't be stopped while it's sleeping, because it
>    uses msleep_interruptible() instead of schedule_timeout_interruptible().
>    The fix is a simple moving to the correct function. At the same time,
>    we should cleanup a common and useless dmesg splat in the same area.
>
> 2) A normal user thread can't be interrupted by hwrng_unregister() while
>    it's sleeping, because hwrng_unregister() is called from elsewhere.
>    The solution here is to keep track of which thread is currently
>    reading, and asleep, and signal that thread when it's time to
>    unregister. There's a bit of book keeping required to prevent
>    lifetime issues on current.

Is there any chance you can name the new function
wake_up_task_interruptible instead of wake_up_process_interruptible.

The name wake_up_process is wrong now, it does not wake up all threads
of a process.  The name dates back to before linux supported multiple
threads in a process, so it is grandfathered in until someone gets
changes it.  But please let's not have a new function with a incorrect
and confusing name.

Eric

>
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: Rui Salvaterra <rsalvaterra@gmail.com>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Valentin Schneider <vschneid@redhat.com>
> Cc: stable@vger.kernel.org
> Reported-by: Gregory Erwin <gregerwin256@gmail.com>
> Tested-by: Gregory Erwin <gregerwin256@gmail.com>
> Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
> Fixes: fcd09c90c3c5 ("ath9k: use hw_random API instead of directly dumping into random.c")
> Link: https://lore.kernel.org/all/CAO+Okf6ZJC5-nTE_EJUGQtd8JiCkiEHytGgDsFGTEjs0c00giw@mail.gmail.com/
> Link: https://lore.kernel.org/lkml/CAO+Okf5k+C+SE6pMVfPf-d8MfVPVq4PO7EY8Hys_DVXtent3HA@mail.gmail.com/
> Link: https://bugs.archlinux.org/task/75138
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
> Changes v8->v9:
> - Use EXPORT_SYMBOL_GPL instead of EXPORT_SYMBOL.
> - Don't export wake_up_state, but rather have __set_notify_signal use
>   wake_up_process_interruptible.
>
>  drivers/char/hw_random/core.c        | 30 ++++++++++++++++++++++++----
>  drivers/net/wireless/ath/ath9k/rng.c | 19 +++++++-----------
>  include/linux/sched.h                |  1 +
>  include/linux/sched/signal.h         |  2 +-
>  kernel/sched/core.c                  |  6 ++++++
>  5 files changed, 41 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> index 16f227b995e8..df45c265878e 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -38,6 +38,8 @@ static LIST_HEAD(rng_list);
>  static DEFINE_MUTEX(rng_mutex);
>  /* Protects rng read functions, data_avail, rng_buffer and rng_fillbuf */
>  static DEFINE_MUTEX(reading_mutex);
> +/* Keeps track of whoever is wait-reading it currently while holding reading_mutex. */
> +static struct task_struct *current_waiting_reader;
>  static int data_avail;
>  static u8 *rng_buffer, *rng_fillbuf;
>  static unsigned short current_quality;
> @@ -208,6 +210,7 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
>  	int err = 0;
>  	int bytes_read, len;
>  	struct hwrng *rng;
> +	bool wait;
>  
>  	while (size) {
>  		rng = get_current_rng();
> @@ -225,9 +228,15 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
>  			goto out_put;
>  		}
>  		if (!data_avail) {
> +			wait = !(filp->f_flags & O_NONBLOCK);
> +			if (wait && cmpxchg(&current_waiting_reader, NULL, current) != NULL) {
> +				err = -EINTR;
> +				goto out_unlock_reading;
> +			}
>  			bytes_read = rng_get_data(rng, rng_buffer,
> -				rng_buffer_size(),
> -				!(filp->f_flags & O_NONBLOCK));
> +				rng_buffer_size(), wait);
> +			if (wait && cmpxchg(&current_waiting_reader, current, NULL) != current)
> +				synchronize_rcu();
>  			if (bytes_read < 0) {
>  				err = bytes_read;
>  				goto out_unlock_reading;
> @@ -513,8 +522,9 @@ static int hwrng_fillfn(void *unused)
>  			break;
>  
>  		if (rc <= 0) {
> -			pr_warn("hwrng: no data available\n");
> -			msleep_interruptible(10000);
> +			if (kthread_should_stop())
> +				break;
> +			schedule_timeout_interruptible(HZ * 10);
>  			continue;
>  		}
>  
> @@ -608,13 +618,21 @@ int hwrng_register(struct hwrng *rng)
>  }
>  EXPORT_SYMBOL_GPL(hwrng_register);
>  
> +#define UNREGISTERING_READER ((void *)~0UL)
> +
>  void hwrng_unregister(struct hwrng *rng)
>  {
>  	struct hwrng *old_rng, *new_rng;
> +	struct task_struct *waiting_reader;
>  	int err;
>  
>  	mutex_lock(&rng_mutex);
>  
> +	rcu_read_lock();
> +	waiting_reader = xchg(&current_waiting_reader, UNREGISTERING_READER);
> +	if (waiting_reader && waiting_reader != UNREGISTERING_READER)
> +		set_notify_signal(waiting_reader);
> +	rcu_read_unlock();
>  	old_rng = current_rng;
>  	list_del(&rng->list);
>  	if (current_rng == rng) {
> @@ -640,6 +658,10 @@ void hwrng_unregister(struct hwrng *rng)
>  	}
>  
>  	wait_for_completion(&rng->cleanup_done);
> +
> +	mutex_lock(&rng_mutex);
> +	cmpxchg(&current_waiting_reader, UNREGISTERING_READER, NULL);
> +	mutex_unlock(&rng_mutex);
>  }
>  EXPORT_SYMBOL_GPL(hwrng_unregister);
>  
> diff --git a/drivers/net/wireless/ath/ath9k/rng.c b/drivers/net/wireless/ath/ath9k/rng.c
> index cb5414265a9b..8980dc36509e 100644
> --- a/drivers/net/wireless/ath/ath9k/rng.c
> +++ b/drivers/net/wireless/ath/ath9k/rng.c
> @@ -52,18 +52,13 @@ static int ath9k_rng_data_read(struct ath_softc *sc, u32 *buf, u32 buf_size)
>  	return j << 2;
>  }
>  
> -static u32 ath9k_rng_delay_get(u32 fail_stats)
> +static unsigned long ath9k_rng_delay_get(u32 fail_stats)
>  {
> -	u32 delay;
> -
>  	if (fail_stats < 100)
> -		delay = 10;
> +		return HZ / 100;
>  	else if (fail_stats < 105)
> -		delay = 1000;
> -	else
> -		delay = 10000;
> -
> -	return delay;
> +		return HZ;
> +	return HZ * 10;
>  }
>  
>  static int ath9k_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
> @@ -80,10 +75,10 @@ static int ath9k_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
>  			bytes_read += max & 3UL;
>  			memzero_explicit(&word, sizeof(word));
>  		}
> -		if (!wait || !max || likely(bytes_read) || fail_stats > 110)
> +		if (!wait || !max || likely(bytes_read) || fail_stats > 110 ||
> +		    ((current->flags & PF_KTHREAD) && kthread_should_stop()) ||
> +		    schedule_timeout_interruptible(ath9k_rng_delay_get(++fail_stats)))
>  			break;
> -
> -		msleep_interruptible(ath9k_rng_delay_get(++fail_stats));
>  	}
>  
>  	if (wait && !bytes_read && max)
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index c46f3a63b758..518fb7694270 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1936,6 +1936,7 @@ extern struct task_struct *find_get_task_by_vpid(pid_t nr);
>  
>  extern int wake_up_state(struct task_struct *tsk, unsigned int state);
>  extern int wake_up_process(struct task_struct *tsk);
> +extern int wake_up_process_interruptible(struct task_struct *tsk);
>  extern void wake_up_new_task(struct task_struct *tsk);
>  
>  #ifdef CONFIG_SMP
> diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
> index cafbe03eed01..e1c0099ba857 100644
> --- a/include/linux/sched/signal.h
> +++ b/include/linux/sched/signal.h
> @@ -364,7 +364,7 @@ static inline void clear_notify_signal(void)
>  static inline bool __set_notify_signal(struct task_struct *task)
>  {
>  	return !test_and_set_tsk_thread_flag(task, TIF_NOTIFY_SIGNAL) &&
> -	       !wake_up_state(task, TASK_INTERRUPTIBLE);
> +	       !wake_up_process_interruptible(task);
>  }
>  
>  /*
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index da0bf6fe9ecd..8e466f0d906f 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4280,6 +4280,12 @@ int wake_up_process(struct task_struct *p)
>  }
>  EXPORT_SYMBOL(wake_up_process);
>  
> +int wake_up_process_interruptible(struct task_struct *p)
> +{
> +	return try_to_wake_up(p, TASK_INTERRUPTIBLE, 0);
> +}
> +EXPORT_SYMBOL_GPL(wake_up_process_interruptible);
> +
>  int wake_up_state(struct task_struct *p, unsigned int state)
>  {
>  	return try_to_wake_up(p, state, 0);
