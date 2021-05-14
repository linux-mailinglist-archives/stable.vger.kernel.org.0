Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6AC3381135
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 21:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233142AbhENT5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 15:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232960AbhENT5V (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 May 2021 15:57:21 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A28C061574;
        Fri, 14 May 2021 12:56:08 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id q6so420876pjj.2;
        Fri, 14 May 2021 12:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y9KJ7BlWCWoA1W8J7stHclnkQlCC75dnPPZ+EbqEQ1E=;
        b=EA4jZYUaKxRG160UgFpjFOSsxbALK2zRkRRHwUexGyQRupWXnTLp/jb40yTf19ERHj
         qHS+XRcOZKyMDNcyPD8lO95CvwOb20IStkTY2kst1SeGsn5QAO5UFOpgXfNZtI+CRvpZ
         rIXkuGGCy7+qMiVlN0pJ2DbOIeQORw7/+74fzFEZY9gJgsh+yBa8qu7TWsIVexwEB+cI
         EGwLH4ieOfvwUCDtVUjw12G9Xc2N2lL1CTF0tmoX8+6J9pEIh9X1fW2hxiZ8g0ZtiU9Y
         TzCFy94SbZceEuUrzf3VGXvBya4ROTGUmO0RdmjD5lCk/+HMKwURf56IGfAK3O5O3ifA
         c/pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y9KJ7BlWCWoA1W8J7stHclnkQlCC75dnPPZ+EbqEQ1E=;
        b=oO71vBYrsjsEQFgOA2nxeSepGnIYtb6MgGTTIL/aitNXAJIuIjkiupBOZUflHVC/3s
         iUyvhEQQ761ZcxQEhByTNMiHiaBV3pjah9FskId/vzeCP+xbZk/mAvsrdckJAzJ4j4Lb
         +4m9uVcG8ykEVV+DB6ZQrUWtO1X3G5MOm1mAWnyRQ7P9eHbljvpTr9VadsVIAzbvLqJL
         LT55iAciP8K16fEXUPLrU2C1DMmFZWT/CxjdVMU9qp9KYr27pdwiLF2B4vsqoEDDTcqk
         1Ery3Y+RuBdeIPIRCUH85wzNrHcMIobVknl8NS6Wt3H6Vjhzh/1bbOcY2ZDvLRucNXoO
         wehw==
X-Gm-Message-State: AOAM532nM72jcdqtj+VPYGPgSgdUNVKx3GoNPmeVhFhObKFa0fpKmezK
        KtpQCesxvoKPN8afNE6jMN4+c5cdX9M=
X-Google-Smtp-Source: ABdhPJyx8iz9afj9ErvJCvSjwiw/Fs3AU9mbu1FmLDGjTaR88nF6pDWtJoLS9gZV1KfmZC3wC/rN7Q==
X-Received: by 2002:a17:902:e051:b029:ed:7646:49c4 with SMTP id x17-20020a170902e051b02900ed764649c4mr47278616plx.55.1621022168063;
        Fri, 14 May 2021 12:56:08 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id v15sm4961850pgc.57.2021.05.14.12.56.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 12:56:07 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>, stable@vger.kernel.org,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 05/11] lpfc: Fix Node recovery when driver is handling simultaneous PLOGIs
Date:   Fri, 14 May 2021 12:55:53 -0700
Message-Id: <20210514195559.119853-6-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210514195559.119853-1-jsmart2021@gmail.com>
References: <20210514195559.119853-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When lpfc is handling a solicited and unsolicited PLOGI with another
initiator, the remote initiator is never recovered. The node for the
initiator is erroneouosly removed and all resources released.

In lpfc_cmpl_els_plogi, when lpfc_els_retry returns a failure
code, the driver is calling the state machine with a device remove
event because the remote port is not currently registered with
the SCSI or nvme transports. The issue is that on a PLOGI "collision"
the driver correctly aborts the solicited PLOGI and allows the
unsolicited PLOGI to complete the process, but this process is
interrupted with a device_rm event.

Introduce logic in the PLOGI completion to capture the PLOGI collision
event and jump out of the routine.  This will avoid removal of the
node.  If there is no collision, the normal node removal will occur.

Fixes: 	52edb2caf675 ("scsi: lpfc: Remove ndlp when a PLOGI/ADISC/PRLI/REG_RPI ultimately fails")
Cc: <stable@vger.kernel.org> # v5.11+

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 118f0d50968a..933927f738c7 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2007,9 +2007,20 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 						NLP_EVT_CMPL_PLOGI);
 
-		/* As long as this node is not registered with the scsi or nvme
-		 * transport, it is no longer an active node.  Otherwise
-		 * devloss handles the final cleanup.
+		/* If a PLOGI collision occurred, the node needs to continue
+		 * with the reglogin process.
+		 */
+		spin_lock_irq(&ndlp->lock);
+		if ((ndlp->nlp_flag & (NLP_ACC_REGLOGIN | NLP_RCV_PLOGI)) &&
+		    ndlp->nlp_state == NLP_STE_REG_LOGIN_ISSUE) {
+			spin_unlock_irq(&ndlp->lock);
+			goto out;
+		}
+		spin_unlock_irq(&ndlp->lock);
+
+		/* No PLOGI collision and the node is not registered with the
+		 * scsi or nvme transport. It is no longer an active node. Just
+		 * start the device remove process.
 		 */
 		if (!(ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD))) {
 			spin_lock_irq(&ndlp->lock);
@@ -4629,6 +4640,10 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	    (vport && vport->port_type == LPFC_NPIV_PORT) &&
 	    ndlp->nlp_flag & NLP_RELEASE_RPI) {
 		lpfc_sli4_free_rpi(phba, ndlp->nlp_rpi);
+		spin_lock_irq(&ndlp->lock);
+		ndlp->nlp_rpi = LPFC_RPI_ALLOC_ERROR;
+		ndlp->nlp_flag &= ~NLP_RELEASE_RPI;
+		spin_unlock_irq(&ndlp->lock);
 		lpfc_drop_node(vport, ndlp);
 	}
 
-- 
2.26.2

