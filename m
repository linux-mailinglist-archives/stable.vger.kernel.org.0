Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2D85498BB3
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344857AbiAXTPt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:15:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344474AbiAXTNI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:13:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E51CC0604E4;
        Mon, 24 Jan 2022 11:04:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B9B8611AA;
        Mon, 24 Jan 2022 19:04:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEED5C340E7;
        Mon, 24 Jan 2022 19:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051053;
        bh=rXd6LyLgHQs8EPpBZPLcthJ27s9rYX6Ct5f8zFmZBnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YFlPQjFLc6TYqFZBEhnvvfzytXN4lsdjYJQcbYm0kWu30bs34eZQ57xVTU7Y9l1RM
         7WhqrptiSX428BZ1bCjXbIJTLvowlDnYvBHHPPzJmBnFRoK3+uRhpFeYeDEi2T+Ze4
         QIpGB9ZAwYAEAxU0SmWhbGYHzgKTZkf65rgBqsVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 007/186] random: fix data race on crng_node_pool
Date:   Mon, 24 Jan 2022 19:41:22 +0100
Message-Id: <20220124183937.351692913@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 5d73d1e320c3fd94ea15ba5f79301da9a8bcc7de upstream.

extract_crng() and crng_backtrack_protect() load crng_node_pool with a
plain load, which causes undefined behavior if do_numa_crng_init()
modifies it concurrently.

Fix this by using READ_ONCE().  Note: as per the previous discussion
https://lore.kernel.org/lkml/20211219025139.31085-1-ebiggers@kernel.org/T/#u,
READ_ONCE() is believed to be sufficient here, and it was requested that
it be used here instead of smp_load_acquire().

Also change do_numa_crng_init() to set crng_node_pool using
cmpxchg_release() instead of mb() + cmpxchg(), as the former is
sufficient here but is more lightweight.

Fixes: 1e7f583af67b ("random: make /dev/urandom scalable for silly userspace programs")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Acked-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -813,8 +813,8 @@ static void do_numa_crng_init(struct wor
 		crng_initialize(crng);
 		pool[i] = crng;
 	}
-	mb();
-	if (cmpxchg(&crng_node_pool, NULL, pool)) {
+	/* pairs with READ_ONCE() in select_crng() */
+	if (cmpxchg_release(&crng_node_pool, NULL, pool) != NULL) {
 		for_each_node(i)
 			kfree(pool[i]);
 		kfree(pool);
@@ -827,8 +827,26 @@ static void numa_crng_init(void)
 {
 	schedule_work(&numa_crng_init_work);
 }
+
+static struct crng_state *select_crng(void)
+{
+	struct crng_state **pool;
+	int nid = numa_node_id();
+
+	/* pairs with cmpxchg_release() in do_numa_crng_init() */
+	pool = READ_ONCE(crng_node_pool);
+	if (pool && pool[nid])
+		return pool[nid];
+
+	return &primary_crng;
+}
 #else
 static void numa_crng_init(void) {}
+
+static struct crng_state *select_crng(void)
+{
+	return &primary_crng;
+}
 #endif
 
 /*
@@ -977,15 +995,7 @@ static void _extract_crng(struct crng_st
 
 static void extract_crng(__u8 out[CHACHA20_BLOCK_SIZE])
 {
-	struct crng_state *crng = NULL;
-
-#ifdef CONFIG_NUMA
-	if (crng_node_pool)
-		crng = crng_node_pool[numa_node_id()];
-	if (crng == NULL)
-#endif
-		crng = &primary_crng;
-	_extract_crng(crng, out);
+	_extract_crng(select_crng(), out);
 }
 
 /*
@@ -1014,15 +1024,7 @@ static void _crng_backtrack_protect(stru
 
 static void crng_backtrack_protect(__u8 tmp[CHACHA20_BLOCK_SIZE], int used)
 {
-	struct crng_state *crng = NULL;
-
-#ifdef CONFIG_NUMA
-	if (crng_node_pool)
-		crng = crng_node_pool[numa_node_id()];
-	if (crng == NULL)
-#endif
-		crng = &primary_crng;
-	_crng_backtrack_protect(crng, tmp, used);
+	_crng_backtrack_protect(select_crng(), tmp, used);
 }
 
 static ssize_t extract_crng_user(void __user *buf, size_t nbytes)


