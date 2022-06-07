Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A018653612C
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 14:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241297AbiE0L5I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353054AbiE0L4J (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:56:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F56D14CA0E;
        Fri, 27 May 2022 04:49:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A535FB8091D;
        Fri, 27 May 2022 11:49:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12ED8C385A9;
        Fri, 27 May 2022 11:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653652175;
        bh=Ll8VB7zcS546EdeqPpDbCytInxlMVmtoBs8Refp006I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GzuyzXuTIB8NuicAUawtMtiblZkq3+SdmWIvkmBFr4v/fzB1MJeo5RnySG582vSox
         qA1LBRjBnjTYBso3grTQTZPFT6NPqxQudcR+t1AcIM1PdHrP53Rr5v7WQjWlxZngKQ
         yPn3h7acyfaMPhFgv7TYeZB9QlkuLo3RDjewt2cA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Varho <jan.varho@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.15 095/145] random: do not split fast init input in add_hwgenerator_randomness()
Date:   Fri, 27 May 2022 10:49:56 +0200
Message-Id: <20220527084902.216336594@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084850.364560116@linuxfoundation.org>
References: <20220527084850.364560116@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -439,11 +439,8 @@ static void crng_make_state(u32 chacha_s
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
@@ -454,18 +451,15 @@ static size_t crng_pre_init_inject(const
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
@@ -476,8 +470,6 @@ static size_t crng_pre_init_inject(const
 
 	if (crng_init == 1)
 		pr_notice("fast init done\n");
-
-	return len;
 }
 
 static void _get_random_bytes(void *buf, size_t nbytes)
@@ -1138,12 +1130,9 @@ void add_hwgenerator_randomness(const vo
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


