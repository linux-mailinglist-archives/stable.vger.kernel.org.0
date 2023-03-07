Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC5E6AEC80
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbjCGR4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:56:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbjCGRzh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:55:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C199A21B5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:50:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E447B8184E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9FFC433D2;
        Tue,  7 Mar 2023 17:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211408;
        bh=1GYjcgIVWb4/6I09OOCF5uGmpMZZ3PplrhlVZbmGtb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MvuGdrN88KYkxWFB+inngYYjF2QRj8fbaOCThfIqiwxA10BVUxRoFZbiDQSuv1zkn
         4ozaSya1vcIm2i90nUXBUT02An16q82wvQa78c3rscjWPYbkaMkNB5CNnlT9I+asjL
         qX8gZ33sGcTznNs4YSG/mC1ZY0zDon/mOyfFK3kE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Roberto Sassu <roberto.sassu@huawei.com>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 6.2 0852/1001] ima: Align ima_file_mmap() parameters with mmap_file LSM hook
Date:   Tue,  7 Mar 2023 18:00:24 +0100
Message-Id: <20230307170058.789092237@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

commit 4971c268b85e1c7a734a61622fc0813c86e2362e upstream.

Commit 98de59bfe4b2f ("take calculation of final prot in
security_mmap_file() into a helper") moved the code to update prot, to be
the actual protections applied to the kernel, to a new helper called
mmap_prot().

However, while without the helper ima_file_mmap() was getting the updated
prot, with the helper ima_file_mmap() gets the original prot, which
contains the protections requested by the application.

A possible consequence of this change is that, if an application calls
mmap() with only PROT_READ, and the kernel applies PROT_EXEC in addition,
that application would have access to executable memory without having this
event recorded in the IMA measurement list. This situation would occur for
example if the application, before mmap(), calls the personality() system
call with READ_IMPLIES_EXEC as the first argument.

Align ima_file_mmap() parameters with those of the mmap_file LSM hook, so
that IMA can receive both the requested prot and the final prot. Since the
requested protections are stored in a new variable, and the final
protections are stored in the existing variable, this effectively restores
the original behavior of the MMAP_CHECK hook.

Cc: stable@vger.kernel.org
Fixes: 98de59bfe4b2 ("take calculation of final prot in security_mmap_file() into a helper")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/ima.h               |    6 ++++--
 security/integrity/ima/ima_main.c |    7 +++++--
 security/security.c               |    7 ++++---
 3 files changed, 13 insertions(+), 7 deletions(-)

--- a/include/linux/ima.h
+++ b/include/linux/ima.h
@@ -21,7 +21,8 @@ extern int ima_file_check(struct file *f
 extern void ima_post_create_tmpfile(struct user_namespace *mnt_userns,
 				    struct inode *inode);
 extern void ima_file_free(struct file *file);
-extern int ima_file_mmap(struct file *file, unsigned long prot);
+extern int ima_file_mmap(struct file *file, unsigned long reqprot,
+			 unsigned long prot, unsigned long flags);
 extern int ima_file_mprotect(struct vm_area_struct *vma, unsigned long prot);
 extern int ima_load_data(enum kernel_load_data_id id, bool contents);
 extern int ima_post_load_data(char *buf, loff_t size,
@@ -76,7 +77,8 @@ static inline void ima_file_free(struct
 	return;
 }
 
-static inline int ima_file_mmap(struct file *file, unsigned long prot)
+static inline int ima_file_mmap(struct file *file, unsigned long reqprot,
+				unsigned long prot, unsigned long flags)
 {
 	return 0;
 }
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -397,7 +397,9 @@ out:
 /**
  * ima_file_mmap - based on policy, collect/store measurement.
  * @file: pointer to the file to be measured (May be NULL)
- * @prot: contains the protection that will be applied by the kernel.
+ * @reqprot: protection requested by the application
+ * @prot: protection that will be applied by the kernel
+ * @flags: operational flags
  *
  * Measure files being mmapped executable based on the ima_must_measure()
  * policy decision.
@@ -405,7 +407,8 @@ out:
  * On success return 0.  On integrity appraisal error, assuming the file
  * is in policy and IMA-appraisal is in enforcing mode, return -EACCES.
  */
-int ima_file_mmap(struct file *file, unsigned long prot)
+int ima_file_mmap(struct file *file, unsigned long reqprot,
+		  unsigned long prot, unsigned long flags)
 {
 	u32 secid;
 
--- a/security/security.c
+++ b/security/security.c
@@ -1661,12 +1661,13 @@ static inline unsigned long mmap_prot(st
 int security_mmap_file(struct file *file, unsigned long prot,
 			unsigned long flags)
 {
+	unsigned long prot_adj = mmap_prot(file, prot);
 	int ret;
-	ret = call_int_hook(mmap_file, 0, file, prot,
-					mmap_prot(file, prot), flags);
+
+	ret = call_int_hook(mmap_file, 0, file, prot, prot_adj, flags);
 	if (ret)
 		return ret;
-	return ima_file_mmap(file, prot);
+	return ima_file_mmap(file, prot, prot_adj, flags);
 }
 
 int security_mmap_addr(unsigned long addr)


