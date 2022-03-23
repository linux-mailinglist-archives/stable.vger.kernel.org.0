Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4E8D4E5A43
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 21:55:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240702AbiCWU51 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 16:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiCWU5Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 16:57:25 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E67B8CCEE;
        Wed, 23 Mar 2022 13:55:55 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id mj15-20020a17090b368f00b001c637aa358eso7605317pjb.0;
        Wed, 23 Mar 2022 13:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8I/s6Mck/BgQdxWJXuzKA36uTPWwAXWlArll/42jSUU=;
        b=LwM4DTom5LVXG7k+BxXRdIjwspF0I/mnxlkljLVggf5UBTYGh48sYCIFcUY+6Ah8dw
         az6OngQ2S1LCuMPEYGXuxCgRJwYBQYNOwBEYBcXVDWx/XXZV8DxiqmRFec1JST5OFpx2
         SJ3q3PJfs9BK5OXiAvHjogPf1Mml3bxVg3wawWs+1FDL416J/ep/ABETwzigvddwxzdz
         ImnADYF2Kb+lJnphbu0KmBzAl47D+p+7QxCKK2kMmhq71Fo0kdrjHQrPbd3Teg+WXtT3
         ocZuWddaKZ8MNuJKFIdtmB5mbslo6HpzX99RvJA4hq1ZgpFPs78zPv7Fr6ZX9FLXXmvw
         +25g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8I/s6Mck/BgQdxWJXuzKA36uTPWwAXWlArll/42jSUU=;
        b=buHXD78HcYotA2HZwOUXECkgTBrzmOcRVOW9LbRAD+q9ni6M7YlMj6oL2gk8F8quYS
         /MyuRxtESv+PlhPcZGqZVR7siesDJ/Qx/3TgwKKMbQOkTfnWy0H2MJGSjXgAkHBJ1EVt
         u5tXC89p6n4+ZNf2y+u7qMYYosy1l1gNmH3fVbOwbCxIQ0mKyKpm5wyuuZ/rhAgbU2xy
         /u021M24PZbBsoINj+FKmYkPTvw8k1ZXhNi0urar3ToToTycF8LRTcXE5+z9zxZc01xs
         zGBay+iov0T96cnSp1jliAYP6o4nOH/uiVl6oPrNZWlrVmKdMQdOK6oqV51MzGVu/QKr
         FzMQ==
X-Gm-Message-State: AOAM530U+9qLntkeKp4/vDIXbXRF0QSQ4cluyV1D3b8J80pScfpfsdWn
        4lOLiQl2CmL9bLxADZuY76eO2CcGt9w=
X-Google-Smtp-Source: ABdhPJzosCadetFdrNP0zPjt6jcq/LIIkDoBnVTHD8kvKx/Q2byH/sB/fFQs+a0JxxD6Zj5JPTH70Q==
X-Received: by 2002:a17:90a:1704:b0:1c6:691b:17f3 with SMTP id z4-20020a17090a170400b001c6691b17f3mr1775281pjd.187.1648068954420;
        Wed, 23 Mar 2022 13:55:54 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x7-20020a056a00188700b004fae6f0d3e5sm600521pfh.175.2022.03.23.13.55.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 13:55:53 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>, stable@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 1/2] lpfc: Fix broken sli4 abort path
Date:   Wed, 23 Mar 2022 13:55:44 -0700
Message-Id: <20220323205545.81814-2-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220323205545.81814-1-jsmart2021@gmail.com>
References: <20220323205545.81814-1-jsmart2021@gmail.com>
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

There was a merge error in ther 14.2.0.0 patches that resulted in
the sli4 path using the sli3 issue_abort_iotag routine. This resulted
in txcmplq corruption.

Fix to use the sli4 routine when sli4.

Fixes: 31a59f75702f ("scsi: lpfc: SLI path split: Refactor Abort paths")
Cc: <stable@vger.kernel.org> # v5.2+
Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 3c132604fd91..ba9dbb51b75f 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5929,13 +5929,15 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 	}
 
 	lpfc_cmd->waitq = &waitq;
-	if (phba->sli_rev == LPFC_SLI_REV4)
+	if (phba->sli_rev == LPFC_SLI_REV4) {
 		spin_unlock(&pring_s4->ring_lock);
-	else
+		ret_val = lpfc_sli4_issue_abort_iotag(phba, iocb,
+						      lpfc_sli_abort_fcp_cmpl);
+	} else {
 		pring = &phba->sli.sli3_ring[LPFC_FCP_RING];
-
-	ret_val = lpfc_sli_issue_abort_iotag(phba, pring, iocb,
-					     lpfc_sli_abort_fcp_cmpl);
+		ret_val = lpfc_sli_issue_abort_iotag(phba, pring, iocb,
+						     lpfc_sli_abort_fcp_cmpl);
+	}
 
 	/* Make sure HBA is alive */
 	lpfc_issue_hb_tmo(phba);
-- 
2.26.2

