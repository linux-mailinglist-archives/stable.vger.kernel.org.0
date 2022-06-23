Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0303E55806D
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbiFWQrp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:47:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232729AbiFWQrL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:47:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CAB449B4E;
        Thu, 23 Jun 2022 09:47:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E6D9B8248A;
        Thu, 23 Jun 2022 16:47:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80AFAC3411B;
        Thu, 23 Jun 2022 16:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002827;
        bh=FJaXs/WxS/PjUiKaRJNrn1pyHd6fKqWMW76i91Xqpic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zf/qSaPRpn1a9gqbLLb+el27+5mzp1IiC3g0E8Ha5FWjU80QFZT3QAo7TD7X2ptZZ
         JKN3zMx7nnkWiIY3SA3ltVfVGUv/eZoGR+uZvL82kZzJux0Ekd8QLbT7LdhhdhbPZM
         pC2UDFKpgtOOogRTkMFsKf5F2BeYfwLdAqjoe+aw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephan Mueller <smueller@chronox.de>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 004/264] random: remove variable limit
Date:   Thu, 23 Jun 2022 18:39:57 +0200
Message-Id: <20220623164344.183470132@linuxfoundation.org>
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

From: "Stephan Müller" <smueller@chronox.de>

commit 43d8a72cd985ca5279a9eb84d61fcbb3ee3d3774 upstream.

The variable limit was used to identify the nonblocking pool's unlimited
random number generation. As the nonblocking pool is a thing of the
past, remove the limit variable and any conditions around it (i.e.
preserve the branches for limit == 1).

Signed-off-by: Stephan Mueller <smueller@chronox.de>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   32 ++++++++------------------------
 1 file changed, 8 insertions(+), 24 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -478,7 +478,6 @@ struct entropy_store {
 	int entropy_count;
 	int entropy_total;
 	unsigned int initialized:1;
-	unsigned int limit:1;
 	unsigned int last_data_init:1;
 	__u8 last_data[EXTRACT_SIZE];
 };
@@ -496,7 +495,6 @@ static __u32 blocking_pool_data[OUTPUT_P
 static struct entropy_store input_pool = {
 	.poolinfo = &poolinfo_table[0],
 	.name = "input",
-	.limit = 1,
 	.lock = __SPIN_LOCK_UNLOCKED(input_pool.lock),
 	.pool = input_pool_data
 };
@@ -504,7 +502,6 @@ static struct entropy_store input_pool =
 static struct entropy_store blocking_pool = {
 	.poolinfo = &poolinfo_table[1],
 	.name = "blocking",
-	.limit = 1,
 	.pull = &input_pool,
 	.lock = __SPIN_LOCK_UNLOCKED(blocking_pool.lock),
 	.pool = blocking_pool_data,
@@ -1280,15 +1277,6 @@ static void xfer_secondary_pool(struct e
 	    r->entropy_count > r->poolinfo->poolfracbits)
 		return;
 
-	if (r->limit == 0 && random_min_urandom_seed) {
-		unsigned long now = jiffies;
-
-		if (time_before(now,
-				r->last_pulled + random_min_urandom_seed * HZ))
-			return;
-		r->last_pulled = now;
-	}
-
 	_xfer_secondary_pool(r, nbytes);
 }
 
@@ -1296,8 +1284,6 @@ static void _xfer_secondary_pool(struct
 {
 	__u32	tmp[OUTPUT_POOL_WORDS];
 
-	/* For /dev/random's pool, always leave two wakeups' worth */
-	int rsvd_bytes = r->limit ? 0 : random_read_wakeup_bits / 4;
 	int bytes = nbytes;
 
 	/* pull at least as much as a wakeup */
@@ -1308,7 +1294,7 @@ static void _xfer_secondary_pool(struct
 	trace_xfer_secondary_pool(r->name, bytes * 8, nbytes * 8,
 				  ENTROPY_BITS(r), ENTROPY_BITS(r->pull));
 	bytes = extract_entropy(r->pull, tmp, bytes,
-				random_read_wakeup_bits / 8, rsvd_bytes);
+				random_read_wakeup_bits / 8, 0);
 	mix_pool_bytes(r, tmp, bytes);
 	credit_entropy_bits(r, bytes*8);
 }
@@ -1336,7 +1322,7 @@ static void push_to_pool(struct work_str
 static size_t account(struct entropy_store *r, size_t nbytes, int min,
 		      int reserved)
 {
-	int entropy_count, orig;
+	int entropy_count, orig, have_bytes;
 	size_t ibytes, nfrac;
 
 	BUG_ON(r->entropy_count > r->poolinfo->poolfracbits);
@@ -1345,14 +1331,12 @@ static size_t account(struct entropy_sto
 retry:
 	entropy_count = orig = ACCESS_ONCE(r->entropy_count);
 	ibytes = nbytes;
-	/* If limited, never pull more than available */
-	if (r->limit) {
-		int have_bytes = entropy_count >> (ENTROPY_SHIFT + 3);
-
-		if ((have_bytes -= reserved) < 0)
-			have_bytes = 0;
-		ibytes = min_t(size_t, ibytes, have_bytes);
-	}
+	/* never pull more than available */
+	have_bytes = entropy_count >> (ENTROPY_SHIFT + 3);
+
+	if ((have_bytes -= reserved) < 0)
+		have_bytes = 0;
+	ibytes = min_t(size_t, ibytes, have_bytes);
 	if (ibytes < min)
 		ibytes = 0;
 


