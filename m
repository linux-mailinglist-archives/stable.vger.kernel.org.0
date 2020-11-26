Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC8ED2C5223
	for <lists+stable@lfdr.de>; Thu, 26 Nov 2020 11:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730376AbgKZKfO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Nov 2020 05:35:14 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2158 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729095AbgKZKfO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Nov 2020 05:35:14 -0500
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4ChYww1WYjz67Hmq;
        Thu, 26 Nov 2020 18:32:32 +0800 (CST)
Received: from roberto-HP-EliteDesk-800-G2-DM-65W.huawei.com (10.204.65.161)
 by fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2106.2; Thu, 26 Nov 2020 11:35:10 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <torvalds@linux-foundation.org>,
        <hch@infradead.org>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <silviu.vlasceanu@huawei.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] ima: Don't modify file descriptor mode on the fly
Date:   Thu, 26 Nov 2020 11:34:56 +0100
Message-ID: <20201126103456.15167-1-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.27.GIT
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.65.161]
X-ClientProxiedBy: lhreml705-chm.china.huawei.com (10.201.108.54) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit a408e4a86b36b ("ima: open a new file instance if no read
permissions") already introduced a second open to measure a file when the
original file descriptor does not allow it. However, it didn't remove the
existing method of changing the mode of the original file descriptor, which
is still necessary if the current process does not have enough privileges
to open a new one.

Changing the mode isn't really an option, as the filesystem might need to
do preliminary steps to make the read possible. Thus, this patch removes
the code and keeps the second open as the only option to measure a file
when it is unreadable with the original file descriptor.

Cc: <stable@vger.kernel.org> # 4.20.x: 0014cc04e8ec0 ima: Set file->f_mode
Cc: <stable@vger.kernel.org> # 4.20.x
Fixes: 2fe5d6def1672 ("ima: integrity appraisal extension")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 security/integrity/ima/ima_crypto.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index 21989fa0c107..f6a7e9643b54 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -537,7 +537,7 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
 	loff_t i_size;
 	int rc;
 	struct file *f = file;
-	bool new_file_instance = false, modified_mode = false;
+	bool new_file_instance = false;
 
 	/*
 	 * For consistency, fail file's opened with the O_DIRECT flag on
@@ -555,18 +555,10 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
 				O_TRUNC | O_CREAT | O_NOCTTY | O_EXCL);
 		flags |= O_RDONLY;
 		f = dentry_open(&file->f_path, flags, file->f_cred);
-		if (IS_ERR(f)) {
-			/*
-			 * Cannot open the file again, lets modify f_mode
-			 * of original and continue
-			 */
-			pr_info_ratelimited("Unable to reopen file for reading.\n");
-			f = file;
-			f->f_mode |= FMODE_READ;
-			modified_mode = true;
-		} else {
-			new_file_instance = true;
-		}
+		if (IS_ERR(f))
+			return PTR_ERR(f);
+
+		new_file_instance = true;
 	}
 
 	i_size = i_size_read(file_inode(f));
@@ -581,8 +573,6 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
 out:
 	if (new_file_instance)
 		fput(f);
-	else if (modified_mode)
-		f->f_mode &= ~FMODE_READ;
 	return rc;
 }
 
-- 
2.27.GIT

