Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75A0660D78B
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 00:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbiJYW6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 18:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232807AbiJYW6t (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 18:58:49 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BEF7CAE6C
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:47 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id a24so8713501qto.10
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lIOCkMKSAlpytczsKPYt4GfYy+CqAu4NwuvWfPqSCe4=;
        b=p6lD5iMCtjk0v7bF+X94uqKvC7VQ6CxpR3d9t1DLwyoVJhFf8sBYockgUMm5d1HZF2
         dkiYAwMiDbnU1o5G3kbPLWgT1vLAV0FCR7PGtlYtT9PeaSzxl2+oYQf24wv8oD2336T4
         6F0qYGyGC1X/FAuwY0R8SEiNLjCFak6ATXvh06eKCSVy26OI1vtRvwxd4fKfVKz4PYkf
         rd5Z0X1Bflx1T+LEkX8C7i44HzrexOdBStiqN+/OVgyoXt3zFYanEo4eh6U3MJZc3MyY
         Y/4ALe7xKTyAjJ2THw34Njq7j01ekxonoVs2BYKQ28yGW0+qu91Lpko8zgTtLown0ugZ
         KC9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lIOCkMKSAlpytczsKPYt4GfYy+CqAu4NwuvWfPqSCe4=;
        b=0k8J0Ja4zgdatekC7O0ASZHXmQt/OB8/2VXw7jjLRH5vQ2D1wh/FEbEuGXUIlnS2ew
         vrnsgLE1CWynVjZV7FMDgNRzcS5zWt8NGYsuOX9vtK2Y/zON//UZA/RC3CE+/IhsOFJX
         mVbQkjlm4vwHfJlUGMXmsibmKDW+t38e2N10heY6nECTjntn1Iyu5b0XRRJWFW6cHu6b
         3BvPT9BaKh4zOGEyo4Kisqx6juMVC3leTAgw4jMFmykIzaMMs5pUNS1m6J31tzuSgQSk
         8B+wNmtJqWvY31/EoGRThjIN77s+oX8gkot3POlMk5Jcs7apHNHsbLbCEBDCr5MjUGJU
         TolA==
X-Gm-Message-State: ACrzQf0hiTxNPLOax37C19blr1uxNw8aS5Iqpy6EmLix64N4Q4NdaLpv
        9blTmqA5mHWg0TW631t0VWcYiDxSltQ=
X-Google-Smtp-Source: AMsMyM753VKLEhi+9Pd10w2Wm3kg+uyGz8FgPvfTKqYxFW+IROBXk28HjLdQiltkc1MPC9EZCKPWaA==
X-Received: by 2002:ac8:7d01:0:b0:39c:ebdf:490c with SMTP id g1-20020ac87d01000000b0039cebdf490cmr34723218qtb.179.1666738726427;
        Tue, 25 Oct 2022 15:58:46 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r12-20020ae9d60c000000b006ecdfcf9d81sm2823766qkk.84.2022.10.25.15.58.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 15:58:46 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     stable@vger.kernel.org
Cc:     jsmart2021@gmail.com, justintee8345@gmail.com,
        martin.petersen@oracle.com, gregkh@linuxfoundation.org
Subject: [PATCH 26/33] scsi: lpfc: Remove redundant lpfc_sli_prep_wqe() call
Date:   Tue, 25 Oct 2022 15:57:32 -0700
Message-Id: <20221025225739.85182-27-jsmart2021@gmail.com>
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

Prior patch added a call to lpfc_sli_prep_wqe() prior to
lpfc_sli_issue_iocb().  This call should not have been added as prep_wqe is
called within the issue_iocb routine. So it's called twice now.

Remove the redundant prep call.

Link: https://lore.kernel.org/r/20220427222223.57920-1-jsmart2021@gmail.com
Fixes: 31a59f75702f ("scsi: lpfc: SLI path split: Refactor Abort paths")
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index a20267ce00bb..534f9c163874 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -18671,13 +18671,11 @@ lpfc_sli4_seq_abort_rsp(struct lpfc_vport *vport,
 	       phba->sli4_hba.rpi_ids[ndlp->nlp_rpi]);
 	bf_set(wqe_cmnd, &icmd->generic.wqe_com, CMD_XMIT_BLS_RSP64_CX);
 
-
 	/* Xmit CT abts response on exchange <xid> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "1200 Send BLS cmd x%x on oxid x%x Data: x%x\n",
 			 ctiocb->abort_rctl, oxid, phba->link_state);
 
-	lpfc_sli_prep_wqe(phba, ctiocb);
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, ctiocb, 0);
 	if (rc == IOCB_ERROR) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-- 
2.35.3

