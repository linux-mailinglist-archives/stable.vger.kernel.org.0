Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B83DC48E59F
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239830AbiANITf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:19:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239732AbiANITC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:19:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C808C06177B;
        Fri, 14 Jan 2022 00:19:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F186161E1F;
        Fri, 14 Jan 2022 08:18:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAFF0C36AE9;
        Fri, 14 Jan 2022 08:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642148339;
        bh=aQwWQG2dZCe/QnD746MOLbyMgXEjVFDmIcu6mhHzYas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dblnxaMejT5qktIA5IcOcWX4Z67W1i0f+MvnLjXuhfjOZvbsQ+HPQe/KjtrqLmRnv
         hvOhihnuKPseawTej9dTUi21X7yGnc3FHjDWrecRMVvOYfqf61rF0JLEwG6ZWuqF4K
         htHN+aZhLYIPE+jZ/6qrQrNG6y2VdQENrurYYeOk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 19/25] random: fix data race on crng_node_pool
Date:   Fri, 14 Jan 2022 09:16:27 +0100
Message-Id: <20220114081543.352538528@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114081542.698002137@linuxfoundation.org>
References: <20220114081542.698002137@linuxfoundation.org>
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
@@ -853,8 +853,8 @@ static void do_numa_crng_init(struct wor
 		crng_initialize_secondary(crng);
 		pool[i] = crng;
 	}
-	mb();
-	if (cmpxchg(&crng_node_pool, NULL, pool)) {
+	/* pairs with READ_ONCE() in select_crng() */
+	if (cmpxchg_release(&crng_node_pool, NULL, pool) != NULL) {
 		for_each_node(i)
 			kfree(pool[i]);
 		kfree(pool);
@@ -867,8 +867,26 @@ static void numa_crng_init(void)
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
@@ -1015,15 +1033,7 @@ static void _extract_crng(struct crng_st
 
 static void extract_crng(__u8 out[CHACHA_BLOCK_SIZE])
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
@@ -1052,15 +1062,7 @@ static void _crng_backtrack_protect(stru
 
 static void crng_backtrack_protect(__u8 tmp[CHACHA_BLOCK_SIZE], int used)
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


