Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF4835B83F4
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 11:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbiINJF4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 05:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbiINJFM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 05:05:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 690C97696A;
        Wed, 14 Sep 2022 02:03:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE18CB8170C;
        Wed, 14 Sep 2022 09:02:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DED7C433D6;
        Wed, 14 Sep 2022 09:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663146157;
        bh=NOkSZjzNwkQdsEJhlqGS7BmGu7T4EL8MsBPS/P34FX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m8xm5UGv0dE8nKHBGSV4D0ats3ygI/6BP4t5YSj5l7IzkTeujwM9UPsrh22dK2d+S
         W8n2c35qk6pUbC3FNxB6FFms6k4aiu5garnhpO5JudzaIf7BQbRStgAisGM+qabq+u
         6Ce3/GF7pAYEuh4kNvfdhxJpk/joMr4v0WpwXWdh891VK7eMw0p00bxIAup8D6TqCA
         ZDnsoSyuFC9TZlEqJOQJPNXHMaQVSNAZHPdk/LjNhIM8ye/tv5KRXze4x2TaB3Vehc
         YzSYOnwG+dwGObRD4I3xtQamfXgrz5flJSrIx+6H11Kp3pJLidXU6u03VyPIUFv7La
         DKIg/x+BP5aBw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>, James Smart <jsmart2021@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 04/16] scsi: lpfc: Return DID_TRANSPORT_DISRUPTED instead of DID_REQUEUE
Date:   Wed, 14 Sep 2022 05:02:12 -0400
Message-Id: <20220914090224.470913-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220914090224.470913-1-sashal@kernel.org>
References: <20220914090224.470913-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit c0a50cd389c3ed54831e240023dd12bafa56b3a6 ]

When the driver hits an internal error condition returning DID_REQUEUE the
I/O will be retried on the same ITL nexus.  This will inhibit multipathing,
resulting in endless retries even if the error could have been resolved by
using a different ITL nexus.  Return DID_TRANSPORT_DISRUPTED to allow for
multipath to engage and route I/O to another ITL nexus.

Link: https://lore.kernel.org/r/20220824060033.138661-1-hare@suse.de
Reviewed-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 7da8e4c845df8..41313fcaf84a3 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -4278,7 +4278,7 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 		    lpfc_cmd->result == IOERR_NO_RESOURCES ||
 		    lpfc_cmd->result == IOERR_ABORT_REQUESTED ||
 		    lpfc_cmd->result == IOERR_SLER_CMD_RCV_FAILURE) {
-			cmd->result = DID_REQUEUE << 16;
+			cmd->result = DID_TRANSPORT_DISRUPTED << 16;
 			break;
 		}
 		if ((lpfc_cmd->result == IOERR_RX_DMA_FAILED ||
@@ -4567,7 +4567,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 			    lpfc_cmd->result == IOERR_NO_RESOURCES ||
 			    lpfc_cmd->result == IOERR_ABORT_REQUESTED ||
 			    lpfc_cmd->result == IOERR_SLER_CMD_RCV_FAILURE) {
-				cmd->result = DID_REQUEUE << 16;
+				cmd->result = DID_TRANSPORT_DISRUPTED << 16;
 				break;
 			}
 			if ((lpfc_cmd->result == IOERR_RX_DMA_FAILED ||
-- 
2.35.1

