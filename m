Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD1C44A088
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241641AbhKIBD6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:03:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:60234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241680AbhKIBDi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:03:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 677EC619EA;
        Tue,  9 Nov 2021 01:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419653;
        bh=fCqHqkmUE/E2BXeR07rNehjkdO7/tamy3VndTpB36NQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AFYiSfhyApwVRX9f4QjmkH0WASBtta7ImVGbw7mU1tqsNoMGtsKFJoSFewSuO7jm8
         M7C5aSMsVF21uFi6FTZ3ft5be68Sl+xXSUq13b5KL0Jl8swOktTINnocXiT6DkxjOR
         rOBNjdITGk5bCFBiJpENEUGkY0fK+pOl1kbsZcl9ELwUmg2gcJWO1Xe+OgEZzZgmzD
         r42M4yrwUDYhnScyRatOZYlNxlb+wztE91VxV/LYLvIvLu79gbXL4lW85CzQf2Sz1h
         bGYItIk8G0dtyB2Vmlkkb6IKVrsCa5v7ukdOP4kxdbalmi8V9ysRB4BcRJU8sAazEd
         BpyKUwaNujz2g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Vladis Dronov <vdronov@redhat.com>,
        Sasha Levin <sashal@kernel.org>, Herbert@vger.kernel.org,
        davem@davemloft.net, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 030/146] crypto: api - Fix built-in testing dependency failures
Date:   Mon,  8 Nov 2021 12:42:57 -0500
Message-Id: <20211108174453.1187052-30-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174453.1187052-1-sashal@kernel.org>
References: <20211108174453.1187052-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit adad556efcdd42a1d9e060cbe5f6161cccf1fa28 ]

When complex algorithms that depend on other algorithms are built
into the kernel, the order of registration must be done such that
the underlying algorithms are ready before the ones on top are
registered.  As otherwise they would fail during the self-test
which is required during registration.

In the past we have used subsystem initialisation ordering to
guarantee this.  The number of such precedence levels are limited
and they may cause ripple effects in other subsystems.

This patch solves this problem by delaying all self-tests during
boot-up for built-in algorithms.  They will be tested either when
something else in the kernel requests for them, or when we have
finished registering all built-in algorithms, whichever comes
earlier.

Reported-by: Vladis Dronov <vdronov@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/algapi.c   | 73 +++++++++++++++++++++++++++++++++--------------
 crypto/api.c      | 52 +++++++++++++++++++++++++++++----
 crypto/internal.h | 10 +++++++
 3 files changed, 108 insertions(+), 27 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 43f999dba4dc0..422bdca214e1c 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -389,29 +389,10 @@ void crypto_remove_final(struct list_head *list)
 }
 EXPORT_SYMBOL_GPL(crypto_remove_final);
 
-static void crypto_wait_for_test(struct crypto_larval *larval)
-{
-	int err;
-
-	err = crypto_probing_notify(CRYPTO_MSG_ALG_REGISTER, larval->adult);
-	if (err != NOTIFY_STOP) {
-		if (WARN_ON(err != NOTIFY_DONE))
-			goto out;
-		crypto_alg_tested(larval->alg.cra_driver_name, 0);
-	}
-
-	err = wait_for_completion_killable(&larval->completion);
-	WARN_ON(err);
-	if (!err)
-		crypto_notify(CRYPTO_MSG_ALG_LOADED, larval);
-
-out:
-	crypto_larval_kill(&larval->alg);
-}
-
 int crypto_register_alg(struct crypto_alg *alg)
 {
 	struct crypto_larval *larval;
+	bool test_started;
 	int err;
 
 	alg->cra_flags &= ~CRYPTO_ALG_DEAD;
@@ -421,12 +402,15 @@ int crypto_register_alg(struct crypto_alg *alg)
 
 	down_write(&crypto_alg_sem);
 	larval = __crypto_register_alg(alg);
+	test_started = static_key_enabled(&crypto_boot_test_finished);
+	larval->test_started = test_started;
 	up_write(&crypto_alg_sem);
 
 	if (IS_ERR(larval))
 		return PTR_ERR(larval);
 
-	crypto_wait_for_test(larval);
+	if (test_started)
+		crypto_wait_for_test(larval);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(crypto_register_alg);
@@ -633,6 +617,8 @@ int crypto_register_instance(struct crypto_template *tmpl,
 	if (IS_ERR(larval))
 		goto unlock;
 
+	larval->test_started = true;
+
 	hlist_add_head(&inst->list, &tmpl->instances);
 	inst->tmpl = tmpl;
 
@@ -1261,9 +1247,48 @@ void crypto_stats_skcipher_decrypt(unsigned int cryptlen, int ret,
 EXPORT_SYMBOL_GPL(crypto_stats_skcipher_decrypt);
 #endif
 
+static void __init crypto_start_tests(void)
+{
+	for (;;) {
+		struct crypto_larval *larval = NULL;
+		struct crypto_alg *q;
+
+		down_write(&crypto_alg_sem);
+
+		list_for_each_entry(q, &crypto_alg_list, cra_list) {
+			struct crypto_larval *l;
+
+			if (!crypto_is_larval(q))
+				continue;
+
+			l = (void *)q;
+
+			if (!crypto_is_test_larval(l))
+				continue;
+
+			if (l->test_started)
+				continue;
+
+			l->test_started = true;
+			larval = l;
+			break;
+		}
+
+		up_write(&crypto_alg_sem);
+
+		if (!larval)
+			break;
+
+		crypto_wait_for_test(larval);
+	}
+
+	static_branch_enable(&crypto_boot_test_finished);
+}
+
 static int __init crypto_algapi_init(void)
 {
 	crypto_init_proc();
+	crypto_start_tests();
 	return 0;
 }
 
@@ -1272,7 +1297,11 @@ static void __exit crypto_algapi_exit(void)
 	crypto_exit_proc();
 }
 
-module_init(crypto_algapi_init);
+/*
+ * We run this at late_initcall so that all the built-in algorithms
+ * have had a chance to register themselves first.
+ */
+late_initcall(crypto_algapi_init);
 module_exit(crypto_algapi_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/api.c b/crypto/api.c
index c4eda56cff891..1cf1f03347cc3 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -12,6 +12,7 @@
 
 #include <linux/err.h>
 #include <linux/errno.h>
+#include <linux/jump_label.h>
 #include <linux/kernel.h>
 #include <linux/kmod.h>
 #include <linux/module.h>
@@ -30,6 +31,8 @@ EXPORT_SYMBOL_GPL(crypto_alg_sem);
 BLOCKING_NOTIFIER_HEAD(crypto_chain);
 EXPORT_SYMBOL_GPL(crypto_chain);
 
+DEFINE_STATIC_KEY_FALSE(crypto_boot_test_finished);
+
 static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg);
 
 struct crypto_alg *crypto_mod_get(struct crypto_alg *alg)
@@ -47,11 +50,6 @@ void crypto_mod_put(struct crypto_alg *alg)
 }
 EXPORT_SYMBOL_GPL(crypto_mod_put);
 
-static inline int crypto_is_test_larval(struct crypto_larval *larval)
-{
-	return larval->alg.cra_driver_name[0];
-}
-
 static struct crypto_alg *__crypto_alg_lookup(const char *name, u32 type,
 					      u32 mask)
 {
@@ -163,11 +161,55 @@ void crypto_larval_kill(struct crypto_alg *alg)
 }
 EXPORT_SYMBOL_GPL(crypto_larval_kill);
 
+void crypto_wait_for_test(struct crypto_larval *larval)
+{
+	int err;
+
+	err = crypto_probing_notify(CRYPTO_MSG_ALG_REGISTER, larval->adult);
+	if (err != NOTIFY_STOP) {
+		if (WARN_ON(err != NOTIFY_DONE))
+			goto out;
+		crypto_alg_tested(larval->alg.cra_driver_name, 0);
+	}
+
+	err = wait_for_completion_killable(&larval->completion);
+	WARN_ON(err);
+	if (!err)
+		crypto_notify(CRYPTO_MSG_ALG_LOADED, larval);
+
+out:
+	crypto_larval_kill(&larval->alg);
+}
+EXPORT_SYMBOL_GPL(crypto_wait_for_test);
+
+static void crypto_start_test(struct crypto_larval *larval)
+{
+	if (!crypto_is_test_larval(larval))
+		return;
+
+	if (larval->test_started)
+		return;
+
+	down_write(&crypto_alg_sem);
+	if (larval->test_started) {
+		up_write(&crypto_alg_sem);
+		return;
+	}
+
+	larval->test_started = true;
+	up_write(&crypto_alg_sem);
+
+	crypto_wait_for_test(larval);
+}
+
 static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg)
 {
 	struct crypto_larval *larval = (void *)alg;
 	long timeout;
 
+	if (!static_branch_likely(&crypto_boot_test_finished))
+		crypto_start_test(larval);
+
 	timeout = wait_for_completion_killable_timeout(
 		&larval->completion, 60 * HZ);
 
diff --git a/crypto/internal.h b/crypto/internal.h
index f00869af689f5..c08385571853e 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -10,6 +10,7 @@
 
 #include <crypto/algapi.h>
 #include <linux/completion.h>
+#include <linux/jump_label.h>
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/notifier.h>
@@ -27,6 +28,7 @@ struct crypto_larval {
 	struct crypto_alg *adult;
 	struct completion completion;
 	u32 mask;
+	bool test_started;
 };
 
 enum {
@@ -45,6 +47,8 @@ extern struct list_head crypto_alg_list;
 extern struct rw_semaphore crypto_alg_sem;
 extern struct blocking_notifier_head crypto_chain;
 
+DECLARE_STATIC_KEY_FALSE(crypto_boot_test_finished);
+
 #ifdef CONFIG_PROC_FS
 void __init crypto_init_proc(void);
 void __exit crypto_exit_proc(void);
@@ -70,6 +74,7 @@ struct crypto_alg *crypto_alg_mod_lookup(const char *name, u32 type, u32 mask);
 
 struct crypto_larval *crypto_larval_alloc(const char *name, u32 type, u32 mask);
 void crypto_larval_kill(struct crypto_alg *alg);
+void crypto_wait_for_test(struct crypto_larval *larval);
 void crypto_alg_tested(const char *name, int err);
 
 void crypto_remove_spawns(struct crypto_alg *alg, struct list_head *list,
@@ -156,5 +161,10 @@ static inline void crypto_yield(u32 flags)
 		cond_resched();
 }
 
+static inline int crypto_is_test_larval(struct crypto_larval *larval)
+{
+	return larval->alg.cra_driver_name[0];
+}
+
 #endif	/* _CRYPTO_INTERNAL_H */
 
-- 
2.33.0

