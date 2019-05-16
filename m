Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1645120CCB
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbfEPQSX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:18:23 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:32948 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726422AbfEPQSX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 12:18:23 -0400
Received: from LHREML713-CAH.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 0D8EE4978D639E36D45B;
        Thu, 16 May 2019 17:18:22 +0100 (IST)
Received: from roberto-HP-EliteDesk-800-G2-DM-65W.huawei.com (10.204.65.154)
 by smtpsuk.huawei.com (10.201.108.36) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Thu, 16 May 2019 17:18:13 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <dmitry.kasatkin@huawei.com>,
        <mjg59@google.com>
CC:     <linux-integrity@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <silviu.vlasceanu@huawei.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 4/4] ima: only audit failed appraisal verifications
Date:   Thu, 16 May 2019 18:12:57 +0200
Message-ID: <20190516161257.6640-4-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190516161257.6640-1-roberto.sassu@huawei.com>
References: <20190516161257.6640-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.204.65.154]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch ensures that integrity_audit_msg() is called only when the
status is not INTEGRITY_PASS.

Fixes: 8606404fa555c ("ima: digital signature verification support")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Cc: stable@vger.kernel.org
---
 security/integrity/ima/ima_appraise.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index a32ed5d7afd1..f5f4506bcb8e 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -359,8 +359,9 @@ int ima_appraise_measurement(enum ima_hooks func,
 			status = INTEGRITY_PASS;
 		}
 
-		integrity_audit_msg(AUDIT_INTEGRITY_DATA, inode, filename,
-				    op, cause, rc, 0);
+		if (status != INTEGRITY_PASS)
+			integrity_audit_msg(AUDIT_INTEGRITY_DATA, inode,
+					    filename, op, cause, rc, 0);
 	} else {
 		ima_cache_flags(iint, func);
 	}
-- 
2.17.1

