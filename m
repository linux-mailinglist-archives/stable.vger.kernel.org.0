Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45434558545
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbiFWRzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235187AbiFWRyA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:54:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48AD5AD18D;
        Thu, 23 Jun 2022 10:14:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D60C261DED;
        Thu, 23 Jun 2022 17:14:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD219C3411B;
        Thu, 23 Jun 2022 17:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004492;
        bh=4gkcvBNjgb8WCPBbXXpE9N01Bc7DZRyaqORkwV2NZXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gqf1LY0+mYMIZOh+q+7bp3dN4f4Z9ntZXYIm3lN7qX1iQv40Ev+cW7Ybf2b53Zzt4
         KqFmi6oweYwi/sT7CsKjHUDrB5b2wLMSsH5YaPW19aiHmjLsAR+DfwpNt97M0HOAaC
         z/N1fMXi57EjUML+vHbRM3HIZacALZe6PSfeUxww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.19 055/234] random: use IS_ENABLED(CONFIG_NUMA) instead of ifdefs
Date:   Thu, 23 Jun 2022 18:42:02 +0200
Message-Id: <20220623164344.622134227@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.042598055@linuxfoundation.org>
References: <20220623164343.042598055@linuxfoundation.org>
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
@@ -761,7 +761,6 @@ static int credit_entropy_bits_safe(stru
 
 static DECLARE_WAIT_QUEUE_HEAD(crng_init_wait);
 
-#ifdef CONFIG_NUMA
 /*
  * Hack to deal with crazy userspace progams when they are all trying
  * to access /dev/urandom in parallel.  The programs are almost
@@ -769,7 +768,6 @@ static DECLARE_WAIT_QUEUE_HEAD(crng_init
  * their brain damage.
  */
 static struct crng_state **crng_node_pool __read_mostly;
-#endif
 
 static void invalidate_batched_entropy(void);
 static void numa_crng_init(void);
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


