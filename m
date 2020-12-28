Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400442E3A4E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389282AbgL1NfL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:35:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:35326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389242AbgL1Neu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:34:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12F6120728;
        Mon, 28 Dec 2020 13:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162449;
        bh=n1t75KBzTYYPQMYwPd+M5JaNDaWblMLcGWzgPNEmyag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BrOFGZlBKX4YwfDG9q7j49D+hBAnaHdaXNfKINX48N8KgnW4cbY0x1+3uq6qSODKZ
         u220oL2vbb91DYCMDcU3yG2TyehH7a1wKiBTLv74aLsbFXrb8enio9CWuZ8Tv4u73g
         vZq47EHb1i5PzzmymwUof1TK1F/I8ExfR5cGnYR4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
        Christoph Hellwig <hch@lst.de>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 4.19 307/346] ima: Dont modify file descriptor mode on the fly
Date:   Mon, 28 Dec 2020 13:50:26 +0100
Message-Id: <20201228124934.635786213@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

commit 207cdd565dfc95a0a5185263a567817b7ebf5467 upstream.

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
Fixes: 2fe5d6def1672 ("ima: integrity appraisal extension")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/integrity/ima/ima_crypto.c |   20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -415,7 +415,7 @@ int ima_calc_file_hash(struct file *file
 	loff_t i_size;
 	int rc;
 	struct file *f = file;
-	bool new_file_instance = false, modified_mode = false;
+	bool new_file_instance = false;
 
 	/*
 	 * For consistency, fail file's opened with the O_DIRECT flag on
@@ -433,18 +433,10 @@ int ima_calc_file_hash(struct file *file
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
@@ -459,8 +451,6 @@ int ima_calc_file_hash(struct file *file
 out:
 	if (new_file_instance)
 		fput(f);
-	else if (modified_mode)
-		f->f_mode &= ~FMODE_READ;
 	return rc;
 }
 


