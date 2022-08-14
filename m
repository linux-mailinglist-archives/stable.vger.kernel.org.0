Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0389359217B
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240920AbiHNPhC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241046AbiHNPgL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:36:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A1571E3FA;
        Sun, 14 Aug 2022 08:31:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D566B60C99;
        Sun, 14 Aug 2022 15:31:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DED3C43470;
        Sun, 14 Aug 2022 15:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491087;
        bh=e0Y26IHvt/BfDtmyJiFGBYaa2Fed/g7mKB3u3OlEk48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZHb+LpW4HqBYWSDKJ0Mt29O1S85VaHatF5jpJoFmlGKCLnijElL4KIladvT1yHndQ
         Sn0si/GstfTWYacoNYfyG4rwsMc6RdYnwMHGZeLAeNzjrlK+9Twj/aoMQzHunLed7w
         8MBPK3NYoIAaQFYlMDD6uqL/P9aEnIv3rHoHROhbuC0aHW5+1wX7bNzAaq+4AAwFln
         qUcUREaTRyKZI9VQhvOrg/YkBVGomhRiClzo7xHQQO37Nvu885/6hPjFp8w9fRwscn
         plpMeWW6xwJ9Qd9WY3lsql0Hojlu1+B3m8ilEDCj3c7zIkpbLMKmXbQYJ+nuHBjOax
         WMc9BZvG4dFtQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 26/56] scsi: lpfc: Fix possible memory leak when failing to issue CMF WQE
Date:   Sun, 14 Aug 2022 11:29:56 -0400
Message-Id: <20220814153026.2377377-26-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153026.2377377-1-sashal@kernel.org>
References: <20220814153026.2377377-1-sashal@kernel.org>
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
index 123a18784aa4..978cc87d4117 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2003,10 +2003,12 @@ lpfc_issue_cmf_sync_wqe(struct lpfc_hba *phba, u32 ms, u64 total)
 
 	sync_buf->cmd_flag |= LPFC_IO_CMF;
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

