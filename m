Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2344B372E8
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 13:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbfFFLak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 07:30:40 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:32989 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727296AbfFFLak (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jun 2019 07:30:40 -0400
Received: from lhreml705-cah.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id A3EEDA022841E334D138;
        Thu,  6 Jun 2019 12:30:38 +0100 (IST)
Received: from roberto-HP-EliteDesk-800-G2-DM-65W.huawei.com (10.204.65.154)
 by smtpsuk.huawei.com (10.201.108.46) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Thu, 6 Jun 2019 12:30:30 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <dmitry.kasatkin@huawei.com>,
        <mjg59@google.com>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <stable@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <silviu.vlasceanu@huawei.com>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v3 2/2] ima: add enforce-evm and log-evm modes to strictly check EVM status
Date:   Thu, 6 Jun 2019 13:26:20 +0200
Message-ID: <20190606112620.26488-3-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190606112620.26488-1-roberto.sassu@huawei.com>
References: <20190606112620.26488-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.204.65.154]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

IMA and EVM have been designed as two independent subsystems: the first for
checking the integrity of file data; the second for checking file metadata.
Making them independent allows users to adopt them incrementally.

The point of intersection is in IMA-Appraisal, which calls
evm_verifyxattr() to ensure that security.ima wasn't modified during an
offline attack. The design choice, to ensure incremental adoption, was to
continue appraisal verification if evm_verifyxattr() returns
INTEGRITY_UNKNOWN. This value is returned when EVM is not enabled in the
kernel configuration, or if the HMAC key has not been loaded yet.

Although this choice appears legitimate, it might not be suitable for
hardened systems, where the administrator expects that access is denied if
there is any error. An attacker could intentionally delete the EVM keys
from the system and set the file digest in security.ima to the actual file
digest so that the final appraisal status is INTEGRITY_PASS.

This patch allows such hardened systems to strictly enforce an access
control policy based on the validity of signatures/HMACs, by introducing
two new values for the ima_appraise= kernel option: enforce-evm and
log-evm.

Fixes: 2fe5d6def1672 ("ima: integrity appraisal extension")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Cc: stable@vger.kernel.org
---
 Documentation/admin-guide/kernel-parameters.txt | 3 ++-
 security/integrity/ima/ima_appraise.c           | 8 ++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index fe5cde58c11b..0585194ca736 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1587,7 +1587,8 @@
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

