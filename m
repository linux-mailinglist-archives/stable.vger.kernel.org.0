Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45D891B2256
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 11:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728379AbgDUJHr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 05:07:47 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2067 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726095AbgDUJHr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 05:07:47 -0400
Received: from lhreml725-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id E92A03756FD049E7F83F;
        Tue, 21 Apr 2020 10:07:44 +0100 (IST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 lhreml725-chm.china.huawei.com (10.201.108.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Tue, 21 Apr 2020 10:07:44 +0100
Received: from roberto-HP-EliteDesk-800-G2-DM-65W.huawei.com (10.204.65.160)
 by fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.1913.5; Tue, 21 Apr 2020 11:07:43 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <silviu.vlasceanu@huawei.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] ima: Fix return value of ima_write_policy()
Date:   Tue, 21 Apr 2020 11:04:42 +0200
Message-ID: <20200421090442.22693-1-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.204.65.160]
X-ClientProxiedBy: lhreml706-chm.china.huawei.com (10.201.108.55) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Return datalen instead of zero if there is a rule to appraise the policy
but that rule is not enforced.

Cc: stable@vger.kernel.org
Fixes: 19f8a84713edc ("ima: measure and appraise the IMA policy itself")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 security/integrity/ima/ima_fs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
index a71e822a6e92..2c2ea814b954 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -340,6 +340,8 @@ static ssize_t ima_write_policy(struct file *file, const char __user *buf,
 				    1, 0);
 		if (ima_appraise & IMA_APPRAISE_ENFORCE)
 			result = -EACCES;
+		else
+			result = datalen;
 	} else {
 		result = ima_parse_add_rule(data);
 	}
-- 
2.17.1

