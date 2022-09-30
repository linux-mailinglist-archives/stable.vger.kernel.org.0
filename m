Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 183D55F05FC
	for <lists+stable@lfdr.de>; Fri, 30 Sep 2022 09:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbiI3HuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Sep 2022 03:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbiI3HuU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Sep 2022 03:50:20 -0400
Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CFAD5E67B
        for <stable@vger.kernel.org>; Fri, 30 Sep 2022 00:50:16 -0700 (PDT)
X-QQ-mid: bizesmtp89t1664524188t400aaeq
Received: from localhost.localdomain ( [113.200.76.118])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 30 Sep 2022 15:49:47 +0800 (CST)
X-QQ-SSF: 0140000000000060D000000A0000000
X-QQ-FEAT: clVcytORefK95t8kqmSjfgmhlR1VoBXdbUeHuyaHJGSLqblzHiW0OGNmxntSr
        Zqx6rc8wNF5eZ/kQ2vI0WzyJyLK9mxFHVPTtnt0F+3H1maksQFrOt08QOv9CUGDnx3GMaRh
        Sy3INlrmqMUy3qnSER48dCQbFyRQUmXN/IA5SimIQhNaEm1aMBlrCg9Ll8PxDIYXdvJFRbe
        6C4cH5yVPtOW3jzEyu9RQp8wPwchHWDSAXJ694oO6h3TsIrrAQCYZ1OYdKch7cEw3RYPuxD
        TT0PYuM31ZJw+E52kArvOtEr5AdjDvafCyZAnmtObuKT/GQCkcunOgmJ7/hmkI5gEfuLBSK
        aMIu2/GfO0ccFNRc6URdMUn+Km2fCDRuuarMMzWNYFyapzvPFfVx8Qhb/2504Hn7PAawTxb
X-QQ-GoodBg: 1
From:   gouhao@uniontech.com
To:     stable@vger.kernel.org
Cc:     gouhao@uniontech.com, tyhicks@linux.microsoft.com,
        zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com,
        jmorris@namei.org, serge@hallyn.com
Subject: [PATCH 2/3] ima: Free the entire rule when deleting a list of rules
Date:   Fri, 30 Sep 2022 15:49:36 +0800
Message-Id: <20220930074937.23339-3-gouhao@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220930074937.23339-1-gouhao@uniontech.com>
References: <20220930074937.23339-1-gouhao@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybglogicsvr:qybglogicsvr7
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tyler Hicks <tyhicks@linux.microsoft.com>

commit 465aee77aae857b5fcde56ee192b33dc369fba04 upstream.

Create a function, ima_free_rule(), to free all memory associated with
an ima_rule_entry. Use the new function to fix memory leaks of allocated
ima_rule_entry members, such as .fsname and .keyrings, when deleting a
list of rules.

Make the existing ima_lsm_free_rule() function specific to the LSM
audit rule array of an ima_rule_entry and require that callers make an
additional call to kfree to free the ima_rule_entry itself.

This fixes a memory leak seen when loading by a valid rule that contains
an additional piece of allocated memory, such as an fsname, followed by
an invalid rule that triggers a policy load failure:

 # echo -e "dont_measure fsname=securityfs\nbad syntax" > \
    /sys/kernel/security/ima/policy
 -bash: echo: write error: Invalid argument
 # echo scan > /sys/kernel/debug/kmemleak
 # cat /sys/kernel/debug/kmemleak
 unreferenced object 0xffff9bab67ca12c0 (size 16):
   comm "bash", pid 684, jiffies 4295212803 (age 252.344s)
   hex dump (first 16 bytes):
     73 65 63 75 72 69 74 79 66 73 00 6b 6b 6b 6b a5  securityfs.kkkk.
   backtrace:
     [<00000000adc80b1b>] kstrdup+0x2e/0x60
     [<00000000d504cb0d>] ima_parse_add_rule+0x7d4/0x1020
     [<00000000444825ac>] ima_write_policy+0xab/0x1d0
     [<000000002b7f0d6c>] vfs_write+0xde/0x1d0
     [<0000000096feedcf>] ksys_write+0x68/0xe0
     [<0000000052b544a2>] do_syscall_64+0x56/0xa0
     [<000000007ead1ba7>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: f1b08bbcbdaf ("ima: define a new policy condition based on the filesystem name")
Fixes: 2b60c0ecedf8 ("IMA: Read keyrings= option from the IMA policy")
Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Cc: <stable@vger.kernel.org> # 4.19+
Signed-off-by: Gou Hao <gouhao@uniontech.com>
---
 security/integrity/ima/ima_policy.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 733efc06d3c1..8a55bdfad404 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -241,6 +241,21 @@ static int __init default_appraise_policy_setup(char *str)
 }
 __setup("ima_appraise_tcb", default_appraise_policy_setup);
 
+static void ima_free_rule(struct ima_rule_entry *entry)
+{
+	int i;
+
+	if (!entry)
+		return;
+
+	kfree(entry->fsname);
+	for (i = 0; i < MAX_LSM_RULES; i++) {
+		security_filter_rule_free(entry->lsm[i].rule);
+		kfree(entry->lsm[i].args_p);
+	}
+	kfree(entry);
+}
+
 /*
  * The LSM policy can be reloaded, leaving the IMA LSM based rules referring
  * to the old, stale LSM policy.  Update the IMA LSM based rules to reflect
@@ -1040,17 +1055,11 @@ ssize_t ima_parse_add_rule(char *rule)
 void ima_delete_rules(void)
 {
 	struct ima_rule_entry *entry, *tmp;
-	int i;
 
 	temp_ima_appraise = 0;
 	list_for_each_entry_safe(entry, tmp, &ima_temp_rules, list) {
-		for (i = 0; i < MAX_LSM_RULES; i++) {
-			security_filter_rule_free(entry->lsm[i].rule);
-			kfree(entry->lsm[i].args_p);
-		}
-
 		list_del(&entry->list);
-		kfree(entry);
+		ima_free_rule(entry);
 	}
 }
 
-- 
2.20.1

