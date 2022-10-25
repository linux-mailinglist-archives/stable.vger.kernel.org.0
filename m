Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBA560D774
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 00:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232560AbiJYW6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 18:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232127AbiJYW6P (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 18:58:15 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CFD6CA8B8
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:14 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id a24so8712511qto.10
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O7z59rnMBEdCWkkAISxSFDbnVWzYW1hbLmPC1hpgNP8=;
        b=AovZvhJIzM49Xh9Bqu+c67A/3T6vk/ICSjhi1b76sv2z+mm8e67+P5FQojp+bA2Olj
         +ZQvkmIvjVgrYvCFA5o0D0Sy9i6LcPOC5B7yoa+nuIb+G4jRd5N0wy63ZaYd66Io67ks
         2r0Zg5UPreuCgFOSYAQsHYRK42vWyv16rVk8p5WXR1y3rPtWWDeossTLrn363Js3oIV2
         LuXcU/q6C5H0uTsdYmkp6H8I9sRG9I5lmMpNmzgH+rxwfPljdTNnZQeAxoWRqrF28hAz
         NlmxgqpvW3ilU6v4MdlYYQaU2PtoqSAjKnCsVTswJ+A0V4NgQs94WviRSuscpl/zR6AM
         wmiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O7z59rnMBEdCWkkAISxSFDbnVWzYW1hbLmPC1hpgNP8=;
        b=ldyVK8tlinw9//hr4aZJBbKoO8laekZ5O1JLUBGAw9QZe7cylc078X4GhsqHWvFLpH
         NFx64eZx425gjovBeiW9DdE/fLUk9XocmgU5e24XphZmsYuEz782aMV14L4Sl/7gqduJ
         GlENC0QFQn4He/s+VwCHIU+WAF29cwy/bvdZjKTY6EE5JhRUIc4ZQzGkaQQk/5EywWM2
         XkXEBXxOtXjxzenYMaHL4Zci97VhxRKq3IwRFdhz9cyyUX1NXF3aHhgEhcrZxuvrJCGk
         N/wRJm+5bFsrFydYqUowNfkZKd1G4Rgj2brtl4xXtoj3T47L9TCiv1fO/8vfF+x10/fg
         y2JQ==
X-Gm-Message-State: ACrzQf3hS1wqHJuxGG8fEeP7hh0x/MchmiIl43FQ9AZb+ZqS59j4C9Pr
        YyaIfE+F673Vn2OQUNECF0y19kgxTdY=
X-Google-Smtp-Source: AMsMyM6/lKl20wMYFcPEJPSgaPo/j0sD+lfNkQRRDge4NGD+KgY8vW2WNBm6pHLOjAK6L0f8LJxNLw==
X-Received: by 2002:a05:622a:41:b0:39c:e2d6:b9ea with SMTP id y1-20020a05622a004100b0039ce2d6b9eamr33597701qtw.58.1666738693623;
        Tue, 25 Oct 2022 15:58:13 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r12-20020ae9d60c000000b006ecdfcf9d81sm2823766qkk.84.2022.10.25.15.58.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 15:58:13 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     stable@vger.kernel.org
Cc:     jsmart2021@gmail.com, justintee8345@gmail.com,
        martin.petersen@oracle.com, gregkh@linuxfoundation.org
Subject: [PATCH 03/33] Revert "scsi: lpfc: Fix locking for lpfc_sli_iocbq_lookup()"
Date:   Tue, 25 Oct 2022 15:57:09 -0700
Message-Id: <20221025225739.85182-4-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20221025225739.85182-1-jsmart2021@gmail.com>
References: <20221025225739.85182-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 9a570069cdbbc28c4b5b4632d5c9369371ec739c.
---
 drivers/scsi/lpfc/lpfc_sli.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 400039c0e076..f1c77adb897c 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -3644,15 +3644,7 @@ lpfc_sli_process_sol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	unsigned long iflag;
 	u32 ulp_command, ulp_status, ulp_word4, ulp_context, iotag;
 
-	if (phba->sli_rev == LPFC_SLI_REV4)
-		spin_lock_irqsave(&pring->ring_lock, iflag);
-	else
-		spin_lock_irqsave(&phba->hbalock, iflag);
 	cmdiocbp = lpfc_sli_iocbq_lookup(phba, pring, saveq);
-	if (phba->sli_rev == LPFC_SLI_REV4)
-		spin_unlock_irqrestore(&pring->ring_lock, iflag);
-	else
-		spin_unlock_irqrestore(&phba->hbalock, iflag);
 
 	ulp_command = get_job_cmnd(phba, saveq);
 	ulp_status = get_job_ulpstatus(phba, saveq);
@@ -3989,8 +3981,10 @@ lpfc_sli_handle_fast_ring_event(struct lpfc_hba *phba,
 				break;
 			}
 
+			spin_unlock_irqrestore(&phba->hbalock, iflag);
 			cmdiocbq = lpfc_sli_iocbq_lookup(phba, pring,
 							 &rspiocbq);
+			spin_lock_irqsave(&phba->hbalock, iflag);
 			if (unlikely(!cmdiocbq))
 				break;
 			if (cmdiocbq->cmd_flag & LPFC_DRIVER_ABORTED)
-- 
2.35.3

