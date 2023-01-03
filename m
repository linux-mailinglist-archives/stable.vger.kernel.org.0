Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4B7665C685
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 19:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238297AbjACSlL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 13:41:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238308AbjACSkb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 13:40:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F34814022;
        Tue,  3 Jan 2023 10:40:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFB1A614E4;
        Tue,  3 Jan 2023 18:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B09C43392;
        Tue,  3 Jan 2023 18:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672771219;
        bh=PUvFWrT9DlCbVEwFrGsscLlqDiFiyTjq461Sr9f4JQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JoQ/AM3zd0PTQZPuKEdC/ie208muKnSeZ+FeWar5gPu5TUYnTxTm7AmF7+pa4zLoq
         Hs9KH8V5jch9jy41O+REK0Qu8dkEolKD6hklUnXTKqcQx05BghZepTehG+n6H9Dise
         KKEzxvAOtwGvPjZp/H7YdRKvrKBHWu3Vnt4BBdPnAgD3Q+VHBJ/LFLdaTZSrhSEqFg
         NGGGpxkgyagqPcOxRaxwvGI+GouLqpuJexwASq9oJ5f3wPiP5Rp80WbFHLRKVhYFAa
         Q4diNroEiw4x+kpNNftpaYHGHhdQIRNmGhY8B4agTYuLrqxWWLE6Nk3mHsOZbNgBJV
         dcZoNqqmv5wyQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Sasha Levin <sashal@kernel.org>, axboe@fb.com,
        sagi@grimberg.me, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 4/4] nvme: also return I/O command effects from nvme_command_effects
Date:   Tue,  3 Jan 2023 13:40:12 -0500
Message-Id: <20230103184013.2022849-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230103184013.2022849-1-sashal@kernel.org>
References: <20230103184013.2022849-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 831ed60c2aca2d7c517b2da22897a90224a97d27 ]

To be able to use the Commands Supported and Effects Log for allowing
unprivileged passtrough, it needs to be corretly reported for I/O
commands as well.  Return the I/O command effects from
nvme_command_effects, and also add a default list of effects for the
NVM command set.  For other command sets, the Commands Supported and
Effects log is required to be present already.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 2d5b5e0fb66a..672f53d5651a 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1113,6 +1113,18 @@ static u32 nvme_known_admin_effects(u8 opcode)
 	return 0;
 }
 
+static u32 nvme_known_nvm_effects(u8 opcode)
+{
+	switch (opcode) {
+	case nvme_cmd_write:
+	case nvme_cmd_write_zeroes:
+	case nvme_cmd_write_uncor:
+		 return NVME_CMD_EFFECTS_LBCC;
+	default:
+		return 0;
+	}
+}
+
 u32 nvme_command_effects(struct nvme_ctrl *ctrl, struct nvme_ns *ns, u8 opcode)
 {
 	u32 effects = 0;
@@ -1120,16 +1132,24 @@ u32 nvme_command_effects(struct nvme_ctrl *ctrl, struct nvme_ns *ns, u8 opcode)
 	if (ns) {
 		if (ns->head->effects)
 			effects = le32_to_cpu(ns->head->effects->iocs[opcode]);
+		if (ns->head->ids.csi == NVME_CAP_CSS_NVM)
+			effects |= nvme_known_nvm_effects(opcode);
 		if (effects & ~(NVME_CMD_EFFECTS_CSUPP | NVME_CMD_EFFECTS_LBCC))
 			dev_warn_once(ctrl->device,
-				"IO command:%02x has unhandled effects:%08x\n",
+				"IO command:%02x has unusual effects:%08x\n",
 				opcode, effects);
-		return 0;
-	}
 
-	if (ctrl->effects)
-		effects = le32_to_cpu(ctrl->effects->acs[opcode]);
-	effects |= nvme_known_admin_effects(opcode);
+		/*
+		 * NVME_CMD_EFFECTS_CSE_MASK causes a freeze all I/O queues,
+		 * which would deadlock when done on an I/O command.  Note that
+		 * We already warn about an unusual effect above.
+		 */
+		effects &= ~NVME_CMD_EFFECTS_CSE_MASK;
+	} else {
+		if (ctrl->effects)
+			effects = le32_to_cpu(ctrl->effects->acs[opcode]);
+		effects |= nvme_known_admin_effects(opcode);
+	}
 
 	return effects;
 }
-- 
2.35.1

