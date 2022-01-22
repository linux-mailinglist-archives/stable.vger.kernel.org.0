Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAD58496942
	for <lists+stable@lfdr.de>; Sat, 22 Jan 2022 02:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231824AbiAVBre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jan 2022 20:47:34 -0500
Received: from mail-pg1-f172.google.com ([209.85.215.172]:33347 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231818AbiAVBrd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jan 2022 20:47:33 -0500
Received: by mail-pg1-f172.google.com with SMTP id 133so9607596pgb.0;
        Fri, 21 Jan 2022 17:47:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FSQsU0fgni5ctiOSZ/TMFGjdHHrdV2q+LsP8z/XpuOA=;
        b=em/Y2xwqxUH0/m3v+AAvY4LpvQ0gseeAVZhzV2PlM7svC9stWul/9IrzwGle2glb38
         yoe8kRoixHGrKaNpL36mY99wUPldhadu1Z7TP1TUWcq8ZAnVo8DZKU+FhgXkVS/SNFuF
         HrdHISFK/1ggbPZskwFiEWuDJBR68rIDTaj9s8QMsSScvvalVU2tv0pOAJ8SAhiXr62R
         3sP0FIfPmTF0TmDCVCf1MvynpsQMoUrJQXJIF8G7iGafLIg9UZ+ac38P5R762uZc3Qyy
         J9DpeG24OmNo1+e8HRJl8+IpZHIrrqdi0d/PUQKupHG4UGQmZDdupwD2wepC/iJyDL1g
         +k8w==
X-Gm-Message-State: AOAM530sLivtfHCcz2GfQi+cWYdsDNdBi8T0NYCCa8SNid1AUgbhUe6g
        sQjJzQQxjCGNIvSjKXL5+wpxS76s7x8=
X-Google-Smtp-Source: ABdhPJyKhxSrVdwd5Fofc/eeMR35IUG6Z5Wyg18+EScKwp6Fcauh1UzfFsR9QWtLm8pEBnhBz/rGmQ==
X-Received: by 2002:a63:d417:: with SMTP id a23mr4653279pgh.297.1642816053114;
        Fri, 21 Jan 2022 17:47:33 -0800 (PST)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id g1sm8242404pfj.84.2022.01.21.17.47.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jan 2022 17:47:32 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, stable@vger.kernel.org,
        Steve French <smfrench@gmail.com>
Subject: [PATCH] ksmbd: fix SMB 3.11 posix extension mount failure
Date:   Sat, 22 Jan 2022 10:47:22 +0900
Message-Id: <20220122014722.8699-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

cifs client set 4 to DataLength of create_posix context, which mean
Mode variable of create_posix context is only available. So buffer
validation of ksmbd should check only the size of Mode except for
the size of Reserved variable.

Fixes: 8f77150c15f8 ("ksmbd: add buffer validation for SMB2_CREATE_CONTEXT")
Cc: stable@vger.kernel.org # v5.15+
Reported-by: Steve French <smfrench@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 1866c81c5c99..3926ca18dca4 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2688,7 +2688,7 @@ int smb2_open(struct ksmbd_work *work)
 					(struct create_posix *)context;
 				if (le16_to_cpu(context->DataOffset) +
 				    le32_to_cpu(context->DataLength) <
-				    sizeof(struct create_posix)) {
+				    sizeof(struct create_posix) - 4) {
 					rc = -EINVAL;
 					goto err_out1;
 				}
-- 
2.25.1

