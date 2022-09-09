Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68EAD5B3401
	for <lists+stable@lfdr.de>; Fri,  9 Sep 2022 11:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiIIJ24 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Sep 2022 05:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbiIIJ14 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Sep 2022 05:27:56 -0400
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD295133A0D;
        Fri,  9 Sep 2022 02:26:32 -0700 (PDT)
Received: by mail-pj1-f41.google.com with SMTP id o4so979138pjp.4;
        Fri, 09 Sep 2022 02:26:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=F6S9HUFtFHbXgTDeg7c9KYlUD/YQxZRLcxmv7Ib0sSQ=;
        b=WPMS892kk8G8nSNtjpKm3TpY6T1I4oXQKBhUgbZ3ckQ7CELObjzJntr2OdPXVV4K7t
         5Hi/gZ+25rquPVN+R8PNNy2uy+XzdzKwLhU2xln/VMZqgZ8B8+CKrBkD6hZMXZ44xRI6
         eFuXH4sWTrZU6KuyLgHKU3JR5ZROk7KWQALhFaSJneZ9WetP5Sd1QHPij5knjM7Ly781
         QiQy5egzaxWtlYWt/dy+uyZzkVIhULiW/Aq7T1juG85DjNEEYwdglmxOpdbCVpfhVtaO
         cdX5xbvlA08vRaauWboEa/7Efb4GG0dOesX0xmZPvW/fxuiVpdYj0GIjSWjVheqP137P
         eASw==
X-Gm-Message-State: ACgBeo0tF7DCTAlA6qpgm/cIqu+ftZTxgNjjqbd5ASBgmIzdwtH8pPqC
        1sbulfc+Nqoion4Hze9VvrlcDYE0Zds=
X-Google-Smtp-Source: AA6agR4v7LLUZhMTqePQKqrYHW5Dv/zDwtgu/OYItdSezGGJzhaTeAUD7pSyilHCXBXDFKTgpaJqMw==
X-Received: by 2002:a17:90a:c402:b0:1f2:ca71:93a5 with SMTP id i2-20020a17090ac40200b001f2ca7193a5mr8639862pjt.34.1662715591982;
        Fri, 09 Sep 2022 02:26:31 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id e15-20020a17090a7c4f00b002008d0df002sm861874pjl.50.2022.09.09.02.26.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 02:26:31 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>,
        stable@vger.kernel.org, Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v2] ksmbd: fix incorrect handling of iterate_dir
Date:   Fri,  9 Sep 2022 18:25:57 +0900
Message-Id: <20220909092558.9498-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

if iterate_dir() returns non-negative value, caller has to treat it
as normal and check there is any error while populating dentry
information. ksmbd doesn't have to do anything because ksmbd already
checks too small OutputBufferLength to store one file information.

And because ctx->pos is set to file->f_pos when iterative_dir is called,
remove restart_ctx(). And if iterate_dir() return -EIO, which mean
directory entry is corrupted, return STATUS_FILE_CORRUPT_ERROR error
response.

This patch fixes some failure of SMB2_QUERY_DIRECTORY, which happens when
ntfs3 is local filesystem.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 v2:
   - remove unneeded restart_ctx().
   - If directory entry is corrupted, return STATUS_FILE_CORRUPT_ERROR
     error response.

 fs/ksmbd/smb2pdu.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index ba74aba2f1d3..634e21bba770 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -3809,11 +3809,6 @@ static int __query_dir(struct dir_context *ctx, const char *name, int namlen,
 	return 0;
 }
 
-static void restart_ctx(struct dir_context *ctx)
-{
-	ctx->pos = 0;
-}
-
 static int verify_info_level(int info_level)
 {
 	switch (info_level) {
@@ -3921,7 +3916,6 @@ int smb2_query_dir(struct ksmbd_work *work)
 	if (srch_flag & SMB2_REOPEN || srch_flag & SMB2_RESTART_SCANS) {
 		ksmbd_debug(SMB, "Restart directory scan\n");
 		generic_file_llseek(dir_fp->filp, 0, SEEK_SET);
-		restart_ctx(&dir_fp->readdir_data.ctx);
 	}
 
 	memset(&d_info, 0, sizeof(struct ksmbd_dir_info));
@@ -3968,11 +3962,9 @@ int smb2_query_dir(struct ksmbd_work *work)
 	 */
 	if (!d_info.out_buf_len && !d_info.num_entry)
 		goto no_buf_len;
-	if (rc == 0)
-		restart_ctx(&dir_fp->readdir_data.ctx);
-	if (rc == -ENOSPC)
+	if (rc > 0 || rc == -ENOSPC)
 		rc = 0;
-	if (rc)
+	else if (rc)
 		goto err_out;
 
 	d_info.wptr = d_info.rptr;
@@ -4029,6 +4021,8 @@ int smb2_query_dir(struct ksmbd_work *work)
 		rsp->hdr.Status = STATUS_NO_MEMORY;
 	else if (rc == -EFAULT)
 		rsp->hdr.Status = STATUS_INVALID_INFO_CLASS;
+	else if (rc == -EIO)
+		rsp->hdr.Status = STATUS_FILE_CORRUPT_ERROR;
 	if (!rsp->hdr.Status)
 		rsp->hdr.Status = STATUS_UNEXPECTED_IO_ERROR;
 
-- 
2.25.1

