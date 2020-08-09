Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF22923FB33
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbgHHXhl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:37:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728047AbgHHXhk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:37:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71DC720716;
        Sat,  8 Aug 2020 23:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596929860;
        bh=iVo0GPoeKyLafUTHicn9yxl086QZHMa+h8QT9zS3jU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rdb+M9pc1YQqHvWz/lhCBsyCsrdbepzpD6fZWRFDOXv7oZG6SMWBCEWoyX5PIDpuJ
         HPYTQAcpQGXvWIVblSbvfvVayNDFMrdeasV/aVbjLIYAmttBhcZl18XWf4p4NPi6VM
         mKYfdp9D4+xTGEemLaMkRkB025zgWKHkVu3bdQlY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Eric Biggers <ebiggers@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.7 12/58] crc-t10dif: Fix potential crypto notify dead-lock
Date:   Sat,  8 Aug 2020 19:36:38 -0400
Message-Id: <20200808233724.3618168-12-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200808233724.3618168-1-sashal@kernel.org>
References: <20200808233724.3618168-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 3906f640224dbe7714b52b66d7d68c0812808e19 ]

The crypto notify call occurs with a read mutex held so you must
not do any substantial work directly.  In particular, you cannot
call crypto_alloc_* as they may trigger further notifications
which may dead-lock in the presence of another writer.

This patch fixes this by postponing the work into a work queue and
taking the same lock in the module init function.

While we're at it this patch also ensures that all RCU accesses are
marked appropriately (tested with sparse).

Finally this also reveals a race condition in module param show
function as it may be called prior to the module init function.
It's fixed by testing whether crct10dif_tfm is NULL (this is true
iff the init function has not completed assuming fallback is false).

Fixes: 11dcb1037f40 ("crc-t10dif: Allow current transform to be...")
Fixes: b76377543b73 ("crc-t10dif: Pick better transform if one...")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/crc-t10dif.c | 54 +++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 42 insertions(+), 12 deletions(-)

diff --git a/lib/crc-t10dif.c b/lib/crc-t10dif.c
index 8cc01a6034165..c9acf1c12cfcb 100644
--- a/lib/crc-t10dif.c
+++ b/lib/crc-t10dif.c
@@ -19,39 +19,46 @@
 static struct crypto_shash __rcu *crct10dif_tfm;
 static struct static_key crct10dif_fallback __read_mostly;
 static DEFINE_MUTEX(crc_t10dif_mutex);
+static struct work_struct crct10dif_rehash_work;
 
-static int crc_t10dif_rehash(struct notifier_block *self, unsigned long val, void *data)
+static int crc_t10dif_notify(struct notifier_block *self, unsigned long val, void *data)
 {
 	struct crypto_alg *alg = data;
-	struct crypto_shash *new, *old;
 
 	if (val != CRYPTO_MSG_ALG_LOADED ||
 	    static_key_false(&crct10dif_fallback) ||
 	    strncmp(alg->cra_name, CRC_T10DIF_STRING, strlen(CRC_T10DIF_STRING)))
 		return 0;
 
+	schedule_work(&crct10dif_rehash_work);
+	return 0;
+}
+
+static void crc_t10dif_rehash(struct work_struct *work)
+{
+	struct crypto_shash *new, *old;
+
 	mutex_lock(&crc_t10dif_mutex);
 	old = rcu_dereference_protected(crct10dif_tfm,
 					lockdep_is_held(&crc_t10dif_mutex));
 	if (!old) {
 		mutex_unlock(&crc_t10dif_mutex);
-		return 0;
+		return;
 	}
 	new = crypto_alloc_shash("crct10dif", 0, 0);
 	if (IS_ERR(new)) {
 		mutex_unlock(&crc_t10dif_mutex);
-		return 0;
+		return;
 	}
 	rcu_assign_pointer(crct10dif_tfm, new);
 	mutex_unlock(&crc_t10dif_mutex);
 
 	synchronize_rcu();
 	crypto_free_shash(old);
-	return 0;
 }
 
 static struct notifier_block crc_t10dif_nb = {
-	.notifier_call = crc_t10dif_rehash,
+	.notifier_call = crc_t10dif_notify,
 };
 
 __u16 crc_t10dif_update(__u16 crc, const unsigned char *buffer, size_t len)
@@ -86,19 +93,26 @@ EXPORT_SYMBOL(crc_t10dif);
 
 static int __init crc_t10dif_mod_init(void)
 {
+	struct crypto_shash *tfm;
+
+	INIT_WORK(&crct10dif_rehash_work, crc_t10dif_rehash);
 	crypto_register_notifier(&crc_t10dif_nb);
-	crct10dif_tfm = crypto_alloc_shash("crct10dif", 0, 0);
-	if (IS_ERR(crct10dif_tfm)) {
+	mutex_lock(&crc_t10dif_mutex);
+	tfm = crypto_alloc_shash("crct10dif", 0, 0);
+	if (IS_ERR(tfm)) {
 		static_key_slow_inc(&crct10dif_fallback);
-		crct10dif_tfm = NULL;
+		tfm = NULL;
 	}
+	RCU_INIT_POINTER(crct10dif_tfm, tfm);
+	mutex_unlock(&crc_t10dif_mutex);
 	return 0;
 }
 
 static void __exit crc_t10dif_mod_fini(void)
 {
 	crypto_unregister_notifier(&crc_t10dif_nb);
-	crypto_free_shash(crct10dif_tfm);
+	cancel_work_sync(&crct10dif_rehash_work);
+	crypto_free_shash(rcu_dereference_protected(crct10dif_tfm, 1));
 }
 
 module_init(crc_t10dif_mod_init);
@@ -106,11 +120,27 @@ module_exit(crc_t10dif_mod_fini);
 
 static int crc_t10dif_transform_show(char *buffer, const struct kernel_param *kp)
 {
+	struct crypto_shash *tfm;
+	const char *name;
+	int len;
+
 	if (static_key_false(&crct10dif_fallback))
 		return sprintf(buffer, "fallback\n");
 
-	return sprintf(buffer, "%s\n",
-		crypto_tfm_alg_driver_name(crypto_shash_tfm(crct10dif_tfm)));
+	rcu_read_lock();
+	tfm = rcu_dereference(crct10dif_tfm);
+	if (!tfm) {
+		len = sprintf(buffer, "init\n");
+		goto unlock;
+	}
+
+	name = crypto_tfm_alg_driver_name(crypto_shash_tfm(tfm));
+	len = sprintf(buffer, "%s\n", name);
+
+unlock:
+	rcu_read_unlock();
+
+	return len;
 }
 
 module_param_call(transform, NULL, crc_t10dif_transform_show, NULL, 0644);
-- 
2.25.1

