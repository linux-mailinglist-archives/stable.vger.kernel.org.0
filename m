Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13E8B25D509
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 11:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730094AbgIDJag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 05:30:36 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2760 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730267AbgIDJaS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Sep 2020 05:30:18 -0400
Received: from lhreml723-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 65E3C44D87CEC059D949;
        Fri,  4 Sep 2020 10:30:16 +0100 (IST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 lhreml723-chm.china.huawei.com (10.201.108.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Fri, 4 Sep 2020 10:30:16 +0100
Received: from roberto-HP-EliteDesk-800-G2-DM-65W.huawei.com (10.204.65.160)
 by fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.1913.5; Fri, 4 Sep 2020 11:30:15 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <mjg59@google.com>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <silviu.vlasceanu@huawei.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2 07/12] evm: Introduce EVM_RESET_STATUS atomic flag
Date:   Fri, 4 Sep 2020 11:26:38 +0200
Message-ID: <20200904092643.20013-3-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.27.GIT
In-Reply-To: <20200904092339.19598-1-roberto.sassu@huawei.com>
References: <20200904092339.19598-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.65.160]
X-ClientProxiedBy: lhreml709-chm.china.huawei.com (10.201.108.58) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When EVM_ALLOW_METADATA_WRITES is set, EVM allows any operation on
metadata. Its main purpose is to allow users to freely set metadata when
they are protected by a portable signature, until the HMAC key is loaded.

However, IMA is not notified about metadata changes and, after the first
successful appraisal, always allows access to the files without checking
metadata again.

This patch introduces the new atomic flag EVM_RESET_STATUS in
integrity_iint_cache that is set in the EVM post hooks and cleared in
evm_verify_hmac(). IMA checks the new flag in process_measurement() and if
it is set, it clears the appraisal flags.

Although the flag could be cleared also by evm_inode_setxattr() and
evm_inode_setattr() before IMA sees it, this does not happen if
EVM_ALLOW_METADATA_WRITES is set. Since the only remaining caller is
evm_verifyxattr(), this ensures that IMA always sees the flag set before it
is cleared.

This patch also adds a call to evm_reset_status() in
evm_inode_post_setattr() so that EVM won't return the cached status the
next time appraisal is performed.

Cc: stable@vger.kernel.org # 4.16.x
Fixes: ae1ba1676b88e ("EVM: Allow userland to permit modification of EVM-protected metadata")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 security/integrity/evm/evm_main.c | 17 +++++++++++++++--
 security/integrity/ima/ima_main.c |  8 ++++++--
 security/integrity/integrity.h    |  1 +
 3 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 4e9f5e8b21d5..05be1ad3e6f3 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -221,8 +221,15 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
 		evm_status = (rc == -ENODATA) ?
 				INTEGRITY_NOXATTRS : INTEGRITY_FAIL;
 out:
-	if (iint)
+	if (iint) {
+		/*
+		 * EVM_RESET_STATUS can be cleared only by evm_verifyxattr()
+		 * when EVM_ALLOW_METADATA_WRITES is set. This guarantees that
+		 * IMA sees the EVM_RESET_STATUS flag set before it is cleared.
+		 */
+		clear_bit(EVM_RESET_STATUS, &iint->atomic_flags);
 		iint->evm_status = evm_status;
+	}
 	kfree(xattr_data);
 	return evm_status;
 }
@@ -418,8 +425,12 @@ static void evm_reset_status(struct inode *inode)
 	struct integrity_iint_cache *iint;
 
 	iint = integrity_iint_find(inode);
-	if (iint)
+	if (iint) {
+		if (evm_initialized & EVM_ALLOW_METADATA_WRITES)
+			set_bit(EVM_RESET_STATUS, &iint->atomic_flags);
+
 		iint->evm_status = INTEGRITY_UNKNOWN;
+	}
 }
 
 /**
@@ -513,6 +524,8 @@ void evm_inode_post_setattr(struct dentry *dentry, int ia_valid)
 	if (!evm_key_loaded())
 		return;
 
+	evm_reset_status(dentry->d_inode);
+
 	if (ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID))
 		evm_update_evmxattr(dentry, NULL, NULL, 0);
 }
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 8a91711ca79b..bb9976dc2b74 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -246,8 +246,12 @@ static int process_measurement(struct file *file, const struct cred *cred,
 
 	mutex_lock(&iint->mutex);
 
-	if (test_and_clear_bit(IMA_CHANGE_ATTR, &iint->atomic_flags))
-		/* reset appraisal flags if ima_inode_post_setattr was called */
+	if (test_and_clear_bit(IMA_CHANGE_ATTR, &iint->atomic_flags) ||
+	    test_bit(EVM_RESET_STATUS, &iint->atomic_flags))
+		/*
+		 * Reset appraisal flags if ima_inode_post_setattr was called or
+		 * EVM reset its status and metadata modification was enabled.
+		 */
 		iint->flags &= ~(IMA_APPRAISE | IMA_APPRAISED |
 				 IMA_APPRAISE_SUBMASK | IMA_APPRAISED_SUBMASK |
 				 IMA_ACTION_FLAGS);
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index 413c803c5208..2adec51c0f6e 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -70,6 +70,7 @@
 #define IMA_CHANGE_ATTR		2
 #define IMA_DIGSIG		3
 #define IMA_MUST_MEASURE	4
+#define EVM_RESET_STATUS	5
 
 enum evm_ima_xattr_type {
 	IMA_XATTR_DIGEST = 0x01,
-- 
2.27.GIT

