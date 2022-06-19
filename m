Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC2AA550B16
	for <lists+stable@lfdr.de>; Sun, 19 Jun 2022 16:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbiFSOLc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jun 2022 10:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiFSOLa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Jun 2022 10:11:30 -0400
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFEC4B7E9;
        Sun, 19 Jun 2022 07:11:29 -0700 (PDT)
Received: by mail-pj1-f51.google.com with SMTP id 73-20020a17090a0fcf00b001eaee69f600so8024782pjz.1;
        Sun, 19 Jun 2022 07:11:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FX9OqpFe7Pfnfmb+wnGlyvrvJuLGJWbixl9jf/rQVVM=;
        b=gZ88wRysS2SirnaGIh01KSdkNPmDcMiFSL1OaWRj6Kog1WUxwNg8p/A/h+c29/+1O/
         2WAQdRGARxmBXP1FieISekfFbI9eCx5Q38o5p8YmQXCpoUW3Ec7Kf/l9R/65hbgn/C10
         kAXEziistHTk6tzEtoDCRixhh05cB8wQnhdvaZ48GFDzOS/4l92iKIk+6KPTQbcXMHuF
         xIAEHZVznRBTt/y/dsy4KeSzjrKer/RR+1usPYp0FWP7WavIYfYlyedntc6RqQGBkWRe
         ubHDH8sjS/98Q6PKvww82p5n6Id8n5fSFWHkS/SNBmneXyTrROyX8mjEjE11ryohIlVl
         Fi1g==
X-Gm-Message-State: AJIora+roOD+x45SCGWFrIOknQVH8AdIy07DEAduQP6n055GxsH10kvp
        QIgG+ZScfoJNmQqMvo0AFyBwfixpwJlXWw==
X-Google-Smtp-Source: AGRyM1vg8ExynVihVHvkTNCfjkxiSq1+kmn6k80B3CXsRXBPwmH6Z4yNK0ICQxlXrz3u6+2eGdXCTg==
X-Received: by 2002:a17:90a:1c02:b0:1e0:df7:31f2 with SMTP id s2-20020a17090a1c0200b001e00df731f2mr33089602pjs.222.1655647888799;
        Sun, 19 Jun 2022 07:11:28 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id o17-20020a170903301100b0016223016d79sm3473156pla.90.2022.06.19.07.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jun 2022 07:11:27 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, hyc.lee@gmail.com, senozhatsky@chromium.org,
        Namjae Jeon <linkinjeon@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 1/2] ksmbd: set the range of bytes to zero without extending file size in FSCTL_ZERO_DATA
Date:   Sun, 19 Jun 2022 23:11:19 +0900
Message-Id: <20220619141120.12760-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
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

generic/091, 263 test failed since commit f66f8b94e7f2 ("cifs: when
extending a file with falloc we should make files not-sparse").
FSCTL_ZERO_DATA sets the range of bytes to zero without extending file
size. The VFS_FALLOCATE_FL_KEEP_SIZE flag should be used even on
non-sparse files.

Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/vfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/vfs.c b/fs/ksmbd/vfs.c
index dcdd07c6efff..f194bf764f9f 100644
--- a/fs/ksmbd/vfs.c
+++ b/fs/ksmbd/vfs.c
@@ -1015,7 +1015,9 @@ int ksmbd_vfs_zero_data(struct ksmbd_work *work, struct ksmbd_file *fp,
 				     FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
 				     off, len);
 
-	return vfs_fallocate(fp->filp, FALLOC_FL_ZERO_RANGE, off, len);
+	return vfs_fallocate(fp->filp,
+			     FALLOC_FL_ZERO_RANGE | FALLOC_FL_KEEP_SIZE,
+			     off, len);
 }
 
 int ksmbd_vfs_fqar_lseek(struct ksmbd_file *fp, loff_t start, loff_t length,
-- 
2.25.1

