Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE465F0603
	for <lists+stable@lfdr.de>; Fri, 30 Sep 2022 09:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbiI3Hvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Sep 2022 03:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiI3Hvb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Sep 2022 03:51:31 -0400
X-Greylist: delayed 80 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 30 Sep 2022 00:51:29 PDT
Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928EDC34D3
        for <stable@vger.kernel.org>; Fri, 30 Sep 2022 00:51:29 -0700 (PDT)
X-QQ-mid: bizesmtp89t1664524184txpix3cu
Received: from localhost.localdomain ( [113.200.76.118])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 30 Sep 2022 15:49:43 +0800 (CST)
X-QQ-SSF: 0140000000000060D000000A0000000
X-QQ-FEAT: +ynUkgUhZJkqBWjYV6tPoTPNR2GCkm7NgySohL8dWhzscx/9gnetA+rSMjaJj
        caXcwNDVyu7qbjDDX9/TBZikIo+EZg68alJHaJuXc55pxRQjsH4FV884ZyCEYj7QpL19PJ4
        85Q/3A8P8a6nmqMyEGhAhAvJUmfZBIvYhTRw/kFjem2+F7wIZeiM3jVfizXOskW2k/nsRI1
        25DENLmnV1Rq5aP9QwRiqAe9KhkxWlx9VBwAvV8QpRLZxqftam2a0p8Vcni6Buy52qvAdVr
        U2Eu+IhNsaoqDXxkmCy/cnkDRsEZm+L/NH/0WC4Or+HNyQX4rlEu13WLWxi0l3hNepbnKUR
        Ybg1AGFdGUm4yYpKr2Dp305cGLJm5YEmoRKBZR0MNaezMK5tnutbj/2f7FmCQ==
X-QQ-GoodBg: 1
From:   gouhao@uniontech.com
To:     stable@vger.kernel.org
Cc:     gouhao@uniontech.com, tyhicks@linux.microsoft.com,
        zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com,
        jmorris@namei.org, serge@hallyn.com
Subject: [PATCH 1/3] ima: Have the LSM free its audit rule
Date:   Fri, 30 Sep 2022 15:49:35 +0800
Message-Id: <20220930074937.23339-2-gouhao@uniontech.com>
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

commit 9ff8a616dfab96a4fa0ddd36190907dc68886d9b upstream.

Ask the LSM to free its audit rule rather than directly calling kfree().
Both AppArmor and SELinux do additional work in their audit_rule_free()
hooks. Fix memory leaks by allowing the LSMs to perform necessary work.

Fixes: b16942455193 ("ima: use the lsm policy update notifier")
Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Cc: Janne Karhunen <janne.karhunen@gmail.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Cc: <stable@vger.kernel.org> # 4.19+
Signed-off-by: Gou Hao <gouhao@uniontech.com>
---
 security/integrity/ima/ima.h        | 5 +++++
 security/integrity/ima/ima_policy.c | 4 +++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index d12b07eb3a58..e2916b115b93 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -298,6 +298,7 @@ static inline int ima_read_xattr(struct dentry *dentry,
 #ifdef CONFIG_IMA_LSM_RULES
 
 #define security_filter_rule_init security_audit_rule_init
+#define security_filter_rule_free security_audit_rule_free
 #define security_filter_rule_match security_audit_rule_match
 
 #else
@@ -308,6 +309,10 @@ static inline int security_filter_rule_init(u32 field, u32 op, char *rulestr,
 	return -EINVAL;
 }
 
+static inline void security_filter_rule_free(void *lsmrule)
+{
+}
+
 static inline int security_filter_rule_match(u32 secid, u32 field, u32 op,
 					     void *lsmrule,
 					     struct audit_context *actx)
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 2d5a3daa02f9..733efc06d3c1 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -1044,8 +1044,10 @@ void ima_delete_rules(void)
 
 	temp_ima_appraise = 0;
 	list_for_each_entry_safe(entry, tmp, &ima_temp_rules, list) {
-		for (i = 0; i < MAX_LSM_RULES; i++)
+		for (i = 0; i < MAX_LSM_RULES; i++) {
+			security_filter_rule_free(entry->lsm[i].rule);
 			kfree(entry->lsm[i].args_p);
+		}
 
 		list_del(&entry->list);
 		kfree(entry);
-- 
2.20.1

