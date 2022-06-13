Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E52E548A68
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380805AbiFMOG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381242AbiFMOEN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:04:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5909157C;
        Mon, 13 Jun 2022 04:38:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A2E560B6E;
        Mon, 13 Jun 2022 11:38:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DFA6C34114;
        Mon, 13 Jun 2022 11:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120339;
        bh=gXTEpPeId4ZlzGs8pHsDB6a7db58EDOdd6nXdpvtzYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X4guPvLNo3eWW5nKSFj1O1ZHVv0X3XXPig+Hlo6kd0VPk+pHU9cuFB7ZJ3B6ntCV6
         vAtjr+m2Yj3W531/VvPmVCyTCJN7mfAh5fnPg2lXZN3WW34xGYwrfgrikf5k+MY75k
         U+jPIdlP5ol0Wum8f5Fto5Uk9hZJERxbBdK0M2pY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.18 337/339] random: account for arch randomness in bits
Date:   Mon, 13 Jun 2022 12:12:42 +0200
Message-Id: <20220613094936.953753352@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 77fc95f8c0dc9e1f8e620ec14d2fb65028fb7adc upstream.

Rather than accounting in bytes and multiplying (shifting), we can just
account in bits and avoid the shift. The main motivation for this is
there are other patches in flux that expand this code a bit, and
avoiding the duplication of "* 8" everywhere makes things a bit clearer.

Cc: stable@vger.kernel.org
Fixes: 12e45a2a6308 ("random: credit architectural init the exact amount")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -817,7 +817,7 @@ early_param("random.trust_bootloader", p
 int __init random_init(const char *command_line)
 {
 	ktime_t now = ktime_get_real();
-	unsigned int i, arch_bytes;
+	unsigned int i, arch_bits;
 	unsigned long entropy;
 
 #if defined(LATENT_ENTROPY_PLUGIN)
@@ -825,12 +825,12 @@ int __init random_init(const char *comma
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
@@ -842,7 +842,7 @@ int __init random_init(const char *comma
 	if (crng_ready())
 		crng_reseed();
 	else if (trust_cpu)
-		_credit_init_bits(arch_bytes * 8);
+		_credit_init_bits(arch_bits);
 
 	return 0;
 }


