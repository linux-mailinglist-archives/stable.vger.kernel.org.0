Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE05A5581A6
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiFWRDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232971AbiFWRAh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:00:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70FF4F1C3;
        Thu, 23 Jun 2022 09:54:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4CE361F8D;
        Thu, 23 Jun 2022 16:54:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD217C341CC;
        Thu, 23 Jun 2022 16:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003248;
        bh=zKzsyeV+YUgO1OfzDfPItn2viW+5rIZVKooAhYmAh70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KNn8ic4rR/0EC0IrRAUx1DKDsToLJnIVcVJqhfclvnmpg8TmjXij3h0b3AlBE3P4R
         Q8tfpUNtijbCJWrVlcVcbFQxRGKpS3XqGz6D7ckh1Kj013jxzYzSuUQlsCYHyECxHI
         KSM68q9wMI+ADxkHFk93aRFGt6ZQA6QBKalnCLPU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Varho <jan.varho@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 170/264] random: do not split fast init input in add_hwgenerator_randomness()
Date:   Thu, 23 Jun 2022 18:42:43 +0200
Message-Id: <20220623164348.874095017@linuxfoundation.org>
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

From: Jan Varho <jan.varho@gmail.com>

commit 527a9867af29ff89f278d037db704e0ed50fb666 upstream.

add_hwgenerator_randomness() tries to only use the required amount of input
for fast init, but credits all the entropy, rather than a fraction of
it. Since it's hard to determine how much entropy is left over out of a
non-unformly random sample, either give it all to fast init or credit
it, but don't attempt to do both. In the process, we can clean up the
injection code to no longer need to return a value.

Signed-off-by: Jan Varho <jan.varho@gmail.com>
[Jason: expanded commit message]
Fixes: 73c7733f122e ("random: do not throw away excess input to crng_fast_load")
Cc: stable@vger.kernel.org # 5.17+, requires af704c856e88
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -438,11 +438,8 @@ static void crng_make_state(u32 chacha_s
  * This shouldn't be set by functions like add_device_randomness(),
  * where we can't trust the buffer passed to it is guaranteed to be
  * unpredictable (so it might not have any entropy at all).
- *
- * Returns the number of bytes processed from input, which is bounded
- * by CRNG_INIT_CNT_THRESH if account is true.
  */
-static size_t crng_pre_init_inject(const void *input, size_t len, bool account)
+static void crng_pre_init_inject(const void *input, size_t len, bool account)
 {
 	static int crng_init_cnt = 0;
 	struct blake2s_state hash;
@@ -453,18 +450,15 @@ static size_t crng_pre_init_inject(const
 	spin_lock_irqsave(&base_crng.lock, flags);
 	if (crng_init != 0) {
 		spin_unlock_irqrestore(&base_crng.lock, flags);
-		return 0;
+		return;
 	}
 
-	if (account)
-		len = min_t(size_t, len, CRNG_INIT_CNT_THRESH - crng_init_cnt);
-
 	blake2s_update(&hash, base_crng.key, sizeof(base_crng.key));
 	blake2s_update(&hash, input, len);
 	blake2s_final(&hash, base_crng.key);
 
 	if (account) {
-		crng_init_cnt += len;
+		crng_init_cnt += min_t(size_t, len, CRNG_INIT_CNT_THRESH - crng_init_cnt);
 		if (crng_init_cnt >= CRNG_INIT_CNT_THRESH) {
 			++base_crng.generation;
 			crng_init = 1;
@@ -475,8 +469,6 @@ static size_t crng_pre_init_inject(const
 
 	if (crng_init == 1)
 		pr_notice("fast init done\n");
-
-	return len;
 }
 
 static void _get_random_bytes(void *buf, size_t nbytes)
@@ -1134,12 +1126,9 @@ void add_hwgenerator_randomness(const vo
 				size_t entropy)
 {
 	if (unlikely(crng_init == 0 && entropy < POOL_MIN_BITS)) {
-		size_t ret = crng_pre_init_inject(buffer, count, true);
-		mix_pool_bytes(buffer, ret);
-		count -= ret;
-		buffer += ret;
-		if (!count || crng_init == 0)
-			return;
+		crng_pre_init_inject(buffer, count, true);
+		mix_pool_bytes(buffer, count);
+		return;
 	}
 
 	/*


