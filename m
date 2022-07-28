Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9148583BF1
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 12:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235875AbiG1KWp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 06:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235395AbiG1KWn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 06:22:43 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFDC232EC4;
        Thu, 28 Jul 2022 03:22:41 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oH0eq-005Pl8-Ak; Thu, 28 Jul 2022 20:22:21 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 28 Jul 2022 18:22:20 +0800
Date:   Thu, 28 Jul 2022 18:22:20 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-wireless@vger.kernel.org, kvalo@kernel.org,
        stable@vger.kernel.org, Gregory Erwin <gregerwin256@gmail.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [v12 PATCH] hwrng: core - let sleep be interrupted when
 unregistering hwrng
Message-ID: <YuJjXI+tuiCcixbd@gondor.apana.org.au>
References: <20220725215536.767961-1-Jason@zx2c4.com>
 <Yt+3ic4YYpAsUHMF@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yt+3ic4YYpAsUHMF@gondor.apana.org.au>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

There are two deadlock scenarios that need addressing, which cause
problems when the computer goes to sleep, the interface is set down, and
hwrng_unregister() is called. When the deadlock is hit, sleep is delayed
for tens of seconds, causing it to fail. These scenarios are:

1) The hwrng kthread can't be stopped while it's sleeping, because it
   uses msleep_interruptible() which does not react to kthread_stop.

2) A normal user thread can't be interrupted by hwrng_unregister() while
   it's sleeping, because hwrng_unregister() is called from elsewhere.

We solve both issues by add a completion object called dying that
fulfils waiters once we have started the process in hwrng_unregister.

At the same time, we should cleanup a common and useless dmesg splat
in the same area.

Cc: <stable@vger.kernel.org>
Reported-by: Gregory Erwin <gregerwin256@gmail.com>
Fixes: fcd09c90c3c5 ("ath9k: use hw_random API instead of directly dumping into random.c")
Link: https://lore.kernel.org/all/CAO+Okf6ZJC5-nTE_EJUGQtd8JiCkiEHytGgDsFGTEjs0c00giw@mail.gmail.com/
Link: https://lore.kernel.org/lkml/CAO+Okf5k+C+SE6pMVfPf-d8MfVPVq4PO7EY8Hys_DVXtent3HA@mail.gmail.com/
Link: https://bugs.archlinux.org/task/75138
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 16f227b995e8..21dce7acf086 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -507,16 +508,17 @@ static int hwrng_fillfn(void *unused)
 			rng->quality = current_quality; /* obsolete */
 		quality = rng->quality;
 		mutex_unlock(&reading_mutex);
+
+		if (rc <= 0)
+			hwrng_msleep(rng, 10000);
+
 		put_rng(rng);
 
 		if (!quality)
 			break;
 
-		if (rc <= 0) {
-			pr_warn("hwrng: no data available\n");
-			msleep_interruptible(10000);
+		if (rc <= 0)
 			continue;
-		}
 
 		/* If we cannot credit at least one bit of entropy,
 		 * keep track of the remainder for the next iteration
@@ -570,6 +572,7 @@ int hwrng_register(struct hwrng *rng)
 
 	init_completion(&rng->cleanup_done);
 	complete(&rng->cleanup_done);
+	init_completion(&rng->dying);
 
 	if (!current_rng ||
 	    (!cur_rng_set_by_user && rng->quality > current_rng->quality)) {
@@ -617,6 +620,7 @@ void hwrng_unregister(struct hwrng *rng)
 
 	old_rng = current_rng;
 	list_del(&rng->list);
+	complete_all(&rng->dying);
 	if (current_rng == rng) {
 		err = enable_best_rng();
 		if (err) {
@@ -685,6 +689,14 @@ void devm_hwrng_unregister(struct device *dev, struct hwrng *rng)
 }
 EXPORT_SYMBOL_GPL(devm_hwrng_unregister);
 
+long hwrng_msleep(struct hwrng *rng, unsigned int msecs)
+{
+	unsigned long timeout = msecs_to_jiffies(msecs) + 1;
+
+	return wait_for_completion_interruptible_timeout(&rng->dying, timeout);
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
index aa1d4da03538..77c2885c4c13 100644
--- a/include/linux/hw_random.h
+++ b/include/linux/hw_random.h
@@ -50,6 +50,7 @@ struct hwrng {
 	struct list_head list;
 	struct kref ref;
 	struct completion cleanup_done;
+	struct completion dying;
 };
 
 struct device;
@@ -61,4 +62,6 @@ extern int devm_hwrng_register(struct device *dev, struct hwrng *rng);
 extern void hwrng_unregister(struct hwrng *rng);
 extern void devm_hwrng_unregister(struct device *dve, struct hwrng *rng);
 
+extern long hwrng_msleep(struct hwrng *rng, unsigned int msecs);
+
 #endif /* LINUX_HWRANDOM_H_ */
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
