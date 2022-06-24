Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DACE7558CB1
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 03:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiFXBPS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 21:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiFXBPQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 21:15:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B181C5676D;
        Thu, 23 Jun 2022 18:15:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5BC07B824C6;
        Fri, 24 Jun 2022 01:15:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22CB0C3411D;
        Fri, 24 Jun 2022 01:15:11 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ptcnY2On"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656033308;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wro+3aj73CCQl/hqLwbq1IxoTtROuu7h8ejF/0ZAALw=;
        b=ptcnY2OnzRbkKrE3VaP4/z/mhPjeRbYkZGlUZgKfsvRS5algCIo7JxwJF5WNF02voAPSx5
        FsFV7MripD6U47f4pLoz7l1FFwAci1yahPZEu2GwxO3idiOc7fZbXw+o/+prknIUH2DJbC
        TwBBZjHob2Zig5coNAKXrXD4/sdU7L8=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 4934de07 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 24 Jun 2022 01:15:08 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Gregory Erwin <gregerwin256@gmail.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Kalle Valo <kvalo@kernel.org>,
        Rui Salvaterra <rsalvaterra@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] ath9k: rng: escape sleep loop when unregistering
Date:   Fri, 24 Jun 2022 03:14:49 +0200
Message-Id: <20220624011449.1473399-1-Jason@zx2c4.com>
In-Reply-To: <YrUKUt5nvX8qf1Je@zx2c4.com>
References: <YrUKUt5nvX8qf1Je@zx2c4.com>
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

There's currently an almost deadlock when ath9k shuts down if no random
bytes are available:

Thread A                                Thread B
-------------------------------------------------------------------------
rng_dev_read
 get_current_rng
  kref_get(&current_rng->ref)
 rng_get_data
  ath9k_rng_read
   msleep_interruptible(...)
                                       ath9k_rng_stop
				        devm_hwrng_unregister
					 devm_hwrng_release
					  hwrng_unregister
					   drop_current_rng
					     kref_put(&current_rng->ref, cleanup_rng)
					      // Does NOT call cleanup_rng here,
					      // because of thread A's kref_get.
					   wait_for_completion(&rng->cleanup_done);
					    // Waits for a really long time...
   // Eventually sleep is over...
 put_rng
  kref_put(&rng->ref, cleanup_rng);
   cleanup_rng
    complete(&rng->cleanup_done);
                                           return

When thread B doesn't return right away, sleep and other functions that
are waiting for ath9k_rng_stop to complete time out, and problems ensue.

This commit fixes the problem by using another completion inside of
ath9k_rng_read so that hwrng_unregister can interrupt it as needed.

Reported-by: Gregory Erwin <gregerwin256@gmail.com>
Cc: Toke Høiland-Jørgensen <toke@redhat.com>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: Rui Salvaterra <rsalvaterra@gmail.com>
Cc: stable@vger.kernel.org
Fixes: fcd09c90c3c5 ("ath9k: use hw_random API instead of directly dumping into random.c")
Link: https://lore.kernel.org/all/CAO+Okf6ZJC5-nTE_EJUGQtd8JiCkiEHytGgDsFGTEjs0c00giw@mail.gmail.com/
Link: https://bugs.archlinux.org/task/75138
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
I do not have an ath9k and therefore I can't test this myself. The
analysis above was done completely statically, with no dynamic tracing
and just a bug report of symptoms from Gregory. So it might be totally
wrong. Thus, this patch very much requires Gregory's testing. Please
don't apply it until we have his `Tested-by` line.

 drivers/net/wireless/ath/ath9k/ath9k.h |  1 +
 drivers/net/wireless/ath/ath9k/rng.c   | 26 ++++++++++++++++----------
 2 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 3ccf8cfc6b63..731db7f70e5d 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -1072,6 +1072,7 @@ struct ath_softc {
 
 #ifdef CONFIG_ATH9K_HWRNG
 	struct hwrng rng_ops;
+	struct completion rng_shutdown;
 	u32 rng_last;
 	char rng_name[sizeof("ath9k_65535")];
 #endif
diff --git a/drivers/net/wireless/ath/ath9k/rng.c b/drivers/net/wireless/ath/ath9k/rng.c
index cb5414265a9b..67c6b03a22ac 100644
--- a/drivers/net/wireless/ath/ath9k/rng.c
+++ b/drivers/net/wireless/ath/ath9k/rng.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2015 Qualcomm Atheros, Inc.
+ * Copyright (C) 2022 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -52,18 +53,13 @@ static int ath9k_rng_data_read(struct ath_softc *sc, u32 *buf, u32 buf_size)
 	return j << 2;
 }
 
-static u32 ath9k_rng_delay_get(u32 fail_stats)
+static unsigned long ath9k_rng_delay_get(u32 fail_stats)
 {
-	u32 delay;
-
 	if (fail_stats < 100)
-		delay = 10;
+		return msecs_to_jiffies(10);
 	else if (fail_stats < 105)
-		delay = 1000;
-	else
-		delay = 10000;
-
-	return delay;
+		return msecs_to_jiffies(1000);
+	return msecs_to_jiffies(10000);
 }
 
 static int ath9k_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
@@ -83,7 +79,10 @@ static int ath9k_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 		if (!wait || !max || likely(bytes_read) || fail_stats > 110)
 			break;
 
-		msleep_interruptible(ath9k_rng_delay_get(++fail_stats));
+		if (wait_for_completion_interruptible_timeout(
+			    &sc->rng_shutdown,
+			    ath9k_rng_delay_get(++fail_stats)))
+			break;
 	}
 
 	if (wait && !bytes_read && max)
@@ -91,6 +90,11 @@ static int ath9k_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 	return bytes_read;
 }
 
+static void ath9k_rng_cleanup(struct hwrng *rng)
+{
+	complete(&container_of(rng, struct ath_softc, rng_ops)->rng_shutdown);
+}
+
 void ath9k_rng_start(struct ath_softc *sc)
 {
 	static atomic_t serial = ATOMIC_INIT(0);
@@ -104,8 +108,10 @@ void ath9k_rng_start(struct ath_softc *sc)
 
 	snprintf(sc->rng_name, sizeof(sc->rng_name), "ath9k_%u",
 		 (atomic_inc_return(&serial) - 1) & U16_MAX);
+	init_completion(&sc->rng_shutdown);
 	sc->rng_ops.name = sc->rng_name;
 	sc->rng_ops.read = ath9k_rng_read;
+	sc->rng_ops.cleanup = ath9k_rng_cleanup;
 	sc->rng_ops.quality = 320;
 
 	if (devm_hwrng_register(sc->dev, &sc->rng_ops))
-- 
2.35.1

