Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FED61F1B7
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbfEOLRb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:17:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730669AbfEOLRb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:17:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DC3E20644;
        Wed, 15 May 2019 11:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919050;
        bh=dAx1Ud770CfA15dP1fOgAyDLUuDk5IXqgHlLykRZ8sU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JgjEl1aFbS/s+kiaJVZSWKBI+jWrVVlTi+1sPwQlh7Syg4ykQiOUahoKhR+nw2h+T
         Di1ZKfZZCsWpUGxftji7hPdyotH9udTSXoXlp7oGLjMWlACXTDyxj2Tl18lpmEXFld
         BhmNuXh6AuZNs9xD3XMySch1aDuKQZDAXwbass4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 4.14 046/115] ima: open a new file instance if no read permissions
Date:   Wed, 15 May 2019 12:55:26 +0200
Message-Id: <20190515090702.901419593@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
References: <20190515090659.123121100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a408e4a86b36bf98ad15b9ada531cf0e5118ac67 ]

Open a new file instance as opposed to changing file->f_mode when
the file is not readable.  This is done to accomodate overlayfs
stacked file operations change.  The real struct file is hidden
behind the overlays struct file.  So, any file->f_mode manipulations are
not reflected on the real struct file.  Open the file again in read mode
if original file cannot be read, read and calculate the hash.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: stable@vger.kernel.org (linux-4.19)
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 security/integrity/ima/ima_crypto.c | 54 ++++++++++++++++++-----------
 1 file changed, 34 insertions(+), 20 deletions(-)

diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index cb041af9eddb2..af680b5b678a4 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -232,7 +232,7 @@ static int ima_calc_file_hash_atfm(struct file *file,
 {
 	loff_t i_size, offset;
 	char *rbuf[2] = { NULL, };
-	int rc, read = 0, rbuf_len, active = 0, ahash_rc = 0;
+	int rc, rbuf_len, active = 0, ahash_rc = 0;
 	struct ahash_request *req;
 	struct scatterlist sg[1];
 	struct ahash_completion res;
@@ -279,11 +279,6 @@ static int ima_calc_file_hash_atfm(struct file *file,
 					  &rbuf_size[1], 0);
 	}
 
-	if (!(file->f_mode & FMODE_READ)) {
-		file->f_mode |= FMODE_READ;
-		read = 1;
-	}
-
 	for (offset = 0; offset < i_size; offset += rbuf_len) {
 		if (!rbuf[1] && offset) {
 			/* Not using two buffers, and it is not the first
@@ -322,8 +317,6 @@ static int ima_calc_file_hash_atfm(struct file *file,
 	/* wait for the last update request to complete */
 	rc = ahash_wait(ahash_rc, &res);
 out3:
-	if (read)
-		file->f_mode &= ~FMODE_READ;
 	ima_free_pages(rbuf[0], rbuf_size[0]);
 	ima_free_pages(rbuf[1], rbuf_size[1]);
 out2:
@@ -358,7 +351,7 @@ static int ima_calc_file_hash_tfm(struct file *file,
 {
 	loff_t i_size, offset = 0;
 	char *rbuf;
-	int rc, read = 0;
+	int rc;
 	SHASH_DESC_ON_STACK(shash, tfm);
 
 	shash->tfm = tfm;
@@ -379,11 +372,6 @@ static int ima_calc_file_hash_tfm(struct file *file,
 	if (!rbuf)
 		return -ENOMEM;
 
-	if (!(file->f_mode & FMODE_READ)) {
-		file->f_mode |= FMODE_READ;
-		read = 1;
-	}
-
 	while (offset < i_size) {
 		int rbuf_len;
 
@@ -400,8 +388,6 @@ static int ima_calc_file_hash_tfm(struct file *file,
 		if (rc)
 			break;
 	}
-	if (read)
-		file->f_mode &= ~FMODE_READ;
 	kfree(rbuf);
 out:
 	if (!rc)
@@ -442,6 +428,8 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
 {
 	loff_t i_size;
 	int rc;
+	struct file *f = file;
+	bool new_file_instance = false, modified_flags = false;
 
 	/*
 	 * For consistency, fail file's opened with the O_DIRECT flag on
@@ -453,15 +441,41 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
 		return -EINVAL;
 	}
 
-	i_size = i_size_read(file_inode(file));
+	/* Open a new file instance in O_RDONLY if we cannot read */
+	if (!(file->f_mode & FMODE_READ)) {
+		int flags = file->f_flags & ~(O_WRONLY | O_APPEND |
+				O_TRUNC | O_CREAT | O_NOCTTY | O_EXCL);
+		flags |= O_RDONLY;
+		f = dentry_open(&file->f_path, flags, file->f_cred);
+		if (IS_ERR(f)) {
+			/*
+			 * Cannot open the file again, lets modify f_flags
+			 * of original and continue
+			 */
+			pr_info_ratelimited("Unable to reopen file for reading.\n");
+			f = file;
+			f->f_flags |= FMODE_READ;
+			modified_flags = true;
+		} else {
+			new_file_instance = true;
+		}
+	}
+
+	i_size = i_size_read(file_inode(f));
 
 	if (ima_ahash_minsize && i_size >= ima_ahash_minsize) {
-		rc = ima_calc_file_ahash(file, hash);
+		rc = ima_calc_file_ahash(f, hash);
 		if (!rc)
-			return 0;
+			goto out;
 	}
 
-	return ima_calc_file_shash(file, hash);
+	rc = ima_calc_file_shash(f, hash);
+out:
+	if (new_file_instance)
+		fput(f);
+	else if (modified_flags)
+		f->f_flags &= ~FMODE_READ;
+	return rc;
 }
 
 /*
-- 
2.20.1



