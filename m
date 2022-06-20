Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3A3C551D20
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347995AbiFTNqn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348028AbiFTNpR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:45:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871D92DAA6;
        Mon, 20 Jun 2022 06:16:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 671DB60FF2;
        Mon, 20 Jun 2022 13:16:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B24BC3411B;
        Mon, 20 Jun 2022 13:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730975;
        bh=6cEbCemrHSo5uu84Ne4VBpDDNncNXsxqhB5T/ss4p+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y5GBJGOZFDFOVy66wlKiTF5SRtNqqPaa1fzeaycwGOd0DTrfBMpBodnpwLBTvNK7J
         8cJgyOxbAfKUnWsf7DEmr61rQbHy1TmaZY8Uscv2JbqLKOoMm7N/4T1vps31fhn55a
         3EM6mCePl8jTh4SP8wbHT9lupHYFpaCcqI0CHFeM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 064/240] random: only call crng_finalize_init() for primary_crng
Date:   Mon, 20 Jun 2022 14:49:25 +0200
Message-Id: <20220620124740.232044992@linuxfoundation.org>
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
@@ -980,7 +979,8 @@ static void crng_reseed(struct crng_stat
 	memzero_explicit(&buf, sizeof(buf));
 	WRITE_ONCE(crng->init_time, jiffies);
 	spin_unlock_irqrestore(&crng->lock, flags);
-	crng_finalize_init(crng);
+	if (crng == &primary_crng && crng_init < 2)
+		crng_finalize_init();
 }
 
 static void _extract_crng(struct crng_state *crng, u8 out[CHACHA_BLOCK_SIZE])
@@ -1697,7 +1697,7 @@ int __init rand_initialize(void)
 {
 	init_std_data();
 	if (crng_need_final_init)
-		crng_finalize_init(&primary_crng);
+		crng_finalize_init();
 	crng_initialize_primary();
 	crng_global_init_time = jiffies;
 	if (ratelimit_disable) {


