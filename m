Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34323558069
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbiFWQsr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232574AbiFWQr1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:47:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E514A3E6;
        Thu, 23 Jun 2022 09:47:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B921B8248E;
        Thu, 23 Jun 2022 16:47:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76E58C3411B;
        Thu, 23 Jun 2022 16:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002842;
        bh=7TBRMasfWnekyJfM7+liwVZ+Uk19yIeiAXsr8VsIe9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UNal6WLVJjocTUwefNNFC2R70zMNr084z7UsexgqnaQvkuQSByJPk0NR+Dn573Klw
         1t8AZP47JaSYw2aSl0AaksPNFa8pVhO7i9onD8UPDXv2cSAjFcOdbhD7UGfZt7nO2z
         gKUnVxwaRTZgAJjSV057MHQSbB4HJuix0WdJzF0c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.9 009/264] random: silence compiler warnings and fix race
Date:   Thu, 23 Jun 2022 18:40:02 +0200
Message-Id: <20220623164344.324630862@linuxfoundation.org>
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

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 4a072c71f49b0a0e495ea13423bdb850da73c58c upstream.

Odd versions of gcc for the sh4 architecture will actually warn about
flags being used while uninitialized, so we set them to zero. Non crazy
gccs will optimize that out again, so it doesn't make a difference.

Next, over aggressive gccs could inline the expression that defines
use_lock, which could then introduce a race resulting in a lock
imbalance. By using READ_ONCE, we prevent that fate. Finally, we make
that assignment const, so that gcc can still optimize a nice amount.

Finally, we fix a potential deadlock between primary_crng.lock and
batched_entropy_reset_lock, where they could be called in opposite
order. Moving the call to invalidate_batched_entropy to outside the lock
rectifies this issue.

Fixes: b169c13de473a85b3c859bb36216a4cb5f00a54a
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -815,13 +815,13 @@ static int crng_fast_load(const char *cp
 		p[crng_init_cnt % CHACHA20_KEY_SIZE] ^= *cp;
 		cp++; crng_init_cnt++; len--;
 	}
+	spin_unlock_irqrestore(&primary_crng.lock, flags);
 	if (crng_init_cnt >= CRNG_INIT_CNT_THRESH) {
 		invalidate_batched_entropy();
 		crng_init = 1;
 		wake_up_interruptible(&crng_init_wait);
 		pr_notice("random: fast init done\n");
 	}
-	spin_unlock_irqrestore(&primary_crng.lock, flags);
 	return 1;
 }
 
@@ -904,6 +904,7 @@ static void crng_reseed(struct crng_stat
 	}
 	memzero_explicit(&buf, sizeof(buf));
 	WRITE_ONCE(crng->init_time, jiffies);
+	spin_unlock_irqrestore(&crng->lock, flags);
 	if (crng == &primary_crng && crng_init < 2) {
 		numa_crng_init();
 		invalidate_batched_entropy();
@@ -924,7 +925,6 @@ static void crng_reseed(struct crng_stat
 			urandom_warning.missed = 0;
 		}
 	}
-	spin_unlock_irqrestore(&crng->lock, flags);
 }
 
 static inline void crng_wait_ready(void)
@@ -2108,8 +2108,8 @@ static DEFINE_PER_CPU(struct batched_ent
 u64 get_random_u64(void)
 {
 	u64 ret;
-	bool use_lock = crng_init < 2;
-	unsigned long flags;
+	bool use_lock = READ_ONCE(crng_init) < 2;
+	unsigned long flags = 0;
 	struct batched_entropy *batch;
 
 #if BITS_PER_LONG == 64
@@ -2140,8 +2140,8 @@ static DEFINE_PER_CPU(struct batched_ent
 u32 get_random_u32(void)
 {
 	u32 ret;
-	bool use_lock = crng_init < 2;
-	unsigned long flags;
+	bool use_lock = READ_ONCE(crng_init) < 2;
+	unsigned long flags = 0;
 	struct batched_entropy *batch;
 
 	if (arch_get_random_int(&ret))


