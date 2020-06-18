Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F80F1FF882
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 18:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728578AbgFRQEQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 12:04:16 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2330 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728134AbgFRQEP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jun 2020 12:04:15 -0400
Received: from lhreml743-chm.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 50781EC1761F9D513D02;
        Thu, 18 Jun 2020 17:04:13 +0100 (IST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 lhreml743-chm.china.huawei.com (10.201.108.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Thu, 18 Jun 2020 17:04:13 +0100
Received: from roberto-HP-EliteDesk-800-G2-DM-65W.huawei.com (10.204.65.160)
 by fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.1913.5; Thu, 18 Jun 2020 18:04:12 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <mjg59@google.com>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 01/11] evm: Execute evm_inode_init_security() only when the HMAC key is loaded
Date:   Thu, 18 Jun 2020 18:01:23 +0200
Message-ID: <20200618160133.937-1-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.17.1
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

evm_inode_init_security() requires the HMAC key to calculate the HMAC on
initial xattrs provided by LSMs. Unfortunately, with the evm_key_loaded()
check, the function continues even if the HMAC key is not loaded
(evm_key_loaded() returns true also if EVM has been initialized only with a
public key). If the HMAC key is not loaded, evm_inode_init_security()
returns an error later when it calls evm_init_hmac().

Thus, this patch replaces the evm_key_loaded() check with a check of the
EVM_INIT_HMAC flag in evm_initialized, so that evm_inode_init_security()
returns 0 instead of an error.

Cc: stable@vger.kernel.org # 4.5.x
Fixes: 26ddabfe96b ("evm: enable EVM when X509 certificate is loaded")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 security/integrity/evm/evm_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 0d36259b690d..744c105b48d1 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -521,7 +521,8 @@ int evm_inode_init_security(struct inode *inode,
 	struct evm_xattr *xattr_data;
 	int rc;
 
-	if (!evm_key_loaded() || !evm_protected_xattr(lsm_xattr->name))
+	if (!(evm_initialized & EVM_INIT_HMAC) ||
+	    !evm_protected_xattr(lsm_xattr->name))
 		return 0;
 
 	xattr_data = kzalloc(sizeof(*xattr_data), GFP_NOFS);
-- 
2.17.1

