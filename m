Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65F1B558241
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbiFWRNZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiFWRLl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:11:41 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66B0BFD26;
        Thu, 23 Jun 2022 09:50:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C347DCE25DE;
        Thu, 23 Jun 2022 16:50:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93925C3411B;
        Thu, 23 Jun 2022 16:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003031;
        bh=cMW0RWQwvnmaeI4SjGqV7oxsiHkLWotEGjxucDFTelw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hj7aG7+0e9EuI+EkcSac2XUX7bPg2+eCXFPGb6k+O+EUHdSjVf1fvdPDVNnFOgB8K
         jnnICNnxxX77QomLbvMVpL4WZnrMCgCYnjFFhPaTfoFMYGiatapZWq09YVQT/80QAB
         u/yHF8N3mdTGry9/CwIS5LXSMBDZLGjxpSToNbV4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: [PATCH 4.9 107/264] random: continually use hwgenerator randomness
Date:   Thu, 23 Jun 2022 18:41:40 +0200
Message-Id: <20220623164347.096943607@linuxfoundation.org>
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
@@ -2244,13 +2244,15 @@ void add_hwgenerator_randomness(const ch
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


