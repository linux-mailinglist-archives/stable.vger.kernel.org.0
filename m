Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44D905C02EE
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbiIUP5C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231931AbiIUP4X (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:56:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A3969FA94;
        Wed, 21 Sep 2022 08:51:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADAEC63138;
        Wed, 21 Sep 2022 15:50:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ED57C433C1;
        Wed, 21 Sep 2022 15:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775423;
        bh=IsyHi3wSqK4hM1NhPP/hH6CMqg72K/1A8UFLZTLCdAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WDSQ4YQpCEaL4yjkSgEVGdH2xUK7hp2gkFRCnN/sxg7jurXzDL7jvfg95gmBxm7YG
         7J5KvqABmEDwoNQPU7EnDabpqbG5pbqW7KxMMhF8GmnANbOOx6Q2jf9LuCODIWRHFo
         N3MoVI31idmYvR0hKbwVHNnLGAyd8PiM9ItgBH1g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Smart <jsmart2021@gmail.com>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 30/45] scsi: lpfc: Return DID_TRANSPORT_DISRUPTED instead of DID_REQUEUE
Date:   Wed, 21 Sep 2022 17:46:20 +0200
Message-Id: <20220921153647.883050090@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153646.931277075@linuxfoundation.org>
References: <20220921153646.931277075@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
index 7da8e4c845df..41313fcaf84a 100644
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



