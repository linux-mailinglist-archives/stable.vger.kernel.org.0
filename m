Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4086455FEF7
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 13:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233221AbiF2LnB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 07:43:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233185AbiF2LnB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 07:43:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92593ED15;
        Wed, 29 Jun 2022 04:42:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71A3BB82285;
        Wed, 29 Jun 2022 11:42:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35CEBC34114;
        Wed, 29 Jun 2022 11:42:56 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="D709hl3z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656502973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q0M5vfXiFiWDWXccdLQMJZX1GsFMFRGBftBOErnhpQo=;
        b=D709hl3zm353dWlIgvfZKTIqYnS30rFdowctEIXBfOB9HRlWfOC71oqorzvVMofBQ/oLMc
        hzwTq2mYGuhuki+lq8jZaBKz2dvD2nTuVopJCH6veLY2gqwnJjJPlpkQndx0E11wqkETKg
        dflSo2tEZgZR4+ZzhIAYtXlqPZ7IN7c=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 69b1f224 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 29 Jun 2022 11:42:53 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Gregory Erwin <gregerwin256@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Kalle Valo <kvalo@kernel.org>,
        Rui Salvaterra <rsalvaterra@gmail.com>, stable@vger.kernel.org
Subject: [PATCH v8] ath9k: let sleep be interrupted when unregistering hwrng
Date:   Wed, 29 Jun 2022 13:42:40 +0200
Message-Id: <20220629114240.946411-1-Jason@zx2c4.com>
In-Reply-To: <Yrw5f8GN2fh2orid@zx2c4.com>
References: <Yrw5f8GN2fh2orid@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There are two deadlock scenarios that need addressing, which cause
problems when the computer goes to sleep, the interface is set down, and
hwrng_unregister() is called. When the deadlock is hit, sleep is delayed
for tens of seconds, causing it to fail. These scenarios are:

1) The hwrng kthread can't be stopped while it's sleeping, because it
   uses msleep_interruptible() instead of schedule_timeout_interruptible().
   The fix is a simple moving to the correct function. At the same time,
   we should cleanup a common and useless dmesg splat in the same area.

2) A normal user thread can't be interrupted by hwrng_unregister() while
   it's sleeping, because hwrng_unregister() is called from elsewhere.
   The solution here is to keep track of which thread is currently
   reading, and asleep, and signal that thread when it's time to
   unregister. There's a bit of book keeping required to prevent
   lifetime issues on current.

Reported-by: Gregory Erwin <gregerwin256@gmail.com>
Cc: Toke Høiland-Jørgensen <toke@redhat.com>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: Rui Salvaterra <rsalvaterra@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: stable@vger.kernel.org
Fixes: fcd09c90c3c5 ("ath9k: use hw_random API instead of directly dumping into random.c")
Link: https://lore.kernel.org/all/CAO+Okf6ZJC5-nTE_EJUGQtd8JiCkiEHytGgDsFGTEjs0c00giw@mail.gmail.com/
Link: https://lore.kernel.org/lkml/CAO+Okf5k+C+SE6pMVfPf-d8MfVPVq4PO7EY8Hys_DVXtent3HA@mail.gmail.com/
Link: https://bugs.archlinux.org/task/75138
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
Changes v7->v8:
- Add a missing export_symbol.

 drivers/char/hw_random/core.c        | 30 ++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath9k/rng.c | 19 +++++++-----------
 kernel/sched/core.c                  |  1 +
 3 files changed, 34 insertions(+), 16 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 16f227b995e8..df45c265878e 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -38,6 +38,8 @@ static LIST_HEAD(rng_list);
 static DEFINE_MUTEX(rng_mutex);
 /* Protects rng read functions, data_avail, rng_buffer and rng_fillbuf */
 static DEFINE_MUTEX(reading_mutex);
+/* Keeps track of whoever is wait-reading it currently while holding reading_mutex. */
+static struct task_struct *current_waiting_reader;
 static int data_avail;
 static u8 *rng_buffer, *rng_fillbuf;
 static unsigned short current_quality;
@@ -208,6 +210,7 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
 	int err = 0;
 	int bytes_read, len;
 	struct hwrng *rng;
+	bool wait;
 
 	while (size) {
 		rng = get_current_rng();
@@ -225,9 +228,15 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
 			goto out_put;
 		}
 		if (!data_avail) {
+			wait = !(filp->f_flags & O_NONBLOCK);
+			if (wait && cmpxchg(&current_waiting_reader, NULL, current) != NULL) {
+				err = -EINTR;
+				goto out_unlock_reading;
+			}
 			bytes_read = rng_get_data(rng, rng_buffer,
-				rng_buffer_size(),
-				!(filp->f_flags & O_NONBLOCK));
+				rng_buffer_size(), wait);
+			if (wait && cmpxchg(&current_waiting_reader, current, NULL) != current)
+				synchronize_rcu();
 			if (bytes_read < 0) {
 				err = bytes_read;
 				goto out_unlock_reading;
@@ -513,8 +522,9 @@ static int hwrng_fillfn(void *unused)
 			break;
 
 		if (rc <= 0) {
-			pr_warn("hwrng: no data available\n");
-			msleep_interruptible(10000);
+			if (kthread_should_stop())
+				break;
+			schedule_timeout_interruptible(HZ * 10);
 			continue;
 		}
 
@@ -608,13 +618,21 @@ int hwrng_register(struct hwrng *rng)
 }
 EXPORT_SYMBOL_GPL(hwrng_register);
 
+#define UNREGISTERING_READER ((void *)~0UL)
+
 void hwrng_unregister(struct hwrng *rng)
 {
 	struct hwrng *old_rng, *new_rng;
+	struct task_struct *waiting_reader;
 	int err;
 
 	mutex_lock(&rng_mutex);
 
+	rcu_read_lock();
+	waiting_reader = xchg(&current_waiting_reader, UNREGISTERING_READER);
+	if (waiting_reader && waiting_reader != UNREGISTERING_READER)
+		set_notify_signal(waiting_reader);
+	rcu_read_unlock();
 	old_rng = current_rng;
 	list_del(&rng->list);
 	if (current_rng == rng) {
@@ -640,6 +658,10 @@ void hwrng_unregister(struct hwrng *rng)
 	}
 
 	wait_for_completion(&rng->cleanup_done);
+
+	mutex_lock(&rng_mutex);
+	cmpxchg(&current_waiting_reader, UNREGISTERING_READER, NULL);
+	mutex_unlock(&rng_mutex);
 }
 EXPORT_SYMBOL_GPL(hwrng_unregister);
 
diff --git a/drivers/net/wireless/ath/ath9k/rng.c b/drivers/net/wireless/ath/ath9k/rng.c
index cb5414265a9b..8980dc36509e 100644
--- a/drivers/net/wireless/ath/ath9k/rng.c
+++ b/drivers/net/wireless/ath/ath9k/rng.c
@@ -52,18 +52,13 @@ static int ath9k_rng_data_read(struct ath_softc *sc, u32 *buf, u32 buf_size)
 	return j << 2;
 }
 
-static u32 ath9k_rng_delay_get(u32 fail_stats)
+static unsigned long ath9k_rng_delay_get(u32 fail_stats)
 {
-	u32 delay;
-
 	if (fail_stats < 100)
-		delay = 10;
+		return HZ / 100;
 	else if (fail_stats < 105)
-		delay = 1000;
-	else
-		delay = 10000;
-
-	return delay;
+		return HZ;
+	return HZ * 10;
 }
 
 static int ath9k_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
@@ -80,10 +75,10 @@ static int ath9k_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 			bytes_read += max & 3UL;
 			memzero_explicit(&word, sizeof(word));
 		}
-		if (!wait || !max || likely(bytes_read) || fail_stats > 110)
+		if (!wait || !max || likely(bytes_read) || fail_stats > 110 ||
+		    ((current->flags & PF_KTHREAD) && kthread_should_stop()) ||
+		    schedule_timeout_interruptible(ath9k_rng_delay_get(++fail_stats)))
 			break;
-
-		msleep_interruptible(ath9k_rng_delay_get(++fail_stats));
 	}
 
 	if (wait && !bytes_read && max)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index da0bf6fe9ecd..d65a5eb9a65e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4284,6 +4284,7 @@ int wake_up_state(struct task_struct *p, unsigned int state)
 {
 	return try_to_wake_up(p, state, 0);
 }
+EXPORT_SYMBOL(wake_up_state);
 
 /*
  * Perform scheduler related setup for a newly forked process p.
-- 
2.35.1

