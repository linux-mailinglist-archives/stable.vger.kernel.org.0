Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD711BA166
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 12:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgD0Kd7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Apr 2020 06:33:59 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2110 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726504AbgD0Kd7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Apr 2020 06:33:59 -0400
Received: from lhreml730-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id CDDD2F1A32276893828B;
        Mon, 27 Apr 2020 11:33:57 +0100 (IST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 lhreml730-chm.china.huawei.com (10.201.108.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Mon, 27 Apr 2020 11:33:57 +0100
Received: from roberto-HP-EliteDesk-800-G2-DM-65W.huawei.com (10.204.65.160)
 by fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Mon, 27 Apr 2020 12:33:56 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <rgoldwyn@suse.de>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <silviu.vlasceanu@huawei.com>,
        <krzysztof.struczynski@huawei.com>,
        "Roberto Sassu" <roberto.sassu@huawei.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2 6/6] ima: Fix return value of ima_write_policy()
Date:   Mon, 27 Apr 2020 12:31:28 +0200
Message-ID: <20200427103128.19229-1-roberto.sassu@huawei.com>
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

This patch fixes the return value of ima_write_policy() when a new policy
is directly passed to IMA and the current policy requires appraisal of the
file containing the policy. Currently, if appraisal is not in ENFORCE mode,
ima_write_policy() returns 0 and leads user space applications to an
endless loop. Fix this issue by denying the operation regardless of the
appraisal mode.

Changelog

v1:
- deny the operation in all cases (suggested by Mimi, Krzysztof)

Cc: stable@vger.kernel.org # 4.10.x
Fixes: 19f8a84713edc ("ima: measure and appraise the IMA policy itself")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 security/integrity/ima/ima_fs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
index 8b030a1c5e0d..e3fcad871861 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -338,8 +338,7 @@ static ssize_t ima_write_policy(struct file *file, const char __user *buf,
 		integrity_audit_msg(AUDIT_INTEGRITY_STATUS, NULL, NULL,
 				    "policy_update", "signed policy required",
 				    1, 0);
-		if (ima_appraise & IMA_APPRAISE_ENFORCE)
-			result = -EACCES;
+		result = -EACCES;
 	} else {
 		result = ima_parse_add_rule(data);
 	}
-- 
2.17.1

