Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74F916E3073
	for <lists+stable@lfdr.de>; Sat, 15 Apr 2023 12:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjDOKME (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Apr 2023 06:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjDOKMD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Apr 2023 06:12:03 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ECD110D5;
        Sat, 15 Apr 2023 03:12:01 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Pz8CT3zclz17SXw;
        Sat, 15 Apr 2023 18:08:21 +0800 (CST)
Received: from cgs.huawei.com (10.244.148.83) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sat, 15 Apr 2023 18:11:59 +0800
From:   Gaosheng Cui <cuigaosheng1@huawei.com>
To:     <stable@vger.kernel.org>, <cuigaosheng1@huawei.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <gregkh@linuxfoundation.org>, <linux-crypto@vger.kernel.org>
Subject: [PATCH 5.10 1/4] crypto: api - Fix built-in testing dependency failures
Date:   Sat, 15 Apr 2023 18:11:55 +0800
Message-ID: <20230415101158.1648486-2-cuigaosheng1@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230415101158.1648486-1-cuigaosheng1@huawei.com>
References: <20230415101158.1648486-1-cuigaosheng1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.244.148.83]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

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
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
---
 crypto/algapi.c   | 73 +++++++++++++++++++++++++++++++++--------------
 crypto/api.c      | 52 +++++++++++++++++++++++++++++----
 crypto/internal.h | 10 +++++++
 3 files changed, 108 insertions(+), 27 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 9de27daa98b4..d6cd860bca4f 100644
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
 
@@ -1279,9 +1265,48 @@ void crypto_stats_skcipher_decrypt(unsigned int cryptlen, int ret,
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
 
@@ -1290,7 +1315,11 @@ static void __exit crypto_algapi_exit(void)
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
index 5ffcd3ab4a75..44d3e4f8bb58 100644
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
index 976ec9dfc76d..0a8986a9ca8c 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -10,6 +10,7 @@
 
 #include <crypto/algapi.h>
 #include <linux/completion.h>
+#include <linux/jump_label.h>
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/notifier.h>
@@ -27,12 +28,15 @@ struct crypto_larval {
 	struct crypto_alg *adult;
 	struct completion completion;
 	u32 mask;
+	bool test_started;
 };
 
 extern struct list_head crypto_alg_list;
 extern struct rw_semaphore crypto_alg_sem;
 extern struct blocking_notifier_head crypto_chain;
 
+DECLARE_STATIC_KEY_FALSE(crypto_boot_test_finished);
+
 #ifdef CONFIG_PROC_FS
 void __init crypto_init_proc(void);
 void __exit crypto_exit_proc(void);
@@ -58,6 +62,7 @@ struct crypto_alg *crypto_alg_mod_lookup(const char *name, u32 type, u32 mask);
 
 struct crypto_larval *crypto_larval_alloc(const char *name, u32 type, u32 mask);
 void crypto_larval_kill(struct crypto_alg *alg);
+void crypto_wait_for_test(struct crypto_larval *larval);
 void crypto_alg_tested(const char *name, int err);
 
 void crypto_remove_spawns(struct crypto_alg *alg, struct list_head *list,
@@ -144,5 +149,10 @@ static inline void crypto_yield(u32 flags)
 		cond_resched();
 }
 
+static inline int crypto_is_test_larval(struct crypto_larval *larval)
+{
+	return larval->alg.cra_driver_name[0];
+}
+
 #endif	/* _CRYPTO_INTERNAL_H */
 
-- 
2.25.1

