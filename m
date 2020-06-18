Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAC3E1FF88A
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 18:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731775AbgFRQEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 12:04:21 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2332 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731753AbgFRQEU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jun 2020 12:04:20 -0400
Received: from lhreml736-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 688362462C46C0D090A2;
        Thu, 18 Jun 2020 17:04:19 +0100 (IST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 lhreml736-chm.china.huawei.com (10.201.108.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Thu, 18 Jun 2020 17:04:19 +0100
Received: from roberto-HP-EliteDesk-800-G2-DM-65W.huawei.com (10.204.65.160)
 by fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.1913.5; Thu, 18 Jun 2020 18:04:18 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <mjg59@google.com>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 03/11] evm: Refuse EVM_ALLOW_METADATA_WRITES only if the HMAC key is loaded
Date:   Thu, 18 Jun 2020 18:01:25 +0200
Message-ID: <20200618160133.937-3-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200618160133.937-1-roberto.sassu@huawei.com>
References: <20200618160133.937-1-roberto.sassu@huawei.com>
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

Granting metadata write is safe if the HMAC key is not loaded, as it won't
let an attacker obtain a valid HMAC from corrupted xattrs. evm_write_key()
however does not allow it if any key is loaded, including a public key,
which should not be a problem.

This patch allows setting EVM_ALLOW_METADATA_WRITES if the EVM_INIT_HMAC
flag is not set.

Cc: stable@vger.kernel.org # 4.16.x
Fixes: ae1ba1676b88e ("EVM: Allow userland to permit modification of EVM-protected metadata")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 security/integrity/evm/evm_secfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/integrity/evm/evm_secfs.c b/security/integrity/evm/evm_secfs.c
index cfc3075769bb..92fe26ace797 100644
--- a/security/integrity/evm/evm_secfs.c
+++ b/security/integrity/evm/evm_secfs.c
@@ -84,7 +84,7 @@ static ssize_t evm_write_key(struct file *file, const char __user *buf,
 	 * keys are loaded.
 	 */
 	if ((i & EVM_ALLOW_METADATA_WRITES) &&
-	    ((evm_initialized & EVM_KEY_MASK) != 0) &&
+	    ((evm_initialized & EVM_INIT_HMAC) != 0) &&
 	    !(evm_initialized & EVM_ALLOW_METADATA_WRITES))
 		return -EPERM;
 
-- 
2.17.1

