Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50E70603CA3
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbiJSIun (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231686AbiJSItE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:49:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 656AF91853;
        Wed, 19 Oct 2022 01:47:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4924B822FF;
        Wed, 19 Oct 2022 08:43:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A257C433D6;
        Wed, 19 Oct 2022 08:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169011;
        bh=5WqAnoSjVTSoddkab9lp14xiGFfx7MVSszDGRO/v0Ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v2GuYzraoAIVX/utpa6O3f7nQBhJ+dpSlQD/i/KtLiKs74ty02VQSCfulgN3JeJ02
         xV3JVhPIF4sMubqy/h8xM7AHwOEcgWXQfRT9fjhgpt4PeJSJGSE3kAYRwgKwILU/Hl
         HS9hKIeok7tQeiMgs96E2tiW+ntqzAC0kybTP/bE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gregory Erwin <gregerwin256@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.0 111/862] hwrng: core - let sleep be interrupted when unregistering hwrng
Date:   Wed, 19 Oct 2022 10:23:18 +0200
Message-Id: <20221019083254.837224927@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit 36cb6494429bd64b27b7ff8b4af56f8e526da2b4 upstream.

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
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Acked-by: Kalle Valo <kvalo@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/hw_random/core.c        |   19 +++++++++++++++----
 drivers/net/wireless/ath/ath9k/rng.c |    3 ++-
 include/linux/hw_random.h            |    3 +++
 3 files changed, 20 insertions(+), 5 deletions(-)

--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -507,16 +507,17 @@ static int hwrng_fillfn(void *unused)
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
@@ -570,6 +571,7 @@ int hwrng_register(struct hwrng *rng)
 
 	init_completion(&rng->cleanup_done);
 	complete(&rng->cleanup_done);
+	init_completion(&rng->dying);
 
 	if (!current_rng ||
 	    (!cur_rng_set_by_user && rng->quality > current_rng->quality)) {
@@ -617,6 +619,7 @@ void hwrng_unregister(struct hwrng *rng)
 
 	old_rng = current_rng;
 	list_del(&rng->list);
+	complete_all(&rng->dying);
 	if (current_rng == rng) {
 		err = enable_best_rng();
 		if (err) {
@@ -685,6 +688,14 @@ void devm_hwrng_unregister(struct device
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
--- a/drivers/net/wireless/ath/ath9k/rng.c
+++ b/drivers/net/wireless/ath/ath9k/rng.c
@@ -83,7 +83,8 @@ static int ath9k_rng_read(struct hwrng *
 		if (!wait || !max || likely(bytes_read) || fail_stats > 110)
 			break;
 
-		msleep_interruptible(ath9k_rng_delay_get(++fail_stats));
+		if (hwrng_msleep(rng, ath9k_rng_delay_get(++fail_stats)))
+			break;
 	}
 
 	if (wait && !bytes_read && max)
--- a/include/linux/hw_random.h
+++ b/include/linux/hw_random.h
@@ -50,6 +50,7 @@ struct hwrng {
 	struct list_head list;
 	struct kref ref;
 	struct completion cleanup_done;
+	struct completion dying;
 };
 
 struct device;
@@ -61,4 +62,6 @@ extern int devm_hwrng_register(struct de
 extern void hwrng_unregister(struct hwrng *rng);
 extern void devm_hwrng_unregister(struct device *dve, struct hwrng *rng);
 
+extern long hwrng_msleep(struct hwrng *rng, unsigned int msecs);
+
 #endif /* LINUX_HWRANDOM_H_ */


