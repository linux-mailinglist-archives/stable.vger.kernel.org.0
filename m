Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F87B5580F4
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233327AbiFWQym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233322AbiFWQup (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:50:45 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2471FE9;
        Thu, 23 Jun 2022 09:48:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 75374CE25DF;
        Thu, 23 Jun 2022 16:48:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD38C3411B;
        Thu, 23 Jun 2022 16:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002912;
        bh=xdb2ZErIUK9uPmVFDjmvj2mIuOcmWwnjk9fgaiX9dhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jlH3XknSDs8pEU/wO6evIPo+v1otT9XlXJhZeJ+EqXR6HQ3XqMmFT2V7CbkyRH5s0
         CvTfN3M9OPIxwqoXLQXgACMJbcZYZta7UG2GiT0oKMa3OW+1SnmcRtsRmQOgHujUBO
         KVSub17o04cFLG7uwWLYOVBqlYjs7MLpt38il0hU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Mark Brown <broonie@kernel.org>, Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 067/264] random: split primary/secondary crng init paths
Date:   Thu, 23 Jun 2022 18:41:00 +0200
Message-Id: <20220623164345.967382230@linuxfoundation.org>
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

From: Mark Rutland <mark.rutland@arm.com>

commit 5cbe0f13b51ac2fb2fd55902cff8d0077fc084c0 upstream.

Currently crng_initialize() is used for both the primary CRNG and
secondary CRNGs. While we wish to share common logic, we need to do a
number of additional things for the primary CRNG, and this would be
easier to deal with were these handled in separate functions.

This patch splits crng_initialize() into crng_initialize_primary() and
crng_initialize_secondary(), with common logic factored out into a
crng_init_try_arch() helper.

There should be no functional change as a result of this patch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Link: https://lore.kernel.org/r/20200210130015.17664-2-mark.rutland@arm.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -783,27 +783,39 @@ static int __init parse_trust_cpu(char *
 }
 early_param("random.trust_cpu", parse_trust_cpu);
 
-static void crng_initialize(struct crng_state *crng)
+static bool crng_init_try_arch(struct crng_state *crng)
 {
 	int		i;
-	int		arch_init = 1;
+	bool		arch_init = true;
 	unsigned long	rv;
 
-	memcpy(&crng->state[0], "expand 32-byte k", 16);
-	if (crng == &primary_crng)
-		_extract_entropy(&input_pool, &crng->state[4],
-				 sizeof(__u32) * 12, 0);
-	else
-		_get_random_bytes(&crng->state[4], sizeof(__u32) * 12);
 	for (i = 4; i < 16; i++) {
 		if (!arch_get_random_seed_long(&rv) &&
 		    !arch_get_random_long(&rv)) {
 			rv = random_get_entropy();
-			arch_init = 0;
+			arch_init = false;
 		}
 		crng->state[i] ^= rv;
 	}
-	if (trust_cpu && arch_init) {
+
+	return arch_init;
+}
+
+static void crng_initialize_secondary(struct crng_state *crng)
+{
+	memcpy(&crng->state[0], "expand 32-byte k", 16);
+	_get_random_bytes(&crng->state[4], sizeof(__u32) * 12);
+	crng_init_try_arch(crng);
+	crng->init_time = jiffies - CRNG_RESEED_INTERVAL - 1;
+}
+
+static void __init crng_initialize_primary(struct crng_state *crng)
+{
+	memcpy(&crng->state[0], "expand 32-byte k", 16);
+	_extract_entropy(&input_pool, &crng->state[4], sizeof(__u32) * 12, 0);
+	if (crng_init_try_arch(crng) && trust_cpu) {
+		invalidate_batched_entropy();
+		numa_crng_init();
 		crng_init = 2;
 		pr_notice("crng done (trusting CPU's manufacturer)\n");
 	}
@@ -852,7 +864,7 @@ static void do_numa_crng_init(struct wor
 		crng = kmalloc_node(sizeof(struct crng_state),
 				    GFP_KERNEL | __GFP_NOFAIL, i);
 		spin_lock_init(&crng->lock);
-		crng_initialize(crng);
+		crng_initialize_secondary(crng);
 		pool[i] = crng;
 	}
 	/* pairs with READ_ONCE() in select_crng() */
@@ -1780,7 +1792,7 @@ int __init rand_initialize(void)
 	init_std_data(&input_pool);
 	if (crng_need_final_init)
 		crng_finalize_init(&primary_crng);
-	crng_initialize(&primary_crng);
+	crng_initialize_primary(&primary_crng);
 	crng_global_init_time = jiffies;
 	if (ratelimit_disable) {
 		urandom_warning.interval = 0;


