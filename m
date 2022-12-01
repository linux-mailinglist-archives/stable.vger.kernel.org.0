Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5585663ED33
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 11:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbiLAKHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 05:07:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbiLAKHE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 05:07:04 -0500
Received: from frasgout11.his.huawei.com (frasgout11.his.huawei.com [14.137.139.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6559A89ADA;
        Thu,  1 Dec 2022 02:07:02 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.18.147.228])
        by frasgout11.his.huawei.com (SkyGuard) with ESMTP id 4NNBQ64lnDz9xFVK;
        Thu,  1 Dec 2022 17:59:58 +0800 (CST)
Received: from huaweicloud.com (unknown [10.204.63.22])
        by APP1 (Coremail) with SMTP id LxC2BwCnkm+tfIhjWgGvAA--.50191S3;
        Thu, 01 Dec 2022 11:06:49 +0100 (CET)
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     zohar@linux.ibm.com, dmitry.kasatkin@gmail.com,
        paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 1/2] evm: Alloc evm_digest in evm_verify_hmac() if CONFIG_VMAP_STACK=y
Date:   Thu,  1 Dec 2022 11:06:24 +0100
Message-Id: <20221201100625.916781-2-roberto.sassu@huaweicloud.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221201100625.916781-1-roberto.sassu@huaweicloud.com>
References: <20221201100625.916781-1-roberto.sassu@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: LxC2BwCnkm+tfIhjWgGvAA--.50191S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJF4xCry8tryxGr45Cr18uFg_yoW5XFWkpa
        1kK3WIqr4rJr1fKFy3CF4Yy3WrKrW0qry2gwsxAw1YvFnxXr1Fy34IyFy7XryrKrW8XFy7
        taySqFn8Ca1UA3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUP2b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
        A2048vs2IY020Ec7CjxVAFwI0_JFI_Gr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
        w2x7M28EF7xvwVC0I7IYx2IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
        WxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
        Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
        Ij6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
        Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AFwI
        0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG
        67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MI
        IYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E
        14v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr
        0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0xs
        qJUUUUU==
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAQANBF1jj4YhZgAAs4
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

Fix this by checking if CONFIG_VMAP_STACK is enabled. If yes, allocate an
evm_digest structure, and use that instead of the in-stack counterpart.

Cc: stable@vger.kernel.org # 4.9.x
Fixes: ba14a194a434 ("fork: Add generic vmalloced stack support")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 security/integrity/evm/evm_main.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 23d484e05e6f..7f76d6103f2e 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -174,6 +174,7 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
 	struct signature_v2_hdr *hdr;
 	enum integrity_status evm_status = INTEGRITY_PASS;
 	struct evm_digest digest;
+	struct evm_digest *digest_ptr = &digest;
 	struct inode *inode;
 	int rc, xattr_len, evm_immutable = 0;
 
@@ -231,14 +232,26 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
 		}
 
 		hdr = (struct signature_v2_hdr *)xattr_data;
-		digest.hdr.algo = hdr->hash_algo;
+
+		if (IS_ENABLED(CONFIG_VMAP_STACK)) {
+			digest_ptr = kmalloc(sizeof(*digest_ptr), GFP_NOFS);
+			if (!digest_ptr) {
+				rc = -ENOMEM;
+				break;
+			}
+		}
+
+		digest_ptr->hdr.algo = hdr->hash_algo;
+
 		rc = evm_calc_hash(dentry, xattr_name, xattr_value,
-				   xattr_value_len, xattr_data->type, &digest);
+				   xattr_value_len, xattr_data->type,
+				   digest_ptr);
 		if (rc)
 			break;
 		rc = integrity_digsig_verify(INTEGRITY_KEYRING_EVM,
 					(const char *)xattr_data, xattr_len,
-					digest.digest, digest.hdr.length);
+					digest_ptr->digest,
+					digest_ptr->hdr.length);
 		if (!rc) {
 			inode = d_backing_inode(dentry);
 
@@ -268,8 +281,11 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
 		else
 			evm_status = INTEGRITY_FAIL;
 	}
-	pr_debug("digest: (%d) [%*phN]\n", digest.hdr.length, digest.hdr.length,
-		  digest.digest);
+	pr_debug("digest: (%d) [%*phN]\n", digest_ptr->hdr.length,
+		 digest_ptr->hdr.length, digest_ptr->digest);
+
+	if (digest_ptr && digest_ptr != &digest)
+		kfree(digest_ptr);
 out:
 	if (iint)
 		iint->evm_status = evm_status;
-- 
2.25.1

