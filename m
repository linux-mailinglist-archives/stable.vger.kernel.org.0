Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55A1F4FB5D2
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 10:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234718AbiDKIVP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 04:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343691AbiDKIVK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 04:21:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A32A3E0F5
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 01:18:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C6F3614A8
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 08:18:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF3CC385B9;
        Mon, 11 Apr 2022 08:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649665124;
        bh=5nNkz3Nfkj5nihmY6ugEbSJBfpjpDYQ1vJqlzCOlM1s=;
        h=Subject:To:Cc:From:Date:From;
        b=1IyEmZI/1kEDCDE8JTqmbZHhoxjgGZdUV+Ho0YgFmJiV3gWgGP3RiXB+hkYJPQzs3
         iKfi8KnlnPZUyG1nvsUlu2mgGs4sllSO4SB+VvDn8y8vmwQ/9Qdf+HcZmZYh73l8Ca
         vcjY6uEIRhzkDC1SYQILjxccWLzx+ijdKfQ6nbzA=
Subject: FAILED: patch "[PATCH] random: do not split fast init input in" failed to apply to 5.17-stable tree
To:     jan.varho@gmail.com, Jason@zx2c4.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Apr 2022 10:18:42 +0200
Message-ID: <164966512212636@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.17-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 527a9867af29ff89f278d037db704e0ed50fb666 Mon Sep 17 00:00:00 2001
From: Jan Varho <jan.varho@gmail.com>
Date: Mon, 4 Apr 2022 19:42:30 +0300
Subject: [PATCH] random: do not split fast init input in
 add_hwgenerator_randomness()

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

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 1d8242969751..ee3ad2ba0942 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -437,11 +437,8 @@ static void crng_make_state(u32 chacha_state[CHACHA_STATE_WORDS],
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
@@ -452,18 +449,15 @@ static size_t crng_pre_init_inject(const void *input, size_t len, bool account)
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
@@ -474,8 +468,6 @@ static size_t crng_pre_init_inject(const void *input, size_t len, bool account)
 
 	if (crng_init == 1)
 		pr_notice("fast init done\n");
-
-	return len;
 }
 
 static void _get_random_bytes(void *buf, size_t nbytes)
@@ -1141,12 +1133,9 @@ void add_hwgenerator_randomness(const void *buffer, size_t count,
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

