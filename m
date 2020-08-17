Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F515247745
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732570AbgHQTrI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:47:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:42684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729209AbgHQPUu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:20:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7E23207DE;
        Mon, 17 Aug 2020 15:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677649;
        bh=iVo0GPoeKyLafUTHicn9yxl086QZHMa+h8QT9zS3jU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QPo0jNw3k7/IEj7D9VAbPu2bV/6HqJfGq1vTMNzIx6nI/DBTMKl1O48OraEYS5glM
         oVTu67Q5QaV88/gXKnV29P8d8DIIV+Qo7PEKjCYydz6OeOZE6AEbZ2kk0D6UQjyOD7
         t4qn6ir/BKqz3WRn9Hgy2ROP4gGSyFuNUguIxt98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Eric Biggers <ebiggers@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 018/464] crc-t10dif: Fix potential crypto notify dead-lock
Date:   Mon, 17 Aug 2020 17:09:31 +0200
Message-Id: <20200817143834.630795761@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



