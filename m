Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8723A5FFF13
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 14:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiJPMWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 08:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiJPMWc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 08:22:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C1C32D8C
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 05:22:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DC7260A4B
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 12:22:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6062AC433D6;
        Sun, 16 Oct 2022 12:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665922950;
        bh=U/qNEWeHFtnvh+iRGxcYK1yYJDbzeUesrf8JHzibtrQ=;
        h=Subject:To:Cc:From:Date:From;
        b=ifsnv26vpGQV3+QhsTU9g5wzir92ME0bsaZ8AsI4jZ1gAmIeshRrHRLH/wOZHhWHa
         /tfRcaGrbLRThzyV3ERnxyB3aiGvR6G1A0j9muA3Fu7H6f1K+5I7zHVHiBeKaeHxMf
         ok8FhzTuJFdzwYPnQ/PKondpFM2C0OsIKJyTr9Nk=
Subject: FAILED: patch "[PATCH] ksmbd: fix incorrect handling of iterate_dir" failed to apply to 5.15-stable tree
To:     linkinjeon@kernel.org, hyc.lee@gmail.com, stfrench@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 14:23:11 +0200
Message-ID: <166592299197218@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

88541cb414b7 ("ksmbd: fix incorrect handling of iterate_dir")
65ca7a3ffff8 ("ksmbd: handle smb2 query dir request for OutputBufferLength that is too small")
04e260948a16 ("ksmbd: don't align last entry offset in smb2 query directory")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 88541cb414b7a2450c45fc9c131b37b5753b7679 Mon Sep 17 00:00:00 2001
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 9 Sep 2022 17:43:53 +0900
Subject: [PATCH] ksmbd: fix incorrect handling of iterate_dir

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
Signed-off-by: Steve French <stfrench@microsoft.com>

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
 

