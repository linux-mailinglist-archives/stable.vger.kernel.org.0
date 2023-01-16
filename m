Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C238C66CC3E
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234334AbjAPRXn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:23:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234653AbjAPRWt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:22:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 784A034C3B
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:00:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82D7760F63
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:00:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9357CC433F2;
        Mon, 16 Jan 2023 17:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888453;
        bh=YG6J9RgwKZu3Vp7W+2E+iGexVV0TkxyAXehYF1f4VKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2VtK234I5c6WQWRma07qncUOH1anjGv+b0ir4I6FA2Eam+c0JcAsvd6w22DPvp+qQ
         zHZyfndLFU6WvFsRHkqmWfrxSLy8q5l0C1Czfa++5qti/f2IntcUJuRMm9GgGmTs+i
         W0idAN7o/FMz/X3uz7tOaPwNv4ke/7m7XTrtQB5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Eric Dumazet <edumazet@google.com>, Willy Tarreau <w@1wt.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 002/338] once: add DO_ONCE_SLOW() for sleepable contexts
Date:   Mon, 16 Jan 2023 16:47:55 +0100
Message-Id: <20230116154820.802470217@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 62c07983bef9d3e78e71189441e1a470f0d1e653 upstream.

Christophe Leroy reported a ~80ms latency spike
happening at first TCP connect() time.

This is because __inet_hash_connect() uses get_random_once()
to populate a perturbation table which became quite big
after commit 4c2c8f03a5ab ("tcp: increase source port perturb table to 2^16")

get_random_once() uses DO_ONCE(), which block hard irqs for the duration
of the operation.

This patch adds DO_ONCE_SLOW() which uses a mutex instead of a spinlock
for operations where we prefer to stay in process context.

Then __inet_hash_connect() can use get_random_slow_once()
to populate its perturbation table.

Fixes: 4c2c8f03a5ab ("tcp: increase source port perturb table to 2^16")
Fixes: 190cc82489f4 ("tcp: change source port randomizarion at connect() time")
Reported-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Link: https://lore.kernel.org/netdev/CANn89iLAEYBaoYajy0Y9UmGFff5GPxDUoG-ErVB2jDdRNQ5Tug@mail.gmail.com/T/#t
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Willy Tarreau <w@1wt.eu>
Tested-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/once.h       |   28 ++++++++++++++++++++++++++++
 lib/once.c                 |   30 ++++++++++++++++++++++++++++++
 net/ipv4/inet_hashtables.c |    4 ++--
 3 files changed, 60 insertions(+), 2 deletions(-)

--- a/include/linux/once.h
+++ b/include/linux/once.h
@@ -5,10 +5,18 @@
 #include <linux/types.h>
 #include <linux/jump_label.h>
 
+/* Helpers used from arbitrary contexts.
+ * Hard irqs are blocked, be cautious.
+ */
 bool __do_once_start(bool *done, unsigned long *flags);
 void __do_once_done(bool *done, struct static_key *once_key,
 		    unsigned long *flags);
 
+/* Variant for process contexts only. */
+bool __do_once_slow_start(bool *done);
+void __do_once_slow_done(bool *done, struct static_key *once_key,
+			 struct module *mod);
+
 /* Call a function exactly once. The idea of DO_ONCE() is to perform
  * a function call such as initialization of random seeds, etc, only
  * once, where DO_ONCE() can live in the fast-path. After @func has
@@ -52,9 +60,29 @@ void __do_once_done(bool *done, struct s
 		___ret;							     \
 	})
 
+/* Variant of DO_ONCE() for process/sleepable contexts. */
+#define DO_ONCE_SLOW(func, ...)						     \
+	({								     \
+		bool ___ret = false;					     \
+		static bool ___done = false;				     \
+		static struct static_key ___once_key = STATIC_KEY_INIT_TRUE; \
+		if (static_key_true(&___once_key)) {		     \
+			___ret = __do_once_slow_start(&___done);	     \
+			if (unlikely(___ret)) {				     \
+				func(__VA_ARGS__);			     \
+				__do_once_slow_done(&___done, &___once_key,  \
+						    THIS_MODULE);	     \
+			}						     \
+		}							     \
+		___ret;							     \
+	})
+
 #define get_random_once(buf, nbytes)					     \
 	DO_ONCE(get_random_bytes, (buf), (nbytes))
 #define get_random_once_wait(buf, nbytes)                                    \
 	DO_ONCE(get_random_bytes_wait, (buf), (nbytes))                      \
 
+#define get_random_slow_once(buf, nbytes)				     \
+	DO_ONCE_SLOW(get_random_bytes, (buf), (nbytes))
+
 #endif /* _LINUX_ONCE_H */
--- a/lib/once.c
+++ b/lib/once.c
@@ -61,3 +61,33 @@ void __do_once_done(bool *done, struct s
 	once_disable_jump(once_key);
 }
 EXPORT_SYMBOL(__do_once_done);
+
+static DEFINE_MUTEX(once_mutex);
+
+bool __do_once_slow_start(bool *done)
+	__acquires(once_mutex)
+{
+	mutex_lock(&once_mutex);
+	if (*done) {
+		mutex_unlock(&once_mutex);
+		/* Keep sparse happy by restoring an even lock count on
+		 * this mutex. In case we return here, we don't call into
+		 * __do_once_done but return early in the DO_ONCE_SLOW() macro.
+		 */
+		__acquire(once_mutex);
+		return false;
+	}
+
+	return true;
+}
+EXPORT_SYMBOL(__do_once_slow_start);
+
+void __do_once_slow_done(bool *done, struct static_key *once_key,
+			 struct module *mod)
+	__releases(once_mutex)
+{
+	*done = true;
+	mutex_unlock(&once_mutex);
+	once_disable_jump(once_key);
+}
+EXPORT_SYMBOL(__do_once_slow_done);
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -638,8 +638,8 @@ int __inet_hash_connect(struct inet_time
 	if (likely(remaining > 1))
 		remaining &= ~1U;
 
-	net_get_random_once(table_perturb,
-			    INET_TABLE_PERTURB_SIZE * sizeof(*table_perturb));
+	get_random_slow_once(table_perturb,
+			     INET_TABLE_PERTURB_SIZE * sizeof(*table_perturb));
 	index = port_offset & (INET_TABLE_PERTURB_SIZE - 1);
 
 	offset = READ_ONCE(table_perturb[index]) + (port_offset >> 32);


