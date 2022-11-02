Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0270B61692E
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 17:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbiKBQfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 12:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbiKBQer (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 12:34:47 -0400
Received: from frasgout12.his.huawei.com (frasgout12.his.huawei.com [14.137.139.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99FE764B;
        Wed,  2 Nov 2022 09:30:39 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.18.147.228])
        by frasgout12.his.huawei.com (SkyGuard) with ESMTP id 4N2XKf5stGz9v7Z1;
        Thu,  3 Nov 2022 00:24:54 +0800 (CST)
Received: from huaweicloud.com (unknown [10.204.63.22])
        by APP1 (Coremail) with SMTP id LxC2BwD3lXIbm2JjrrUxAA--.2055S2;
        Wed, 02 Nov 2022 17:30:26 +0100 (CET)
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     zohar@linux.ibm.com, dmitry.kasatkin@gmail.com,
        paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaac.jmatt@gmail.com,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org
Subject: [PATCH] ima: Fix memory leak in __ima_inode_hash()
Date:   Wed,  2 Nov 2022 17:30:06 +0100
Message-Id: <20221102163006.1039343-1-roberto.sassu@huaweicloud.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: LxC2BwD3lXIbm2JjrrUxAA--.2055S2
X-Coremail-Antispam: 1UD129KBjvJXoW7ZFyrtr4xXw1UAryxJr1UKFg_yoW8XF1xpa
        4Dua4UCrW8KFWfCr1kGa42vw4Sk3yjgFWUWrZ8twn0yFn3XF1qkr15AF1Y9r95GryFyr1x
        tw47t345Aa1jyaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUv2b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxV
        AFwI0_Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAa
        w2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxV
        Aqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q
        6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6x
        kF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVW3JVWrJr1lIxAIcVC2z280aVAF
        wI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa
        7IU8imRUUUUUU==
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgAEBF1jj4D5-QABs2
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

Commit f3cc6b25dcc5 ("ima: always measure and audit files in policy") lets
measurement or audit happen even if the file digest cannot be calculated.

As a result, iint->ima_hash could have been allocated despite
ima_collect_measurement() returning an error.

Since ima_hash belongs to a temporary inode metadata structure, declared
at the beginning of __ima_inode_hash(), just add a kfree() call if
ima_collect_measurement() returns an error different from -ENOMEM (in that
case, ima_hash should not have been allocated).

Cc: stable@vger.kernel.org
Fixes: 280fe8367b0d ("ima: Always return a file measurement in ima_file_hash()")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 security/integrity/ima/ima_main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 040b03ddc1c7..4a207a3ef7ef 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -542,8 +542,13 @@ static int __ima_inode_hash(struct inode *inode, struct file *file, char *buf,
 
 		rc = ima_collect_measurement(&tmp_iint, file, NULL, 0,
 					     ima_hash_algo, NULL);
-		if (rc < 0)
+		if (rc < 0) {
+			/* ima_hash could be allocated in case of failure. */
+			if (rc != -ENOMEM)
+				kfree(tmp_iint.ima_hash);
+
 			return -EOPNOTSUPP;
+		}
 
 		iint = &tmp_iint;
 		mutex_lock(&iint->mutex);
-- 
2.25.1

