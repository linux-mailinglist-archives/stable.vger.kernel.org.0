Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EECB6484A4
	for <lists+stable@lfdr.de>; Fri,  9 Dec 2022 16:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbiLIPH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Dec 2022 10:07:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbiLIPHP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Dec 2022 10:07:15 -0500
Received: from frasgout12.his.huawei.com (frasgout12.his.huawei.com [14.137.139.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB94E31DC3;
        Fri,  9 Dec 2022 07:07:13 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.18.147.229])
        by frasgout12.his.huawei.com (SkyGuard) with ESMTP id 4NTDj50wv1z9v7cV;
        Fri,  9 Dec 2022 23:00:25 +0800 (CST)
Received: from huaweicloud.com (unknown [10.204.63.22])
        by APP2 (Coremail) with SMTP id GxC2BwC37PgAT5NjmZfRAA--.1505S2;
        Fri, 09 Dec 2022 16:06:48 +0100 (CET)
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     dhowells@redhat.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, zohar@linux.ibm.com,
        dmitry.kasatkin@gmail.com, paul@paul-moore.com, jmorris@namei.org,
        serge@hallyn.com
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2] KEYS: asymmetric: Copy sig and digest in public_key_verify_signature()
Date:   Fri,  9 Dec 2022 16:06:33 +0100
Message-Id: <20221209150633.1033556-1-roberto.sassu@huaweicloud.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GxC2BwC37PgAT5NjmZfRAA--.1505S2
X-Coremail-Antispam: 1UD129KBjvJXoWxJF4xCry8tF47try5uF1UAwb_yoW5Wrykpa
        n5WrW5tFyUGr1Skry3Aw4Ik34rAw4kJFW2gw4Iyws5uwn8XrZ3C3yIvF43WFyxJrykWryf
        trWkWw4UuF1UXaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvab4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxV
        AFwI0_Gr1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0E
        n4kS14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I
        0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8
        ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcV
        CY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Zr0_Wr1UMIIF0xvEx4A2jsIE
        14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyT
        uYvjxUxo7KDUUUU
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgABBF1jj4J50AACsf
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
stack support"), made it possible to move the stack in the vmalloc area,
which is not contiguous, and thus not suitable for sg_set_buf() which needs
adjacent pages.

Always make a copy of the signature and digest in the same buffer used to
store the key and its parameters, and pass them to sg_set_buf(). Prefer it
to conditionally doing the copy if necessary, to keep the code simple. The
buffer allocated with kmalloc() is in the linear mapping area.

Cc: stable@vger.kernel.org # 4.9.x
Fixes: ba14a194a434 ("fork: Add generic vmalloced stack support")
Link: https://lore.kernel.org/linux-integrity/Y4pIpxbjBdajymBJ@sol.localdomain/
Suggested-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 crypto/asymmetric_keys/public_key.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index 2f8352e88860..ccc091119972 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -363,6 +363,7 @@ int public_key_verify_signature(const struct public_key *pkey,
 	struct scatterlist src_sg[2];
 	char alg_name[CRYPTO_MAX_ALG_NAME];
 	char *key, *ptr;
+	u32 key_max_len;
 	int ret;
 
 	pr_devel("==>%s()\n", __func__);
@@ -400,8 +401,12 @@ int public_key_verify_signature(const struct public_key *pkey,
 	if (!req)
 		goto error_free_tfm;
 
-	key = kmalloc(pkey->keylen + sizeof(u32) * 2 + pkey->paramlen,
-		      GFP_KERNEL);
+	key_max_len = max_t(u32,
+			    pkey->keylen + sizeof(u32) * 2 + pkey->paramlen,
+			    sig->s_size + sig->digest_size);
+
+	/* key is used to store the sig and digest too. */
+	key = kmalloc(key_max_len, GFP_KERNEL);
 	if (!key)
 		goto error_free_req;
 
@@ -424,9 +429,13 @@ int public_key_verify_signature(const struct public_key *pkey,
 			goto error_free_key;
 	}
 
+	memcpy(key, sig->s, sig->s_size);
+	memcpy(key + sig->s_size, sig->digest, sig->digest_size);
+
 	sg_init_table(src_sg, 2);
-	sg_set_buf(&src_sg[0], sig->s, sig->s_size);
-	sg_set_buf(&src_sg[1], sig->digest, sig->digest_size);
+	/* Cannot use one scatterlist. The first needs to be s->s_size long. */
+	sg_set_buf(&src_sg[0], key, sig->s_size);
+	sg_set_buf(&src_sg[1], key + sig->s_size, sig->digest_size);
 	akcipher_request_set_crypt(req, src_sg, NULL, sig->s_size,
 				   sig->digest_size);
 	crypto_init_wait(&cwait);
-- 
2.25.1

