Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C583E551E64
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 16:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350446AbiFTODI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 10:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351375AbiFTNym (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:54:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB0B326CC;
        Mon, 20 Jun 2022 06:20:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A8A0B811A9;
        Mon, 20 Jun 2022 13:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E17C341C0;
        Mon, 20 Jun 2022 13:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655731256;
        bh=7JqZO4gBFyYGQRpAT08nVxEHFtLtSadDB5BiDeLTUY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=me0/BB5XquQAKfWZkcYQJAnWKrs4J9UTEx3B50ABcgVNHXtSvbjOkoOCsj+V2B113
         cjh4LX5vvA7uQ+XIpxjNnEPc9SDm/fxkQcENrwd41EhaXYE0N1Hw6TmWmDf7l1vV1Q
         ivfPVhiZY4DiVHTUkk9ulTc+gEssmCAuwQVB6W3c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 151/240] random: help compiler out with fast_mix() by using simpler arguments
Date:   Mon, 20 Jun 2022 14:50:52 +0200
Message-Id: <20220620124743.385298866@linuxfoundation.org>
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

commit 791332b3cbb080510954a4c152ce02af8832eac9 upstream.

Now that fast_mix() has more than one caller, gcc no longer inlines it.
That's fine. But it also doesn't handle the compound literal argument we
pass it very efficiently, nor does it handle the loop as well as it
could. So just expand the code to spell out this function so that it
generates the same code as it did before. Performance-wise, this now
behaves as it did before the last commit. The difference in actual code
size on x86 is 45 bytes, which is less than a cache line.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   44 +++++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 21 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1026,25 +1026,30 @@ static DEFINE_PER_CPU(struct fast_pool,
  * and therefore this has no security on its own. s represents the
  * four-word SipHash state, while v represents a two-word input.
  */
-static void fast_mix(unsigned long s[4], const unsigned long v[2])
+static void fast_mix(unsigned long s[4], unsigned long v1, unsigned long v2)
 {
-	size_t i;
-
-	for (i = 0; i < 2; ++i) {
-		s[3] ^= v[i];
 #ifdef CONFIG_64BIT
-		s[0] += s[1]; s[1] = rol64(s[1], 13); s[1] ^= s[0]; s[0] = rol64(s[0], 32);
-		s[2] += s[3]; s[3] = rol64(s[3], 16); s[3] ^= s[2];
-		s[0] += s[3]; s[3] = rol64(s[3], 21); s[3] ^= s[0];
-		s[2] += s[1]; s[1] = rol64(s[1], 17); s[1] ^= s[2]; s[2] = rol64(s[2], 32);
+#define PERM() do { \
+	s[0] += s[1]; s[1] = rol64(s[1], 13); s[1] ^= s[0]; s[0] = rol64(s[0], 32); \
+	s[2] += s[3]; s[3] = rol64(s[3], 16); s[3] ^= s[2]; \
+	s[0] += s[3]; s[3] = rol64(s[3], 21); s[3] ^= s[0]; \
+	s[2] += s[1]; s[1] = rol64(s[1], 17); s[1] ^= s[2]; s[2] = rol64(s[2], 32); \
+} while (0)
 #else
-		s[0] += s[1]; s[1] = rol32(s[1],  5); s[1] ^= s[0]; s[0] = rol32(s[0], 16);
-		s[2] += s[3]; s[3] = rol32(s[3],  8); s[3] ^= s[2];
-		s[0] += s[3]; s[3] = rol32(s[3],  7); s[3] ^= s[0];
-		s[2] += s[1]; s[1] = rol32(s[1], 13); s[1] ^= s[2]; s[2] = rol32(s[2], 16);
+#define PERM() do { \
+	s[0] += s[1]; s[1] = rol32(s[1],  5); s[1] ^= s[0]; s[0] = rol32(s[0], 16); \
+	s[2] += s[3]; s[3] = rol32(s[3],  8); s[3] ^= s[2]; \
+	s[0] += s[3]; s[3] = rol32(s[3],  7); s[3] ^= s[0]; \
+	s[2] += s[1]; s[1] = rol32(s[1], 13); s[1] ^= s[2]; s[2] = rol32(s[2], 16); \
+} while (0)
 #endif
-		s[0] ^= v[i];
-	}
+
+	s[3] ^= v1;
+	PERM();
+	s[0] ^= v1;
+	s[3] ^= v2;
+	PERM();
+	s[0] ^= v2;
 }
 
 #ifdef CONFIG_SMP
@@ -1114,10 +1119,8 @@ void add_interrupt_randomness(int irq)
 	struct pt_regs *regs = get_irq_regs();
 	unsigned int new_count;
 
-	fast_mix(fast_pool->pool, (unsigned long[2]){
-		entropy,
-		(regs ? instruction_pointer(regs) : _RET_IP_) ^ swab(irq)
-	});
+	fast_mix(fast_pool->pool, entropy,
+		 (regs ? instruction_pointer(regs) : _RET_IP_) ^ swab(irq));
 	new_count = ++fast_pool->count;
 
 	if (new_count & MIX_INFLIGHT)
@@ -1157,8 +1160,7 @@ static void add_timer_randomness(struct
 	 * sometime after, so mix into the fast pool.
 	 */
 	if (in_irq()) {
-		fast_mix(this_cpu_ptr(&irq_randomness)->pool,
-			 (unsigned long[2]){ entropy, num });
+		fast_mix(this_cpu_ptr(&irq_randomness)->pool, entropy, num);
 	} else {
 		spin_lock_irqsave(&input_pool.lock, flags);
 		_mix_pool_bytes(&entropy, sizeof(entropy));


