Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF36955828E
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbiFWRQN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232561AbiFWROL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:14:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 001A5995F4;
        Thu, 23 Jun 2022 09:59:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5870360AE7;
        Thu, 23 Jun 2022 16:59:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A10FC3411B;
        Thu, 23 Jun 2022 16:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003562;
        bh=PfpNYgemX8Jh+rsiJPQJSzagjf9HvdH9B2NPGRUZbK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JG04voKGXAFA6u7TwnDKzKDy55oqFSe9b+SNO4xyCse8rnLhkb/fGmRdLoG1/5Ymk
         Ai0gvi8tbXQzM6Ze1/qusqty1rDZ4qC8Y62e85A8iZNgGUBgm9R6A5S9ggB72QaZVe
         Rnm63hO/VS6jNMBZQWTNqN4Hei5qjkVXA/23e3IQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 015/237] random: only read from /dev/random after its pool has received 128 bits
Date:   Thu, 23 Jun 2022 18:40:49 +0200
Message-Id: <20220623164343.590015979@linuxfoundation.org>
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

From: Theodore Ts'o <tytso@mit.edu>

commit eb9d1bf079bb438d1a066d72337092935fc770f6 upstream.

Immediately after boot, we allow reads from /dev/random before its
entropy pool has been fully initialized.  Fix this so that we don't
allow this until the blocking pool has received 128 bits.

We do this by repurposing the initialized flag in the entropy pool
struct, and use the initialized flag in the blocking pool to indicate
whether it is safe to pull from the blocking pool.

To do this, we needed to rework when we decide to push entropy from the
input pool to the blocking pool, since the initialized flag for the
input pool was used for this purpose.  To simplify things, we no
longer use the initialized flag for that purpose, nor do we use the
entropy_total field any more.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c         |   44 +++++++++++++++++++++---------------------
 include/trace/events/random.h |   13 ++++--------
 2 files changed, 27 insertions(+), 30 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -471,7 +471,6 @@ struct entropy_store {
 	unsigned short add_ptr;
 	unsigned short input_rotate;
 	int entropy_count;
-	int entropy_total;
 	unsigned int initialized:1;
 	unsigned int last_data_init:1;
 	__u8 last_data[EXTRACT_SIZE];
@@ -644,7 +643,7 @@ static void process_random_ready_list(vo
  */
 static void credit_entropy_bits(struct entropy_store *r, int nbits)
 {
-	int entropy_count, orig;
+	int entropy_count, orig, has_initialized = 0;
 	const int pool_size = r->poolinfo->poolfracbits;
 	int nfrac = nbits << ENTROPY_SHIFT;
 
@@ -699,23 +698,25 @@ retry:
 		entropy_count = 0;
 	} else if (entropy_count > pool_size)
 		entropy_count = pool_size;
+	if ((r == &blocking_pool) && !r->initialized &&
+	    (entropy_count >> ENTROPY_SHIFT) > 128)
+		has_initialized = 1;
 	if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
 		goto retry;
 
-	r->entropy_total += nbits;
-	if (!r->initialized && r->entropy_total > 128) {
+	if (has_initialized)
 		r->initialized = 1;
-		r->entropy_total = 0;
-	}
 
 	trace_credit_entropy_bits(r->name, nbits,
-				  entropy_count >> ENTROPY_SHIFT,
-				  r->entropy_total, _RET_IP_);
+				  entropy_count >> ENTROPY_SHIFT, _RET_IP_);
 
 	if (r == &input_pool) {
 		int entropy_bits = entropy_count >> ENTROPY_SHIFT;
+		struct entropy_store *other = &blocking_pool;
 
-		if (crng_init < 2 && entropy_bits >= 128) {
+		if (crng_init < 2) {
+			if (entropy_bits < 128)
+				return;
 			crng_reseed(&primary_crng, r);
 			entropy_bits = r->entropy_count >> ENTROPY_SHIFT;
 		}
@@ -726,20 +727,14 @@ retry:
 			wake_up_interruptible(&random_read_wait);
 			kill_fasync(&fasync, SIGIO, POLL_IN);
 		}
-		/* If the input pool is getting full, send some
-		 * entropy to the blocking pool until it is 75% full.
+		/* If the input pool is getting full, and the blocking
+		 * pool has room, send some entropy to the blocking
+		 * pool.
 		 */
-		if (entropy_bits > random_write_wakeup_bits &&
-		    r->initialized &&
-		    r->entropy_total >= 2*random_read_wakeup_bits) {
-			struct entropy_store *other = &blocking_pool;
-
-			if (other->entropy_count <=
-			    3 * other->poolinfo->poolfracbits / 4) {
-				schedule_work(&other->push_work);
-				r->entropy_total = 0;
-			}
-		}
+		if (!work_pending(&other->push_work) &&
+		    (ENTROPY_BITS(r) > 6 * r->poolinfo->poolbytes) &&
+		    (ENTROPY_BITS(other) <= 6 * other->poolinfo->poolbytes))
+			schedule_work(&other->push_work);
 	}
 }
 
@@ -1559,6 +1554,11 @@ static ssize_t extract_entropy_user(stru
 	int large_request = (nbytes > 256);
 
 	trace_extract_entropy_user(r->name, nbytes, ENTROPY_BITS(r), _RET_IP_);
+	if (!r->initialized && r->pull) {
+		xfer_secondary_pool(r, ENTROPY_BITS(r->pull)/8);
+		if (!r->initialized)
+			return 0;
+	}
 	xfer_secondary_pool(r, nbytes);
 	nbytes = account(r, nbytes, 0, 0);
 
--- a/include/trace/events/random.h
+++ b/include/trace/events/random.h
@@ -62,15 +62,14 @@ DEFINE_EVENT(random__mix_pool_bytes, mix
 
 TRACE_EVENT(credit_entropy_bits,
 	TP_PROTO(const char *pool_name, int bits, int entropy_count,
-		 int entropy_total, unsigned long IP),
+		 unsigned long IP),
 
-	TP_ARGS(pool_name, bits, entropy_count, entropy_total, IP),
+	TP_ARGS(pool_name, bits, entropy_count, IP),
 
 	TP_STRUCT__entry(
 		__field( const char *,	pool_name		)
 		__field(	  int,	bits			)
 		__field(	  int,	entropy_count		)
-		__field(	  int,	entropy_total		)
 		__field(unsigned long,	IP			)
 	),
 
@@ -78,14 +77,12 @@ TRACE_EVENT(credit_entropy_bits,
 		__entry->pool_name	= pool_name;
 		__entry->bits		= bits;
 		__entry->entropy_count	= entropy_count;
-		__entry->entropy_total	= entropy_total;
 		__entry->IP		= IP;
 	),
 
-	TP_printk("%s pool: bits %d entropy_count %d entropy_total %d "
-		  "caller %pS", __entry->pool_name, __entry->bits,
-		  __entry->entropy_count, __entry->entropy_total,
-		  (void *)__entry->IP)
+	TP_printk("%s pool: bits %d entropy_count %d caller %pS",
+		  __entry->pool_name, __entry->bits,
+		  __entry->entropy_count, (void *)__entry->IP)
 );
 
 TRACE_EVENT(push_to_pool,


