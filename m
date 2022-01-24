Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 277B0499F52
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1841018AbiAXW5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:57:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1579202AbiAXWFM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:05:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D984C0C6857;
        Mon, 24 Jan 2022 12:42:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBBF6B80FA3;
        Mon, 24 Jan 2022 20:42:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DAD2C36B08;
        Mon, 24 Jan 2022 20:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056932;
        bh=OBTuXiREeeRTt0kQKSBldCdfbCJ4bnAco+QXL8c1owQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ikCY4LB1Dd2Ljc8C4jq+uDk5yWLB6G0uJ0mBY3kWcA4s/gJwxnz8COLbtHYddgOVK
         q5AkxZP1ScdUn+lPHW5ArkNdAmAaLGOjHGTX/dmFzEG1+elowkjmvfDDtfVcUpvssx
         PnKuwL3WUwHEcvzJz4GVhayWkOZvyjstoVLomMmE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 614/846] random: do not throw away excess input to crng_fast_load
Date:   Mon, 24 Jan 2022 19:42:11 +0100
Message-Id: <20220124184122.222730672@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

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
index 7470ee24db2f9..a27ae3999ff32 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -912,12 +912,14 @@ static struct crng_state *select_crng(void)
 
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
@@ -928,7 +930,7 @@ static int crng_fast_load(const char *cp, size_t len)
 	p = (unsigned char *) &primary_crng.state[4];
 	while (len > 0 && crng_init_cnt < CRNG_INIT_CNT_THRESH) {
 		p[crng_init_cnt % CHACHA_KEY_SIZE] ^= *cp;
-		cp++; crng_init_cnt++; len--;
+		cp++; crng_init_cnt++; len--; ret++;
 	}
 	spin_unlock_irqrestore(&primary_crng.lock, flags);
 	if (crng_init_cnt >= CRNG_INIT_CNT_THRESH) {
@@ -936,7 +938,7 @@ static int crng_fast_load(const char *cp, size_t len)
 		crng_init = 1;
 		pr_notice("fast init done\n");
 	}
-	return 1;
+	return ret;
 }
 
 /*
@@ -1287,7 +1289,7 @@ void add_interrupt_randomness(int irq, int irq_flags)
 	if (unlikely(crng_init == 0)) {
 		if ((fast_pool->count >= 64) &&
 		    crng_fast_load((char *) fast_pool->pool,
-				   sizeof(fast_pool->pool))) {
+				   sizeof(fast_pool->pool)) > 0) {
 			fast_pool->count = 0;
 			fast_pool->last = now;
 		}
@@ -2295,8 +2297,11 @@ void add_hwgenerator_randomness(const char *buffer, size_t count,
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



