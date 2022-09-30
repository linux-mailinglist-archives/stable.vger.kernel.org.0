Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B87FF5F05FD
	for <lists+stable@lfdr.de>; Fri, 30 Sep 2022 09:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbiI3HuZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Sep 2022 03:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbiI3HuX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Sep 2022 03:50:23 -0400
Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12FC82DA94
        for <stable@vger.kernel.org>; Fri, 30 Sep 2022 00:50:19 -0700 (PDT)
X-QQ-mid: bizesmtp89t1664524191ti19mh79
Received: from localhost.localdomain ( [113.200.76.118])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 30 Sep 2022 15:49:50 +0800 (CST)
X-QQ-SSF: 0140000000000060D000000A0000000
X-QQ-FEAT: D2GZf6M6C/hErDXT0FCac3i49oD7Kg49dqxI5E3P/A51CiTTLmwabug4L83W4
        rL/KUzf5paHLRyCfBdHFbz3TlU5mKRAMfvaWGJ4crLIUFG8lWzSA+xGzFNigEZLzQFTb1Nt
        LrdfJUWxfowPVDPgkvuKa9mFJAnVBCSTT3+5z4KLTR2AXObPzQz/UGIHMG/VHiAevYrixp6
        WGtjYqSVwFw7IpsebB3QEh3w0Ekp0UwVR+FbwjZezmROVkD8oHHCG9M60T2mje4NNQTNIdY
        nIdaqZEgr5Y8c+opyPAvoQs31Q+a3fw2DpmUhdKAVwqq+yXaZEGOCDaWvmllpvyhj9Jb7JG
        ahd0AOu5cSeGA2QWsWSurU8bvGSQ2gYPVZZygHwuTAHOtghHLtNt168vDHHG5D8GiqkmA+V
X-QQ-GoodBg: 1
From:   gouhao@uniontech.com
To:     stable@vger.kernel.org
Cc:     gouhao@uniontech.com, tyhicks@linux.microsoft.com,
        zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com,
        jmorris@namei.org, serge@hallyn.com
Subject: [PATCH 3/3] ima: Free the entire rule if it fails to parse
Date:   Fri, 30 Sep 2022 15:49:37 +0800
Message-Id: <20220930074937.23339-4-gouhao@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220930074937.23339-1-gouhao@uniontech.com>
References: <20220930074937.23339-1-gouhao@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybglogicsvr:qybglogicsvr7
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tyler Hicks <tyhicks@linux.microsoft.com>

commit 2bdd737c5687d6dec30e205953146ede8a87dbdd upstream.

Use ima_free_rule() to fix memory leaks of allocated ima_rule_entry
members, such as .fsname and .keyrings, when an error is encountered
during rule parsing.

Set the args_p pointer to NULL after freeing it in the error path of
ima_lsm_rule_init() so that it isn't freed twice.

This fixes a memory leak seen when loading an rule that contains an
additional piece of allocated memory, such as an fsname, followed by an
invalid conditional:

 # echo "measure fsname=tmpfs bad=cond" > /sys/kernel/security/ima/policy
 -bash: echo: write error: Invalid argument
 # echo scan > /sys/kernel/debug/kmemleak
 # cat /sys/kernel/debug/kmemleak
 unreferenced object 0xffff98e7e4ece6c0 (size 8):
   comm "bash", pid 672, jiffies 4294791843 (age 21.855s)
   hex dump (first 8 bytes):
     74 6d 70 66 73 00 6b a5                          tmpfs.k.
   backtrace:
     [<00000000abab7413>] kstrdup+0x2e/0x60
     [<00000000f11ede32>] ima_parse_add_rule+0x7d4/0x1020
     [<00000000f883dd7a>] ima_write_policy+0xab/0x1d0
     [<00000000b17cf753>] vfs_write+0xde/0x1d0
     [<00000000b8ddfdea>] ksys_write+0x68/0xe0
     [<00000000b8e21e87>] do_syscall_64+0x56/0xa0
     [<0000000089ea7b98>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: f1b08bbcbdaf ("ima: define a new policy condition based on the filesystem name")
Fixes: 2b60c0ecedf8 ("IMA: Read keyrings= option from the IMA policy")
Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Cc: <stable@vger.kernel.org> # 4.19+
Signed-off-by: Gou Hao <gouhao@uniontech.com>
---
 security/integrity/ima/ima_policy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 8a55bdfad404..b2dadff3626b 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -662,6 +662,7 @@ static int ima_lsm_rule_init(struct ima_rule_entry *entry,
 					   &entry->lsm[lsm_rule].rule);
 	if (!entry->lsm[lsm_rule].rule) {
 		kfree(entry->lsm[lsm_rule].args_p);
+		entry->lsm[lsm_rule].args_p = NULL;
 		return -EINVAL;
 	}
 
@@ -1034,7 +1035,7 @@ ssize_t ima_parse_add_rule(char *rule)
 
 	result = ima_parse_rule(p, entry);
 	if (result) {
-		kfree(entry);
+		ima_free_rule(entry);
 		integrity_audit_msg(AUDIT_INTEGRITY_STATUS, NULL,
 				    NULL, op, "invalid-policy", result,
 				    audit_info);
-- 
2.20.1

