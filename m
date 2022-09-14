Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB485B83A7
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 11:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbiINJCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 05:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbiINJBm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 05:01:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C7274DDA;
        Wed, 14 Sep 2022 02:01:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71B93619A0;
        Wed, 14 Sep 2022 09:01:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C264C433D6;
        Wed, 14 Sep 2022 09:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663146089;
        bh=GtJ5TpsEJOeHEM2xrGD8mq6ipmdMTYtj9haYmKc0evk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XRrLlXBQunWWguF/0kV8n14OrWWcbKVdRN12XexN3ZHISfa6RNmlH9eIRlrQzZEuE
         D64wklm65PBBQdXl51V7Z6aO1ccrInBIJibSd5NcIfizv8kyNiMPo3tLEiNMxbZ1YL
         xf8Q70Lvn2khN+wzxkqqxFyzI+0iOdB0rWW9LNRpRSkQNZPOZdgf7uTRiBOzSWqfhW
         dsbmiHE7pkjH2oHfNSklw626qPoBJItnBl7Eucg0IfTqpaURZshJjL0kFZIcSmk2ax
         ois9JwAbKX2T2mTF707Xdg5jRjbJgOv48m3u5e3U1qMFe/IemoBT88BAwe4yJ/bZfY
         rKfSd2W02k+Og==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>, James Smart <jsmart2021@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 07/22] scsi: lpfc: Return DID_TRANSPORT_DISRUPTED instead of DID_REQUEUE
Date:   Wed, 14 Sep 2022 05:00:48 -0400
Message-Id: <20220914090103.470630-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220914090103.470630-1-sashal@kernel.org>
References: <20220914090103.470630-1-sashal@kernel.org>
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
index 084c0f9fdc3a6..938a5e4359436 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -4272,7 +4272,7 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 		    lpfc_cmd->result == IOERR_ABORT_REQUESTED ||
 		    lpfc_cmd->result == IOERR_RPI_SUSPENDED ||
 		    lpfc_cmd->result == IOERR_SLER_CMD_RCV_FAILURE) {
-			cmd->result = DID_REQUEUE << 16;
+			cmd->result = DID_TRANSPORT_DISRUPTED << 16;
 			break;
 		}
 		if ((lpfc_cmd->result == IOERR_RX_DMA_FAILED ||
@@ -4562,7 +4562,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
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

