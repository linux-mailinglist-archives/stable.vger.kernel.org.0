Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 948B75582B6
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232729AbiFWRS4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232328AbiFWRQN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:16:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76DA6A1E15;
        Thu, 23 Jun 2022 09:59:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E74A6613F9;
        Thu, 23 Jun 2022 16:59:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD934C3411B;
        Thu, 23 Jun 2022 16:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003578;
        bh=HBIVGomVi6vkWGZrSgfeWMKrxWFtfvsKNC1dty2ecVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2lOT/PGhHS52j5U8W+0/fuByil2UpbCgRB1pneRbB84Tgot+Fi+AFzUdxGEFmJOQK
         /H1c41SibjuYt8VxyEIyfLbB2QzgEDua09jPF6d4Q8a3ywePFSwigUzWcDcTzr4BHy
         QOl0dpuhKWqXGP7JzylQjKjjfWpYcPkDDui7Ol9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keerthy <j-keerthy@ti.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 020/237] random: Support freezable kthreads in add_hwgenerator_randomness()
Date:   Thu, 23 Jun 2022 18:40:54 +0200
Message-Id: <20220623164343.734920585@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.132308638@linuxfoundation.org>
References: <20220623164343.132308638@linuxfoundation.org>
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

From: Stephen Boyd <swboyd@chromium.org>

commit ff296293b3538d19278a7f7cd1f3aa600ad9164c upstream.

The kthread calling this function is freezable after commit 03a3bb7ae631
("hwrng: core - Freeze khwrng thread during suspend") is applied.
Unfortunately, this function uses wait_event_interruptible() but doesn't
check for the kthread being woken up by the fake freezer signal. When a
user suspends the system, this kthread will wake up and if it fails the
entropy size check it will immediately go back to sleep and not go into
the freezer. Eventually, suspend will fail because the task never froze
and a warning message like this may appear:

 PM: suspend entry (deep)
 Filesystems sync: 0.000 seconds
 Freezing user space processes ... (elapsed 0.001 seconds) done.
 OOM killer disabled.
 Freezing remaining freezable tasks ...
 Freezing of tasks failed after 20.003 seconds (1 tasks refusing to freeze, wq_busy=0):
 hwrng           R  running task        0   289      2 0x00000020
 [<c08c64c4>] (__schedule) from [<c08c6a10>] (schedule+0x3c/0xc0)
 [<c08c6a10>] (schedule) from [<c05dbd8c>] (add_hwgenerator_randomness+0xb0/0x100)
 [<c05dbd8c>] (add_hwgenerator_randomness) from [<bf1803c8>] (hwrng_fillfn+0xc0/0x14c [rng_core])
 [<bf1803c8>] (hwrng_fillfn [rng_core]) from [<c015abec>] (kthread+0x134/0x148)
 [<c015abec>] (kthread) from [<c01010e8>] (ret_from_fork+0x14/0x2c)

Check for a freezer signal here and skip adding any randomness if the
task wakes up because it was frozen. This should make the kthread freeze
properly and suspend work again.

Fixes: 03a3bb7ae631 ("hwrng: core - Freeze khwrng thread during suspend")
Reported-by: Keerthy <j-keerthy@ti.com>
Tested-by: Keerthy <j-keerthy@ti.com>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -2420,6 +2420,7 @@ void add_hwgenerator_randomness(const ch
 				size_t entropy)
 {
 	struct entropy_store *poolp = &input_pool;
+	bool frozen = false;
 
 	if (unlikely(crng_init == 0)) {
 		crng_fast_load(buffer, count);
@@ -2430,9 +2431,12 @@ void add_hwgenerator_randomness(const ch
 	 * We'll be woken up again once below random_write_wakeup_thresh,
 	 * or when the calling thread is about to terminate.
 	 */
-	wait_event_interruptible(random_write_wait, kthread_should_stop() ||
+	wait_event_interruptible(random_write_wait,
+			kthread_freezable_should_stop(&frozen) ||
 			ENTROPY_BITS(&input_pool) <= random_write_wakeup_bits);
-	mix_pool_bytes(poolp, buffer, count);
-	credit_entropy_bits(poolp, entropy);
+	if (!frozen) {
+		mix_pool_bytes(poolp, buffer, count);
+		credit_entropy_bits(poolp, entropy);
+	}
 }
 EXPORT_SYMBOL_GPL(add_hwgenerator_randomness);


