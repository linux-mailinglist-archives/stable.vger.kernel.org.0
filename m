Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81DA0647496
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 17:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbiLHQqv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 11:46:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiLHQqu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 11:46:50 -0500
Received: from frasgout13.his.huawei.com (frasgout13.his.huawei.com [14.137.139.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4005AD9B9;
        Thu,  8 Dec 2022 08:46:47 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.18.147.228])
        by frasgout13.his.huawei.com (SkyGuard) with ESMTP id 4NSfy10j7pz9xG9q;
        Fri,  9 Dec 2022 00:39:37 +0800 (CST)
Received: from huaweicloud.com (unknown [10.204.63.22])
        by APP1 (Coremail) with SMTP id LxC2BwDHs3DWFJJjUyvOAA--.59467S2;
        Thu, 08 Dec 2022 17:46:23 +0100 (CET)
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
Subject: [PATCH] KEYS: asymmetric: Make a copy of sig and digest in vmalloced stack
Date:   Thu,  8 Dec 2022 17:46:10 +0100
Message-Id: <20221208164610.867747-1-roberto.sassu@huaweicloud.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: LxC2BwDHs3DWFJJjUyvOAA--.59467S2
X-Coremail-Antispam: 1UD129KBjvJXoWxJF4xCry8tF4DCr43Kr4fuFg_yoW5uFWkpa
        95Wr15tryUGr1Ik3y3C3WxK345Aw4vkr17Ww4fZw45CFsxXrW8C3yIva13WFyfJrykXFWx
        trWvqws8uF1UXaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvFb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxV
        AFwI0_Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAa
        w2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxV
        Aqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a
        6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6x
        kF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVW8JVW3JwCI42IY6I8E87Iv67AK
        xVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvj
        xUxo7KDUUUU
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgAABF1jj4JxzwAAsL
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

Check if the signature and digest passed to public_key_verify_signature()
are in the linear mapping area and, for those which are not, make a copy in
the linear mapping area with kmalloc() and adjust the pointer passed to
sg_set_buf(). Reuse the existing kmalloc() and increase the allocation size
as needed.

Minimize the number of copies with the compile-time check of
CONFIG_VMAP_STACK and with the run-time check virt_addr_valid().

Cc: stable@vger.kernel.org # 4.9.x
Fixes: ba14a194a434 ("fork: Add generic vmalloced stack support")
Link: https://lore.kernel.org/linux-integrity/Y4pIpxbjBdajymBJ@sol.localdomain/
Suggested-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 crypto/asymmetric_keys/public_key.c | 39 +++++++++++++++++++++++++----
 1 file changed, 34 insertions(+), 5 deletions(-)

diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index 2f8352e88860..307799ffbc3e 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -363,7 +363,8 @@ int public_key_verify_signature(const struct public_key *pkey,
 	struct scatterlist src_sg[2];
 	char alg_name[CRYPTO_MAX_ALG_NAME];
 	char *key, *ptr;
-	int ret;
+	char *sig_s, *digest;
+	int ret, verif_bundle_len;
 
 	pr_devel("==>%s()\n", __func__);
 
@@ -400,8 +401,21 @@ int public_key_verify_signature(const struct public_key *pkey,
 	if (!req)
 		goto error_free_tfm;
 
-	key = kmalloc(pkey->keylen + sizeof(u32) * 2 + pkey->paramlen,
-		      GFP_KERNEL);
+	verif_bundle_len = pkey->keylen + sizeof(u32) * 2 + pkey->paramlen;
+
+	sig_s = sig->s;
+	digest = sig->digest;
+
+	if (IS_ENABLED(CONFIG_VMAP_STACK)) {
+		if (!virt_addr_valid(sig_s))
+			verif_bundle_len += sig->s_size;
+
+		if (!virt_addr_valid(digest))
+			verif_bundle_len += sig->digest_size;
+	}
+
+	/* key points to a buffer which could contain the sig and digest too. */
+	key = kmalloc(verif_bundle_len, GFP_KERNEL);
 	if (!key)
 		goto error_free_req;
 
@@ -424,9 +438,24 @@ int public_key_verify_signature(const struct public_key *pkey,
 			goto error_free_key;
 	}
 
+	if (IS_ENABLED(CONFIG_VMAP_STACK)) {
+		ptr += pkey->paramlen;
+
+		if (!virt_addr_valid(sig_s)) {
+			sig_s = ptr;
+			memcpy(sig_s, sig->s, sig->s_size);
+			ptr += sig->s_size;
+		}
+
+		if (!virt_addr_valid(digest)) {
+			digest = ptr;
+			memcpy(digest, sig->digest, sig->digest_size);
+		}
+	}
+
 	sg_init_table(src_sg, 2);
-	sg_set_buf(&src_sg[0], sig->s, sig->s_size);
-	sg_set_buf(&src_sg[1], sig->digest, sig->digest_size);
+	sg_set_buf(&src_sg[0], sig_s, sig->s_size);
+	sg_set_buf(&src_sg[1], digest, sig->digest_size);
 	akcipher_request_set_crypt(req, src_sg, NULL, sig->s_size,
 				   sig->digest_size);
 	crypto_init_wait(&cwait);
-- 
2.25.1

