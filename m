Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D031164B512
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 13:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235633AbiLMMXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 07:23:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235565AbiLMMXH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 07:23:07 -0500
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15884FFB;
        Tue, 13 Dec 2022 04:23:06 -0800 (PST)
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4NWd1g1B4Dz9smY;
        Tue, 13 Dec 2022 13:23:03 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id wQpv-BK6o0IO; Tue, 13 Dec 2022 13:23:03 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4NWd1g0GVNz9sm8;
        Tue, 13 Dec 2022 13:23:03 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id EDEC78B773;
        Tue, 13 Dec 2022 13:23:02 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id a2dakGG70529; Tue, 13 Dec 2022 13:23:02 +0100 (CET)
Received: from PO20335.IDSI0.si.c-s.fr (unknown [192.168.7.67])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id B11108B766;
        Tue, 13 Dec 2022 13:23:02 +0100 (CET)
Received: from PO20335.IDSI0.si.c-s.fr (localhost [127.0.0.1])
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.16.1) with ESMTPS id 2BDCMosN630599
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 13:22:50 +0100
Received: (from chleroy@localhost)
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.17.1/Submit) id 2BDCMnIC630590;
        Tue, 13 Dec 2022 13:22:49 +0100
X-Authentication-Warning: PO20335.IDSI0.si.c-s.fr: chleroy set sender to christophe.leroy@csgroup.eu using -f
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Eric Dumazet <edumazet@google.com>, Willy Tarreau <w@1wt.eu>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH] [REBASED for 4.14] once: add DO_ONCE_SLOW() for sleepable contexts
Date:   Tue, 13 Dec 2022 13:22:40 +0100
Message-Id: <df44c3cd06ae0155f04f9d87fff35db67761beea.1670934155.git.christophe.leroy@csgroup.eu>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1670934159; l=5194; i=christophe.leroy@csgroup.eu; s=20211009; h=from:subject:message-id; bh=l/gW9uV8JB+UhiaHzRrRgcxXXLZq3Tnd8dyGrCC7WSQ=; b=3X9VI7eJm5NqUCwR9bw3dR0g6EqtdvEC+5pulqUc5uMYk1TxKqxmRogKnpF5UF/QPd1Ps57wnCmV 8KMtUWLzBbSTHeNxuUHDDtReljWOh85skZtePeE4r5iff+reV2fa
X-Developer-Key: i=christophe.leroy@csgroup.eu; a=ed25519; pk=HIzTzUj91asvincQGOFx6+ZF5AoUuP9GdOtQChs7Mm0=
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 62c07983bef9d3e78e71189441e1a470f0d1e653 ]

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
---
 include/linux/once.h       | 28 ++++++++++++++++++++++++++++
 lib/once.c                 | 30 ++++++++++++++++++++++++++++++
 net/ipv4/inet_hashtables.c |  4 ++--
 3 files changed, 60 insertions(+), 2 deletions(-)

diff --git a/include/linux/once.h b/include/linux/once.h
index 6790884d3c57..bb091119b754 100644
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
@@ -52,9 +60,29 @@ void __do_once_done(bool *done, struct static_key *once_key,
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
diff --git a/lib/once.c b/lib/once.c
index bfb7420d0de3..76c7bbc0aa40 100644
--- a/lib/once.c
+++ b/lib/once.c
@@ -61,3 +61,33 @@ void __do_once_done(bool *done, struct static_key *once_key,
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
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 48c7a3a51fc1..590801a7487f 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -638,8 +638,8 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	if (likely(remaining > 1))
 		remaining &= ~1U;
 
-	net_get_random_once(table_perturb,
-			    INET_TABLE_PERTURB_SIZE * sizeof(*table_perturb));
+	get_random_slow_once(table_perturb,
+			     INET_TABLE_PERTURB_SIZE * sizeof(*table_perturb));
 	index = port_offset & (INET_TABLE_PERTURB_SIZE - 1);
 
 	offset = READ_ONCE(table_perturb[index]) + (port_offset >> 32);
-- 
2.38.1

