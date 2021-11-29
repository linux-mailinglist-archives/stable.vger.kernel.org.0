Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93FCB461ED5
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379483AbhK2Sk4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:40:56 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:54654 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379454AbhK2Siy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:38:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EA568CE13D0;
        Mon, 29 Nov 2021 18:35:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98837C53FAD;
        Mon, 29 Nov 2021 18:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210933;
        bh=IJ2dXdwhT25l1CIeqH3ncy6xMkbSsRJusfJIZXgqJTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BgtgeorI5eJmZdbeJeau27pgxeBXUhmITj0kfuHDD5qW/sj3XLcCRd8ovaiaAi6P6
         E9WRYhXHdQC5hTA4Mo5jiPZ5BwjiMy6HCysKo+qEixPNuDRzgdNTKioI9R8Xvv6TnG
         u2nGiRFZOmkqq8GZxEHVbHttR3bQ5zZzEefXy72Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hyunchul Lee <hyc.lee@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 045/179] ksmbd: contain default data stream even if xattr is empty
Date:   Mon, 29 Nov 2021 19:17:19 +0100
Message-Id: <20211129181720.448146300@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namjae Jeon <linkinjeon@kernel.org>

commit 1ec72153ff434ce75bace3044dc89a23a05d7064 upstream.

If xattr is not supported like exfat or fat, ksmbd server doesn't
contain default data stream in FILE_STREAM_INFORMATION response. It will
cause ppt or doc file update issue if local filesystem is such as ones.
This patch move goto statement to contain it.

Fixes: 9f6323311c70 ("ksmbd: add default data stream name in FILE_STREAM_INFORMATION")
Cc: stable@vger.kernel.org # v5.15
Acked-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -4450,6 +4450,12 @@ static void get_file_stream_info(struct
 			 &stat);
 	file_info = (struct smb2_file_stream_info *)rsp->Buffer;
 
+	buf_free_len =
+		smb2_calc_max_out_buf_len(work, 8,
+					  le32_to_cpu(req->OutputBufferLength));
+	if (buf_free_len < 0)
+		goto out;
+
 	xattr_list_len = ksmbd_vfs_listxattr(path->dentry, &xattr_list);
 	if (xattr_list_len < 0) {
 		goto out;
@@ -4458,12 +4464,6 @@ static void get_file_stream_info(struct
 		goto out;
 	}
 
-	buf_free_len =
-		smb2_calc_max_out_buf_len(work, 8,
-					  le32_to_cpu(req->OutputBufferLength));
-	if (buf_free_len < 0)
-		goto out;
-
 	while (idx < xattr_list_len) {
 		stream_name = xattr_list + idx;
 		streamlen = strlen(stream_name);
@@ -4507,6 +4507,7 @@ static void get_file_stream_info(struct
 		file_info->NextEntryOffset = cpu_to_le32(next);
 	}
 
+out:
 	if (!S_ISDIR(stat.mode) &&
 	    buf_free_len >= sizeof(struct smb2_file_stream_info) + 7 * 2) {
 		file_info = (struct smb2_file_stream_info *)
@@ -4515,14 +4516,13 @@ static void get_file_stream_info(struct
 					      "::$DATA", 7, conn->local_nls, 0);
 		streamlen *= 2;
 		file_info->StreamNameLength = cpu_to_le32(streamlen);
-		file_info->StreamSize = 0;
-		file_info->StreamAllocationSize = 0;
+		file_info->StreamSize = cpu_to_le64(stat.size);
+		file_info->StreamAllocationSize = cpu_to_le64(stat.blocks << 9);
 		nbytes += sizeof(struct smb2_file_stream_info) + streamlen;
 	}
 
 	/* last entry offset should be 0 */
 	file_info->NextEntryOffset = 0;
-out:
 	kvfree(xattr_list);
 
 	rsp->OutputBufferLength = cpu_to_le32(nbytes);


