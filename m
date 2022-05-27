Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B641536160
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 14:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345398AbiE0MBk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 08:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352775AbiE0MA4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 08:00:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26107340DB;
        Fri, 27 May 2022 04:52:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D045161DCD;
        Fri, 27 May 2022 11:52:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0701C385A9;
        Fri, 27 May 2022 11:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653652371;
        bh=D9xC7tn6/OQ/5iRy4mlmzda2gCcLi44NCVnSzSSRzbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jh+pSbf4WbN8BaotTd29eXtq1ccc19qo4mUSUh2QPUphrRHvkFsQtRgOWbND2znm9
         EsqI4c3PJo6yprVWSjaHoSJ9m7HI+PlJgIHsqpbMH2cqVgacLpcke8CfShdMEI7wta
         DUVvfr0lBGvzmaw64B+Mzjy1ZlkoYAym8s8w9dSQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 143/163] random: help compiler out with fast_mix() by using simpler arguments
Date:   Fri, 27 May 2022 10:50:23 +0200
Message-Id: <20220527084848.194523755@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084828.156494029@linuxfoundation.org>
References: <20220527084828.156494029@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
@@ -1031,25 +1031,30 @@ static DEFINE_PER_CPU(struct fast_pool,
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
@@ -1119,10 +1124,8 @@ void add_interrupt_randomness(int irq)
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
@@ -1162,8 +1165,7 @@ static void add_timer_randomness(struct
 	 * sometime after, so mix into the fast pool.
 	 */
 	if (in_irq()) {
-		fast_mix(this_cpu_ptr(&irq_randomness)->pool,
-			 (unsigned long[2]){ entropy, num });
+		fast_mix(this_cpu_ptr(&irq_randomness)->pool, entropy, num);
 	} else {
 		spin_lock_irqsave(&input_pool.lock, flags);
 		_mix_pool_bytes(&entropy, sizeof(entropy));


