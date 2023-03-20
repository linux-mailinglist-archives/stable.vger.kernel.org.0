Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBAC26C07EC
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 02:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbjCTBDZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 21:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbjCTBCk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 21:02:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86C32233E2;
        Sun, 19 Mar 2023 17:57:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2832611E8;
        Mon, 20 Mar 2023 00:55:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682E2C433A0;
        Mon, 20 Mar 2023 00:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273747;
        bh=l2A9QQihpFJRFhhKWIMSe7D1FvrYtIWgCPHdfGY7ya0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ndset1lRKenhMTsXVRGqJBzc6SqqNVq3wAaYca5PnBR8HTbyOg1Rl3chi/MPrJyIJ
         Y9OqVQSqlHGpPZOYu6tJIChRbr3nAbyCpyTD2PwmQ57r3P+f0w9PXl8W5UOk7nooJZ
         UvltgN3jkm8vluyctDUQdt4iQi3tXo9kw/PZhPJsgq1OJFZ/z9i4h0bRf4Lp42H/Up
         wsYSJ5PTNUDiKB/DXahElnWHSbsxr+XmGGOUquXEyoWtm/9uIDYyAILSyUsTmyA1Qq
         Z7CmSQ5GjHx4rT1NBxFZT9bpYo0+B4i4QgONFpMwBTVqT5rw36+FedoNNgK2JXQSyt
         ppbet8QFhUATA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Justin Tee <justin.tee@broadcom.com>,
        Kang Chen <void0red@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 11/17] scsi: lpfc: Check kzalloc() in lpfc_sli4_cgn_params_read()
Date:   Sun, 19 Mar 2023 20:55:13 -0400
Message-Id: <20230320005521.1428820-11-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005521.1428820-1-sashal@kernel.org>
References: <20230320005521.1428820-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 312320b0e0ec21249a17645683fe5304d796aec1 ]

If kzalloc() fails in lpfc_sli4_cgn_params_read(), then we rely on
lpfc_read_object()'s routine to NULL check pdata.

Currently, an early return error is thrown from lpfc_read_object() to
protect us from NULL ptr dereference, but the errno code is -ENODEV.

Change the errno code to a more appropriate -ENOMEM.

Reported-by: Kang Chen <void0red@gmail.com>
Link: https://lore.kernel.org/all/20230226102338.3362585-1-void0red@gmail.com
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20230228044336.5195-1-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_init.c | 2 ++
 drivers/scsi/lpfc/lpfc_sli.c  | 4 ----
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 855817f6fe671..f79299f6178cd 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -7056,6 +7056,8 @@ lpfc_sli4_cgn_params_read(struct lpfc_hba *phba)
 	/* Find out if the FW has a new set of congestion parameters. */
 	len = sizeof(struct lpfc_cgn_param);
 	pdata = kzalloc(len, GFP_KERNEL);
+	if (!pdata)
+		return -ENOMEM;
 	ret = lpfc_read_object(phba, (char *)LPFC_PORT_CFG_NAME,
 			       pdata, len);
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 7d333167047f5..1f1d346adc038 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -22376,10 +22376,6 @@ lpfc_read_object(struct lpfc_hba *phba, char *rdobject, uint32_t *datap,
 	struct lpfc_dmabuf *pcmd;
 	u32 rd_object_name[LPFC_MBX_OBJECT_NAME_LEN_DW] = {0};
 
-	/* sanity check on queue memory */
-	if (!datap)
-		return -ENODEV;
-
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mbox)
 		return -ENOMEM;
-- 
2.39.2

