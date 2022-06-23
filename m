Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74267558073
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231714AbiFWQrQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232471AbiFWQqp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:46:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F42749B48;
        Thu, 23 Jun 2022 09:46:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 195F061F8B;
        Thu, 23 Jun 2022 16:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9A7C3411B;
        Thu, 23 Jun 2022 16:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002798;
        bh=W8dq3uMApTVef6GoyPpbGGEqhGowcse71vUYaDeYi34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JvA0GxQAAn+oCTuduJlfb76Bz9FKvWPsUPi1aDscGGB7Z5TJ4Rzdz9r3tl/E0M/Uq
         WycE3mcvNsLqok5kIZjjOGzPZdRk2DBqxCuwgEyNP1Sk2Z1hRHk0vrkO3ruhC8/wCN
         G7YAjdO99ArWa0AjH1B4IfGTBaFIFVlTsAFjl5JA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 029/264] drivers/char/random.c: remove unused dont_count_entropy
Date:   Thu, 23 Jun 2022 18:40:22 +0200
Message-Id: <20220623164344.893849680@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
References: <20220623164344.053938039@linuxfoundation.org>
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

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

commit 5e747dd9be54be190dd6ebeebf4a4a01ba765625 upstream.

Ever since "random: kill dead extract_state struct" [1], the
dont_count_entropy member of struct timer_rand_state has been
effectively unused. Since it hasn't found a new use in 12 years, it's
probably safe to finally kill it.

[1] Pre-git, https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git/commit/?id=c1c48e61c251f57e7a3f1bf11b3c462b2de9dcb5

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   55 +++++++++++++++++++++++---------------------------
 1 file changed, 26 insertions(+), 29 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1130,7 +1130,6 @@ static ssize_t extract_crng_user(void __
 struct timer_rand_state {
 	cycles_t last_time;
 	long last_delta, last_delta2;
-	unsigned dont_count_entropy:1;
 };
 
 #define INIT_TIMER_RAND_STATE { INITIAL_JIFFIES, };
@@ -1194,35 +1193,33 @@ static void add_timer_randomness(struct
 	 * We take into account the first, second and third-order deltas
 	 * in order to make our estimate.
 	 */
+	delta = sample.jiffies - state->last_time;
+	state->last_time = sample.jiffies;
+
+	delta2 = delta - state->last_delta;
+	state->last_delta = delta;
+
+	delta3 = delta2 - state->last_delta2;
+	state->last_delta2 = delta2;
+
+	if (delta < 0)
+		delta = -delta;
+	if (delta2 < 0)
+		delta2 = -delta2;
+	if (delta3 < 0)
+		delta3 = -delta3;
+	if (delta > delta2)
+		delta = delta2;
+	if (delta > delta3)
+		delta = delta3;
+
+	/*
+	 * delta is now minimum absolute delta.
+	 * Round down by 1 bit on general principles,
+	 * and limit entropy entimate to 12 bits.
+	 */
+	credit_entropy_bits(r, min_t(int, fls(delta>>1), 11));
 
-	if (!state->dont_count_entropy) {
-		delta = sample.jiffies - state->last_time;
-		state->last_time = sample.jiffies;
-
-		delta2 = delta - state->last_delta;
-		state->last_delta = delta;
-
-		delta3 = delta2 - state->last_delta2;
-		state->last_delta2 = delta2;
-
-		if (delta < 0)
-			delta = -delta;
-		if (delta2 < 0)
-			delta2 = -delta2;
-		if (delta3 < 0)
-			delta3 = -delta3;
-		if (delta > delta2)
-			delta = delta2;
-		if (delta > delta3)
-			delta = delta3;
-
-		/*
-		 * delta is now minimum absolute delta.
-		 * Round down by 1 bit on general principles,
-		 * and limit entropy entimate to 12 bits.
-		 */
-		credit_entropy_bits(r, min_t(int, fls(delta>>1), 11));
-	}
 	preempt_enable();
 }
 


