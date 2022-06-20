Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24C8E551C3D
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346370AbiFTNeo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347564AbiFTNeH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:34:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C64E91D33D;
        Mon, 20 Jun 2022 06:13:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1165360EC6;
        Mon, 20 Jun 2022 13:12:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00434C3411B;
        Mon, 20 Jun 2022 13:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730759;
        bh=mvbc0UwFRxHk3S/6WpcJH1rq+Wb+kHQBfZvG3cSrfQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CDV2jJPOo0xEsOpzaEeopYPfXCy9+ILkX08PitGHMDXrcsNbcdweuPy+nQTiQrNCB
         Jcy2kjW9KIl52sG4cUtNVm3qzXjpI9n5F6sIhN29Se4ZbUAMkXxRXK3dqpX9q2HNnA
         qbLhhgbuiZ+BJUNNcK1eCBuGEuMISrFMvbZSWjZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Ard Biesheuvel <ardb@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 047/240] random: avoid superfluous call to RDRAND in CRNG extraction
Date:   Mon, 20 Jun 2022 14:49:08 +0200
Message-Id: <20220620124739.458601247@linuxfoundation.org>
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

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 2ee25b6968b1b3c66ffa408de23d023c1bce81cf upstream.

RDRAND is not fast. RDRAND is actually quite slow. We've known this for
a while, which is why functions like get_random_u{32,64} were converted
to use batching of our ChaCha-based CRNG instead.

Yet CRNG extraction still includes a call to RDRAND, in the hot path of
every call to get_random_bytes(), /dev/urandom, and getrandom(2).

This call to RDRAND here seems quite superfluous. CRNG is already
extracting things based on a 256-bit key, based on good entropy, which
is then reseeded periodically, updated, backtrack-mutated, and so
forth. The CRNG extraction construction is something that we're already
relying on to be secure and solid. If it's not, that's a serious
problem, and it's unlikely that mixing in a measly 32 bits from RDRAND
is going to alleviate things.

And in the case where the CRNG doesn't have enough entropy yet, we're
already initializing the ChaCha key row with RDRAND in
crng_init_try_arch_early().

Removing the call to RDRAND improves performance on an i7-11850H by
370%. In other words, the vast majority of the work done by
extract_crng() prior to this commit was devoted to fetching 32 bits of
RDRAND.

Reviewed-by: Theodore Ts'o <tytso@mit.edu>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1024,7 +1024,7 @@ static void crng_reseed(struct crng_stat
 static void _extract_crng(struct crng_state *crng,
 			  __u8 out[CHACHA_BLOCK_SIZE])
 {
-	unsigned long v, flags, init_time;
+	unsigned long flags, init_time;
 
 	if (crng_ready()) {
 		init_time = READ_ONCE(crng->init_time);
@@ -1034,8 +1034,6 @@ static void _extract_crng(struct crng_st
 				    &input_pool : NULL);
 	}
 	spin_lock_irqsave(&crng->lock, flags);
-	if (arch_get_random_long(&v))
-		crng->state[14] ^= v;
 	chacha20_block(&crng->state[0], out);
 	if (crng->state[12] == 0)
 		crng->state[13]++;


