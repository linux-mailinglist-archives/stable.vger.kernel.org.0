Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D258535C8D
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 11:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350412AbiE0JCc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 05:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350663AbiE0JAP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 05:00:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A4662BE3;
        Fri, 27 May 2022 01:56:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A363B823DE;
        Fri, 27 May 2022 08:56:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C79D1C34100;
        Fri, 27 May 2022 08:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653641797;
        bh=TvSP2+gIKr8wSl72N8VM4swQHZlA8NwkYof9GNkuWzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gSgkPNic/fwp/ZFwHk+YJyeROQlZ6KbRpzFFwR5XQQxMNt15rrb2iaJAR8Fj6qIXR
         7FUxmQkKOTCaggQ/XoGF5K2ETcqXq/P6/D0mP14KxcJtwgLlkgE6WkqLu+c/+1JQ1/
         pFQ7gt6vdhq1wYzXxrdBUmQuLQUOYKks6A8bePuc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-crypto@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Jann Horn <jannh@google.com>, Theodore Tso <tytso@mit.edu>,
        Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 012/163] random: remove dead code left over from blocking pool
Date:   Fri, 27 May 2022 10:48:12 +0200
Message-Id: <20220527084829.902796403@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@google.com>

commit 118a4417e14348b2e46f5e467da8444ec4757a45 upstream.

Remove some dead code that was left over following commit 90ea1c6436d2
("random: remove the blocking pool").

Cc: linux-crypto@vger.kernel.org
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Andy Lutomirski <luto@kernel.org>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c         |   17 +-------
 include/trace/events/random.h |   83 ------------------------------------------
 2 files changed, 3 insertions(+), 97 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -501,7 +501,6 @@ struct entropy_store {
 	unsigned short add_ptr;
 	unsigned short input_rotate;
 	int entropy_count;
-	unsigned int initialized:1;
 	unsigned int last_data_init:1;
 	__u8 last_data[EXTRACT_SIZE];
 };
@@ -661,7 +660,7 @@ static void process_random_ready_list(vo
  */
 static void credit_entropy_bits(struct entropy_store *r, int nbits)
 {
-	int entropy_count, orig, has_initialized = 0;
+	int entropy_count, orig;
 	const int pool_size = r->poolinfo->poolfracbits;
 	int nfrac = nbits << ENTROPY_SHIFT;
 
@@ -718,23 +717,14 @@ retry:
 	if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
 		goto retry;
 
-	if (has_initialized) {
-		r->initialized = 1;
-		kill_fasync(&fasync, SIGIO, POLL_IN);
-	}
-
 	trace_credit_entropy_bits(r->name, nbits,
 				  entropy_count >> ENTROPY_SHIFT, _RET_IP_);
 
 	if (r == &input_pool) {
 		int entropy_bits = entropy_count >> ENTROPY_SHIFT;
 
-		if (crng_init < 2) {
-			if (entropy_bits < 128)
-				return;
+		if (crng_init < 2 && entropy_bits >= 128)
 			crng_reseed(&primary_crng, r);
-			entropy_bits = ENTROPY_BITS(r);
-		}
 	}
 }
 
@@ -1392,8 +1382,7 @@ retry:
 }
 
 /*
- * This function does the actual extraction for extract_entropy and
- * extract_entropy_user.
+ * This function does the actual extraction for extract_entropy.
  *
  * Note: we assume that .poolwords is a multiple of 16 words.
  */
--- a/include/trace/events/random.h
+++ b/include/trace/events/random.h
@@ -85,28 +85,6 @@ TRACE_EVENT(credit_entropy_bits,
 		  __entry->entropy_count, (void *)__entry->IP)
 );
 
-TRACE_EVENT(push_to_pool,
-	TP_PROTO(const char *pool_name, int pool_bits, int input_bits),
-
-	TP_ARGS(pool_name, pool_bits, input_bits),
-
-	TP_STRUCT__entry(
-		__field( const char *,	pool_name		)
-		__field(	  int,	pool_bits		)
-		__field(	  int,	input_bits		)
-	),
-
-	TP_fast_assign(
-		__entry->pool_name	= pool_name;
-		__entry->pool_bits	= pool_bits;
-		__entry->input_bits	= input_bits;
-	),
-
-	TP_printk("%s: pool_bits %d input_pool_bits %d",
-		  __entry->pool_name, __entry->pool_bits,
-		  __entry->input_bits)
-);
-
 TRACE_EVENT(debit_entropy,
 	TP_PROTO(const char *pool_name, int debit_bits),
 
@@ -161,35 +139,6 @@ TRACE_EVENT(add_disk_randomness,
 		  MINOR(__entry->dev), __entry->input_bits)
 );
 
-TRACE_EVENT(xfer_secondary_pool,
-	TP_PROTO(const char *pool_name, int xfer_bits, int request_bits,
-		 int pool_entropy, int input_entropy),
-
-	TP_ARGS(pool_name, xfer_bits, request_bits, pool_entropy,
-		input_entropy),
-
-	TP_STRUCT__entry(
-		__field( const char *,	pool_name		)
-		__field(	  int,	xfer_bits		)
-		__field(	  int,	request_bits		)
-		__field(	  int,	pool_entropy		)
-		__field(	  int,	input_entropy		)
-	),
-
-	TP_fast_assign(
-		__entry->pool_name	= pool_name;
-		__entry->xfer_bits	= xfer_bits;
-		__entry->request_bits	= request_bits;
-		__entry->pool_entropy	= pool_entropy;
-		__entry->input_entropy	= input_entropy;
-	),
-
-	TP_printk("pool %s xfer_bits %d request_bits %d pool_entropy %d "
-		  "input_entropy %d", __entry->pool_name, __entry->xfer_bits,
-		  __entry->request_bits, __entry->pool_entropy,
-		  __entry->input_entropy)
-);
-
 DECLARE_EVENT_CLASS(random__get_random_bytes,
 	TP_PROTO(int nbytes, unsigned long IP),
 
@@ -253,38 +202,6 @@ DEFINE_EVENT(random__extract_entropy, ex
 	TP_ARGS(pool_name, nbytes, entropy_count, IP)
 );
 
-DEFINE_EVENT(random__extract_entropy, extract_entropy_user,
-	TP_PROTO(const char *pool_name, int nbytes, int entropy_count,
-		 unsigned long IP),
-
-	TP_ARGS(pool_name, nbytes, entropy_count, IP)
-);
-
-TRACE_EVENT(random_read,
-	TP_PROTO(int got_bits, int need_bits, int pool_left, int input_left),
-
-	TP_ARGS(got_bits, need_bits, pool_left, input_left),
-
-	TP_STRUCT__entry(
-		__field(	  int,	got_bits		)
-		__field(	  int,	need_bits		)
-		__field(	  int,	pool_left		)
-		__field(	  int,	input_left		)
-	),
-
-	TP_fast_assign(
-		__entry->got_bits	= got_bits;
-		__entry->need_bits	= need_bits;
-		__entry->pool_left	= pool_left;
-		__entry->input_left	= input_left;
-	),
-
-	TP_printk("got_bits %d still_needed_bits %d "
-		  "blocking_pool_entropy_left %d input_entropy_left %d",
-		  __entry->got_bits, __entry->got_bits, __entry->pool_left,
-		  __entry->input_left)
-);
-
 TRACE_EVENT(urandom_read,
 	TP_PROTO(int got_bits, int pool_left, int input_left),
 


