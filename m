Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3E5525D504
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 11:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730275AbgIDJaV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 05:30:21 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2759 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730251AbgIDJaR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Sep 2020 05:30:17 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id AB700FA363A68C7F4490;
        Fri,  4 Sep 2020 10:30:15 +0100 (IST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Fri, 4 Sep 2020 10:30:15 +0100
Received: from roberto-HP-EliteDesk-800-G2-DM-65W.huawei.com (10.204.65.160)
 by fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.1913.5; Fri, 4 Sep 2020 11:30:14 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <mjg59@google.com>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <silviu.vlasceanu@huawei.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2 06/12] evm: Refuse EVM_ALLOW_METADATA_WRITES only if the HMAC key is loaded
Date:   Fri, 4 Sep 2020 11:26:37 +0200
Message-ID: <20200904092643.20013-2-roberto.sassu@huawei.com>
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

EVM_ALLOW_METADATA_WRITES is an EVM initialization flag that can be set to
temporarily disable metadata verification until all xattrs/attrs necessary
to verify an EVM portable signature are copied to the file. This flag is
cleared when EVM is initialized with an HMAC key, to avoid that the HMAC is
calculated on unverified xattrs/attrs.

Currently EVM unnecessarily denies setting this flag if EVM is initialized
with public key, which is not a concern as it cannot be used to trust
xattrs/attrs updates. This patch removes this limitation.

Cc: stable@vger.kernel.org # 4.16.x
Fixes: ae1ba1676b88e ("EVM: Allow userland to permit modification of EVM-protected metadata")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 Documentation/ABI/testing/evm      | 6 ++++--
 security/integrity/evm/evm_secfs.c | 2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/Documentation/ABI/testing/evm b/Documentation/ABI/testing/evm
index 201d10319fa1..cbb50ab09c78 100644
--- a/Documentation/ABI/testing/evm
+++ b/Documentation/ABI/testing/evm
@@ -42,8 +42,10 @@ Description:
 		modification of EVM-protected metadata and
 		disable all further modification of policy
 
-		Note that once a key has been loaded, it will no longer be
-		possible to enable metadata modification.
+		Note that once HMAC validation and creation is enabled,
+		it will no longer be possible to enable metadata modification
+		and if metadata modification is already enabled, it will be
+		disabled.
 
 		Until key loading has been signaled EVM can not create
 		or validate the 'security.evm' xattr, but returns
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
2.27.GIT

