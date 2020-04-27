Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD4451BA140
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 12:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgD0Kbo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Apr 2020 06:31:44 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2107 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726955AbgD0Kbn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Apr 2020 06:31:43 -0400
Received: from lhreml722-chm.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 7B7784AEC8FCA8D2792F;
        Mon, 27 Apr 2020 11:31:41 +0100 (IST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 lhreml722-chm.china.huawei.com (10.201.108.73) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Mon, 27 Apr 2020 11:31:41 +0100
Received: from roberto-HP-EliteDesk-800-G2-DM-65W.huawei.com (10.204.65.160)
 by fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Mon, 27 Apr 2020 12:31:40 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <rgoldwyn@suse.de>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <silviu.vlasceanu@huawei.com>,
        <krzysztof.struczynski@huawei.com>, <stable@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v2 3/6] ima: Fix ima digest hash table key calculation
Date:   Mon, 27 Apr 2020 12:28:57 +0200
Message-ID: <20200427102900.18887-3-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200427102900.18887-1-roberto.sassu@huawei.com>
References: <20200427102900.18887-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.204.65.160]
X-ClientProxiedBy: lhreml710-chm.china.huawei.com (10.201.108.61) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Struczynski <krzysztof.struczynski@huawei.com>

Function hash_long() accepts unsigned long, while currently only one byte
is passed from ima_hash_key(), which calculates a key for ima_htable.

Given that hashing the digest does not give clear benefits compared to
using the digest itself, remove hash_long() and return the modulus
calculated on the beginning of the digest with the number of slots. Also
reduce the depth of the hash table by doubling the number of slots.

Cc: stable@vger.kernel.org
Fixes: 3323eec921ef ("integrity: IMA as an integrity service provider")
Co-developed-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Krzysztof Struczynski <krzysztof.struczynski@huawei.com>
---
 security/integrity/ima/ima.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 467dfdbea25c..6ee458cf124a 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -36,7 +36,7 @@ enum tpm_pcrs { TPM_PCR0 = 0, TPM_PCR8 = 8 };
 #define IMA_DIGEST_SIZE		SHA1_DIGEST_SIZE
 #define IMA_EVENT_NAME_LEN_MAX	255
 
-#define IMA_HASH_BITS 9
+#define IMA_HASH_BITS 10
 #define IMA_MEASURE_HTABLE_SIZE (1 << IMA_HASH_BITS)
 
 #define IMA_TEMPLATE_FIELD_ID_MAX_LEN	16
@@ -179,9 +179,9 @@ struct ima_h_table {
 };
 extern struct ima_h_table ima_htable;
 
-static inline unsigned long ima_hash_key(u8 *digest)
+static inline unsigned int ima_hash_key(u8 *digest)
 {
-	return hash_long(*digest, IMA_HASH_BITS);
+	return (*(unsigned int *)digest % IMA_MEASURE_HTABLE_SIZE);
 }
 
 #define __ima_hooks(hook)		\
-- 
2.17.1

