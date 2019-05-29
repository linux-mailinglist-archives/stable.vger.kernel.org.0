Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F06872DE49
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 15:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbfE2NfH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 09:35:07 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:32972 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726104AbfE2NfG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 09:35:06 -0400
Received: from lhreml709-cah.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 2D59B29D317FA73B2E71;
        Wed, 29 May 2019 14:35:05 +0100 (IST)
Received: from roberto-HP-EliteDesk-800-G2-DM-65W.huawei.com (10.204.65.154)
 by smtpsuk.huawei.com (10.201.108.32) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Wed, 29 May 2019 14:34:58 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <dmitry.kasatkin@huawei.com>,
        <mjg59@google.com>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <silviu.vlasceanu@huawei.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2 1/3] evm: check hash algorithm passed to init_desc()
Date:   Wed, 29 May 2019 15:30:33 +0200
Message-ID: <20190529133035.28724-2-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190529133035.28724-1-roberto.sassu@huawei.com>
References: <20190529133035.28724-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.204.65.154]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch prevents memory access beyond the evm_tfm array by checking the
validity of the index (hash algorithm) passed to init_desc(). The hash
algorithm can be arbitrarily set if the security.ima xattr type is not
EVM_XATTR_HMAC.

Fixes: 5feeb61183dde ("evm: Allow non-SHA1 digital signatures")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Cc: stable@vger.kernel.org
---
 security/integrity/evm/evm_crypto.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index e11564eb645b..82a38e801ee4 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -89,6 +89,9 @@ static struct shash_desc *init_desc(char type, uint8_t hash_algo)
 		tfm = &hmac_tfm;
 		algo = evm_hmac;
 	} else {
+		if (hash_algo >= HASH_ALGO__LAST)
+			return ERR_PTR(-EINVAL);
+
 		tfm = &evm_tfm[hash_algo];
 		algo = hash_algo_name[hash_algo];
 	}
-- 
2.17.1

