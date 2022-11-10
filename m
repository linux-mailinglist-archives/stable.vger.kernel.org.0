Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2369E6239DE
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 03:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbiKJCkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 21:40:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232335AbiKJCj6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 21:39:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9218827145;
        Wed,  9 Nov 2022 18:39:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9A7A61D3A;
        Thu, 10 Nov 2022 02:39:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326A4C433D6;
        Thu, 10 Nov 2022 02:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668047993;
        bh=71fdnYwHkC15btlmZ17sMh39sslSdjdNKrbVDGaRcaE=;
        h=From:To:Cc:Subject:Date:From;
        b=edXxWPVHm1/Ei7W8SBg4W7fMtqk1Jrn1mkqUEuJSaqIreUkPgfM4B+9En748+5YQq
         Mk80Jz5b+hmcBxSb7UY/I0HpCSg3+EhEj1UOALRSZDjgpHnBQ5ShOSZDIKO4Sl2dlt
         KJfKNppPekOAMUblWWie0duNKEqYUJnNgg/8aHuJ8QH8c/pDEDyiJ520wRDfPdi5f5
         Zv/Se8sHe53/el55+Oh5418BG+kXjjQWv6ms6m57nJsDa0cmGn2l8+eSJghf7I47pc
         M0VDaBzP+CwBIp4+9OVFcRddgkjRCPrWS6e0U2YQLFsnVKkY0M46ondo6K6+UCP4Jx
         YPFQLzUzQRPzg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] crypto: avoid unnecessary work when self-tests are disabled
Date:   Wed,  9 Nov 2022 18:37:38 -0800
Message-Id: <20221110023738.147128-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Currently, registering an algorithm with the crypto API always causes a
notification to be posted to the "cryptomgr", which then creates a
kthread to self-test the algorithm.  However, if self-tests are disabled
in the kconfig (as is the default option), then this kthread just
notifies waiters that the algorithm has been tested, then exits.

This causes a significant amount of overhead, especially in the kthread
creation and destruction, which is not necessary at all.  For example,
in a quick test I found that booting a "minimum" x86_64 kernel with all
the crypto options enabled (except for the self-tests) takes about 400ms
until PID 1 can start.  Of that, a full 13ms is spent just doing this
pointless dance, involving a kthread being created, run, and destroyed
over 200 times.  That's over 3% of the entire kernel start time.

Fix this by just skipping the creation of the test larval and the
posting of the registration notification entirely, when self-tests are
disabled.  Also compile out the unnecessary code in algboss.c.

While this patch is an optimization and not a "fix" per se, I've marked
it as for stable, due to the large improvement it can make to boot time.

Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/algapi.c  |  3 ++-
 crypto/algboss.c | 11 +++++++----
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 5c69ff8e8fa5c..018935cb8417d 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -226,7 +226,8 @@ static struct crypto_larval *crypto_alloc_test_larval(struct crypto_alg *alg)
 {
 	struct crypto_larval *larval;
 
-	if (!IS_ENABLED(CONFIG_CRYPTO_MANAGER))
+	if (!IS_ENABLED(CONFIG_CRYPTO_MANAGER) ||
+	    IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS))
 		return NULL;
 
 	larval = crypto_larval_alloc(alg->cra_name,
diff --git a/crypto/algboss.c b/crypto/algboss.c
index eb5fe84efb83e..e6f0443d08048 100644
--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -171,16 +171,18 @@ static int cryptomgr_schedule_probe(struct crypto_larval *larval)
 	return NOTIFY_OK;
 }
 
+#ifdef CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
+static int cryptomgr_schedule_test(struct crypto_alg *alg)
+{
+	return 0;
+}
+#else
 static int cryptomgr_test(void *data)
 {
 	struct crypto_test_param *param = data;
 	u32 type = param->type;
 	int err = 0;
 
-#ifdef CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
-	goto skiptest;
-#endif
-
 	if (type & CRYPTO_ALG_TESTED)
 		goto skiptest;
 
@@ -229,6 +231,7 @@ static int cryptomgr_schedule_test(struct crypto_alg *alg)
 err:
 	return NOTIFY_OK;
 }
+#endif /* !CONFIG_CRYPTO_MANAGER_DISABLE_TESTS */
 
 static int cryptomgr_notify(struct notifier_block *this, unsigned long msg,
 			    void *data)

base-commit: f67dd6ce0723ad013395f20a3f79d8a437d3f455
-- 
2.38.1

