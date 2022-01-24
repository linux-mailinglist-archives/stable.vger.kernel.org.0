Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87BF44989E5
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343553AbiAXS7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:59:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343568AbiAXS5F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:57:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331D7C061759;
        Mon, 24 Jan 2022 10:55:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C702E61509;
        Mon, 24 Jan 2022 18:55:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B2F4C340E5;
        Mon, 24 Jan 2022 18:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050511;
        bh=qAKyD/fvJ7v//yJ2hNYiXSdEGeERP8oQyMU7qc6xpG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qj5r8VgBucjV9A9U5ciASlC0KsRaOkI172OpLnXETypxg2Q3ubMQqU/tWLkgPtUwD
         CpiQNE8VsdmIig8BBMxG36OR1SyH4jRnquHbr5FbMlXXLV3bWAU4ka67HXEF+Xbl3l
         2WAuvZ7ovovcQxvubnEkqMtaKbxCZNTZqZm7kzjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 008/157] random: fix data race on crng init time
Date:   Mon, 24 Jan 2022 19:41:38 +0100
Message-Id: <20220124183933.050687345@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183932.787526760@linuxfoundation.org>
References: <20220124183932.787526760@linuxfoundation.org>
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
@@ -908,7 +908,7 @@ static void crng_reseed(struct crng_stat
 		crng->state[i+4] ^= buf.key[i] ^ rv;
 	}
 	memzero_explicit(&buf, sizeof(buf));
-	crng->init_time = jiffies;
+	WRITE_ONCE(crng->init_time, jiffies);
 	if (crng == &primary_crng && crng_init < 2) {
 		numa_crng_init();
 		crng_init = 2;
@@ -946,12 +946,15 @@ static inline void crng_wait_ready(void)
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
@@ -1916,7 +1919,7 @@ static long random_ioctl(struct file *f,
 		if (crng_init < 2)
 			return -ENODATA;
 		crng_reseed(&primary_crng, &input_pool);
-		crng_global_init_time = jiffies - 1;
+		WRITE_ONCE(crng_global_init_time, jiffies - 1);
 		return 0;
 	default:
 		return -EINVAL;


