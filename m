Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 852B655804B
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232427AbiFWQqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232119AbiFWQqK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:46:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A84849936;
        Thu, 23 Jun 2022 09:46:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C3E161F4A;
        Thu, 23 Jun 2022 16:46:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD2F9C3411B;
        Thu, 23 Jun 2022 16:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002763;
        bh=acTDpMhWkZASg9kenzikQtg6sdaeRAIDpz7Wx/oAjgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ObIfpMf6ELm9qDQ3eM2iY3hw4dpNN98gNLLgNlX/Nu5MIt8jo7mrbVsqUspde2bv
         vwP06QgqS5XPv2xc++hUgnVKWHxWVMLoJcGJ9rfZxBHhxLWslE15wc/uPwL+14bGA6
         3nBLuWUOElLAR9ZKplZP4GSfKkZLKmC9C8Sqplds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 4.9 018/264] random: set up the NUMA crng instances after the CRNG is fully initialized
Date:   Thu, 23 Jun 2022 18:40:11 +0200
Message-Id: <20220623164344.580933193@linuxfoundation.org>
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

commit 8ef35c866f8862df074a49a93b0309725812dea8 upstream.

Until the primary_crng is fully initialized, don't initialize the NUMA
crng nodes.  Otherwise users of /dev/urandom on NUMA systems before
the CRNG is fully initialized can get very bad quality randomness.  Of
course everyone should move to getrandom(2) where this won't be an
issue, but there's a lot of legacy code out there.  This related to
CVE-2018-1108.

Reported-by: Jann Horn <jannh@google.com>
Fixes: 1e7f583af67b ("random: make /dev/urandom scalable for silly...")
Cc: stable@kernel.org # 4.8+
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -799,6 +799,32 @@ static void crng_initialize(struct crng_
 	crng->init_time = jiffies - CRNG_RESEED_INTERVAL - 1;
 }
 
+#ifdef CONFIG_NUMA
+static void numa_crng_init(void)
+{
+	int i;
+	struct crng_state *crng;
+	struct crng_state **pool;
+
+	pool = kcalloc(nr_node_ids, sizeof(*pool), GFP_KERNEL|__GFP_NOFAIL);
+	for_each_online_node(i) {
+		crng = kmalloc_node(sizeof(struct crng_state),
+				    GFP_KERNEL | __GFP_NOFAIL, i);
+		spin_lock_init(&crng->lock);
+		crng_initialize(crng);
+		pool[i] = crng;
+	}
+	mb();
+	if (cmpxchg(&crng_node_pool, NULL, pool)) {
+		for_each_node(i)
+			kfree(pool[i]);
+		kfree(pool);
+	}
+}
+#else
+static void numa_crng_init(void) {}
+#endif
+
 /*
  * crng_fast_load() can be called by code in the interrupt service
  * path.  So we can't afford to dilly-dally.
@@ -957,6 +983,7 @@ static void crng_reseed(struct crng_stat
 	if (crng == &primary_crng && crng_init < 2) {
 		numa_crng_init();
 		invalidate_batched_entropy();
+		numa_crng_init();
 		crng_init = 2;
 		process_random_ready_list();
 		wake_up_interruptible(&crng_init_wait);


