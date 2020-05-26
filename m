Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 112411E2B37
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390570AbgEZTDA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:03:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:58084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390512AbgEZTDA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:03:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 169E020849;
        Tue, 26 May 2020 19:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519779;
        bh=kxsdlBfX6zHwJ5lx6O1HQrN+V3050FVdkhRw/4p0zFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NeUhwg4exbmuz2cIIcmCHKkErwM1oa3gMWixKZv05krjByYfJWlNRqUvf0H7DuwQv
         xfoQdf4KsakF6c7/Z4J6zG2EyX4noHLJLbS9KnI7SUhnrcizwGtFrcmsmF4+I1HYSw
         StgST9WQEYgjDd+YP/w1SaosfkIzPESq3NWtcz6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 06/81] ima: Set file->f_mode instead of file->f_flags in ima_calc_file_hash()
Date:   Tue, 26 May 2020 20:52:41 +0200
Message-Id: <20200526183924.827862563@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183923.108515292@linuxfoundation.org>
References: <20200526183923.108515292@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index f63b4bd45d60..6a6d19ada66a 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -415,7 +415,7 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
 	loff_t i_size;
 	int rc;
 	struct file *f = file;
-	bool new_file_instance = false, modified_flags = false;
+	bool new_file_instance = false, modified_mode = false;
 
 	/*
 	 * For consistency, fail file's opened with the O_DIRECT flag on
@@ -435,13 +435,13 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
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
@@ -459,8 +459,8 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
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



