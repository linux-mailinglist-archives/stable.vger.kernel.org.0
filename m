Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E91CB2B16D7
	for <lists+stable@lfdr.de>; Fri, 13 Nov 2020 09:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgKMIBx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Nov 2020 03:01:53 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2098 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbgKMIBx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Nov 2020 03:01:53 -0500
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4CXW975bv4z67L3Y;
        Fri, 13 Nov 2020 16:00:11 +0800 (CST)
Received: from roberto-HP-EliteDesk-800-G2-DM-65W.huawei.com (10.204.65.161)
 by fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Fri, 13 Nov 2020 09:01:50 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <silviu.vlasceanu@huawei.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        <stable@vger.kernel.org>
Subject: [RESEND][PATCH] ima: Set and clear FMODE_CAN_READ in ima_calc_file_hash()
Date:   Fri, 13 Nov 2020 09:01:32 +0100
Message-ID: <20201113080132.16591-1-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.27.GIT
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.65.161]
X-ClientProxiedBy: lhreml741-chm.china.huawei.com (10.201.108.191) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit a1f9b1c0439db ("integrity/ima: switch to using __kernel_read")
replaced the __vfs_read() call in integrity_kernel_read() with
__kernel_read(), a new helper introduced by commit 61a707c543e2a ("fs: add
a __kernel_read helper").

Since the new helper requires that also the FMODE_CAN_READ flag is set in
file->f_mode, this patch saves the original f_mode and sets the flag if the
the file descriptor has the necessary file operation. Lastly, it restores
the original f_mode at the end of ima_calc_file_hash().

Cc: stable@vger.kernel.org # 5.8.x
Fixes: a1f9b1c0439db ("integrity/ima: switch to using __kernel_read")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 security/integrity/ima/ima_crypto.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index 21989fa0c107..22ed86a0c964 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -537,6 +537,7 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
 	loff_t i_size;
 	int rc;
 	struct file *f = file;
+	fmode_t saved_mode;
 	bool new_file_instance = false, modified_mode = false;
 
 	/*
@@ -550,7 +551,7 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
 	}
 
 	/* Open a new file instance in O_RDONLY if we cannot read */
-	if (!(file->f_mode & FMODE_READ)) {
+	if (!(file->f_mode & FMODE_READ) || !(file->f_mode & FMODE_CAN_READ)) {
 		int flags = file->f_flags & ~(O_WRONLY | O_APPEND |
 				O_TRUNC | O_CREAT | O_NOCTTY | O_EXCL);
 		flags |= O_RDONLY;
@@ -562,7 +563,10 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
 			 */
 			pr_info_ratelimited("Unable to reopen file for reading.\n");
 			f = file;
+			saved_mode = f->f_mode;
 			f->f_mode |= FMODE_READ;
+			if (likely(file->f_op->read || file->f_op->read_iter))
+				f->f_mode |= FMODE_CAN_READ;
 			modified_mode = true;
 		} else {
 			new_file_instance = true;
@@ -582,7 +586,7 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
 	if (new_file_instance)
 		fput(f);
 	else if (modified_mode)
-		f->f_mode &= ~FMODE_READ;
+		f->f_mode = saved_mode;
 	return rc;
 }
 
-- 
2.27.GIT

