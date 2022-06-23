Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89D7D55835D
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbiFWR3k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbiFWR0y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:26:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B51C63;
        Thu, 23 Jun 2022 10:02:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9693F60AD7;
        Thu, 23 Jun 2022 17:02:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D197C3411B;
        Thu, 23 Jun 2022 17:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003775;
        bh=1gYXjOiQ/z90nRzb8U321OxJ4EeK2vYVDyO9CPVnJcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=McXGMqJrZb02GoXnVYQXzULIKIRziPG1RyAmBmQSPy00c/uPxIj6XhLqfmHR2WmSY
         xQsXobWJBh4JxOV9JRvpPgn+T85yIuAzPTzrNT900rAITPJMKt7txGBAcgiwvjs/yo
         7RxvP5cjOuq8ziC737ZU32RG6a5aBwtNgw/TE/pI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 082/237] random: cleanup fractional entropy shift constants
Date:   Thu, 23 Jun 2022 18:41:56 +0200
Message-Id: <20220623164345.511013966@linuxfoundation.org>
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

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 18263c4e8e62f7329f38f5eadc568751242ca89c upstream.

The entropy estimator is calculated in terms of 1/8 bits, which means
there are various constants where things are shifted by 3. Move these
into our pool info enum with the other relevant constants. While we're
at it, move an English assertion about sizes into a proper BUILD_BUG_ON
so that the compiler can ensure this invariant.

Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -359,16 +359,6 @@
 /* #define ADD_INTERRUPT_BENCH */
 
 /*
- * To allow fractional bits to be tracked, the entropy_count field is
- * denominated in units of 1/8th bits.
- *
- * 2*(POOL_ENTROPY_SHIFT + poolbitshift) must <= 31, or the multiply in
- * credit_entropy_bits() needs to be 64 bits wide.
- */
-#define POOL_ENTROPY_SHIFT 3
-#define POOL_ENTROPY_BITS() (input_pool.entropy_count >> POOL_ENTROPY_SHIFT)
-
-/*
  * If the entropy count falls under this number of bits, then we
  * should wake up processes which are selecting or polling on write
  * access to /dev/random.
@@ -425,8 +415,13 @@ enum poolinfo {
 	POOL_WORDMASK = POOL_WORDS - 1,
 	POOL_BYTES = POOL_WORDS * sizeof(u32),
 	POOL_BITS = POOL_BYTES * 8,
-	POOL_BITSHIFT = ilog2(POOL_WORDS) + 5,
-	POOL_FRACBITS = POOL_WORDS << (POOL_ENTROPY_SHIFT + 5),
+	POOL_BITSHIFT = ilog2(POOL_BITS),
+
+	/* To allow fractional bits to be tracked, the entropy_count field is
+	 * denominated in units of 1/8th bits. */
+	POOL_ENTROPY_SHIFT = 3,
+#define POOL_ENTROPY_BITS() (input_pool.entropy_count >> POOL_ENTROPY_SHIFT)
+	POOL_FRACBITS = POOL_BITS << POOL_ENTROPY_SHIFT,
 
 	/* x^128 + x^104 + x^76 + x^51 +x^25 + x + 1 */
 	POOL_TAP1 = 104,
@@ -652,6 +647,9 @@ static void credit_entropy_bits(int nbit
 	int entropy_count, entropy_bits, orig;
 	int nfrac = nbits << POOL_ENTROPY_SHIFT;
 
+	/* Ensure that the multiplication can avoid being 64 bits wide. */
+	BUILD_BUG_ON(2 * (POOL_ENTROPY_SHIFT + POOL_BITSHIFT) > 31);
+
 	if (!nbits)
 		return;
 
@@ -687,13 +685,13 @@ retry:
 		/* The +2 corresponds to the /4 in the denominator */
 
 		do {
-			unsigned int anfrac = min(pnfrac, POOL_FRACBITS/2);
+			unsigned int anfrac = min(pnfrac, POOL_FRACBITS / 2);
 			unsigned int add =
-				((POOL_FRACBITS - entropy_count)*anfrac*3) >> s;
+				((POOL_FRACBITS - entropy_count) * anfrac * 3) >> s;
 
 			entropy_count += add;
 			pnfrac -= anfrac;
-		} while (unlikely(entropy_count < POOL_FRACBITS-2 && pnfrac));
+		} while (unlikely(entropy_count < POOL_FRACBITS - 2 && pnfrac));
 	}
 
 	if (WARN_ON(entropy_count < 0)) {


