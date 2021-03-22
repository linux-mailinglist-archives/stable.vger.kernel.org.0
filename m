Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34F9B343829
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 06:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbhCVFJ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 01:09:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:43464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229746AbhCVFJK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 01:09:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 764F261924;
        Mon, 22 Mar 2021 05:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616389749;
        bh=suu6mNgZOnCVzT4QdfXxKiTmiuK9LXZ9LoMgZcHk18E=;
        h=From:To:Cc:Subject:Date:From;
        b=gLz7Xtd5o8gAf/yYS3Rq871q7SEsl094SNnIakhVstMUZ+VTIT6EDGoYHe3g2NA/W
         34XzyoUzAd37m+T9c1FPbMiM5afPN0ByKudacVzlJgtFVL9B1yv7Z7Zuz3qxgIW4cL
         LcVe7CMejgAgZkrCTGWcXvolYVlFf6UMOwKASz7xhPrn8hNTPKQzu0TCshZZaj2udB
         ajztQZ1TzHvOdUv0AXod+toMMIOpB25tKHmIPApUV85+0Bl9/IfX17F+f626RMR2NX
         DuILuyjApAfRvAoZi+FgZZIr5p1K2FIsDmZpm0RPoqsDPDwdAY9XO7va2p2J0t183Y
         EznsgilmRneQg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Corentin Labbe <clabbe@baylibre.com>, stable@vger.kernel.org
Subject: [PATCH] crypto: rng - fix crypto_rng_reset() refcounting when !CRYPTO_STATS
Date:   Sun, 21 Mar 2021 22:07:48 -0700
Message-Id: <20210322050748.265604-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

crypto_stats_get() is a no-op when the kernel is compiled without
CONFIG_CRYPTO_STATS, so pairing it with crypto_alg_put() unconditionally
(as crypto_rng_reset() does) is wrong.

Fix this by moving the call to crypto_stats_get() to just before the
actual algorithm operation which might need it.  This makes it always
paired with crypto_stats_rng_seed().

Fixes: eed74b3eba9e ("crypto: rng - Fix a refcounting bug in crypto_rng_reset()")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/rng.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/crypto/rng.c b/crypto/rng.c
index a888d84b524a4..fea082b25fe4b 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -34,22 +34,18 @@ int crypto_rng_reset(struct crypto_rng *tfm, const u8 *seed, unsigned int slen)
 	u8 *buf = NULL;
 	int err;
 
-	crypto_stats_get(alg);
 	if (!seed && slen) {
 		buf = kmalloc(slen, GFP_KERNEL);
-		if (!buf) {
-			crypto_alg_put(alg);
+		if (!buf)
 			return -ENOMEM;
-		}
 
 		err = get_random_bytes_wait(buf, slen);
-		if (err) {
-			crypto_alg_put(alg);
+		if (err)
 			goto out;
-		}
 		seed = buf;
 	}
 
+	crypto_stats_get(alg);
 	err = crypto_rng_alg(tfm)->seed(tfm, seed, slen);
 	crypto_stats_rng_seed(alg, err);
 out:
-- 
2.31.0

