Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F06B1F2DD2
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729632AbgFHXNw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:13:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:33780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729615AbgFHXNv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:13:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5673821527;
        Mon,  8 Jun 2020 23:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658031;
        bh=PEqJ5eyUtSxJhYnhnCrIAr5eo6UL8Kd/34b2Bw2Fusg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TOPdiM5vRSJossSVMACGCX9VTNDMH+7/XUPzb539+Ba+IVj2bGzQnwtiC9cTU8xWS
         gUC5AJ2Ho4smMKaw5XFoYcID9OzSups7AdBLKv+9nNbH/QHmLwB/xEyH1mS1RYE7Xm
         Qg0s6Y5MU1kXS06qF0/4WrGRjJCxwkMQ21kBWPFc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roberto Sassu <roberto.sassu@huawei.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 082/606] ima: Set file->f_mode instead of file->f_flags in ima_calc_file_hash()
Date:   Mon,  8 Jun 2020 19:03:27 -0400
Message-Id: <20200608231211.3363633-82-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

[ Upstream commit 0014cc04e8ec077dc482f00c87dfd949cfe2b98f ]

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
Reviewed-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_crypto.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index 7967a6904851..e8fa23cd4a6c 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -413,7 +413,7 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
 	loff_t i_size;
 	int rc;
 	struct file *f = file;
-	bool new_file_instance = false, modified_flags = false;
+	bool new_file_instance = false, modified_mode = false;
 
 	/*
 	 * For consistency, fail file's opened with the O_DIRECT flag on
@@ -433,13 +433,13 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
 		f = dentry_open(&file->f_path, flags, file->f_cred);
 		if (IS_ERR(f)) {
 			/*
-			 * Cannot open the file again, lets modify f_flags
+			 * Cannot open the file again, lets modify f_mode
 			 * of original and continue
 			 */
 			pr_info_ratelimited("Unable to reopen file for reading.\n");
 			f = file;
-			f->f_flags |= FMODE_READ;
-			modified_flags = true;
+			f->f_mode |= FMODE_READ;
+			modified_mode = true;
 		} else {
 			new_file_instance = true;
 		}
@@ -457,8 +457,8 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
 out:
 	if (new_file_instance)
 		fput(f);
-	else if (modified_flags)
-		f->f_flags &= ~FMODE_READ;
+	else if (modified_mode)
+		f->f_mode &= ~FMODE_READ;
 	return rc;
 }
 
-- 
2.25.1

