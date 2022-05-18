Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E025352BAFE
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 14:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237354AbiERMf1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 08:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237137AbiERMeu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 08:34:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1694197F68;
        Wed, 18 May 2022 05:30:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE960B81FBF;
        Wed, 18 May 2022 12:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8ECC385AA;
        Wed, 18 May 2022 12:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652877019;
        bh=sBS5VQKb5ioj3Nk8RgBkunxitCuvKvoRM4eCzRa6ets=;
        h=From:To:Cc:Subject:Date:From;
        b=Vh6u3Iwel/6Vb0uNISumtWCguXZ+MYoDWd002YD27agjUqgVgE7998l2gL0Rwck3x
         PI4Ih7vzCDhJERjyDkWGSj9PFoM5DLiKeerL1/O+2nbSXWoXIhU1gqiE8sFuRvCsbe
         qsj58fc670dPzejVjKCfq+hkvoHQ+3djoPPcLLpHCTElmNQJ/+DzlTQdSnHv6RT6uF
         bNH8SwpUEc/riNUAOqB0WM2eTwN1dyWxpi7Hd8RI/vscUKOYN+z2h/mVDVEm+s4ZPe
         k8dyxRAW6meOm3XJBMHPbMDFr10bAl13y3uwKee+Fa7PHZz8wMGjftqH3dKqqhnRoK
         p+vpOMiYlWWSQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gleb Chesnokov <Chesnokov.G@raidix.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 1/4] scsi: qla2xxx: Fix missed DMA unmap for aborted commands
Date:   Wed, 18 May 2022 08:30:13 -0400
Message-Id: <20220518123016.343867-1-sashal@kernel.org>
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
index 6ef7a094ee51..b4a21adb3e73 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3286,6 +3286,9 @@ int qlt_abort_cmd(struct qla_tgt_cmd *cmd)
 
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

