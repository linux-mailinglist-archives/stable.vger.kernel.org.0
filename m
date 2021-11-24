Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A93E645B140
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 02:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237319AbhKXBss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 20:48:48 -0500
Received: from mail-pg1-f174.google.com ([209.85.215.174]:37482 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236317AbhKXBss (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Nov 2021 20:48:48 -0500
Received: by mail-pg1-f174.google.com with SMTP id 71so668447pgb.4;
        Tue, 23 Nov 2021 17:45:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ohTgjHlzbGc0VJOUJWLdSdqVRKqE+ASflNlxV1obW+g=;
        b=wyanNoXq3+QZ0VxZK8zvizJ7j/i/PHAPdzFat/K9QcOaQqJJe3IJOT4mwltomxHK2J
         FBb+q8Ui7GiiuZmBJvjcbERPPdgR0c6Lj2/TgjFOWuh1IUy5Um4k6VZlJgTktYhGqQgG
         Js1CNg9ZHtHHoocnZF/PcUmwC84ve08XwjBI+xsehxuxup80K1wwM1kRVaMrtkQPsPzy
         AwqTLgYvpBGlu7YCPFkGekHIcg1T21ioW0P4Fg/6dytAAMgv2V3kBC+sYJ/83sILsP4f
         4wSF1ZawVpEe3UXD/OyJbv74B5UoTQ7I/n9AtraAoVNDx0MBb5oTSyoxJv0MVeKXxp/i
         9qGw==
X-Gm-Message-State: AOAM530W1EtWJ5Xrz2rr8b3TJh/aPYpN3ibXev1T9xnnPbOuFPzH1y4s
        Yqb+9qbMnB3RNCPquaJqPAGTTpQaXYQ=
X-Google-Smtp-Source: ABdhPJznKzDL1pqEw661Gr/VfpJnu5toV9LVduER40jpyI5bSOMKtxquNc7JW6sABFeceNhNWgBJzw==
X-Received: by 2002:a63:f702:: with SMTP id x2mr7151804pgh.162.1637718338755;
        Tue, 23 Nov 2021 17:45:38 -0800 (PST)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id nv12sm2687733pjb.49.2021.11.23.17.45.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 17:45:38 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, stable@vger.kernel.org,
        Coverity Scan <scan-admin@coverity.com>
Subject: [PATCH] ksmbd: fix memleak in get_file_stream_info()
Date:   Wed, 24 Nov 2021 10:45:11 +0900
Message-Id: <20211124014511.12510-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix memleak in get_file_stream_info()

Fixes: 34061d6b76a4 ("ksmbd: validate OutputBufferLength of QUERY_DIR, QUERY_INFO, IOCTL requests")
Cc: stable@vger.kernel.org # v5.15
Reported-by: Coverity Scan <scan-admin@coverity.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 2067d5bab1b0..c70972b49da8 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -4496,8 +4496,10 @@ static void get_file_stream_info(struct ksmbd_work *work,
 				     ":%s", &stream_name[XATTR_NAME_STREAM_LEN]);
 
 		next = sizeof(struct smb2_file_stream_info) + streamlen * 2;
-		if (next > buf_free_len)
+		if (next > buf_free_len) {
+			kfree(stream_buf);
 			break;
+		}
 
 		file_info = (struct smb2_file_stream_info *)&rsp->Buffer[nbytes];
 		streamlen  = smbConvertToUTF16((__le16 *)file_info->StreamName,
-- 
2.25.1

