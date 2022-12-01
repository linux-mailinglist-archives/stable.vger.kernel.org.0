Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4384363ED38
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 11:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbiLAKHd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 05:07:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbiLAKHY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 05:07:24 -0500
Received: from frasgout12.his.huawei.com (frasgout12.his.huawei.com [14.137.139.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE178D677;
        Thu,  1 Dec 2022 02:07:09 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.18.147.227])
        by frasgout12.his.huawei.com (SkyGuard) with ESMTP id 4NNBQp5yk1z9xFY9;
        Thu,  1 Dec 2022 18:00:34 +0800 (CST)
Received: from huaweicloud.com (unknown [10.204.63.22])
        by APP1 (Coremail) with SMTP id LxC2BwCnkm+tfIhjWgGvAA--.50191S4;
        Thu, 01 Dec 2022 11:06:54 +0100 (CET)
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     zohar@linux.ibm.com, dmitry.kasatkin@gmail.com,
        paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 2/2] ima: Alloc ima_max_digest_data in xattr_verify() if CONFIG_VMAP_STACK=y
Date:   Thu,  1 Dec 2022 11:06:25 +0100
Message-Id: <20221201100625.916781-3-roberto.sassu@huaweicloud.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221201100625.916781-1-roberto.sassu@huaweicloud.com>
References: <20221201100625.916781-1-roberto.sassu@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: LxC2BwCnkm+tfIhjWgGvAA--.50191S4
X-Coremail-Antispam: 1UD129KBjvJXoWxJr1xXF1UKrWrZF47Jr1UZFb_yoW8Kryxpa
        1kKF1DGr1FqFs2kFW7AFs0kw4Ykry0vry8WF4DAw1SyF93Xw1j9FykAFyxuFy5Cry8tF1x
        Kr4Sgr15ua10y3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUP2b4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUXw
        A2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
        w2x7M28EF7xvwVC0I7IYx2IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
        WxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
        Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
        Ij6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
        Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AFwI
        0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG
        67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MI
        IYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E
        14v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr
        0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0WU
        DJUUUUU==
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgANBF1jj4IjMwAAso
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

Similarly to evm_verify_hmac(), which allocates an evm_digest structure to
satisfy the linear mapping requirement if CONFIG_VMAP_STACK is enabled, do
the same in xattr_verify(). Allocate an ima_max_digest_data structure and
use that instead of the in-stack counterpart.

Cc: stable@vger.kernel.org # 4.9.x
Fixes: ba14a194a434 ("fork: Add generic vmalloced stack support")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 security/integrity/ima/ima_appraise.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 3e0fbbd99534..ed8f05340fe8 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -278,6 +278,7 @@ static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
 			enum integrity_status *status, const char **cause)
 {
 	struct ima_max_digest_data hash;
+	struct ima_max_digest_data *hash_ptr = &hash;
 	struct signature_v2_hdr *sig;
 	int rc = -EINVAL, hash_start = 0;
 	int mask;
@@ -376,8 +377,17 @@ static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
 			break;
 		}
 
+		if (IS_ENABLED(CONFIG_VMAP_STACK)) {
+			hash_ptr = kmalloc(sizeof(*hash_ptr), GFP_KERNEL);
+			if (!hash_ptr) {
+				*cause = "out-of-memory";
+				*status = INTEGRITY_FAIL;
+				break;
+			}
+		}
+
 		rc = calc_file_id_hash(IMA_VERITY_DIGSIG, iint->ima_hash->algo,
-				       iint->ima_hash->digest, &hash.hdr);
+				       iint->ima_hash->digest, &hash_ptr->hdr);
 		if (rc) {
 			*cause = "sigv3-hashing-error";
 			*status = INTEGRITY_FAIL;
@@ -386,8 +396,8 @@ static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
 
 		rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
 					     (const char *)xattr_value,
-					     xattr_len, hash.digest,
-					     hash.hdr.length);
+					     xattr_len, hash_ptr->digest,
+					     hash_ptr->hdr.length);
 		if (rc) {
 			*cause = "invalid-verity-signature";
 			*status = INTEGRITY_FAIL;
@@ -402,6 +412,9 @@ static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
 		break;
 	}
 
+	if (hash_ptr && hash_ptr != &hash)
+		kfree(hash_ptr);
+
 	return rc;
 }
 
-- 
2.25.1

