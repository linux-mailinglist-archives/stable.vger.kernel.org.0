Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F136B1FF8A5
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 18:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731541AbgFRQHl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 12:07:41 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2337 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728310AbgFRQHk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jun 2020 12:07:40 -0400
Received: from lhreml718-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 437AA5C6CDCCA9710100;
        Thu, 18 Jun 2020 17:07:38 +0100 (IST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 lhreml718-chm.china.huawei.com (10.201.108.69) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Thu, 18 Jun 2020 17:07:38 +0100
Received: from roberto-HP-EliteDesk-800-G2-DM-65W.huawei.com (10.204.65.160)
 by fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.1913.5; Thu, 18 Jun 2020 18:07:37 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <mjg59@google.com>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <silviu.vlasceanu@huawei.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 07/11] evm: Set IMA_CHANGE_XATTR/ATTR bit if EVM_ALLOW_METADATA_WRITES is set
Date:   Thu, 18 Jun 2020 18:04:54 +0200
Message-ID: <20200618160458.1579-7-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200618160329.1263-2-roberto.sassu@huawei.com>
References: <20200618160329.1263-2-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.204.65.160]
X-ClientProxiedBy: lhreml704-chm.china.huawei.com (10.201.108.53) To
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
appraisal, always allows access to the files without checking metadata
again.

This patch checks in evm_reset_status() if EVM_ALLOW_METADATA WRITES is
enabled and if it is, sets the IMA_CHANGE_XATTR/ATTR bits depending on the
operation performed. At the next appraisal, metadata are revalidated.

This patch also adds a call to evm_reset_status() in
evm_inode_post_setattr() so that EVM won't return the cached status the
next time appraisal is performed.

Cc: stable@vger.kernel.org # 4.16.x
Fixes: ae1ba1676b88e ("EVM: Allow userland to permit modification of EVM-protected metadata")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 security/integrity/evm/evm_main.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 41cc6a4aaaab..d4d918183094 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -478,13 +478,17 @@ int evm_inode_removexattr(struct dentry *dentry, const char *xattr_name)
 	return evm_protect_xattr(dentry, xattr_name, NULL, 0);
 }
 
-static void evm_reset_status(struct inode *inode)
+static void evm_reset_status(struct inode *inode, int bit)
 {
 	struct integrity_iint_cache *iint;
 
 	iint = integrity_iint_find(inode);
-	if (iint)
+	if (iint) {
+		if (evm_initialized & EVM_ALLOW_METADATA_WRITES)
+			set_bit(bit, &iint->atomic_flags);
+
 		iint->evm_status = INTEGRITY_UNKNOWN;
+	}
 }
 
 /**
@@ -507,7 +511,7 @@ void evm_inode_post_setxattr(struct dentry *dentry, const char *xattr_name,
 				  && !posix_xattr_acl(xattr_name)))
 		return;
 
-	evm_reset_status(dentry->d_inode);
+	evm_reset_status(dentry->d_inode, IMA_CHANGE_XATTR);
 
 	evm_update_evmxattr(dentry, xattr_name, xattr_value, xattr_value_len);
 }
@@ -527,7 +531,7 @@ void evm_inode_post_removexattr(struct dentry *dentry, const char *xattr_name)
 	if (!evm_key_loaded() || !evm_protected_xattr(xattr_name))
 		return;
 
-	evm_reset_status(dentry->d_inode);
+	evm_reset_status(dentry->d_inode, IMA_CHANGE_XATTR);
 
 	evm_update_evmxattr(dentry, xattr_name, NULL, 0);
 }
@@ -600,6 +604,8 @@ void evm_inode_post_setattr(struct dentry *dentry, int ia_valid)
 	if (!evm_key_loaded())
 		return;
 
+	evm_reset_status(dentry->d_inode, IMA_CHANGE_ATTR);
+
 	if (ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID))
 		evm_update_evmxattr(dentry, NULL, NULL, 0);
 }
-- 
2.17.1

