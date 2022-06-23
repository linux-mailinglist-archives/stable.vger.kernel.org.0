Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE5B5582DB
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbiFWRVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbiFWRUy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:20:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B0C4F44B;
        Thu, 23 Jun 2022 10:00:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F019B82493;
        Thu, 23 Jun 2022 17:00:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD37CC3411B;
        Thu, 23 Jun 2022 17:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003636;
        bh=/XFET9+SKI8rKv+riAwsmtnXJOwCQVRbvx7+8+FI7qQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E2vcdGRoh1d37hZZbxmpPOw6LnXLjLxwZeGEWkkvmRUxt8fgwyfxXpT3LqcMUyWBo
         7q95z6ZYUdp4WKTeV/tV72INnHOF4Hjr1loisCCHKd/ch2PcZjC/NGXStwilnUjuha
         lCAv4uTkPdiOXObNBsFTFtJih4JNDkQMohQOnIX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 037/237] random: delete code to pull data into pools
Date:   Thu, 23 Jun 2022 18:41:11 +0200
Message-Id: <20220623164344.222789578@linuxfoundation.org>
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
@@ -530,10 +530,8 @@ struct entropy_store {
 	const struct poolinfo *poolinfo;
 	__u32 *pool;
 	const char *name;
-	struct entropy_store *pull;
 
 	/* read-write data: */
-	unsigned long last_pulled;
 	spinlock_t lock;
 	unsigned short add_ptr;
 	unsigned short input_rotate;
@@ -1364,41 +1362,6 @@ EXPORT_SYMBOL_GPL(add_disk_randomness);
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
@@ -1561,7 +1524,6 @@ static ssize_t extract_entropy(struct en
 			spin_unlock_irqrestore(&r->lock, flags);
 			trace_extract_entropy(r->name, EXTRACT_SIZE,
 					      ENTROPY_BITS(r), _RET_IP_);
-			xfer_secondary_pool(r, EXTRACT_SIZE);
 			extract_buf(r, tmp);
 			spin_lock_irqsave(&r->lock, flags);
 			memcpy(r->last_data, tmp, EXTRACT_SIZE);
@@ -1570,7 +1532,6 @@ static ssize_t extract_entropy(struct en
 	}
 
 	trace_extract_entropy(r->name, nbytes, ENTROPY_BITS(r), _RET_IP_);
-	xfer_secondary_pool(r, nbytes);
 	nbytes = account(r, nbytes, min, reserved);
 
 	return _extract_entropy(r, buf, nbytes, fips_enabled);
@@ -1782,7 +1743,6 @@ static void __init init_std_data(struct
 	ktime_t now = ktime_get_real();
 	unsigned long rv;
 
-	r->last_pulled = jiffies;
 	mix_pool_bytes(r, &now, sizeof(now));
 	for (i = r->poolinfo->poolbytes; i > 0; i -= sizeof(rv)) {
 		if (!arch_get_random_seed_long(&rv) &&


