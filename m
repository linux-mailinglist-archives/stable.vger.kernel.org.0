Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70B54558053
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbiFWQql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232420AbiFWQqH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:46:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8441849241;
        Thu, 23 Jun 2022 09:46:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 176D061F94;
        Thu, 23 Jun 2022 16:46:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6C7C341CE;
        Thu, 23 Jun 2022 16:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002760;
        bh=I7PN7zgOKRU45SFEGfEkUiKD3HLDRmiwei1csYDJPa0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QOjvKewQ9t+9aWv8eyLn1aY8FLSMAGMmpaaPX7niKMdoEFcDRxYmzL6VVmUhnrIOO
         pyo229FDQMJ15LoCQkVo4Tmw2SR3wsLNvGI9D2SIu8BrZvf4cLFvBxoqWSDS3J8Ma5
         G208Zjsh4UeGeaQBUSXOXryIjOFzHqnd9XTiUX4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 4.9 017/264] random: use a different mixing algorithm for add_device_randomness()
Date:   Thu, 23 Jun 2022 18:40:10 +0200
Message-Id: <20220623164344.552148585@linuxfoundation.org>
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

From: Theodore Ts'o <tytso@mit.edu>

commit dc12baacb95f205948f64dc936a47d89ee110117 upstream.

add_device_randomness() use of crng_fast_load() was highly
problematic.  Some callers of add_device_randomness() can pass in a
large amount of static information.  This would immediately promote
the crng_init state from 0 to 1, without really doing much to
initialize the primary_crng's internal state with something even
vaguely unpredictable.

Since we don't have the speed constraints of add_interrupt_randomness(),
we can do a better job mixing in the what unpredictability a device
driver or architecture maintainer might see fit to give us, and do it
in a way which does not bump the crng_init_cnt variable.

Also, since add_device_randomness() doesn't bump any entropy
accounting in crng_init state 0, mix the device randomness into the
input_pool entropy pool as well.  This is related to CVE-2018-1108.

Reported-by: Jann Horn <jannh@google.com>
Fixes: ee7998c50c26 ("random: do not ignore early device randomness")
Cc: stable@kernel.org # 4.13+
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   55 ++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 51 insertions(+), 4 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -799,6 +799,10 @@ static void crng_initialize(struct crng_
 	crng->init_time = jiffies - CRNG_RESEED_INTERVAL - 1;
 }
 
+/*
+ * crng_fast_load() can be called by code in the interrupt service
+ * path.  So we can't afford to dilly-dally.
+ */
 static int crng_fast_load(const char *cp, size_t len)
 {
 	unsigned long flags;
@@ -876,6 +880,51 @@ static struct crng_state *select_crng(vo
 }
 #endif
 
+/*
+ * crng_slow_load() is called by add_device_randomness, which has two
+ * attributes.  (1) We can't trust the buffer passed to it is
+ * guaranteed to be unpredictable (so it might not have any entropy at
+ * all), and (2) it doesn't have the performance constraints of
+ * crng_fast_load().
+ *
+ * So we do something more comprehensive which is guaranteed to touch
+ * all of the primary_crng's state, and which uses a LFSR with a
+ * period of 255 as part of the mixing algorithm.  Finally, we do
+ * *not* advance crng_init_cnt since buffer we may get may be something
+ * like a fixed DMI table (for example), which might very well be
+ * unique to the machine, but is otherwise unvarying.
+ */
+static int crng_slow_load(const char *cp, size_t len)
+{
+	unsigned long		flags;
+	static unsigned char	lfsr = 1;
+	unsigned char		tmp;
+	unsigned		i, max = CHACHA20_KEY_SIZE;
+	const char *		src_buf = cp;
+	char *			dest_buf = (char *) &primary_crng.state[4];
+
+	if (!spin_trylock_irqsave(&primary_crng.lock, flags))
+		return 0;
+	if (crng_init != 0) {
+		spin_unlock_irqrestore(&primary_crng.lock, flags);
+		return 0;
+	}
+	if (len > max)
+		max = len;
+
+	for (i = 0; i < max ; i++) {
+		tmp = lfsr;
+		lfsr >>= 1;
+		if (tmp & 1)
+			lfsr ^= 0xE1;
+		tmp = dest_buf[i % CHACHA20_KEY_SIZE];
+		dest_buf[i % CHACHA20_KEY_SIZE] ^= src_buf[i % len] ^ lfsr;
+		lfsr += (tmp << 3) | (tmp >> 5);
+	}
+	spin_unlock_irqrestore(&primary_crng.lock, flags);
+	return 1;
+}
+
 static void crng_reseed(struct crng_state *crng, struct entropy_store *r)
 {
 	unsigned long	flags;
@@ -1046,10 +1095,8 @@ void add_device_randomness(const void *b
 	unsigned long time = random_get_entropy() ^ jiffies;
 	unsigned long flags;
 
-	if (!crng_ready()) {
-		crng_fast_load(buf, size);
-		return;
-	}
+	if (!crng_ready() && size)
+		crng_slow_load(buf, size);
 
 	trace_add_device_randomness(size, _RET_IP_);
 	spin_lock_irqsave(&input_pool.lock, flags);


