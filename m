Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F80355808F
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbiFWQwg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233883AbiFWQvs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:51:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C654F13F3D;
        Thu, 23 Jun 2022 09:50:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B1E161FBF;
        Thu, 23 Jun 2022 16:50:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40491C3411B;
        Thu, 23 Jun 2022 16:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003037;
        bh=gPjIJx2UsgYG+ZjDGkqJcx9hLZiYTeR+h9JF0JxYGTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=14nNOGIA/XwPUGhdtopauLB/aop7XWaXLJcHqC2oQTwTrb2e7BxEq4rRtsuwXz4s1
         1wICYUUvEpGMqoj29JzDoxdG0+1urF7Gqaf+3LlWU6i5ssSAKbpzaaz9J2G//S7fyV
         PEBYLb9MFqH3ClWahQ0v75brqXu9mWV9nczjBFz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 109/264] random: only call crng_finalize_init() for primary_crng
Date:   Thu, 23 Jun 2022 18:41:42 +0200
Message-Id: <20220623164347.152724953@linuxfoundation.org>
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

From: Dominik Brodowski <linux@dominikbrodowski.net>

commit 9d5505f1eebeca778074a0260ed077fd85f8792c upstream.

crng_finalize_init() returns instantly if it is called for another pool
than primary_crng. The test whether crng_finalize_init() is still required
can be moved to the relevant caller in crng_reseed(), and
crng_need_final_init can be reset to false if crng_finalize_init() is
called with workqueues ready. Then, no previous callsite will call
crng_finalize_init() unless it is needed, and we can get rid of the
superfluous function parameter.

Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -800,10 +800,8 @@ static void __init crng_initialize_prima
 	primary_crng.init_time = jiffies - CRNG_RESEED_INTERVAL - 1;
 }
 
-static void crng_finalize_init(struct crng_state *crng)
+static void crng_finalize_init(void)
 {
-	if (crng != &primary_crng || crng_init >= 2)
-		return;
 	if (!system_wq) {
 		/* We can't call numa_crng_init until we have workqueues,
 		 * so mark this for processing later. */
@@ -814,6 +812,7 @@ static void crng_finalize_init(struct cr
 	invalidate_batched_entropy();
 	numa_crng_init();
 	crng_init = 2;
+	crng_need_final_init = false;
 	process_random_ready_list();
 	wake_up_interruptible(&crng_init_wait);
 	kill_fasync(&fasync, SIGIO, POLL_IN);
@@ -1031,7 +1030,8 @@ static void crng_reseed(struct crng_stat
 	memzero_explicit(&buf, sizeof(buf));
 	WRITE_ONCE(crng->init_time, jiffies);
 	spin_unlock_irqrestore(&crng->lock, flags);
-	crng_finalize_init(crng);
+	if (crng == &primary_crng && crng_init < 2)
+		crng_finalize_init();
 }
 
 static void _extract_crng(struct crng_state *crng, u8 out[CHACHA20_BLOCK_SIZE])
@@ -1748,7 +1748,7 @@ int __init rand_initialize(void)
 {
 	init_std_data();
 	if (crng_need_final_init)
-		crng_finalize_init(&primary_crng);
+		crng_finalize_init();
 	crng_initialize_primary();
 	crng_global_init_time = jiffies;
 	if (ratelimit_disable) {


