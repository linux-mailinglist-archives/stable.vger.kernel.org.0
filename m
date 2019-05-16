Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 684E020CC6
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbfEPQSN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:18:13 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:32947 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726422AbfEPQSN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 12:18:13 -0400
Received: from LHREML713-CAH.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id DF1CC146AA4D89FCF04B;
        Thu, 16 May 2019 17:18:11 +0100 (IST)
Received: from roberto-HP-EliteDesk-800-G2-DM-65W.huawei.com (10.204.65.154)
 by smtpsuk.huawei.com (10.201.108.36) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Thu, 16 May 2019 17:18:05 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <dmitry.kasatkin@huawei.com>,
        <mjg59@google.com>
CC:     <linux-integrity@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <silviu.vlasceanu@huawei.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 3/4] ima: don't ignore INTEGRITY_UNKNOWN EVM status
Date:   Thu, 16 May 2019 18:12:56 +0200
Message-ID: <20190516161257.6640-3-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190516161257.6640-1-roberto.sassu@huawei.com>
References: <20190516161257.6640-1-roberto.sassu@huawei.com>
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
new behavior might break user space, it must be turned on by adding
ima_appraise_req_evm to the kernel command line.

Fixes: 2fe5d6def1672 ("ima: integrity appraisal extension")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Cc: stable@vger.kernel.org
---
 Documentation/admin-guide/kernel-parameters.txt |  3 +++
 security/integrity/ima/ima_appraise.c           | 12 ++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 52e6fbb042cc..80e1c233656b 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1588,6 +1588,9 @@
 			Format: { "off" | "enforce" | "fix" | "log" }
 			default: "enforce"
 
+	ima_appraise_req_evm
+			[IMA] require EVM for appraisal with file digests.
+
 	ima_appraise_tcb [IMA] Deprecated.  Use ima_policy= instead.
 			The builtin appraise policy appraises all files
 			owned by uid=0.
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 5fb7127bbe68..a32ed5d7afd1 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -33,6 +33,14 @@ static int __init default_appraise_setup(char *str)
 
 __setup("ima_appraise=", default_appraise_setup);
 
+static bool ima_appraise_req_evm;
+static int __init appraise_req_evm_setup(char *str)
+{
+	ima_appraise_req_evm = true;
+	return 1;
+}
+__setup("ima_appraise_req_evm", appraise_req_evm_setup);
+
 /*
  * is_ima_appraise_enabled - return appraise status
  *
@@ -245,7 +253,11 @@ int ima_appraise_measurement(enum ima_hooks func,
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

