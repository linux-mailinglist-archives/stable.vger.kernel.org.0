Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7C2A15725A
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 11:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgBJKCX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 05:02:23 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2395 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726451AbgBJKCX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 05:02:23 -0500
Received: from LHREML712-CAH.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 9DF2BCF56F1F86B7A36A;
        Mon, 10 Feb 2020 10:02:21 +0000 (GMT)
Received: from roberto-HP-EliteDesk-800-G2-DM-65W.huawei.com (10.204.65.160)
 by smtpsuk.huawei.com (10.201.108.35) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 10 Feb 2020 10:02:13 +0000
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <James.Bottomley@HansenPartnership.com>,
        <jarkko.sakkinen@linux.intel.com>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <silviu.vlasceanu@huawei.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v3 3/8] ima: Evaluate error in init_ima()
Date:   Mon, 10 Feb 2020 11:00:43 +0100
Message-ID: <20200210100048.21448-4-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200210100048.21448-1-roberto.sassu@huawei.com>
References: <20200210100048.21448-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.204.65.160]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Evaluate error in init_ima() before register_blocking_lsm_notifier() and
return if not zero.

Cc: stable@vger.kernel.org # 5.3.x
Fixes: b16942455193 ("ima: use the lsm policy update notifier")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 security/integrity/ima/ima_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index d7e987baf127..a16c148ed90d 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -738,6 +738,9 @@ static int __init init_ima(void)
 		error = ima_init();
 	}
 
+	if (error)
+		return error;
+
 	error = register_blocking_lsm_notifier(&ima_lsm_policy_notifier);
 	if (error)
 		pr_warn("Couldn't register LSM notifier, error %d\n", error);
-- 
2.17.1

