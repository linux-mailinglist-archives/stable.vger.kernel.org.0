Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E32E52DE53
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 15:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbfE2Nfm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 09:35:42 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:32973 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726702AbfE2Nfm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 09:35:42 -0400
Received: from lhreml709-cah.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id A920149401E1EF5D8FE5;
        Wed, 29 May 2019 14:35:40 +0100 (IST)
Received: from roberto-HP-EliteDesk-800-G2-DM-65W.huawei.com (10.204.65.154)
 by smtpsuk.huawei.com (10.201.108.32) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Wed, 29 May 2019 14:35:34 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <dmitry.kasatkin@huawei.com>,
        <mjg59@google.com>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <silviu.vlasceanu@huawei.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2 2/3] ima: don't ignore INTEGRITY_UNKNOWN EVM status
Date:   Wed, 29 May 2019 15:30:34 +0200
Message-ID: <20190529133035.28724-3-roberto.sassu@huawei.com>
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

Currently, ima_appraise_measurement() ignores the EVM status when
evm_verifyxattr() returns INTEGRITY_UNKNOWN. If a file has a valid
security.ima xattr with type IMA_XATTR_DIGEST or IMA_XATTR_DIGEST_NG,
ima_appraise_measurement() returns INTEGRITY_PASS regardless of the EVM
status. The problem is that the EVM status is overwritten with the
appraisal status.

This patch mitigates the issue by selecting signature verification as the
only method allowed for appraisal when EVM is not initialized. Since the
new behavior might break user space, it must be turned on by adding the
'-evm' suffix to the value of the ima_appraise= kernel option.

Fixes: 2fe5d6def1672 ("ima: integrity appraisal extension")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Cc: stable@vger.kernel.org
---
 Documentation/admin-guide/kernel-parameters.txt | 3 ++-
 security/integrity/ima/ima_appraise.c           | 8 ++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 138f6664b2e2..d84a2e612b93 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1585,7 +1585,8 @@
 			Set number of hash buckets for inode cache.
 
 	ima_appraise=	[IMA] appraise integrity measurements
-			Format: { "off" | "enforce" | "fix" | "log" }
+			Format: { "off" | "enforce" | "fix" | "log" |
+				  "enforce-evm" | "log-evm" }
 			default: "enforce"
 
 	ima_appraise_tcb [IMA] Deprecated.  Use ima_policy= instead.
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 5fb7127bbe68..afef06e10fb9 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -18,6 +18,7 @@
 
 #include "ima.h"
 
+static bool ima_appraise_req_evm __ro_after_init;
 static int __init default_appraise_setup(char *str)
 {
 #ifdef CONFIG_IMA_APPRAISE_BOOTPARAM
@@ -28,6 +29,9 @@ static int __init default_appraise_setup(char *str)
 	else if (strncmp(str, "fix", 3) == 0)
 		ima_appraise = IMA_APPRAISE_FIX;
 #endif
+	if (strcmp(str, "enforce-evm") == 0 ||
+	    strcmp(str, "log-evm") == 0)
+		ima_appraise_req_evm = true;
 	return 1;
 }
 
@@ -245,7 +249,11 @@ int ima_appraise_measurement(enum ima_hooks func,
 	switch (status) {
 	case INTEGRITY_PASS:
 	case INTEGRITY_PASS_IMMUTABLE:
+		break;
 	case INTEGRITY_UNKNOWN:
+		if (ima_appraise_req_evm &&
+		    xattr_value->type != EVM_IMA_XATTR_DIGSIG)
+			goto out;
 		break;
 	case INTEGRITY_NOXATTRS:	/* No EVM protected xattrs. */
 	case INTEGRITY_NOLABEL:		/* No security.evm xattr. */
-- 
2.17.1

