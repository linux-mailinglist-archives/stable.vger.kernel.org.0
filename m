Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 654AD1F2DC2
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728941AbgFHXOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:14:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:34180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729706AbgFHXOH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:14:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6772212CC;
        Mon,  8 Jun 2020 23:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658046;
        bh=BJ0tO64MAidki1KuaMNtI00MVaxBlWf8j4Gm2u/+cZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Keqv0rS70tvJzYTwWANaKiPmi54Ypdya445tlYFcciOTLJH6xRaaWqYs5MqJPbWsC
         gEBkMZVmczSQ4iPxRWiPghrXnZSJmHkqQieUTGRyXSnkGNWe6u+mvNaUNGfQJxEwdD
         n4OHRa5oPP4RyvzmVfbrb0mYy9WFBfihFWdKz6Zs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Krzysztof Struczynski <krzysztof.struczynski@huawei.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 095/606] evm: Fix a small race in init_desc()
Date:   Mon,  8 Jun 2020 19:03:40 -0400
Message-Id: <20200608231211.3363633-95-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 8433856947217ebb5697a8ff9c4c9cad4639a2cf ]

The IS_ERR_OR_NULL() function has two conditions and if we got really
unlucky we could hit a race where "ptr" started as an error pointer and
then was set to NULL.  Both conditions would be false even though the
pointer at the end was NULL.

This patch fixes the problem by ensuring that "*tfm" can only be NULL
or valid.  I have introduced a "tmp_tfm" variable to make that work.  I
also reversed a condition and pulled the code in one tab.

Reported-by: Roberto Sassu <roberto.sassu@huawei.com>
Fixes: 53de3b080d5e ("evm: Check also if *tfm is an error pointer in init_desc()")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Roberto Sassu <roberto.sassu@huawei.com>
Acked-by: Krzysztof Struczynski <krzysztof.struczynski@huawei.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/evm/evm_crypto.c | 44 ++++++++++++++---------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index 302adeb2d37b..cc826c2767a3 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -75,7 +75,7 @@ static struct shash_desc *init_desc(char type, uint8_t hash_algo)
 {
 	long rc;
 	const char *algo;
-	struct crypto_shash **tfm;
+	struct crypto_shash **tfm, *tmp_tfm;
 	struct shash_desc *desc;
 
 	if (type == EVM_XATTR_HMAC) {
@@ -93,31 +93,31 @@ static struct shash_desc *init_desc(char type, uint8_t hash_algo)
 		algo = hash_algo_name[hash_algo];
 	}
 
-	if (IS_ERR_OR_NULL(*tfm)) {
-		mutex_lock(&mutex);
-		if (*tfm)
-			goto out;
-		*tfm = crypto_alloc_shash(algo, 0, CRYPTO_NOLOAD);
-		if (IS_ERR(*tfm)) {
-			rc = PTR_ERR(*tfm);
-			pr_err("Can not allocate %s (reason: %ld)\n", algo, rc);
-			*tfm = NULL;
+	if (*tfm)
+		goto alloc;
+	mutex_lock(&mutex);
+	if (*tfm)
+		goto unlock;
+
+	tmp_tfm = crypto_alloc_shash(algo, 0, CRYPTO_NOLOAD);
+	if (IS_ERR(tmp_tfm)) {
+		pr_err("Can not allocate %s (reason: %ld)\n", algo,
+		       PTR_ERR(tmp_tfm));
+		mutex_unlock(&mutex);
+		return ERR_CAST(tmp_tfm);
+	}
+	if (type == EVM_XATTR_HMAC) {
+		rc = crypto_shash_setkey(tmp_tfm, evmkey, evmkey_len);
+		if (rc) {
+			crypto_free_shash(tmp_tfm);
 			mutex_unlock(&mutex);
 			return ERR_PTR(rc);
 		}
-		if (type == EVM_XATTR_HMAC) {
-			rc = crypto_shash_setkey(*tfm, evmkey, evmkey_len);
-			if (rc) {
-				crypto_free_shash(*tfm);
-				*tfm = NULL;
-				mutex_unlock(&mutex);
-				return ERR_PTR(rc);
-			}
-		}
-out:
-		mutex_unlock(&mutex);
 	}
-
+	*tfm = tmp_tfm;
+unlock:
+	mutex_unlock(&mutex);
+alloc:
 	desc = kmalloc(sizeof(*desc) + crypto_shash_descsize(*tfm),
 			GFP_KERNEL);
 	if (!desc)
-- 
2.25.1

