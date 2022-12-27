Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 541C0656BD0
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 15:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbiL0O3Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 09:29:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231697AbiL0O3J (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 09:29:09 -0500
Received: from frasgout11.his.huawei.com (frasgout11.his.huawei.com [14.137.139.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13E4BCA4;
        Tue, 27 Dec 2022 06:29:01 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.18.147.228])
        by frasgout11.his.huawei.com (SkyGuard) with ESMTP id 4NhGzs12JNz9xHwB;
        Tue, 27 Dec 2022 22:21:29 +0800 (CST)
Received: from huaweicloud.com (unknown [10.204.63.22])
        by APP2 (Coremail) with SMTP id GxC2BwAH3WP1AKtjzU5JAA--.42546S4;
        Tue, 27 Dec 2022 15:28:35 +0100 (CET)
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     dhowells@redhat.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, zohar@linux.ibm.com,
        dmitry.kasatkin@gmail.com, paul@paul-moore.com, jmorris@namei.org,
        serge@hallyn.com, ebiggers@kernel.org
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v5 2/2] KEYS: asymmetric: Copy sig and digest in public_key_verify_signature()
Date:   Tue, 27 Dec 2022 15:27:40 +0100
Message-Id: <20221227142740.2807136-3-roberto.sassu@huaweicloud.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221227142740.2807136-1-roberto.sassu@huaweicloud.com>
References: <20221227142740.2807136-1-roberto.sassu@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GxC2BwAH3WP1AKtjzU5JAA--.42546S4
X-Coremail-Antispam: 1UD129KBjvJXoWxJF4xZr1fZw15Zw1fuw45ZFb_yoWrXFWfpF
        s5WrWxtry5Gr1xCrZ5Ca10ka45A3y8A3Wagw4fCw1fCrnxZrWkCryI9w45Wry7JrykXryr
        tr4vgw4rWr1DXaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUB0b4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUXw
        A2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
        w2x7M28EF7xvwVC0I7IYx2IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
        W8JVWxJwA2z4x0Y4vEx4A2jsIE14v26r4j6F4UM28EF7xvwVC2z280aVCY1x0267AKxVW8
        Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
        Ij6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
        Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2Ij64
        vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
        jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2I
        x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK
        8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
        0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUrdgADUUUU
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgATBF1jj4MMcwABsZ
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

Commit ac4e97abce9b8 ("scatterlist: sg_set_buf() argument must be in linear
mapping") checks that both the signature and the digest reside in the
linear mapping area.

However, more recently commit ba14a194a434c ("fork: Add generic vmalloced
stack support") made it possible to move the stack in the vmalloc area,
which is not contiguous, and thus not suitable for sg_set_buf() which needs
adjacent pages.

Always make a copy of the signature and digest in the same buffer used to
store the key and its parameters, and pass them to sg_init_one(). Prefer it
to conditionally doing the copy if necessary, to keep the code simple. The
buffer allocated with kmalloc() is in the linear mapping area.

Cc: stable@vger.kernel.org # 4.9.x
Fixes: ba14a194a434 ("fork: Add generic vmalloced stack support")
Link: https://lore.kernel.org/linux-integrity/Y4pIpxbjBdajymBJ@sol.localdomain/
Suggested-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 crypto/asymmetric_keys/public_key.c | 38 ++++++++++++++++-------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index 2f8352e88860..49a3f7c01149 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -360,9 +360,10 @@ int public_key_verify_signature(const struct public_key *pkey,
 	struct crypto_wait cwait;
 	struct crypto_akcipher *tfm;
 	struct akcipher_request *req;
-	struct scatterlist src_sg[2];
+	struct scatterlist src_sg;
 	char alg_name[CRYPTO_MAX_ALG_NAME];
-	char *key, *ptr;
+	char *buf, *ptr;
+	size_t buf_len;
 	int ret;
 
 	pr_devel("==>%s()\n", __func__);
@@ -400,34 +401,37 @@ int public_key_verify_signature(const struct public_key *pkey,
 	if (!req)
 		goto error_free_tfm;
 
-	key = kmalloc(pkey->keylen + sizeof(u32) * 2 + pkey->paramlen,
-		      GFP_KERNEL);
-	if (!key)
+	buf_len = max_t(size_t, pkey->keylen + sizeof(u32) * 2 + pkey->paramlen,
+			sig->s_size + sig->digest_size);
+
+	buf = kmalloc(buf_len, GFP_KERNEL);
+	if (!buf)
 		goto error_free_req;
 
-	memcpy(key, pkey->key, pkey->keylen);
-	ptr = key + pkey->keylen;
+	memcpy(buf, pkey->key, pkey->keylen);
+	ptr = buf + pkey->keylen;
 	ptr = pkey_pack_u32(ptr, pkey->algo);
 	ptr = pkey_pack_u32(ptr, pkey->paramlen);
 	memcpy(ptr, pkey->params, pkey->paramlen);
 
 	if (pkey->key_is_private)
-		ret = crypto_akcipher_set_priv_key(tfm, key, pkey->keylen);
+		ret = crypto_akcipher_set_priv_key(tfm, buf, pkey->keylen);
 	else
-		ret = crypto_akcipher_set_pub_key(tfm, key, pkey->keylen);
+		ret = crypto_akcipher_set_pub_key(tfm, buf, pkey->keylen);
 	if (ret)
-		goto error_free_key;
+		goto error_free_buf;
 
 	if (strcmp(pkey->pkey_algo, "sm2") == 0 && sig->data_size) {
 		ret = cert_sig_digest_update(sig, tfm);
 		if (ret)
-			goto error_free_key;
+			goto error_free_buf;
 	}
 
-	sg_init_table(src_sg, 2);
-	sg_set_buf(&src_sg[0], sig->s, sig->s_size);
-	sg_set_buf(&src_sg[1], sig->digest, sig->digest_size);
-	akcipher_request_set_crypt(req, src_sg, NULL, sig->s_size,
+	memcpy(buf, sig->s, sig->s_size);
+	memcpy(buf + sig->s_size, sig->digest, sig->digest_size);
+
+	sg_init_one(&src_sg, buf, sig->s_size + sig->digest_size);
+	akcipher_request_set_crypt(req, &src_sg, NULL, sig->s_size,
 				   sig->digest_size);
 	crypto_init_wait(&cwait);
 	akcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
@@ -435,8 +439,8 @@ int public_key_verify_signature(const struct public_key *pkey,
 				      crypto_req_done, &cwait);
 	ret = crypto_wait_req(crypto_akcipher_verify(req), &cwait);
 
-error_free_key:
-	kfree(key);
+error_free_buf:
+	kfree(buf);
 error_free_req:
 	akcipher_request_free(req);
 error_free_tfm:
-- 
2.25.1

