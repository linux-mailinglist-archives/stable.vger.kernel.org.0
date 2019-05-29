Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8332DE55
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 15:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbfE2NgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 09:36:13 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:32974 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726612AbfE2NgM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 09:36:12 -0400
Received: from lhreml709-cah.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 18762D6F4E180265B89C;
        Wed, 29 May 2019 14:36:11 +0100 (IST)
Received: from roberto-HP-EliteDesk-800-G2-DM-65W.huawei.com (10.204.65.154)
 by smtpsuk.huawei.com (10.201.108.32) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Wed, 29 May 2019 14:36:03 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <dmitry.kasatkin@huawei.com>,
        <mjg59@google.com>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <silviu.vlasceanu@huawei.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2 3/3] ima: show rules with IMA_INMASK correctly
Date:   Wed, 29 May 2019 15:30:35 +0200
Message-ID: <20190529133035.28724-4-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190529133035.28724-1-roberto.sassu@huawei.com>
References: <20190529133035.28724-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.204.65.154]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Show the '^' character when a policy rule has flag IMA_INMASK.

Fixes: 80eae209d63ac ("IMA: allow reading back the current IMA policy")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Cc: stable@vger.kernel.org
---
 security/integrity/ima/ima_policy.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index e0cc323f948f..ae4034f041c4 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -1146,10 +1146,10 @@ enum {
 };
 
 static const char *const mask_tokens[] = {
-	"MAY_EXEC",
-	"MAY_WRITE",
-	"MAY_READ",
-	"MAY_APPEND"
+	"^MAY_EXEC",
+	"^MAY_WRITE",
+	"^MAY_READ",
+	"^MAY_APPEND"
 };
 
 #define __ima_hook_stringify(str)	(#str),
@@ -1209,6 +1209,7 @@ int ima_policy_show(struct seq_file *m, void *v)
 	struct ima_rule_entry *entry = v;
 	int i;
 	char tbuf[64] = {0,};
+	int offset = 0;
 
 	rcu_read_lock();
 
@@ -1232,15 +1233,17 @@ int ima_policy_show(struct seq_file *m, void *v)
 	if (entry->flags & IMA_FUNC)
 		policy_func_show(m, entry->func);
 
-	if (entry->flags & IMA_MASK) {
+	if ((entry->flags & IMA_MASK) || (entry->flags & IMA_INMASK)) {
+		if (entry->flags & IMA_MASK)
+			offset = 1;
 		if (entry->mask & MAY_EXEC)
-			seq_printf(m, pt(Opt_mask), mt(mask_exec));
+			seq_printf(m, pt(Opt_mask), mt(mask_exec) + offset);
 		if (entry->mask & MAY_WRITE)
-			seq_printf(m, pt(Opt_mask), mt(mask_write));
+			seq_printf(m, pt(Opt_mask), mt(mask_write) + offset);
 		if (entry->mask & MAY_READ)
-			seq_printf(m, pt(Opt_mask), mt(mask_read));
+			seq_printf(m, pt(Opt_mask), mt(mask_read) + offset);
 		if (entry->mask & MAY_APPEND)
-			seq_printf(m, pt(Opt_mask), mt(mask_append));
+			seq_printf(m, pt(Opt_mask), mt(mask_append) + offset);
 		seq_puts(m, " ");
 	}
 
-- 
2.17.1

