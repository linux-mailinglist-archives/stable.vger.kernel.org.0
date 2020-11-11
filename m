Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28E822AED6E
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 10:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgKKJYD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Nov 2020 04:24:03 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2082 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726061AbgKKJYC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Nov 2020 04:24:02 -0500
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4CWK4w3zX1z67KXd;
        Wed, 11 Nov 2020 17:22:24 +0800 (CST)
Received: from roberto-HP-EliteDesk-800-G2-DM-65W.huawei.com (10.204.65.161)
 by fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Wed, 11 Nov 2020 10:23:59 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <mjg59@google.com>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <silviu.vlasceanu@huawei.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v3 01/11] evm: Execute evm_inode_init_security() only when an HMAC key is loaded
Date:   Wed, 11 Nov 2020 10:22:52 +0100
Message-ID: <20201111092302.1589-2-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.27.GIT
In-Reply-To: <20201111092302.1589-1-roberto.sassu@huawei.com>
References: <20201111092302.1589-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.65.161]
X-ClientProxiedBy: lhreml735-chm.china.huawei.com (10.201.108.86) To
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
 security/integrity/evm/evm_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 76d19146d74b..001e001eae01 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -530,7 +530,8 @@ int evm_inode_init_security(struct inode *inode,
 	struct evm_xattr *xattr_data;
 	int rc;
 
-	if (!evm_key_loaded() || !evm_protected_xattr(lsm_xattr->name))
+	if (!(evm_initialized & EVM_INIT_HMAC) ||
+	    !evm_protected_xattr(lsm_xattr->name))
 		return 0;
 
 	xattr_data = kzalloc(sizeof(*xattr_data), GFP_NOFS);
-- 
2.27.GIT

