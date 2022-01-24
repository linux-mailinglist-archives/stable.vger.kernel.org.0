Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F69749A8DB
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234424AbiAYDQu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:16:50 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38196 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346079AbiAXTM3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:12:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28D1DB8123D;
        Mon, 24 Jan 2022 19:12:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 259BBC340E5;
        Mon, 24 Jan 2022 19:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051545;
        bh=Vo4fc08dYU7Q2vdyaqh6jXfagzpgeNQG+pLuG1tBzYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vfpfjgUkKnZPe4a5s4Pgfj64YPwMBfrHw1/ZCCJ2GD2lq4Q5+BEzRbFXrD9Tij+nL
         tEUs1XKAky8kELDicjfM7vegjBqLaZEMhO8jVBelg80lLvbSDHTSb481rxtEp9nHBr
         m9Esrd/QJP0JmdYdTv50XJLpMciHVpD1Y+9NcZgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.19 010/239] random: fix data race on crng init time
Date:   Mon, 24 Jan 2022 19:40:48 +0100
Message-Id: <20220124183943.439160423@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 009ba8568be497c640cab7571f7bfd18345d7b24 upstream.

_extract_crng() does plain loads of crng->init_time and
crng_global_init_time, which causes undefined behavior if
crng_reseed() and RNDRESEEDCRNG modify these corrently.

Use READ_ONCE() and WRITE_ONCE() to make the behavior defined.

Don't fix the race on crng->init_time by protecting it with crng->lock,
since it's not a problem for duplicate reseedings to occur.  I.e., the
lockless access with READ_ONCE() is fine.

Fixes: d848e5f8e1eb ("random: add new ioctl RNDRESEEDCRNG")
Fixes: e192be9d9a30 ("random: replace non-blocking pool with a Chacha20-based CRNG")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Acked-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -969,7 +969,7 @@ static void crng_reseed(struct crng_stat
 		crng->state[i+4] ^= buf.key[i] ^ rv;
 	}
 	memzero_explicit(&buf, sizeof(buf));
-	crng->init_time = jiffies;
+	WRITE_ONCE(crng->init_time, jiffies);
 	spin_unlock_irqrestore(&crng->lock, flags);
 	if (crng == &primary_crng && crng_init < 2) {
 		invalidate_batched_entropy();
@@ -996,12 +996,15 @@ static void crng_reseed(struct crng_stat
 static void _extract_crng(struct crng_state *crng,
 			  __u8 out[CHACHA20_BLOCK_SIZE])
 {
-	unsigned long v, flags;
+	unsigned long v, flags, init_time;
 
-	if (crng_ready() &&
-	    (time_after(crng_global_init_time, crng->init_time) ||
-	     time_after(jiffies, crng->init_time + CRNG_RESEED_INTERVAL)))
-		crng_reseed(crng, crng == &primary_crng ? &input_pool : NULL);
+	if (crng_ready()) {
+		init_time = READ_ONCE(crng->init_time);
+		if (time_after(READ_ONCE(crng_global_init_time), init_time) ||
+		    time_after(jiffies, init_time + CRNG_RESEED_INTERVAL))
+			crng_reseed(crng, crng == &primary_crng ?
+				    &input_pool : NULL);
+	}
 	spin_lock_irqsave(&crng->lock, flags);
 	if (arch_get_random_long(&v))
 		crng->state[14] ^= v;
@@ -2074,7 +2077,7 @@ static long random_ioctl(struct file *f,
 		if (crng_init < 2)
 			return -ENODATA;
 		crng_reseed(&primary_crng, &input_pool);
-		crng_global_init_time = jiffies - 1;
+		WRITE_ONCE(crng_global_init_time, jiffies - 1);
 		return 0;
 	default:
 		return -EINVAL;


