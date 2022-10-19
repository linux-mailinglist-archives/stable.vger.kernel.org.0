Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 992F96044EC
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 14:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbiJSMTM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 08:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232902AbiJSMST (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 08:18:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E00AFFF223;
        Wed, 19 Oct 2022 04:53:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF687B822CE;
        Wed, 19 Oct 2022 08:44:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5408FC433D6;
        Wed, 19 Oct 2022 08:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169075;
        bh=rCyFVxv5D3nRejcezEL/j3R7yTl+gDdfILEu0MAjraw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1w0wdQP1vfGdVGhprDeEd14L0lB5Cv//SNYkZWTX6uyA6sOLQ8TEm5EonU2N36Qmf
         J6jMFObN+6Liy/L+GzN3POwGMGlvqi1BGhi/2RrbswEOpTdPtUq3U8X1x5W6GmK2uN
         6a9ttUgsd7wyElex7kHOngXqTZFy5JnPvjpD1cxo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hyunchul Lee <hyc.lee@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.0 113/862] ksmbd: fix incorrect handling of iterate_dir
Date:   Wed, 19 Oct 2022 10:23:20 +0200
Message-Id: <20221019083254.912900126@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namjae Jeon <linkinjeon@kernel.org>

commit 88541cb414b7a2450c45fc9c131b37b5753b7679 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -3808,11 +3808,6 @@ static int __query_dir(struct dir_contex
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
@@ -3921,7 +3916,6 @@ int smb2_query_dir(struct ksmbd_work *wo
 	if (srch_flag & SMB2_REOPEN || srch_flag & SMB2_RESTART_SCANS) {
 		ksmbd_debug(SMB, "Restart directory scan\n");
 		generic_file_llseek(dir_fp->filp, 0, SEEK_SET);
-		restart_ctx(&dir_fp->readdir_data.ctx);
 	}
 
 	memset(&d_info, 0, sizeof(struct ksmbd_dir_info));
@@ -3968,11 +3962,9 @@ int smb2_query_dir(struct ksmbd_work *wo
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
@@ -4029,6 +4021,8 @@ err_out2:
 		rsp->hdr.Status = STATUS_NO_MEMORY;
 	else if (rc == -EFAULT)
 		rsp->hdr.Status = STATUS_INVALID_INFO_CLASS;
+	else if (rc == -EIO)
+		rsp->hdr.Status = STATUS_FILE_CORRUPT_ERROR;
 	if (!rsp->hdr.Status)
 		rsp->hdr.Status = STATUS_UNEXPECTED_IO_ERROR;
 


