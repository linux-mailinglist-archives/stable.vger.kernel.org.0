Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 486F1584053
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 15:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiG1NuD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 09:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiG1NuC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 09:50:02 -0400
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86AE762A46;
        Thu, 28 Jul 2022 06:50:01 -0700 (PDT)
Received: by mail-pl1-f181.google.com with SMTP id iw1so1855991plb.6;
        Thu, 28 Jul 2022 06:50:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fJlProHpWW9lA3WyeUazKlvpeQSoWqdtf8mgGAQ1wPw=;
        b=wWPvvE3yI/Pof8ahiH9nqN8JO24ANfKJjPD8mQDckMwahfgdDL1OSkGUtbmZXuxYx6
         0tBNn6NU12oxxu/HKx0DuQuExSXJMTiKd/FZstzjr6mRzpB9NfHxV5lLKSebRXMRBKvT
         dFOgPYcbgoYbX5RAoF0QkpCiG8BrYRIZ84Nl8tb0wZZJykTxT74PONPdMdsscFr9CiVs
         yPiKQasQyMdBFbX6PCBIuVuRBFX7uCb8P1VM+RqloEZjnIzQt7e2wwaihCOjPnijiqyV
         XZnq+gNGI9rHdN0laohqyFPdSJrIEJZBK+h1zYUBzQTIebWc2dM5mR6Qy+6XMhLFBC2b
         XcZA==
X-Gm-Message-State: AJIora/mkEIVbPF/SBVM2yn4aeyeqfemqGWu44TJkMRLuKvvALU6aJv8
        xUeSrJ7862NQnnuWXlb1mpa70VYkhMs=
X-Google-Smtp-Source: AGRyM1v6aYSYrvI41+mRmrHxLskgNMXm7Cidh4rif86mbxC+aINcd9A2013vF9kyrreNjgHmd9XXJw==
X-Received: by 2002:a17:90b:78d:b0:1ef:c46f:19a7 with SMTP id l13-20020a17090b078d00b001efc46f19a7mr10341009pjz.216.1659016200777;
        Thu, 28 Jul 2022 06:50:00 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id q8-20020a170902eb8800b0016cf985c0fcsm491712plg.124.2022.07.28.06.49.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 06:50:00 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, hyc.lee@gmail.com, senozhatsky@chromium.org,
        gregkh@linuxfoundation.org, Namjae Jeon <linkinjeon@kernel.org>,
        stable@vger.kernel.org, zdi-disclosures@trendmicro.com
Subject: [PATCH v2 1/5] ksmbd: fix memory leak in smb2_handle_negotiate
Date:   Thu, 28 Jul 2022 22:49:42 +0900
Message-Id: <20220728134946.7603-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The allocated memory didn't free under an error
path in smb2_handle_negotiate().

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-17815
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
---
 v2:
   - add missing fixes and stable tags.

 fs/ksmbd/smb2pdu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 1f4f2d5217a6..41ef076af072 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1142,12 +1142,16 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
 			       status);
 			rsp->hdr.Status = status;
 			rc = -EINVAL;
+			kfree(conn->preauth_info);
+			conn->preauth_info = NULL;
 			goto err_out;
 		}
 
 		rc = init_smb3_11_server(conn);
 		if (rc < 0) {
 			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+			kfree(conn->preauth_info);
+			conn->preauth_info = NULL;
 			goto err_out;
 		}
 
-- 
2.25.1

