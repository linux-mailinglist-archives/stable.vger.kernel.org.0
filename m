Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64635192DE1
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 17:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgCYQNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Mar 2020 12:13:14 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2600 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727600AbgCYQNO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Mar 2020 12:13:14 -0400
Received: from lhreml702-cah.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 85E86EC761C3ACE8F76B;
        Wed, 25 Mar 2020 16:13:11 +0000 (GMT)
Received: from roberto-HP-EliteDesk-800-G2-DM-65W.huawei.com (10.204.65.160)
 by smtpsuk.huawei.com (10.201.108.43) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Wed, 25 Mar 2020 16:13:02 +0000
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <krzysztof.struczynski@huawei.com>,
        <silviu.vlasceanu@huawei.com>,
        "Roberto Sassu" <roberto.sassu@huawei.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 1/5] ima: Set file->f_mode instead of file->f_flags in ima_calc_file_hash()
Date:   Wed, 25 Mar 2020 17:11:12 +0100
Message-ID: <20200325161116.7082-1-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.204.65.160]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit a408e4a86b36 ("ima: open a new file instance if no read
permissions") tries to create a new file descriptor to calculate a file
digest if the file has not been opened with O_RDONLY flag. However, if a
new file descriptor cannot be obtained, it sets the FMODE_READ flag to
file->f_flags instead of file->f_mode.

This patch fixes this issue by replacing f_flags with f_mode as it was
before that commit.

Cc: stable@vger.kernel.org # 4.20.x
Fixes: a408e4a86b36 ("ima: open a new file instance if no read permissions")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 security/integrity/ima/ima_crypto.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index 423c84f95a14..8ab17aa867dd 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -436,7 +436,7 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
 			 */
 			pr_info_ratelimited("Unable to reopen file for reading.\n");
 			f = file;
-			f->f_flags |= FMODE_READ;
+			f->f_mode |= FMODE_READ;
 			modified_flags = true;
 		} else {
 			new_file_instance = true;
@@ -456,7 +456,7 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
 	if (new_file_instance)
 		fput(f);
 	else if (modified_flags)
-		f->f_flags &= ~FMODE_READ;
+		f->f_mode &= ~FMODE_READ;
 	return rc;
 }
 
-- 
2.17.1

