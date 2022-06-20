Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9C0551E9F
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 16:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237539AbiFTOAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 10:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349205AbiFTNxr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:53:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 639851A05C;
        Mon, 20 Jun 2022 06:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7F6AB80E7D;
        Mon, 20 Jun 2022 13:19:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A19C3411B;
        Mon, 20 Jun 2022 13:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655731156;
        bh=K5PXdgP1phRc7i/QqxIpNqkZRJfk01xQXAilZKpUPHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c2ynHxfZvbAkp5YVtwrvaOollChjNE9fhL3A8Vl+atSCpaKmSSVTCLPIU+UnDpG8+
         7jCBAkehKfFbSR3WeSPEz0wAc5sA+cYN0n9ovTSB2ocy5N7MN9T2VuJJX7FAgrrQOS
         IlDXOl3f8NM6u4UL/S1bBAvTrJse0sIetPt2JXa4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 171/240] Revert "random: use static branch for crng_ready()"
Date:   Mon, 20 Jun 2022 14:51:12 +0200
Message-Id: <20220620124743.954374435@linuxfoundation.org>
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

This reverts upstream commit f5bda35fba615ace70a656d4700423fa6c9bebee
from stable. It's not essential and will take some time during 5.19 to
work out properly.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -79,8 +79,7 @@ static enum {
 	CRNG_EARLY = 1, /* At least POOL_EARLY_BITS collected */
 	CRNG_READY = 2  /* Fully initialized with POOL_READY_BITS collected */
 } crng_init __read_mostly = CRNG_EMPTY;
-static DEFINE_STATIC_KEY_FALSE(crng_is_ready);
-#define crng_ready() (static_branch_likely(&crng_is_ready) || crng_init >= CRNG_READY)
+#define crng_ready() (likely(crng_init >= CRNG_READY))
 /* Various types of waiters for crng_init->CRNG_READY transition. */
 static DECLARE_WAIT_QUEUE_HEAD(crng_init_wait);
 static struct fasync_struct *fasync;
@@ -110,11 +109,6 @@ bool rng_is_initialized(void)
 }
 EXPORT_SYMBOL(rng_is_initialized);
 
-static void __cold crng_set_ready(struct work_struct *work)
-{
-	static_branch_enable(&crng_is_ready);
-}
-
 /* Used by wait_for_random_bytes(), and considered an entropy collector, below. */
 static void try_to_generate_entropy(void);
 
@@ -268,7 +262,7 @@ static void crng_reseed(void)
 		++next_gen;
 	WRITE_ONCE(base_crng.generation, next_gen);
 	WRITE_ONCE(base_crng.birth, jiffies);
-	if (!static_branch_likely(&crng_is_ready))
+	if (!crng_ready())
 		crng_init = CRNG_READY;
 	spin_unlock_irqrestore(&base_crng.lock, flags);
 	memzero_explicit(key, sizeof(key));
@@ -709,7 +703,6 @@ static void extract_entropy(void *buf, s
 
 static void __cold _credit_init_bits(size_t bits)
 {
-	static struct execute_work set_ready;
 	unsigned int new, orig, add;
 	unsigned long flags;
 
@@ -725,7 +718,6 @@ static void __cold _credit_init_bits(siz
 
 	if (orig < POOL_READY_BITS && new >= POOL_READY_BITS) {
 		crng_reseed(); /* Sets crng_init to CRNG_READY under base_crng.lock. */
-		execute_in_process_context(crng_set_ready, &set_ready);
 		process_random_ready_list();
 		wake_up_interruptible(&crng_init_wait);
 		kill_fasync(&fasync, SIGIO, POLL_IN);


