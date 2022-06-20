Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8608551B02
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347109AbiFTNkQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348973AbiFTNj3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:39:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 138152983C;
        Mon, 20 Jun 2022 06:14:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FDE960ABE;
        Mon, 20 Jun 2022 13:14:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 041A4C3411B;
        Mon, 20 Jun 2022 13:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730879;
        bh=OFK+I4hC4CbXFovI2d2Y6mlAc9oHx06iwqtm1T1Gx8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qmjjAKh3rfyE8FXiHLO/QsMs66udFOF2da0lKUmMS3g43DcpGWf0kTv7WdIbCKEFF
         cIF0TXGiKAqP15K7btFvrEBgvBCAasXRHJnHu4EPqzN0yc5imCr0qZWkuH+anshRxV
         B+JbBmFsJ5zuiSxUOQM5lmYWb0yf41d7Omxf/tF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 084/240] random: fix locking for crng_init in crng_reseed()
Date:   Mon, 20 Jun 2022 14:49:45 +0200
Message-Id: <20220620124741.344640221@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
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

commit 7191c628fe07b70d3f37de736d173d1b115396ed upstream.

crng_init is protected by primary_crng->lock. Therefore, we need
to hold this lock when increasing crng_init to 2. As we shouldn't
hold this lock for too long, only hold it for those parts which
require protection.

Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -500,6 +500,7 @@ static void crng_reseed(void)
 	int entropy_count;
 	unsigned long next_gen;
 	u8 key[CHACHA_KEY_SIZE];
+	bool finalize_init = false;
 
 	/*
 	 * First we make sure we have POOL_MIN_BITS of entropy in the pool,
@@ -527,12 +528,14 @@ static void crng_reseed(void)
 		++next_gen;
 	WRITE_ONCE(base_crng.generation, next_gen);
 	WRITE_ONCE(base_crng.birth, jiffies);
-	spin_unlock_irqrestore(&base_crng.lock, flags);
-	memzero_explicit(key, sizeof(key));
-
 	if (crng_init < 2) {
 		invalidate_batched_entropy();
 		crng_init = 2;
+		finalize_init = true;
+	}
+	spin_unlock_irqrestore(&base_crng.lock, flags);
+	memzero_explicit(key, sizeof(key));
+	if (finalize_init) {
 		process_random_ready_list();
 		wake_up_interruptible(&crng_init_wait);
 		kill_fasync(&fasync, SIGIO, POLL_IN);


