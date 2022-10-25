Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA2FE60D78A
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 00:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbiJYW6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 18:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232799AbiJYW6q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 18:58:46 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE9ED73FC
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:46 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id cr19so8770322qtb.0
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ptjKIoYBNyfxmifhbV7Ngd7GO8MpGNEuTQbRWTHSqdU=;
        b=EqSTTB2kvxydA9RFoRGtaueKM41Gz6FNLu1ofa/zAn8zcv335rJdHZMoCoqnDJ30QK
         wYwKYzK1S3W0KIe0EL01lObZ+cDDNy2a0KDy8+8Ev3uMa3GOiMhxRmjKAC3RmHVxOuZM
         YEauP3mm3kyhlWNRwU4GnOLmME4MgCPAEO3shzpejIE4tAL3qxW/lQ/QCCFsSGABR4B0
         S7ci3194g8t6XIiHxYfIeooV22qYPty7rkSeRnAxO03w4Su6tC3K+TK1zDVSGqHCmCmr
         luKnhEXZy4ywLzWaPhcMjWKCIZswiIwRFXsmM2F3xxwAa5zF7xK+NmzeT79klIyxxFJd
         85bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ptjKIoYBNyfxmifhbV7Ngd7GO8MpGNEuTQbRWTHSqdU=;
        b=hgjkQya6D3Y1yhOGaOk53/s+1I3QS6ZnlB122w6NwzO472o8492JnISWqO4dKnROJh
         MQtw1+ZQ90lgRhXx5dj9aNedFL0wWE5Pfwg6odz0JIZZdf0PuMKzp9bxE1lKMFMswDNv
         GFfowH8JNJerxz0+xyGMgFJPZ/Dhcow6AgPJJ1KkpMJ5xM8sbCmrfP1E9rPZ4Mo8mEaK
         mdr9vO8aLSRiNvVdnFYBL42fKW7lq92lFWgf3TVBDxAF9iN2x2pZaTaUmMSNqZygxno4
         rcrDBMKePXlR/z8KhjQPyXCITrwhz8KexJYhl9ncieH2Jd+TI369ZXJ5C5np5BdiZV9E
         zHqw==
X-Gm-Message-State: ACrzQf0NxOwvTFwpQ+Dg8090+mG8vtDPnMNjfRK56ZhL4zBKsaxvHs8H
        FNt/oI8A0dRY1Af9VlaETtQU/gjNphE=
X-Google-Smtp-Source: AMsMyM6qPCxffU153cME6Lk5mgCS6mNt9vFqkYytuBuC0chtYLL4AhJ2TdCqLX4QB1nwyNT9k4CwXg==
X-Received: by 2002:a05:622a:43:b0:39c:eb15:c2ee with SMTP id y3-20020a05622a004300b0039ceb15c2eemr34595885qtw.331.1666738725317;
        Tue, 25 Oct 2022 15:58:45 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r12-20020ae9d60c000000b006ecdfcf9d81sm2823766qkk.84.2022.10.25.15.58.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 15:58:44 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     stable@vger.kernel.org
Cc:     jsmart2021@gmail.com, justintee8345@gmail.com,
        martin.petersen@oracle.com, gregkh@linuxfoundation.org,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 25/33] scsi: lpfc: Fix locking for lpfc_sli_iocbq_lookup()
Date:   Tue, 25 Oct 2022 15:57:31 -0700
Message-Id: <20221025225739.85182-26-jsmart2021@gmail.com>
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

The rules changed for lpfc_sli_iocbq_lookup() vs locking. Prior, the
routine properly took out the lock. In newly refactored code, the locks
must be held when calling the routine.

Fix lpfc_sli_process_sol_iocb() to take the locks before calling the
routine.

Fix lpfc_sli_handle_fast_ring_event() to not release the locks to call the
routine.

Link: https://lore.kernel.org/r/20220323205545.81814-3-jsmart2021@gmail.com
Fixes: 1b64aa9eae28 ("scsi: lpfc: SLI path split: Refactor fast and slow paths to native SLI4")
Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index b1476c8fe8e4..a20267ce00bb 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -3717,7 +3717,15 @@ lpfc_sli_process_sol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	unsigned long iflag;
 	u32 ulp_command, ulp_status, ulp_word4, ulp_context, iotag;
 
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		spin_lock_irqsave(&pring->ring_lock, iflag);
+	else
+		spin_lock_irqsave(&phba->hbalock, iflag);
 	cmdiocbp = lpfc_sli_iocbq_lookup(phba, pring, saveq);
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		spin_unlock_irqrestore(&pring->ring_lock, iflag);
+	else
+		spin_unlock_irqrestore(&phba->hbalock, iflag);
 
 	ulp_command = get_job_cmnd(phba, saveq);
 	ulp_status = get_job_ulpstatus(phba, saveq);
@@ -4054,10 +4062,8 @@ lpfc_sli_handle_fast_ring_event(struct lpfc_hba *phba,
 				break;
 			}
 
-			spin_unlock_irqrestore(&phba->hbalock, iflag);
 			cmdiocbq = lpfc_sli_iocbq_lookup(phba, pring,
 							 &rspiocbq);
-			spin_lock_irqsave(&phba->hbalock, iflag);
 			if (unlikely(!cmdiocbq))
 				break;
 			if (cmdiocbq->cmd_flag & LPFC_DRIVER_ABORTED)
-- 
2.35.3

