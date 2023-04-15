Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73D3A6E3079
	for <lists+stable@lfdr.de>; Sat, 15 Apr 2023 12:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjDOKMG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Apr 2023 06:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbjDOKMD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Apr 2023 06:12:03 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744C9198A;
        Sat, 15 Apr 2023 03:12:01 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Pz8Df1Kp9zKyFZ;
        Sat, 15 Apr 2023 18:09:22 +0800 (CST)
Received: from cgs.huawei.com (10.244.148.83) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sat, 15 Apr 2023 18:11:59 +0800
From:   Gaosheng Cui <cuigaosheng1@huawei.com>
To:     <stable@vger.kernel.org>, <cuigaosheng1@huawei.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <gregkh@linuxfoundation.org>, <linux-crypto@vger.kernel.org>
Subject: [PATCH 5.10 2/4] crypto: api - Do not create test larvals if manager is disabled
Date:   Sat, 15 Apr 2023 18:11:56 +0800
Message-ID: <20230415101158.1648486-3-cuigaosheng1@huawei.com>
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

The delayed boot-time testing patch created a dependency loop
between api.c and algapi.c because it added a crypto_alg_tested
call to the former when the crypto manager is disabled.

We could instead avoid creating the test larvals if the crypto
manager is disabled.  This avoids the dependency loop as well
as saving some unnecessary work, albeit in a very unlikely case.

Reported-by: Nathan Chancellor <nathan@kernel.org>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Reported-by: kernel test robot <lkp@intel.com>
Fixes: adad556efcdd ("crypto: api - Fix built-in testing dependency failures")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
---
 crypto/algapi.c | 56 +++++++++++++++++++++++++++++++------------------
 crypto/api.c    |  7 ++-----
 2 files changed, 38 insertions(+), 25 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index d6cd860bca4f..f6481cb79946 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -216,6 +216,32 @@ void crypto_remove_spawns(struct crypto_alg *alg, struct list_head *list,
 }
 EXPORT_SYMBOL_GPL(crypto_remove_spawns);
 
+static struct crypto_larval *crypto_alloc_test_larval(struct crypto_alg *alg)
+{
+	struct crypto_larval *larval;
+
+	if (!IS_ENABLED(CONFIG_CRYPTO_MANAGER))
+		return NULL;
+
+	larval = crypto_larval_alloc(alg->cra_name,
+				     alg->cra_flags | CRYPTO_ALG_TESTED, 0);
+	if (IS_ERR(larval))
+		return larval;
+
+	larval->adult = crypto_mod_get(alg);
+	if (!larval->adult) {
+		kfree(larval);
+		return ERR_PTR(-ENOENT);
+	}
+
+	refcount_set(&larval->alg.cra_refcnt, 1);
+	memcpy(larval->alg.cra_driver_name, alg->cra_driver_name,
+	       CRYPTO_MAX_ALG_NAME);
+	larval->alg.cra_priority = alg->cra_priority;
+
+	return larval;
+}
+
 static struct crypto_larval *__crypto_register_alg(struct crypto_alg *alg)
 {
 	struct crypto_alg *q;
@@ -250,31 +276,20 @@ static struct crypto_larval *__crypto_register_alg(struct crypto_alg *alg)
 			goto err;
 	}
 
-	larval = crypto_larval_alloc(alg->cra_name,
-				     alg->cra_flags | CRYPTO_ALG_TESTED, 0);
+	larval = crypto_alloc_test_larval(alg);
 	if (IS_ERR(larval))
 		goto out;
 
-	ret = -ENOENT;
-	larval->adult = crypto_mod_get(alg);
-	if (!larval->adult)
-		goto free_larval;
-
-	refcount_set(&larval->alg.cra_refcnt, 1);
-	memcpy(larval->alg.cra_driver_name, alg->cra_driver_name,
-	       CRYPTO_MAX_ALG_NAME);
-	larval->alg.cra_priority = alg->cra_priority;
-
 	list_add(&alg->cra_list, &crypto_alg_list);
-	list_add(&larval->alg.cra_list, &crypto_alg_list);
+
+	if (larval)
+		list_add(&larval->alg.cra_list, &crypto_alg_list);
 
 	crypto_stats_init(alg);
 
 out:
 	return larval;
 
-free_larval:
-	kfree(larval);
 err:
 	larval = ERR_PTR(ret);
 	goto out;
@@ -403,10 +418,11 @@ int crypto_register_alg(struct crypto_alg *alg)
 	down_write(&crypto_alg_sem);
 	larval = __crypto_register_alg(alg);
 	test_started = static_key_enabled(&crypto_boot_test_finished);
-	larval->test_started = test_started;
+	if (!IS_ERR_OR_NULL(larval))
+		larval->test_started = test_started;
 	up_write(&crypto_alg_sem);
 
-	if (IS_ERR(larval))
+	if (IS_ERR_OR_NULL(larval))
 		return PTR_ERR(larval);
 
 	if (test_started)
@@ -616,8 +632,8 @@ int crypto_register_instance(struct crypto_template *tmpl,
 	larval = __crypto_register_alg(&inst->alg);
 	if (IS_ERR(larval))
 		goto unlock;
-
-	larval->test_started = true;
+	else if (larval)
+		larval->test_started = true;
 
 	hlist_add_head(&inst->list, &tmpl->instances);
 	inst->tmpl = tmpl;
@@ -626,7 +642,7 @@ int crypto_register_instance(struct crypto_template *tmpl,
 	up_write(&crypto_alg_sem);
 
 	err = PTR_ERR(larval);
-	if (IS_ERR(larval))
+	if (IS_ERR_OR_NULL(larval))
 		goto err;
 
 	crypto_wait_for_test(larval);
diff --git a/crypto/api.c b/crypto/api.c
index 44d3e4f8bb58..0e7a255252ca 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -166,11 +166,8 @@ void crypto_wait_for_test(struct crypto_larval *larval)
 	int err;
 
 	err = crypto_probing_notify(CRYPTO_MSG_ALG_REGISTER, larval->adult);
-	if (err != NOTIFY_STOP) {
-		if (WARN_ON(err != NOTIFY_DONE))
-			goto out;
-		crypto_alg_tested(larval->alg.cra_driver_name, 0);
-	}
+	if (WARN_ON_ONCE(err != NOTIFY_STOP))
+		goto out;
 
 	err = wait_for_completion_killable(&larval->completion);
 	WARN_ON(err);
-- 
2.25.1

