Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8D3531A4E
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240129AbiEWRSI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240505AbiEWRQY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:16:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2DF76D3B5;
        Mon, 23 May 2022 10:15:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 748AD61525;
        Mon, 23 May 2022 17:14:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77334C385A9;
        Mon, 23 May 2022 17:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326088;
        bh=PbB7C77+uD6w0+4mF6M8fnCmGhUXFeYrAwDI9Gltt64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LwkaZ1V5I7UdZ2oxw9uK93/6LQ1iC+Ejj8eo8NDpR31xSb+lU8uTfc/mHCDgW2nNA
         OuF1JwC7trkwHp7GEJHK3psp0GSygOfZujaZRfKPuqmGfs6zQkzSn/8aXYgmqDxATO
         SHMJtEDgUFlZTze9P5CjwvgqRGt4iM9adVloBKIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Gleb Chesnokov <Chesnokov.G@raidix.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 53/68] scsi: qla2xxx: Fix missed DMA unmap for aborted commands
Date:   Mon, 23 May 2022 19:05:20 +0200
Message-Id: <20220523165811.258317918@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165802.500642349@linuxfoundation.org>
References: <20220523165802.500642349@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gleb Chesnokov <Chesnokov.G@raidix.com>

[ Upstream commit 26f9ce53817a8fd84b69a73473a7de852a24c897 ]

Aborting commands that have already been sent to the firmware can
cause BUG in qlt_free_cmd(): BUG_ON(cmd->sg_mapped)

For instance:

 - Command passes rdx_to_xfer state, maps sgl, sends to the firmware

 - Reset occurs, qla2xxx performs ISP error recovery, aborts the command

 - Target stack calls qlt_abort_cmd() and then qlt_free_cmd()

 - BUG_ON(cmd->sg_mapped) in qlt_free_cmd() occurs because sgl was not
   unmapped

Thus, unmap sgl in qlt_abort_cmd() for commands with the aborted flag set.

Link: https://lore.kernel.org/r/AS8PR10MB4952D545F84B6B1DFD39EC1E9DEE9@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Gleb Chesnokov <Chesnokov.G@raidix.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_target.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index df598c377161..cb97565b6a33 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3768,6 +3768,9 @@ int qlt_abort_cmd(struct qla_tgt_cmd *cmd)
 
 	spin_lock_irqsave(&cmd->cmd_lock, flags);
 	if (cmd->aborted) {
+		if (cmd->sg_mapped)
+			qlt_unmap_sg(vha, cmd);
+
 		spin_unlock_irqrestore(&cmd->cmd_lock, flags);
 		/*
 		 * It's normal to see 2 calls in this path:
-- 
2.35.1



