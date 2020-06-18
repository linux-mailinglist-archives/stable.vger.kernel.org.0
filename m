Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1C81FF88E
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 18:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731804AbgFRQE0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 12:04:26 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2333 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731753AbgFRQEZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jun 2020 12:04:25 -0400
Received: from lhreml734-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id BE2AC619E696DA4357FB;
        Thu, 18 Jun 2020 17:04:23 +0100 (IST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 lhreml734-chm.china.huawei.com (10.201.108.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Thu, 18 Jun 2020 17:04:23 +0100
Received: from roberto-HP-EliteDesk-800-G2-DM-65W.huawei.com (10.204.65.160)
 by fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.1913.5; Thu, 18 Jun 2020 18:04:22 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <mjg59@google.com>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 04/11] evm: Check size of security.evm before using it
Date:   Thu, 18 Jun 2020 18:01:26 +0200
Message-ID: <20200618160133.937-4-roberto.sassu@huawei.com>
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

This patch checks the size for the EVM_IMA_XATTR_DIGSIG and
EVM_XATTR_PORTABLE_DIGSIG types to ensure that the algorithm is read from
the buffer returned by vfs_getxattr_alloc().

Cc: stable@vger.kernel.org # 4.19.x
Fixes: 5feeb61183dde ("evm: Allow non-SHA1 digital signatures")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 security/integrity/evm/evm_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 744c105b48d1..4e9f5e8b21d5 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -181,6 +181,12 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
 		break;
 	case EVM_IMA_XATTR_DIGSIG:
 	case EVM_XATTR_PORTABLE_DIGSIG:
+		/* accept xattr with non-empty signature field */
+		if (xattr_len <= sizeof(struct signature_v2_hdr)) {
+			evm_status = INTEGRITY_FAIL;
+			goto out;
+		}
+
 		hdr = (struct signature_v2_hdr *)xattr_data;
 		digest.hdr.algo = hdr->hash_algo;
 		rc = evm_calc_hash(dentry, xattr_name, xattr_value,
-- 
2.17.1

