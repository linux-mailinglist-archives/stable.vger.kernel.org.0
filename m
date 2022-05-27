Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB59E53601B
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350774AbiE0Lqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352214AbiE0Lpe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:45:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F200146418;
        Fri, 27 May 2022 04:42:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE57EB824D6;
        Fri, 27 May 2022 11:42:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D457C385A9;
        Fri, 27 May 2022 11:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651731;
        bh=xAuCzTVviPXxJnAdM360P/oOekOpa2tGjcl+YzLgXvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F85pgKrbbe/Z7aD7Xmy/StRnVkm6KeX6BZaAdK+mJPgsZ+iVTjTJTvbBD9BJDs9cR
         hj0ocdgAbIGlXhljoc/ng7NRetz/PwBg7Bk4h+83bG9VVI28/IccfgQ/eBh1w3wtVn
         vwkyUa2VghyNd0IJ12iqGkpZ0cw/IBdJAWzzkaG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: [PATCH 5.10 053/163] random: continually use hwgenerator randomness
Date:   Fri, 27 May 2022 10:48:53 +0200
Message-Id: <20220527084835.417374878@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084828.156494029@linuxfoundation.org>
References: <20220527084828.156494029@linuxfoundation.org>
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

From: Dominik Brodowski <linux@dominikbrodowski.net>

commit c321e907aa4803d562d6e70ebed9444ad082f953 upstream.

The rngd kernel thread may sleep indefinitely if the entropy count is
kept above random_write_wakeup_bits by other entropy sources. To make
best use of multiple sources of randomness, mix entropy from hardware
RNGs into the pool at least once within CRNG_RESEED_INTERVAL.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -2198,13 +2198,15 @@ void add_hwgenerator_randomness(const ch
 			return;
 	}
 
-	/* Suspend writing if we're above the trickle threshold.
+	/* Throttle writing if we're above the trickle threshold.
 	 * We'll be woken up again once below random_write_wakeup_thresh,
-	 * or when the calling thread is about to terminate.
+	 * when the calling thread is about to terminate, or once
+	 * CRNG_RESEED_INTERVAL has lapsed.
 	 */
-	wait_event_interruptible(random_write_wait,
+	wait_event_interruptible_timeout(random_write_wait,
 			!system_wq || kthread_should_stop() ||
-			POOL_ENTROPY_BITS() <= random_write_wakeup_bits);
+			POOL_ENTROPY_BITS() <= random_write_wakeup_bits,
+			CRNG_RESEED_INTERVAL);
 	mix_pool_bytes(buffer, count);
 	credit_entropy_bits(entropy);
 }


