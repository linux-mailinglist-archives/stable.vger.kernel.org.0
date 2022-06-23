Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0506558086
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbiFWQwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233907AbiFWQvv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:51:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC4821800;
        Thu, 23 Jun 2022 09:51:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 574F161F90;
        Thu, 23 Jun 2022 16:51:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237EBC3411B;
        Thu, 23 Jun 2022 16:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003097;
        bh=qDiaCc4FHNBqJDJ8zGZcdPoTAJhHp92c2LQwYafhUYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xvycc3zleX3xevBguV3YFVd7xgBiVKoxvF448S6HKVYqtacPjn7ay9NwJ9W1rR/Hw
         Q285plwJBeRFGqFReVXh58WYc0SN7H613DH/EXqdNjj/pKzIkYF4TGMo1oCiSGGO3P
         xmpTIX4xx56r8+aG3STmXlNhc7B7x7f96roZafag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 088/264] random: use IS_ENABLED(CONFIG_NUMA) instead of ifdefs
Date:   Thu, 23 Jun 2022 18:41:21 +0200
Message-Id: <20220623164346.561810956@linuxfoundation.org>
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

commit 7b87324112df2e1f9b395217361626362dcfb9fb upstream.

Rather than an awkward combination of ifdefs and __maybe_unused, we can
ensure more source gets parsed, regardless of the configuration, by
using IS_ENABLED for the CONFIG_NUMA conditional code. This makes things
cleaner and easier to follow.

I've confirmed that on !CONFIG_NUMA, we don't wind up with excess code
by accident; the generated object file is the same.

Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   32 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 20 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -762,7 +762,6 @@ static int credit_entropy_bits_safe(stru
 
 static DECLARE_WAIT_QUEUE_HEAD(crng_init_wait);
 
-#ifdef CONFIG_NUMA
 /*
  * Hack to deal with crazy userspace progams when they are all trying
  * to access /dev/urandom in parallel.  The programs are almost
@@ -770,7 +769,6 @@ static DECLARE_WAIT_QUEUE_HEAD(crng_init
  * their brain damage.
  */
 static struct crng_state **crng_node_pool __read_mostly;
-#endif
 
 static void invalidate_batched_entropy(void);
 
@@ -817,7 +815,7 @@ static bool __init crng_init_try_arch_ea
 	return arch_init;
 }
 
-static void __maybe_unused crng_initialize_secondary(struct crng_state *crng)
+static void crng_initialize_secondary(struct crng_state *crng)
 {
 	memcpy(&crng->state[0], "expand 32-byte k", 16);
 	_get_random_bytes(&crng->state[4], sizeof(__u32) * 12);
@@ -868,7 +866,6 @@ static void crng_finalize_init(struct cr
 	}
 }
 
-#ifdef CONFIG_NUMA
 static void do_numa_crng_init(struct work_struct *work)
 {
 	int i;
@@ -895,29 +892,24 @@ static DECLARE_WORK(numa_crng_init_work,
 
 static void numa_crng_init(void)
 {
-	schedule_work(&numa_crng_init_work);
+	if (IS_ENABLED(CONFIG_NUMA))
+		schedule_work(&numa_crng_init_work);
 }
 
 static struct crng_state *select_crng(void)
 {
-	struct crng_state **pool;
-	int nid = numa_node_id();
-
-	/* pairs with cmpxchg_release() in do_numa_crng_init() */
-	pool = READ_ONCE(crng_node_pool);
-	if (pool && pool[nid])
-		return pool[nid];
-
-	return &primary_crng;
-}
-#else
-static void numa_crng_init(void) {}
+	if (IS_ENABLED(CONFIG_NUMA)) {
+		struct crng_state **pool;
+		int nid = numa_node_id();
+
+		/* pairs with cmpxchg_release() in do_numa_crng_init() */
+		pool = READ_ONCE(crng_node_pool);
+		if (pool && pool[nid])
+			return pool[nid];
+	}
 
-static struct crng_state *select_crng(void)
-{
 	return &primary_crng;
 }
-#endif
 
 /*
  * crng_fast_load() can be called by code in the interrupt service


