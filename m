Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 026F1551C9D
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345140AbiFTNaB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346256AbiFTN2w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:28:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A74023BE8;
        Mon, 20 Jun 2022 06:11:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 006F8B811EA;
        Mon, 20 Jun 2022 13:10:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45624C3411B;
        Mon, 20 Jun 2022 13:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730654;
        bh=pcD20pTjXc0OFvfBkI7Jf92GEK2cRr+LG3vaDSjPkLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kGgzEujNdNrT36ekwSZZfPtpztZBTPkRq+UHQ5RmvGROp8wqP7+HF/XpQlnjGXlBS
         V0mkCA9yg1vOCu4NRVBMtieq8h2N9YHYTD9qt36viqml00sg4MXrCdjTP8yCGQ9HkV
         0Sq34qR0DztrCJdGoj/2UF21G7Pq9gG8uNIs1XMY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 015/240] random: delete code to pull data into pools
Date:   Mon, 20 Jun 2022 14:48:36 +0200
Message-Id: <20220620124738.252986941@linuxfoundation.org>
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

From: Andy Lutomirski <luto@kernel.org>

commit 84df7cdfbb215a34657b39f4257dab739efa2df9 upstream.

There is no pool that pulls, so it was just dead code.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Link: https://lore.kernel.org/r/4a05fe0c7a5c831389ef4aea51d24528ac8682c7.1577088521.git.luto@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   40 ----------------------------------------
 1 file changed, 40 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -529,10 +529,8 @@ struct entropy_store {
 	const struct poolinfo *poolinfo;
 	__u32 *pool;
 	const char *name;
-	struct entropy_store *pull;
 
 	/* read-write data: */
-	unsigned long last_pulled;
 	spinlock_t lock;
 	unsigned short add_ptr;
 	unsigned short input_rotate;
@@ -1368,41 +1366,6 @@ EXPORT_SYMBOL_GPL(add_disk_randomness);
  *********************************************************************/
 
 /*
- * This utility inline function is responsible for transferring entropy
- * from the primary pool to the secondary extraction pool. We make
- * sure we pull enough for a 'catastrophic reseed'.
- */
-static void _xfer_secondary_pool(struct entropy_store *r, size_t nbytes);
-static void xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
-{
-	if (!r->pull ||
-	    r->entropy_count >= (nbytes << (ENTROPY_SHIFT + 3)) ||
-	    r->entropy_count > r->poolinfo->poolfracbits)
-		return;
-
-	_xfer_secondary_pool(r, nbytes);
-}
-
-static void _xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
-{
-	__u32	tmp[OUTPUT_POOL_WORDS];
-
-	int bytes = nbytes;
-
-	/* pull at least as much as a wakeup */
-	bytes = max_t(int, bytes, random_read_wakeup_bits / 8);
-	/* but never more than the buffer size */
-	bytes = min_t(int, bytes, sizeof(tmp));
-
-	trace_xfer_secondary_pool(r->name, bytes * 8, nbytes * 8,
-				  ENTROPY_BITS(r), ENTROPY_BITS(r->pull));
-	bytes = extract_entropy(r->pull, tmp, bytes,
-				random_read_wakeup_bits / 8, 0);
-	mix_pool_bytes(r, tmp, bytes);
-	credit_entropy_bits(r, bytes*8);
-}
-
-/*
  * This function decides how many bytes to actually take from the
  * given pool, and also debits the entropy count accordingly.
  */
@@ -1565,7 +1528,6 @@ static ssize_t extract_entropy(struct en
 			spin_unlock_irqrestore(&r->lock, flags);
 			trace_extract_entropy(r->name, EXTRACT_SIZE,
 					      ENTROPY_BITS(r), _RET_IP_);
-			xfer_secondary_pool(r, EXTRACT_SIZE);
 			extract_buf(r, tmp);
 			spin_lock_irqsave(&r->lock, flags);
 			memcpy(r->last_data, tmp, EXTRACT_SIZE);
@@ -1574,7 +1536,6 @@ static ssize_t extract_entropy(struct en
 	}
 
 	trace_extract_entropy(r->name, nbytes, ENTROPY_BITS(r), _RET_IP_);
-	xfer_secondary_pool(r, nbytes);
 	nbytes = account(r, nbytes, min, reserved);
 
 	return _extract_entropy(r, buf, nbytes, fips_enabled);
@@ -1846,7 +1807,6 @@ static void __init init_std_data(struct
 	ktime_t now = ktime_get_real();
 	unsigned long rv;
 
-	r->last_pulled = jiffies;
 	mix_pool_bytes(r, &now, sizeof(now));
 	for (i = r->poolinfo->poolbytes; i > 0; i -= sizeof(rv)) {
 		if (!arch_get_random_seed_long(&rv) &&


