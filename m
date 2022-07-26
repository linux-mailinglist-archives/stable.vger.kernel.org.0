Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75D6758102F
	for <lists+stable@lfdr.de>; Tue, 26 Jul 2022 11:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbiGZJo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jul 2022 05:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbiGZJo4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jul 2022 05:44:56 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7499A31391;
        Tue, 26 Jul 2022 02:44:54 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oGH7I-004bw2-UL; Tue, 26 Jul 2022 19:44:42 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 26 Jul 2022 17:44:41 +0800
Date:   Tue, 26 Jul 2022 17:44:41 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-wireless@vger.kernel.org, kvalo@kernel.org,
        stable@vger.kernel.org, Gregory Erwin <gregerwin256@gmail.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        "Eric W . Biederman" <ebiederm@xmission.com>
Subject: [PATCH RESEND v11] hwrng: core - let sleep be interrupted when
 unregistering hwrng
Message-ID: <Yt+3ic4YYpAsUHMF@gondor.apana.org.au>
References: <20220725215536.767961-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220725215536.767961-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 25, 2022 at 11:55:36PM +0200, Jason A. Donenfeld wrote:
>
> Kalle - I'm resending this to you with the various acks collected from
> the long sprawling thread, in hopes that this actually makes it into
> your tree. Please let me know if you *don't* want to take this. -Jason

Hi Jason:

Thanks for all your effort in resolving this issue.

I think Valentin's concern is valid though.  The sleep/wakeup paradigm
in this patch-set is slightly unusual.

So what I've done is taken your latest patch, and incorporated
Valentin's suggestions on top of it.  I don't think there is an
issue with other drivers as neither approach really changes them.

While doing so I've found a little problem with your patch.

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

In between the setting and clearing of current_waiting_reader,
a reader that gets a new RNG may fail simply because it detected
the value of UNREGITERING_READER.

So I've fixed this by using a different mechanism to detect whether
an RNG is going away, namely list_empty on rng->list.  In doing so
we no longer need to modify current_waiting_reader in hwrng_unregister
and therefore it no longer needs to be modified using xchg.

---8<---
From: Jason A. Donenfeld <Jason@zx2c4.com>

There are two deadlock scenarios that need addressing, which cause
problems when the computer goes to sleep, the interface is set down, and
hwrng_unregister() is called. When the deadlock is hit, sleep is delayed
for tens of seconds, causing it to fail. These scenarios are:

1) The hwrng kthread can't be stopped while it's sleeping, because it
   uses msleep_interruptible() instead of schedule_timeout().
   The fix is a simple moving to the correct function. At the same time,
   we should cleanup a common and useless dmesg splat in the same area.

2) A normal user thread can't be interrupted by hwrng_unregister() while
   it's sleeping, because hwrng_unregister() is called from elsewhere.
   The solution here is to keep track of which thread is currently
   reading, and asleep, and signal that thread when it's time to
   unregister. There's a bit of book keeping required to prevent
   lifetime issues on current.

Cc: <stable@vger.kernel.org>
Reported-by: Gregory Erwin <gregerwin256@gmail.com>
Fixes: fcd09c90c3c5 ("ath9k: use hw_random API instead of directly dumping into random.c")
Link: https://lore.kernel.org/all/CAO+Okf6ZJC5-nTE_EJUGQtd8JiCkiEHytGgDsFGTEjs0c00giw@mail.gmail.com/
Link: https://lore.kernel.org/lkml/CAO+Okf5k+C+SE6pMVfPf-d8MfVPVq4PO7EY8Hys_DVXtent3HA@mail.gmail.com/
Link: https://bugs.archlinux.org/task/75138
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 16f227b995e8..4f254b65ce0b 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -10,6 +10,7 @@
  * of the GNU General Public License, incorporated herein by reference.
  */
 
+#include <linux/atomic.h>
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/err.h>
@@ -22,6 +23,7 @@
 #include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/random.h>
+#include <linux/rcupdate.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
@@ -38,6 +40,8 @@ static LIST_HEAD(rng_list);
 static DEFINE_MUTEX(rng_mutex);
 /* Protects rng read functions, data_avail, rng_buffer and rng_fillbuf */
 static DEFINE_MUTEX(reading_mutex);
+/* Keeps track of whoever is wait-reading it currently while holding reading_mutex. */
+static struct task_struct *current_waiting_reader;
 static int data_avail;
 static u8 *rng_buffer, *rng_fillbuf;
 static unsigned short current_quality;
@@ -57,6 +61,23 @@ static void hwrng_manage_rngd(struct hwrng *rng);
 static inline int rng_get_data(struct hwrng *rng, u8 *buffer, size_t size,
 			       int wait);
 
+/* rng_dying without a barrier.  Use this if there is a barrier elsewhere. */
+static inline bool __rng_dying(struct hwrng *rng)
+{
+	return list_empty(&rng->list);
+}
+
+static inline bool rng_dying(struct hwrng *rng)
+{
+	/*
+	 * This barrier pairs with the one in
+	 * hwrng_unregister.  This ensures that
+	 * we see any attempt to unregister rng.
+	 */
+	smp_mb();
+	return list_empty(&rng->list);
+}
+
 static size_t rng_buffer_size(void)
 {
 	return SMP_CACHE_BYTES < 32 ? 32 : SMP_CACHE_BYTES;
@@ -204,6 +225,7 @@ static inline int rng_get_data(struct hwrng *rng, u8 *buffer, size_t size,
 static ssize_t rng_dev_read(struct file *filp, char __user *buf,
 			    size_t size, loff_t *offp)
 {
+	int synch = false;
 	ssize_t ret = 0;
 	int err = 0;
 	int bytes_read, len;
@@ -225,9 +247,16 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
 			goto out_put;
 		}
 		if (!data_avail) {
+			bool wait = !(filp->f_flags & O_NONBLOCK);
+
+			if (wait)
+				current_waiting_reader = current;
 			bytes_read = rng_get_data(rng, rng_buffer,
-				rng_buffer_size(),
-				!(filp->f_flags & O_NONBLOCK));
+				rng_buffer_size(), wait);
+			if (wait) {
+				current_waiting_reader = NULL;
+				synch |= rng_dying(rng);
+			}
 			if (bytes_read < 0) {
 				err = bytes_read;
 				goto out_unlock_reading;
@@ -269,6 +298,9 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
 		}
 	}
 out:
+	if (synch)
+		synchronize_rcu();
+
 	return ret ? : err;
 
 out_unlock_reading:
@@ -501,20 +533,26 @@ static int hwrng_fillfn(void *unused)
 		if (IS_ERR(rng) || !rng)
 			break;
 		mutex_lock(&reading_mutex);
+		current_waiting_reader = current;
 		rc = rng_get_data(rng, rng_fillbuf,
 				  rng_buffer_size(), 1);
+		current_waiting_reader = NULL;
 		if (current_quality != rng->quality)
 			rng->quality = current_quality; /* obsolete */
 		quality = rng->quality;
 		mutex_unlock(&reading_mutex);
+		if (rng_dying(rng))
+			synchronize_rcu();
 		put_rng(rng);
 
 		if (!quality)
 			break;
 
 		if (rc <= 0) {
-			pr_warn("hwrng: no data available\n");
-			msleep_interruptible(10000);
+			set_current_state(TASK_INTERRUPTIBLE);
+			if (kthread_should_stop())
+				__set_current_state(TASK_RUNNING);
+			schedule_timeout(10 * HZ);
 			continue;
 		}
 
@@ -616,8 +654,22 @@ void hwrng_unregister(struct hwrng *rng)
 	mutex_lock(&rng_mutex);
 
 	old_rng = current_rng;
-	list_del(&rng->list);
+	list_del_init(&rng->list);
 	if (current_rng == rng) {
+		struct task_struct *waiting_reader;
+
+		/*
+		 * Ensure that rng->list is cleared before the
+		 * subsequent read of current_waiting_reader.
+		 */
+		smp_mb();
+
+		rcu_read_lock();
+		waiting_reader = current_waiting_reader;
+		if (waiting_reader)
+			wake_up_process(waiting_reader);
+		rcu_read_unlock();
+
 		err = enable_best_rng();
 		if (err) {
 			drop_current_rng();
@@ -685,6 +737,17 @@ void devm_hwrng_unregister(struct device *dev, struct hwrng *rng)
 }
 EXPORT_SYMBOL_GPL(devm_hwrng_unregister);
 
+long hwrng_msleep(struct hwrng *rng, unsigned int msecs)
+{
+	set_current_state(TASK_INTERRUPTIBLE);
+
+	if (__rng_dying(rng))
+		 __set_current_state(TASK_RUNNING);
+
+	return schedule_timeout(msecs);
+}
+EXPORT_SYMBOL_GPL(hwrng_msleep);
+
 static int __init hwrng_modinit(void)
 {
 	int ret;
diff --git a/drivers/net/wireless/ath/ath9k/rng.c b/drivers/net/wireless/ath/ath9k/rng.c
index cb5414265a9b..58c0ab01771b 100644
--- a/drivers/net/wireless/ath/ath9k/rng.c
+++ b/drivers/net/wireless/ath/ath9k/rng.c
@@ -83,7 +83,8 @@ static int ath9k_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 		if (!wait || !max || likely(bytes_read) || fail_stats > 110)
 			break;
 
-		msleep_interruptible(ath9k_rng_delay_get(++fail_stats));
+		if (hwrng_msleep(rng, ath9k_rng_delay_get(++fail_stats)))
+			break;
 	}
 
 	if (wait && !bytes_read && max)
diff --git a/include/linux/hw_random.h b/include/linux/hw_random.h
index aa1d4da03538..021a971bfd68 100644
--- a/include/linux/hw_random.h
+++ b/include/linux/hw_random.h
@@ -61,4 +61,6 @@ extern int devm_hwrng_register(struct device *dev, struct hwrng *rng);
 extern void hwrng_unregister(struct hwrng *rng);
 extern void devm_hwrng_unregister(struct device *dve, struct hwrng *rng);
 
+extern long hwrng_msleep(struct hwrng *rng, unsigned int msecs);
+
 #endif /* LINUX_HWRANDOM_H_ */
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
