Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 723D1373957
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 13:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbhEELbB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 07:31:01 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3003 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232905AbhEELbB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 07:31:01 -0400
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4FZvS85d7qz6rlXW;
        Wed,  5 May 2021 19:22:00 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.62.217) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 5 May 2021 13:30:02 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <mjg59@google.com>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v6 01/11] evm: Execute evm_inode_init_security() only when an HMAC key is loaded
Date:   Wed, 5 May 2021 13:29:25 +0200
Message-ID: <20210505112935.1410679-2-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210505112935.1410679-1-roberto.sassu@huawei.com>
References: <20210505112935.1410679-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.62.217]
X-ClientProxiedBy: lhreml752-chm.china.huawei.com (10.201.108.202) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

evm_inode_init_security() requires an HMAC key to calculate the HMAC on
initial xattrs provided by LSMs. However, it checks generically whether a
key has been loaded, including also public keys, which is not correct as
public keys are not suitable to calculate the HMAC.

Originally, support for signature verification was introduced to verify a
possibly immutable initial ram disk, when no new files are created, and to
switch to HMAC for the root filesystem. By that time, an HMAC key should
have been loaded and usable to calculate HMACs for new files.

More recently support for requiring an HMAC key was removed from the
kernel, so that signature verification can be used alone. Since this is a
legitimate use case, evm_inode_init_security() should not return an error
when no HMAC key has been loaded.

This patch fixes this problem by replacing the evm_key_loaded() check with
a check of the EVM_INIT_HMAC flag in evm_initialized.

Cc: stable@vger.kernel.org # 4.5.x
Fixes: 26ddabfe96b ("evm: enable EVM when X509 certificate is loaded")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>
---
 security/integrity/evm/evm_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 0de367aaa2d3..7ac5204c8d1f 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -521,7 +521,7 @@ void evm_inode_post_setattr(struct dentry *dentry, int ia_valid)
 }
 
 /*
- * evm_inode_init_security - initializes security.evm
+ * evm_inode_init_security - initializes security.evm HMAC value
  */
 int evm_inode_init_security(struct inode *inode,
 				 const struct xattr *lsm_xattr,
@@ -530,7 +530,8 @@ int evm_inode_init_security(struct inode *inode,
 	struct evm_xattr *xattr_data;
 	int rc;
 
-	if (!evm_key_loaded() || !evm_protected_xattr(lsm_xattr->name))
+	if (!(evm_initialized & EVM_INIT_HMAC) ||
+	    !evm_protected_xattr(lsm_xattr->name))
 		return 0;
 
 	xattr_data = kzalloc(sizeof(*xattr_data), GFP_NOFS);
-- 
2.25.1

