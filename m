Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B9745832C
	for <lists+stable@lfdr.de>; Sun, 21 Nov 2021 12:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238160AbhKULqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Nov 2021 06:46:54 -0500
Received: from mail-pl1-f175.google.com ([209.85.214.175]:45645 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237933AbhKULqy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Nov 2021 06:46:54 -0500
Received: by mail-pl1-f175.google.com with SMTP id b11so11666346pld.12;
        Sun, 21 Nov 2021 03:43:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pJfPYBJyfkcBnBGdY7sChz7Sol37Z/WHAjh3mHtNWsM=;
        b=jxuKFpbJhM7N7O4tFrM40ZxRg4Q8+aNvDHjIXhMiUwv2AgpBAbyK+8Y/kRkSSCu9/1
         JTKuZkf5QKy8eXh2x59G6TsnbEtLhyO8lcGZrCX1dWrg1FCEBh+8KGZ4W9OwVzavGTTU
         6T5vLL55O1H8/LXIdW95YoVhKG+6P7tof57jMUng+7+KoqXlQQfwiJM5HRj5iUvLRK1c
         H3VD+DoOkc2lWiq2iwAgTexb5Qhr6KGUTNGOkQ92fATEPmddGJfzU/JnIVVT35mlqOz8
         7EG1ASfdIgbxc9BWhQT/jA97aBBS9JY+3KxOU6PoraTLBSqbBpws7MYNS/wLFivDO3xi
         DrUg==
X-Gm-Message-State: AOAM530FyEk1+h+/yMYzA1hvPTiip8ntpuzNm4Ajh1KvMK9Wy10MtSOd
        wT4Vrun0LrOHrhMc++ea9kHsMtHU/e4=
X-Google-Smtp-Source: ABdhPJzuL/07kOaznyGgUXoKDxfOiFuscj8ySJkwRM7sTDd25UU1Hya/aMBagjM40rDlROUwg6qusw==
X-Received: by 2002:a17:90b:94:: with SMTP id bb20mr20095116pjb.210.1637495029402;
        Sun, 21 Nov 2021 03:43:49 -0800 (PST)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id s2sm5721266pfg.124.2021.11.21.03.43.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 03:43:49 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 2/2] ksmbd: contain default data stream even if xattr is empty
Date:   Sun, 21 Nov 2021 20:43:33 +0900
Message-Id: <20211121114333.6179-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211121114333.6179-1-linkinjeon@kernel.org>
References: <20211121114333.6179-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If xattr is not supported like exfat or fat, ksmbd server doesn't
contain default data stream in FILE_STREAM_INFORMATION response. It will
cause ppt or doc file update issue if local filesystem is such as ones.
This patch move goto statement to contain it.

Fixes: 9f6323311c70 ("ksmbd: add default data stream name in FILE_STREAM_INFORMATION")
Cc: stable@vger.kernel.org # v5.15
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 82954b2b8d31..2067d5bab1b0 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -4457,6 +4457,12 @@ static void get_file_stream_info(struct ksmbd_work *work,
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
@@ -4465,12 +4471,6 @@ static void get_file_stream_info(struct ksmbd_work *work,
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
@@ -4514,6 +4514,7 @@ static void get_file_stream_info(struct ksmbd_work *work,
 		file_info->NextEntryOffset = cpu_to_le32(next);
 	}
 
+out:
 	if (!S_ISDIR(stat.mode) &&
 	    buf_free_len >= sizeof(struct smb2_file_stream_info) + 7 * 2) {
 		file_info = (struct smb2_file_stream_info *)
@@ -4522,14 +4523,13 @@ static void get_file_stream_info(struct ksmbd_work *work,
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
-- 
2.25.1

