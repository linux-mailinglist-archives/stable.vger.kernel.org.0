Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B223611C35
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 23:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiJ1VJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 17:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiJ1VJC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 17:09:02 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C10724AAC4
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 14:09:02 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id cr19so4301107qtb.0
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 14:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/vmz5aTaUCprhXpdboV6KmkEygYuXF9i6RwPl/s6lyQ=;
        b=jP5oLlaHz33sLcdb3znP4nhJkwykxJGhu1zpmZCszvRpHzvgYAMMoO+rbAzcjeANAu
         Mm7qaZoyXZnpF+6OUrnri7sOhrhrEbgEONgunnZBFOYO0SXEcGk32dxGcyhF/kyWTb/L
         UdAFsbQZvqwZmnu4xYKkCeFXbfFsv2ld1E2c2O3mf2Ia/Ot55m6MBz921725TmO9vfKb
         KaqavjlaGcB7E6Z7nMDEuOQh+1u9fDtlPJoXsJZlXnhxkQVHcY6egd+yBcDzAig55xFf
         A12j9dyKaqhfE2P1IltzFYMElBwWd3gWDTBaZLb7fVcLgCIc5zRYGATNG+ioWg6sKizn
         F0CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/vmz5aTaUCprhXpdboV6KmkEygYuXF9i6RwPl/s6lyQ=;
        b=Ghv7LY4C1ZPO1shwMwMVL9an2aGiBauZslf9uxN1GjmlOTeawIYNe6CkNeDq0IWVtk
         t2Y4FUcfEJJHNM5M/G91kASRB/3hWF6CHRYt9L8t44R+6VrTuLJ5pBTxfIL5Qma4wLXQ
         NKGi6SEwkSDWGyoZ8XhOlihaI/JvIimaEhHXDTskp+ORW6zs4oIZNmPKZ9yFVDX9bOl0
         BHKqJyyBRZotwkzJizjc/bNIuU227+baY00+Izzjh5Lseu7Qis22ThAXv1nqVMKx4jOD
         +GapkHM70LLYc7iR70U6H/r/ZxgTOERo6QOH1xieBvG6ml6WfaX1Rcam0Ei6oLcBs+ou
         ETTQ==
X-Gm-Message-State: ACrzQf1v3P5RX4iJdabhGGWbKU3MkdxKXrty/SbanCbGwIACShkXs7D7
        cln2cjB2leArEdxhG7ZJO8a1I/1b4z4=
X-Google-Smtp-Source: AMsMyM4o3yFSWxsZFPeEMGmypsOgufki4E0dx3ou+460yP9Vner5UQQF0sDYg3sNIn5JbOmzvLLtvQ==
X-Received: by 2002:ac8:7c4a:0:b0:39c:f9c0:29c4 with SMTP id o10-20020ac87c4a000000b0039cf9c029c4mr1349965qtv.14.1666991341192;
        Fri, 28 Oct 2022 14:09:01 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id fu36-20020a05622a5da400b0035cf31005e2sm2906808qtb.73.2022.10.28.14.09.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 14:09:00 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     stable@vger.kernel.org
Cc:     jsmart2021@gmail.com, justintee8345@gmail.com,
        martin.petersen@oracle.com, gregkh@linuxfoundation.org
Subject: [PATCH v2 3/6] Revert "scsi: lpfc: Fix locking for lpfc_sli_iocbq_lookup()"
Date:   Fri, 28 Oct 2022 14:08:24 -0700
Message-Id: <20221028210827.23149-4-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20221028210827.23149-1-jsmart2021@gmail.com>
References: <20221028210827.23149-1-jsmart2021@gmail.com>
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

LTS 5.15 pulled in several lpfc "SLI Path split" patches.  The Path
Split mods were a 14-patch set, which refactors the driver from
to split the sli-3 hw (now eol) from the sli-4 hw and use sli4
structures natively. The patches are highly inter-related.

Given only some of the patches were included, it created a situation
where FLOGI's fail, thus SLI Ports can't start communication.

Reverting this patch as its a fix specific to the Path Split patches,
which were partially included and now being pulled from 5.15.

Signed-off-by: James Smart <jsmart2021@gmail.com>
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

