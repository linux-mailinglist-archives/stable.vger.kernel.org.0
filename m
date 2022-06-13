Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDB64547FB5
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 08:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbiFMGpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 02:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237234AbiFMGpN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 02:45:13 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E069FD34
        for <stable@vger.kernel.org>; Sun, 12 Jun 2022 23:45:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 739BDCE0F55
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 06:45:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA9EC34114;
        Mon, 13 Jun 2022 06:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655102708;
        bh=ROkQ8+Kgfhbp+JrMlUWtJdMAtklVms887Ba0XVzKdbs=;
        h=Subject:To:Cc:From:Date:From;
        b=b369WvA1IkW8BIwJT8IppTkZlvnBmFEeSKWt4KA3zfu25CqVNslrjtU9mlTem5V23
         k6UcM+vUUsl5bi9hd72UN9UUFExUR0ZYdurbe/x2JcgKlPW4s62l65BLYqg/YTrCfK
         GDKcrRR1rsxJ2c4bNiflFFIxv8CRQFiSecb/4NbI=
Subject: FAILED: patch "[PATCH] random: account for arch randomness in bits" failed to apply to 5.15-stable tree
To:     Jason@zx2c4.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Jun 2022 08:44:53 +0200
Message-ID: <1655102693128152@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 77fc95f8c0dc9e1f8e620ec14d2fb65028fb7adc Mon Sep 17 00:00:00 2001
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue, 7 Jun 2022 17:04:38 +0200
Subject: [PATCH] random: account for arch randomness in bits

Rather than accounting in bytes and multiplying (shifting), we can just
account in bits and avoid the shift. The main motivation for this is
there are other patches in flux that expand this code a bit, and
avoiding the duplication of "* 8" everywhere makes things a bit clearer.

Cc: stable@vger.kernel.org
Fixes: 12e45a2a6308 ("random: credit architectural init the exact amount")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 0d6fb3eaf609..60d701a2516b 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -776,7 +776,7 @@ static struct notifier_block pm_notifier = { .notifier_call = random_pm_notifica
 int __init random_init(const char *command_line)
 {
 	ktime_t now = ktime_get_real();
-	unsigned int i, arch_bytes;
+	unsigned int i, arch_bits;
 	unsigned long entropy;
 
 #if defined(LATENT_ENTROPY_PLUGIN)
@@ -784,12 +784,12 @@ int __init random_init(const char *command_line)
 	_mix_pool_bytes(compiletime_seed, sizeof(compiletime_seed));
 #endif
 
-	for (i = 0, arch_bytes = BLAKE2S_BLOCK_SIZE;
+	for (i = 0, arch_bits = BLAKE2S_BLOCK_SIZE * 8;
 	     i < BLAKE2S_BLOCK_SIZE; i += sizeof(entropy)) {
 		if (!arch_get_random_seed_long_early(&entropy) &&
 		    !arch_get_random_long_early(&entropy)) {
 			entropy = random_get_entropy();
-			arch_bytes -= sizeof(entropy);
+			arch_bits -= sizeof(entropy) * 8;
 		}
 		_mix_pool_bytes(&entropy, sizeof(entropy));
 	}
@@ -801,8 +801,8 @@ int __init random_init(const char *command_line)
 	if (crng_ready())
 		crng_reseed();
 	else if (trust_cpu)
-		_credit_init_bits(arch_bytes * 8);
-	used_arch_random = arch_bytes * 8 >= POOL_READY_BITS;
+		_credit_init_bits(arch_bits);
+	used_arch_random = arch_bits >= POOL_READY_BITS;
 
 	WARN_ON(register_pm_notifier(&pm_notifier));
 

