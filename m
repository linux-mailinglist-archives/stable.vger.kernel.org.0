Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 971A5550B18
	for <lists+stable@lfdr.de>; Sun, 19 Jun 2022 16:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231859AbiFSOLg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jun 2022 10:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiFSOLf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Jun 2022 10:11:35 -0400
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1651B7F0;
        Sun, 19 Jun 2022 07:11:34 -0700 (PDT)
Received: by mail-pj1-f45.google.com with SMTP id x1-20020a17090abc8100b001ec7f8a51f5so4506065pjr.0;
        Sun, 19 Jun 2022 07:11:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qG1X/R0Mxy/riJeZK+qqMQXzwBuz+EMM+/jJlX4ZTUs=;
        b=BKfnkSpfrLhI1nMd90XmlpnKoHIybD5KmJsW8G3Om6vHN45vUgb7tVYC30zuIdojn9
         sqdJ7YSshYZ+7tM49cBhXH5ZcKh8iKGePB/Zrh6t24JnCaLCfziptp8Znu4NTvoxJavD
         F/BEpmEm4cVrpV8Bz0mLfh4PWBtgJWfrd+zRGL1bJPUXaoMCEzp1EPExnb0a12mn7iOD
         XaS3XeyS63/osukI+o1g4myD2NdZ+em12k3lvwnxM29t2iJT5z5CXgjFdPWXJbhusGam
         ypLVQe+uLBkEcAAbTqDzL65vQsLkk8/lPS84jSBKI8UNK+E4t7ocMStaeVsKGg7/B5N7
         6XbA==
X-Gm-Message-State: AJIora+yQvIGc6sfAfR+QhKXPptHv2mffKd8ZbsQ1yvGBpQdHQkM3hWl
        iR7pninlk7kM+uZuHNR0kTcx5lcrxruSDQ==
X-Google-Smtp-Source: AGRyM1swdaRn/1F1a1jX4QwaPecpLN+Fz5BPA4FS08bwtRnY6IxwsOpC1n44Km0KbnAkT8Aur4jOfg==
X-Received: by 2002:a17:90b:4b83:b0:1e3:3ad3:612c with SMTP id lr3-20020a17090b4b8300b001e33ad3612cmr31930832pjb.87.1655647893871;
        Sun, 19 Jun 2022 07:11:33 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id o17-20020a170903301100b0016223016d79sm3473156pla.90.2022.06.19.07.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jun 2022 07:11:33 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, hyc.lee@gmail.com, senozhatsky@chromium.org,
        Namjae Jeon <linkinjeon@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 2/2] ksmbd: check invalid FileOffset and BeyondFinalZero in FSCTL_ZERO_DATA
Date:   Sun, 19 Jun 2022 23:11:20 +0900
Message-Id: <20220619141120.12760-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220619141120.12760-1-linkinjeon@kernel.org>
References: <20220619141120.12760-1-linkinjeon@kernel.org>
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

FileOffset should not be greater than BeyondFinalZero in FSCTL_ZERO_DATA.
And don't call ksmbd_vfs_zero_data() if length is zero.

Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index e35930867893..94ab1dcd80e7 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -7700,7 +7700,7 @@ int smb2_ioctl(struct ksmbd_work *work)
 	{
 		struct file_zero_data_information *zero_data;
 		struct ksmbd_file *fp;
-		loff_t off, len;
+		loff_t off, len, bfz;
 
 		if (!test_tree_conn_flag(work->tcon, KSMBD_TREE_CONN_FLAG_WRITABLE)) {
 			ksmbd_debug(SMB,
@@ -7717,19 +7717,26 @@ int smb2_ioctl(struct ksmbd_work *work)
 		zero_data =
 			(struct file_zero_data_information *)&req->Buffer[0];
 
-		fp = ksmbd_lookup_fd_fast(work, id);
-		if (!fp) {
-			ret = -ENOENT;
+		off = le64_to_cpu(zero_data->FileOffset);
+		bfz = le64_to_cpu(zero_data->BeyondFinalZero);
+		if (off > bfz) {
+			ret = -EINVAL;
 			goto out;
 		}
 
-		off = le64_to_cpu(zero_data->FileOffset);
-		len = le64_to_cpu(zero_data->BeyondFinalZero) - off;
+		len = bfz - off;
+		if (len) {
+			fp = ksmbd_lookup_fd_fast(work, id);
+			if (!fp) {
+				ret = -ENOENT;
+				goto out;
+			}
 
-		ret = ksmbd_vfs_zero_data(work, fp, off, len);
-		ksmbd_fd_put(work, fp);
-		if (ret < 0)
-			goto out;
+			ret = ksmbd_vfs_zero_data(work, fp, off, len);
+			ksmbd_fd_put(work, fp);
+			if (ret < 0)
+				goto out;
+		}
 		break;
 	}
 	case FSCTL_QUERY_ALLOCATED_RANGES:
-- 
2.25.1

