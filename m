Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA0D0458329
	for <lists+stable@lfdr.de>; Sun, 21 Nov 2021 12:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238155AbhKULqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Nov 2021 06:46:52 -0500
Received: from mail-pj1-f50.google.com ([209.85.216.50]:42526 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237933AbhKULqw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Nov 2021 06:46:52 -0500
Received: by mail-pj1-f50.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so12810042pjb.1;
        Sun, 21 Nov 2021 03:43:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=taxGodIhuujH/c6RvcYAqEzJc13SpNVwiy9tNwv8Btk=;
        b=fi2EzAwWAkJd+UFPvF8PqFmZ9Aqk9a4Iw7bRZSyPzd4kb6DDbbeWR48cydgGTiOC2d
         1eYj3HCICwERMMe/I8UkRGTevDuNYlCIsbyEysLFyku78GRlNglf2yFEab+TGfEr4/Xv
         dhh9TNJehfhrKirdWflIVFwzmgBL1a1wVRDof2jigMxYT8Sm5GBbou1VH0aCc+EwSeG7
         pshbJGr+sL73hyX1MbEomQMjWLVtuN7i4+sI4uEJeap94gSvLR+OcurtpXx5qW07gToV
         nGhUTeKcZJVeqeIDcGngOozom2frWni5sspCL4iQrB7e5Pzkv0Pamj3xBBewrXqg4rRP
         qs/Q==
X-Gm-Message-State: AOAM533YdIL1mfCj8nqPOxQfz5/iSYCHpxm8qDqYxM5JzvqzqxOv+2ma
        5nBMjMlCLstfn7a3v373jHOkyBwTbWQ=
X-Google-Smtp-Source: ABdhPJzBnkqKi/jL5clH1wct5fxidSBlS77Tpxxj2SAFo09KoI8F9X5rTYB7TFYAn7Ds0mJ0end8Fg==
X-Received: by 2002:a17:90a:2fc7:: with SMTP id n7mr20161963pjm.141.1637495027033;
        Sun, 21 Nov 2021 03:43:47 -0800 (PST)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id s2sm5721266pfg.124.2021.11.21.03.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 03:43:46 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 1/2] ksmbd: downgrade addition info error msg to debug in smb2_get_info_sec()
Date:   Sun, 21 Nov 2021 20:43:32 +0900
Message-Id: <20211121114333.6179-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While file transfer through windows client, This error flood message
happen. This flood message will cause performance degradation and
misunderstand server has problem.

Fixes: e294f78d3478 ("ksmbd: allow PROTECTED_DACL_SECINFO and UNPROTECTED_DACL_SECINFO addition information in smb2 set info security")
Cc: stable@vger.kernel.org # v5.15
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 121f8e8c70ac..82954b2b8d31 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -5068,7 +5068,7 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
 	if (addition_info & ~(OWNER_SECINFO | GROUP_SECINFO | DACL_SECINFO |
 			      PROTECTED_DACL_SECINFO |
 			      UNPROTECTED_DACL_SECINFO)) {
-		pr_err("Unsupported addition info: 0x%x)\n",
+		ksmbd_debug(SMB, "Unsupported addition info: 0x%x)\n",
 		       addition_info);
 
 		pntsd->revision = cpu_to_le16(1);
-- 
2.25.1

