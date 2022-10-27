Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 415F860FE47
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236898AbiJ0RDy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236902AbiJ0RDr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:03:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB2E197F91
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:03:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D810623F5
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:03:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4A3C433C1;
        Thu, 27 Oct 2022 17:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890225;
        bh=vhd+ti1PHyQTdJ3ugJ3V5BoIBeXZMGEZVmo4QFENfA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eXEO6DEn7+Htm20keQWBc48ZtJgjYa6Lv2a+aIUmL2ekcUQzkYx7uvnBwgvzgObQ0
         Z0zHS7h+EOHU6As0nJUWqs2VAXO4KLBeqFpA6RpWdFAubPOq8pbW2k1rivrD+WZS1Y
         tshiEtVPhTiUQvZvE660C8ZtRJHGhvwyLIW3Kc5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hyunchul Lee <hyc.lee@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 70/79] ksmbd: fix incorrect handling of iterate_dir
Date:   Thu, 27 Oct 2022 18:56:08 +0200
Message-Id: <20221027165057.250429245@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.917467648@linuxfoundation.org>
References: <20221027165054.917467648@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 88541cb414b7a2450c45fc9c131b37b5753b7679 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index ef0aef78eba6..65c85ca71ebe 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -3803,11 +3803,6 @@ static int __query_dir(struct dir_context *ctx, const char *name, int namlen,
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
2.35.1



