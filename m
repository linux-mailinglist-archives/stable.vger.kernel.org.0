Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE6653CECA
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344414AbiFCRrK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345237AbiFCRqh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:46:37 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C79453E1B;
        Fri,  3 Jun 2022 10:43:39 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id q123so7735591pgq.6;
        Fri, 03 Jun 2022 10:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8+0I0SHfG0zz73fJ2FA496i9DVz96wphBCcvxAp0CpA=;
        b=jrSpzUpvJysLpcT9KHdN7iayPW+qGXtismb/MpiHJ4iwHbhvt8rqzRYT6SbrTWeqc/
         YwnYqal4iKzgyLCRZ2eq16OSCGI9KR2FOYp2/mL49VYyw2kG2ESxtUDZQ1GTJCa+2zxZ
         Eyt9DyriY4MDVfJ/XCe/1Qcgli+v5ZJmPjiqjn/0hCg9+NljxcnqQwKB17bJ+pR6JZZi
         oIZME0vToFc843ET4DfemOaCs/B++i3HMR8jlJWAEYiCg106Acu5yCtbhPHQmMoO1GD9
         IUs6wg3Qk6Ek7E/4choP/99ZpjsSyORfugIfIogwVkW29+pJ1y/RKFkc8G6mPsIIgQY/
         Mk+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8+0I0SHfG0zz73fJ2FA496i9DVz96wphBCcvxAp0CpA=;
        b=m80nKyzaumRkqaNZ7FglihvgLKXtc5SBBz1b75v7rjkDZ4lHNYpOCW6t+aPcjk0eBO
         xrn6px4/ASGM1TxpTqOOCXdSO0PcaDrCsr8WdBYEZRIUoyl2l2sS6IfjUe3iQQP0SA1e
         Z/Gd65MOlJyZJfWXKZS3zFNvpMEQePMhrc9Wbqr3lXnkjUitSUSt+KbnQcZBRqau1QZA
         X4f9dBFcvmnfe8H7S8mSiI0K+kP94n5RQREWtjNMfUKLDcmcpJnqU6GPhn6Ame6Zo509
         VHUwQ/ddxJ1LAkry1rpBO6Jr7Q357Jl2Db3OP2JDtpdB0dkF2ddhIKX6GbR2vg9dreOj
         8Epg==
X-Gm-Message-State: AOAM532n9nz7Hkn+7RIJQZsdz4jsrOtgzDRe5uapnC8YcOmsSqRkhfT8
        CXCx0pjhsKGiplPpsVF7LBJwolxtOcE=
X-Google-Smtp-Source: ABdhPJxSR4y3U82TXHppiIHKpM/WM/aE1pZqWV9Ge54biKSoSKUXkjnLcBXsIS4XRYb5dtT3aJKEyw==
X-Received: by 2002:a63:f955:0:b0:3fc:cf92:cd26 with SMTP id q21-20020a63f955000000b003fccf92cd26mr9767628pgk.137.1654278218432;
        Fri, 03 Jun 2022 10:43:38 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id a13-20020a170902710d00b0015e8d4eb1d2sm5705047pll.28.2022.06.03.10.43.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 10:43:38 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>, stable@vger.kernel.org,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 4/9] lpfc: Address null pointer dereference after starget_to_rport()
Date:   Fri,  3 Jun 2022 10:43:24 -0700
Message-Id: <20220603174329.63777-5-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220603174329.63777-1-jsmart2021@gmail.com>
References: <20220603174329.63777-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Calls to starget_to_rport() may return null.  Add check for null rport
before dereference.

Fixes: bb21fc9911ee ("scsi: lpfc: Use fc_block_rport()")
Cc: <stable@vger.kernel.org> # v5.18
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index f5f4409e24cd..cb5e4e63ac44 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -6060,6 +6060,9 @@ lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
 	int status;
 	u32 logit = LOG_FCP;
 
+	if (!rport)
+		return FAILED;
+
 	rdata = rport->dd_data;
 	if (!rdata || !rdata->pnode) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
@@ -6138,6 +6141,9 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 	unsigned long flags;
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(waitq);
 
+	if (!rport)
+		return FAILED;
+
 	rdata = rport->dd_data;
 	if (!rdata || !rdata->pnode) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-- 
2.26.2

