Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D77E551C3B
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347018AbiFTNkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347743AbiFTNiv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:38:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A86289A0;
        Mon, 20 Jun 2022 06:14:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D41660A21;
        Mon, 20 Jun 2022 13:14:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C56C3411B;
        Mon, 20 Jun 2022 13:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730863;
        bh=bLrhEzyvIal2sDn4qUZktif14Nf2K0HpX6+iuLCe2uw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VwUD2hG12KXS/fDMBOIth/M5/ntmo+vOcHFjC+ODwnNbqgyPfTpWpBCWk62OU+/SM
         5XJSSxCTS8wGp6v4Mwr/He7l1LTobDtRoifzx2yOG8fasL0q+d+iMgQh0Yhz0gs5mW
         rb0x+CFKrSLzwrsl1MizBjaxeIJxHI97XudD/VC0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 080/240] random: use hash function for crng_slow_load()
Date:   Mon, 20 Jun 2022 14:49:41 +0200
Message-Id: <20220620124741.078716212@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 66e4c2b9541503d721e936cc3898c9f25f4591ff upstream.

Since we have a hash function that's really fast, and the goal of
crng_slow_load() is reportedly to "touch all of the crng's state", we
can just hash the old state together with the new state and call it a
day. This way we dont need to reason about another LFSR or worry about
various attacks there. This code is only ever used at early boot and
then never again.

Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   40 ++++++++++++++--------------------------
 1 file changed, 14 insertions(+), 26 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -475,42 +475,30 @@ static size_t crng_fast_load(const u8 *c
  * all), and (2) it doesn't have the performance constraints of
  * crng_fast_load().
  *
- * So we do something more comprehensive which is guaranteed to touch
- * all of the primary_crng's state, and which uses a LFSR with a
- * period of 255 as part of the mixing algorithm.  Finally, we do
- * *not* advance crng_init_cnt since buffer we may get may be something
- * like a fixed DMI table (for example), which might very well be
- * unique to the machine, but is otherwise unvarying.
+ * So, we simply hash the contents in with the current key. Finally,
+ * we do *not* advance crng_init_cnt since buffer we may get may be
+ * something like a fixed DMI table (for example), which might very
+ * well be unique to the machine, but is otherwise unvarying.
  */
-static int crng_slow_load(const u8 *cp, size_t len)
+static void crng_slow_load(const u8 *cp, size_t len)
 {
 	unsigned long flags;
-	static u8 lfsr = 1;
-	u8 tmp;
-	unsigned int i, max = sizeof(base_crng.key);
-	const u8 *src_buf = cp;
-	u8 *dest_buf = base_crng.key;
+	struct blake2s_state hash;
+
+	blake2s_init(&hash, sizeof(base_crng.key));
 
 	if (!spin_trylock_irqsave(&base_crng.lock, flags))
-		return 0;
+		return;
 	if (crng_init != 0) {
 		spin_unlock_irqrestore(&base_crng.lock, flags);
-		return 0;
+		return;
 	}
-	if (len > max)
-		max = len;
 
-	for (i = 0; i < max; i++) {
-		tmp = lfsr;
-		lfsr >>= 1;
-		if (tmp & 1)
-			lfsr ^= 0xE1;
-		tmp = dest_buf[i % sizeof(base_crng.key)];
-		dest_buf[i % sizeof(base_crng.key)] ^= src_buf[i % len] ^ lfsr;
-		lfsr += (tmp << 3) | (tmp >> 5);
-	}
+	blake2s_update(&hash, base_crng.key, sizeof(base_crng.key));
+	blake2s_update(&hash, cp, len);
+	blake2s_final(&hash, base_crng.key);
+
 	spin_unlock_irqrestore(&base_crng.lock, flags);
-	return 1;
 }
 
 static void crng_reseed(void)


