Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B589491ADA
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344143AbiARDDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:03:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353208AbiARDBV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 22:01:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 044B3C08E87E;
        Mon, 17 Jan 2022 18:46:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA0EF61312;
        Tue, 18 Jan 2022 02:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91514C36AF6;
        Tue, 18 Jan 2022 02:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474016;
        bh=qtr5avAJSnRhKUpyTvJyRJlGaOx2L1q0VJR95o+tj7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oJW2z5s3tjKgp6MQNWUoot/x3Keo+6zMh5yWB0N46pMEVkqJ46ECYEePkmKTxB3vi
         gh9GPy0L8UKaGSifrhhyUBItAnOs0lQdwB7BpdVnyV2pAtq8Z2ed/JMfpazPQcctyH
         xPtM2dp0qlG3SJBgcY11WxLdvMINEkEHTJNh38/yPWJm98Bk5A6NIrzM3UXb1ZUoQ4
         8stgmbGVjvro69R/XdKRCb5SCzVyEiX6/jsmix9DALiXM4L15zA/TOM9z7vWbr5PsO
         PqTgc445u8I4kg+QlQ+3gVlpN2j9OvY97Edf1YkQTbBxl9PoLqf2F4EVCCXPZk34dV
         SIZWM2rwqQUrg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Sasha Levin <sashal@kernel.org>, tytso@mit.edu
Subject: [PATCH AUTOSEL 5.4 72/73] random: do not throw away excess input to crng_fast_load
Date:   Mon, 17 Jan 2022 21:44:31 -0500
Message-Id: <20220118024432.1952028-72-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024432.1952028-1-sashal@kernel.org>
References: <20220118024432.1952028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

[ Upstream commit 73c7733f122e8d0107f88655a12011f68f69e74b ]

When crng_fast_load() is called by add_hwgenerator_randomness(), we
currently will advance to crng_init==1 once we've acquired 64 bytes, and
then throw away the rest of the buffer. Usually, that is not a problem:
When add_hwgenerator_randomness() gets called via EFI or DT during
setup_arch(), there won't be any IRQ randomness. Therefore, the 64 bytes
passed by EFI exactly matches what is needed to advance to crng_init==1.
Usually, DT seems to pass 64 bytes as well -- with one notable exception
being kexec, which hands over 128 bytes of entropy to the kexec'd kernel.
In that case, we'll advance to crng_init==1 once 64 of those bytes are
consumed by crng_fast_load(), but won't continue onward feeding in bytes
to progress to crng_init==2. This commit fixes the issue by feeding
any leftover bytes into the next phase in add_hwgenerator_randomness().

[linux@dominikbrodowski.net: rewrite commit message]
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/random.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index ffd61aadb7614..a094704033062 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -924,12 +924,14 @@ static void numa_crng_init(void) {}
 
 /*
  * crng_fast_load() can be called by code in the interrupt service
- * path.  So we can't afford to dilly-dally.
+ * path.  So we can't afford to dilly-dally. Returns the number of
+ * bytes processed from cp.
  */
-static int crng_fast_load(const char *cp, size_t len)
+static size_t crng_fast_load(const char *cp, size_t len)
 {
 	unsigned long flags;
 	char *p;
+	size_t ret = 0;
 
 	if (!spin_trylock_irqsave(&primary_crng.lock, flags))
 		return 0;
@@ -940,7 +942,7 @@ static int crng_fast_load(const char *cp, size_t len)
 	p = (unsigned char *) &primary_crng.state[4];
 	while (len > 0 && crng_init_cnt < CRNG_INIT_CNT_THRESH) {
 		p[crng_init_cnt % CHACHA_KEY_SIZE] ^= *cp;
-		cp++; crng_init_cnt++; len--;
+		cp++; crng_init_cnt++; len--; ret++;
 	}
 	spin_unlock_irqrestore(&primary_crng.lock, flags);
 	if (crng_init_cnt >= CRNG_INIT_CNT_THRESH) {
@@ -949,7 +951,7 @@ static int crng_fast_load(const char *cp, size_t len)
 		wake_up_interruptible(&crng_init_wait);
 		pr_notice("random: fast init done\n");
 	}
-	return 1;
+	return ret;
 }
 
 /*
@@ -1334,7 +1336,7 @@ void add_interrupt_randomness(int irq, int irq_flags)
 	if (unlikely(crng_init == 0)) {
 		if ((fast_pool->count >= 64) &&
 		    crng_fast_load((char *) fast_pool->pool,
-				   sizeof(fast_pool->pool))) {
+				   sizeof(fast_pool->pool)) > 0) {
 			fast_pool->count = 0;
 			fast_pool->last = now;
 		}
@@ -2480,8 +2482,11 @@ void add_hwgenerator_randomness(const char *buffer, size_t count,
 	struct entropy_store *poolp = &input_pool;
 
 	if (unlikely(crng_init == 0)) {
-		crng_fast_load(buffer, count);
-		return;
+		size_t ret = crng_fast_load(buffer, count);
+		count -= ret;
+		buffer += ret;
+		if (!count || crng_init == 0)
+			return;
 	}
 
 	/* Suspend writing if we're above the trickle threshold.
-- 
2.34.1

