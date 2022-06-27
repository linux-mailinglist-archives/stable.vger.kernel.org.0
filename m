Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBFAE55D90B
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239675AbiF0MI0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 08:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240576AbiF0MIC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 08:08:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A4FF3A1;
        Mon, 27 Jun 2022 05:08:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB40861558;
        Mon, 27 Jun 2022 12:08:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 462D1C3411D;
        Mon, 27 Jun 2022 12:07:59 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="GwEsXBZc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656331677;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8R/GDxD1kS9DrC5nWZmnAALbx/9F2+JyOdg8IjdBSdA=;
        b=GwEsXBZcVVuwPnLTBCsF2aosc6AX6Fqumdv7dzZg5405+MeeHcfPC9NlDyy3I3RucPW7yG
        BA25sINZZV0m1xG7qQW0IMY0c62EWWc8jPNQSOoK6T3eAMdh9ZMiaTdT3jS/4fckv6MNkz
        8x33NRIudZG34vQLD5VZ5RtzFxiT/Os=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b72fdf7b (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 27 Jun 2022 12:07:57 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Gregory Erwin <gregerwin256@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Rui Salvaterra <rsalvaterra@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable@vger.kernel.org
Subject: [PATCH v6] ath9k: sleep for less time when unregistering hwrng
Date:   Mon, 27 Jun 2022 14:07:35 +0200
Message-Id: <20220627120735.611821-1-Jason@zx2c4.com>
In-Reply-To: <20220627113749.564132-1-Jason@zx2c4.com>
References: <20220627113749.564132-1-Jason@zx2c4.com>
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

Even though hwrng provides a `wait` parameter, it doesn't work very well
when waiting for a long time. There are numerous deadlocks that emerge
related to shutdown. Work around this API limitation by waiting for a
shorter amount of time and erroring more frequently. This commit also
prevents hwrng from splatting messages to dmesg when there's a timeout
and switches to using schedule_timeout_interruptible(), so that the
kthread can be stopped.

Reported-by: Gregory Erwin <gregerwin256@gmail.com>
Tested-by: Gregory Erwin <gregerwin256@gmail.com>
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
 drivers/char/hw_random/core.c        |  5 +++--
 drivers/net/wireless/ath/ath9k/rng.c | 20 +++-----------------
 2 files changed, 6 insertions(+), 19 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 16f227b995e8..9987f0642285 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -513,8 +513,9 @@ static int hwrng_fillfn(void *unused)
 			break;
 
 		if (rc <= 0) {
-			pr_warn("hwrng: no data available\n");
-			msleep_interruptible(10000);
+			if (kthread_should_stop())
+				break;
+			schedule_timeout_interruptible(HZ * 10);
 			continue;
 		}
 
diff --git a/drivers/net/wireless/ath/ath9k/rng.c b/drivers/net/wireless/ath/ath9k/rng.c
index cb5414265a9b..757603d1949d 100644
--- a/drivers/net/wireless/ath/ath9k/rng.c
+++ b/drivers/net/wireless/ath/ath9k/rng.c
@@ -52,20 +52,6 @@ static int ath9k_rng_data_read(struct ath_softc *sc, u32 *buf, u32 buf_size)
 	return j << 2;
 }
 
-static u32 ath9k_rng_delay_get(u32 fail_stats)
-{
-	u32 delay;
-
-	if (fail_stats < 100)
-		delay = 10;
-	else if (fail_stats < 105)
-		delay = 1000;
-	else
-		delay = 10000;
-
-	return delay;
-}
-
 static int ath9k_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 {
 	struct ath_softc *sc = container_of(rng, struct ath_softc, rng_ops);
@@ -80,10 +66,10 @@ static int ath9k_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 			bytes_read += max & 3UL;
 			memzero_explicit(&word, sizeof(word));
 		}
-		if (!wait || !max || likely(bytes_read) || fail_stats > 110)
+		if (!wait || !max || likely(bytes_read) || ++fail_stats >= 100 ||
+		    ((current->flags & PF_KTHREAD) && kthread_should_stop()) ||
+		    schedule_timeout_interruptible(HZ / 20))
 			break;
-
-		msleep_interruptible(ath9k_rng_delay_get(++fail_stats));
 	}
 
 	if (wait && !bytes_read && max)
-- 
2.35.1

