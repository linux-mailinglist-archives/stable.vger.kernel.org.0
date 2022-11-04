Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA18619617
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 13:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbiKDMU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 08:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231831AbiKDMUy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 08:20:54 -0400
Received: from frasgout13.his.huawei.com (frasgout13.his.huawei.com [14.137.139.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 334892D760;
        Fri,  4 Nov 2022 05:20:52 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.18.147.227])
        by frasgout13.his.huawei.com (SkyGuard) with ESMTP id 4N3fgZ3HXJzB0DDL;
        Fri,  4 Nov 2022 20:14:18 +0800 (CST)
Received: from huaweicloud.com (unknown [10.204.63.22])
        by APP1 (Coremail) with SMTP id LxC2BwA3I3CQA2Vjh6Q5AA--.49461S2;
        Fri, 04 Nov 2022 13:20:38 +0100 (CET)
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     zohar@linux.ibm.com, dmitry.kasatkin@gmail.com,
        paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org
Subject: [PATCH] ima: Make a copy of sig and digest in asymmetric_verify()
Date:   Fri,  4 Nov 2022 13:20:23 +0100
Message-Id: <20221104122023.1750333-1-roberto.sassu@huaweicloud.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: LxC2BwA3I3CQA2Vjh6Q5AA--.49461S2
X-Coremail-Antispam: 1UD129KBjvJXoWxWFy7KF4fKFWkuF4xKFWDXFb_yoW5Jw15pa
        1kKas8KF4UKr4xCFW3Ca1xW3yrWFWrKr47WayfAwn3uFn8Xw4qywn2y3W7Xr98WryxtFW3
        trnFqF17Cr1DC3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAQAGBF1jj4URMQAAsX
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
mapping") requires that both the signature and the digest resides in the
linear mapping area.

However, more recently commit ba14a194a434c ("fork: Add generic vmalloced
stack support"), made it possible to move the stack in the vmalloc area,
which could make the requirement of the first commit not satisfied anymore.

If CONFIG_SG=y and CONFIG_VMAP_STACK=y, the following BUG() is triggered:

[  467.077359] kernel BUG at include/linux/scatterlist.h:163!
[  467.077939] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI

[...]

[  467.095225] Call Trace:
[  467.096088]  <TASK>
[  467.096928]  ? rcu_read_lock_held_common+0xe/0x50
[  467.097569]  ? rcu_read_lock_sched_held+0x13/0x70
[  467.098123]  ? trace_hardirqs_on+0x2c/0xd0
[  467.098647]  ? public_key_verify_signature+0x470/0x470
[  467.099237]  asymmetric_verify+0x14c/0x300
[  467.099869]  evm_verify_hmac+0x245/0x360
[  467.100391]  evm_inode_setattr+0x43/0x190

The failure happens only for the digest, as the pointer comes from the
stack, and not for the signature, which instead was allocated by
vfs_getxattr_alloc().

Fix this by making a copy of both in asymmetric_verify(), so that the
linear mapping requirement is always satisfied, regardless of the caller.

Cc: stable@vger.kernel.org # 4.9.x
Fixes: ba14a194a434 ("fork: Add generic vmalloced stack support")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 security/integrity/digsig_asymmetric.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/security/integrity/digsig_asymmetric.c b/security/integrity/digsig_asymmetric.c
index 895f4b9ce8c6..635238d5c7fe 100644
--- a/security/integrity/digsig_asymmetric.c
+++ b/security/integrity/digsig_asymmetric.c
@@ -122,11 +122,26 @@ int asymmetric_verify(struct key *keyring, const char *sig,
 		goto out;
 	}
 
-	pks.digest = (u8 *)data;
+	pks.digest = kmemdup(data, datalen, GFP_KERNEL);
+	if (!pks.digest) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
 	pks.digest_size = datalen;
-	pks.s = hdr->sig;
+
+	pks.s = kmemdup(hdr->sig, siglen, GFP_KERNEL);
+	if (!pks.s) {
+		kfree(pks.digest);
+		ret = -ENOMEM;
+		goto out;
+	}
+
 	pks.s_size = siglen;
+
 	ret = verify_signature(key, &pks);
+	kfree(pks.digest);
+	kfree(pks.s);
 out:
 	key_put(key);
 	pr_debug("%s() = %d\n", __func__, ret);
-- 
2.25.1

