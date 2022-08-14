Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CEA959220D
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241242AbiHNPmu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241692AbiHNPmK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:42:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B052823BC6;
        Sun, 14 Aug 2022 08:33:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7525260D3D;
        Sun, 14 Aug 2022 15:33:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0BD3C43470;
        Sun, 14 Aug 2022 15:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491211;
        bh=O8aE1jTKrL0TskUtT7Qa2QYgF4+w8ELLS2dMm9AG0R4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hepIXFa4YAHHDQdkwFBSp6VqLf+G9gxvmWV1FJEsRVhEAMjBfyDXLaza2PTdj0Slp
         S/Y9julYFEY0NxFAIsTU6P51/X/XJFA/gocUuJUyr5b5z1mnQGGkMqVN+BFdqW/lci
         i/EXj4cUT68M0i5+e9ASqOWYTfmrFppWnyKaYGJtApEv0th6gOWgtUQKL0HY+I8SNU
         8f2KSTBsglMgnYxuQQ93ftQRO34XhQoEBuMmkF6snB1CPAVE2miv+WBwfvbTvSMXr3
         RUobwgljhaWdui8QEAa+r0Jnm2BtiHsM7SKt30tm2NXt7+gk4zzhjjPj6pHAzIJtWX
         CmuTTCbn3mK5A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 22/46] scsi: lpfc: Fix possible memory leak when failing to issue CMF WQE
Date:   Sun, 14 Aug 2022 11:32:23 -0400
Message-Id: <20220814153247.2378312-22-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153247.2378312-1-sashal@kernel.org>
References: <20220814153247.2378312-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 2f67dc7970bce3529edce93a0a14234d88b3fcd5 ]

There is no corresponding free routine if lpfc_sli4_issue_wqe fails to
issue the CMF WQE in lpfc_issue_cmf_sync_wqe.

If ret_val is non-zero, then free the iocbq request structure.

Link: https://lore.kernel.org/r/20220701211425.2708-6-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_sli.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index d8d26cde70b6..d5a47fdf8650 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2007,10 +2007,12 @@ lpfc_issue_cmf_sync_wqe(struct lpfc_hba *phba, u32 ms, u64 total)
 
 	sync_buf->iocb_flag |= LPFC_IO_CMF;
 	ret_val = lpfc_sli4_issue_wqe(phba, &phba->sli4_hba.hdwq[0], sync_buf);
-	if (ret_val)
+	if (ret_val) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_CGN_MGMT,
 				"6214 Cannot issue CMF_SYNC_WQE: x%x\n",
 				ret_val);
+		__lpfc_sli_release_iocbq(phba, sync_buf);
+	}
 out_unlock:
 	spin_unlock_irqrestore(&phba->hbalock, iflags);
 	return ret_val;
-- 
2.35.1

