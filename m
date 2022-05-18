Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0DBB52BB14
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 14:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237222AbiERMeh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 08:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237018AbiERMdo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 08:33:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0146C1737C2;
        Wed, 18 May 2022 05:29:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F3DDB81FB9;
        Wed, 18 May 2022 12:29:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56DFC385A5;
        Wed, 18 May 2022 12:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652876988;
        bh=AEH/dvMVbcFeYDvFezpfR84pX6HTZhUBNCCoNrj0aKI=;
        h=From:To:Cc:Subject:Date:From;
        b=BIRmo9hTbP8frive6zI5edydk1EUOuDv5qAOheL/7kwkdFSBMdBiCS+DZDCT+b9EV
         WorYbpOeq3EykQ+ijhBuzd5RHO9u8UTFonWi5U06n85OG/0roHn0d+9l1p/uB9K/iy
         yf+9+tqOgsXCi6KwJX1IqipSBU7IeXYaPqEplmn+/HOfPo31G+RqvAcIXHwW3MULIP
         vOtN9QFr31OqaNop03KzrQuB/AocfML9RQPJSIjQbvNxbwklU1/v3njNqBXK6xfpoC
         UG7RwZXngeHSA+WDLekI6R0cnviwlQ6dAJnwLidfpRGAWhMQNp6jsZsFizOv+RSPKb
         ulMEO7pHlDRVg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gleb Chesnokov <Chesnokov.G@raidix.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 1/5] scsi: qla2xxx: Fix missed DMA unmap for aborted commands
Date:   Wed, 18 May 2022 08:29:41 -0400
Message-Id: <20220518122946.343712-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 09c52ef66887..27d3293eadf5 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3753,6 +3753,9 @@ int qlt_abort_cmd(struct qla_tgt_cmd *cmd)
 
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

