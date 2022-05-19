Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 461F752D365
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 15:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237116AbiESNB0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 09:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235615AbiESNBY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 09:01:24 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F4D256237;
        Thu, 19 May 2022 06:01:23 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id s14so4720798plk.8;
        Thu, 19 May 2022 06:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IgNNbJbyl7kjGrNNEc1hjGAmCRnpuU/cns8tSfV5AmE=;
        b=q4K6v32ZzYdQSl7xKiTVyzqdXQQJG0ORn1Kb0I114XxNQtFP6Bn00nJ+j8XjTWvUWS
         4XZzgpSHy0skVQXVQjhak0E3ibPixyFVXiZJFAJVHAey46a6jA5eVNH2nEc65gjDCGzj
         gEaXq2ItDyNo9MpVvfRzQhxXvmn5eos4cZVXPMuTjUExhmMdv3QqA//cnbzP6+TZq8bT
         CIEJnp6IpK7ONbu9hskspFsfgVChHhY6xdU5FhSxegD18zzDE73QsDZu0ZEgKNxGoani
         C+tujREFtGAK99tBlDDRZ5POpj78mhi7Z3hYgrewRc5sETmF2BCA/EcjZ5RSImPugomY
         ka/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IgNNbJbyl7kjGrNNEc1hjGAmCRnpuU/cns8tSfV5AmE=;
        b=lzhtcMlwa4jUW7SqRvnQHrvh1iJQKT5XrEEoWglIc1fW1vPqAn9ppd8qkoX5q9iM3h
         ciBo5pmaWG+hsZPXF3byfunuLlSim2u86/xLENrctSOWLVUTWqD/r+XOhPrXP3XiZPHU
         StJENedMaGrbMSV2/cCd2kBEWJWpdBh9AqxO2twYt13s7afAE14Jth00ABrFCc1g+Lbi
         DAPJVdqq10L1AFCWK53DKInPtqZWLm9Ew2TXk94ximbEMobNhfRAwfcncUBkTZ2Swg92
         YEh3EICb7yO2DrvOOFJP40ZYX4T70Tq8V2hi+lR+KA8hLIRKwTNxCCrIt9xPl8Slv0a1
         ZY1A==
X-Gm-Message-State: AOAM533NHdbwW3tJ75sV7RTIKMoGbpzyhRUhH3DCjUFG+maAzsSt6dUK
        7Uk74Gr7z78JbIi38RqcsAEpE+pc2AJ2nQ==
X-Google-Smtp-Source: ABdhPJyiF5P0qHrAMxFp6dQVXM//mOxu/hQBS7DEEbOeFMPkpcY15f//7kQxr2+LuIdiyc2Rq1LWAA==
X-Received: by 2002:a17:902:b70c:b0:156:16f0:cbfe with SMTP id d12-20020a170902b70c00b0015616f0cbfemr4674453pls.152.1652965282269;
        Thu, 19 May 2022 06:01:22 -0700 (PDT)
Received: from localhost.localdomain ([125.177.232.58])
        by smtp.googlemail.com with ESMTPSA id j1-20020a17090a060100b001df264610c4sm6475957pjj.0.2022.05.19.06.01.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 06:01:20 -0700 (PDT)
From:   Hyunchul Lee <hyc.lee@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>, stable@vger.kernel.org,
        Yufan Chen <wiz.chen@gmail.com>
Subject: [PATCH v2] ksmbd: fix outstanding credits related bugs
Date:   Thu, 19 May 2022 22:00:55 +0900
Message-Id: <20220519130055.305767-1-hyc.lee@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

outstanding credits must be initialized to 0,
because it means the sum of credits consumed by
in-flight requests.
And outstanding credits must be compared with
total credits in smb2_validate_credit_charge(),
because total credits are the sum of credits
granted by ksmbd.

This patch fix the following error,
while frametest with Windows clients:

Limits exceeding the maximum allowable outstanding requests,
given : 128, pending : 8065

Fixes: b589f5db6d4a ("ksmbd: limits exceeding the maximum allowable outstanding requests")
Cc: stable@vger.kernel.org
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Reported-by: Yufan Chen <wiz.chen@gmail.com>
Tested-by: Yufan Chen <wiz.chen@gmail.com>
---
changes from v1:
 - Add "Fixes" and stable tags

 fs/ksmbd/connection.c | 2 +-
 fs/ksmbd/smb2misc.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
index 7db87771884a..e8f476c5f189 100644
--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -62,7 +62,7 @@ struct ksmbd_conn *ksmbd_conn_alloc(void)
 	atomic_set(&conn->req_running, 0);
 	atomic_set(&conn->r_count, 0);
 	conn->total_credits = 1;
-	conn->outstanding_credits = 1;
+	conn->outstanding_credits = 0;
 
 	init_waitqueue_head(&conn->req_running_q);
 	INIT_LIST_HEAD(&conn->conns_list);
diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
index 4a9460153b59..f8f456377a51 100644
--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -338,7 +338,7 @@ static int smb2_validate_credit_charge(struct ksmbd_conn *conn,
 		ret = 1;
 	}
 
-	if ((u64)conn->outstanding_credits + credit_charge > conn->vals->max_credits) {
+	if ((u64)conn->outstanding_credits + credit_charge > conn->total_credits) {
 		ksmbd_debug(SMB, "Limits exceeding the maximum allowable outstanding requests, given : %u, pending : %u\n",
 			    credit_charge, conn->outstanding_credits);
 		ret = 1;
-- 
2.25.1

