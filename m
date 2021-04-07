Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAF03356A62
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 12:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351607AbhDGKxW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 06:53:22 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:2787 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351596AbhDGKxR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Apr 2021 06:53:17 -0400
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4FFgwm0cJkz681vb;
        Wed,  7 Apr 2021 18:43:36 +0800 (CST)
Received: from fraphisprd00473.huawei.com (7.182.8.141) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 7 Apr 2021 12:53:05 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <mjg59@google.com>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v5 03/12] evm: Refuse EVM_ALLOW_METADATA_WRITES only if an HMAC key is loaded
Date:   Wed, 7 Apr 2021 12:52:43 +0200
Message-ID: <20210407105252.30721-4-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210407105252.30721-1-roberto.sassu@huawei.com>
References: <20210407105252.30721-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [7.182.8.141]
X-ClientProxiedBy: lhreml753-chm.china.huawei.com (10.201.108.203) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

EVM_ALLOW_METADATA_WRITES is an EVM initialization flag that can be set to
temporarily disable metadata verification until all xattrs/attrs necessary
to verify an EVM portable signature are copied to the file. This flag is
cleared when EVM is initialized with an HMAC key, to avoid that the HMAC is
calculated on unverified xattrs/attrs.

Currently EVM unnecessarily denies setting this flag if EVM is initialized
with a public key, which is not a concern as it cannot be used to trust
xattrs/attrs updates. This patch removes this limitation.

Cc: stable@vger.kernel.org # 4.16.x
Fixes: ae1ba1676b88e ("EVM: Allow userland to permit modification of EVM-protected metadata")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 Documentation/ABI/testing/evm      | 5 +++--
 security/integrity/evm/evm_secfs.c | 4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/Documentation/ABI/testing/evm b/Documentation/ABI/testing/evm
index 3c477ba48a31..eb6d70fd6fa2 100644
--- a/Documentation/ABI/testing/evm
+++ b/Documentation/ABI/testing/evm
@@ -49,8 +49,9 @@ Description:
 		modification of EVM-protected metadata and
 		disable all further modification of policy
 
-		Note that once a key has been loaded, it will no longer be
-		possible to enable metadata modification.
+		Note that once an HMAC key has been loaded, it will no longer
+		be possible to enable metadata modification and, if it is
+		already enabled, it will be disabled.
 
 		Until key loading has been signaled EVM can not create
 		or validate the 'security.evm' xattr, but returns
diff --git a/security/integrity/evm/evm_secfs.c b/security/integrity/evm/evm_secfs.c
index bbc85637e18b..197a4b83e534 100644
--- a/security/integrity/evm/evm_secfs.c
+++ b/security/integrity/evm/evm_secfs.c
@@ -81,10 +81,10 @@ static ssize_t evm_write_key(struct file *file, const char __user *buf,
 		return -EINVAL;
 
 	/* Don't allow a request to freshly enable metadata writes if
-	 * keys are loaded.
+	 * an HMAC key is loaded.
 	 */
 	if ((i & EVM_ALLOW_METADATA_WRITES) &&
-	    ((evm_initialized & EVM_KEY_MASK) != 0) &&
+	    ((evm_initialized & EVM_INIT_HMAC) != 0) &&
 	    !(evm_initialized & EVM_ALLOW_METADATA_WRITES))
 		return -EPERM;
 
-- 
2.26.2

