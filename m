Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 721AF65C67A
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 19:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238211AbjACSk3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 13:40:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238315AbjACSkD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 13:40:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DD3413F3E;
        Tue,  3 Jan 2023 10:39:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9A21B810AA;
        Tue,  3 Jan 2023 18:39:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A88C433F1;
        Tue,  3 Jan 2023 18:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672771195;
        bh=jktih1V+pEJSNMJGLXpJMhxqZlHX4fppjmcyULYa1Ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=coPo01GgIzfcYW4dKKFpwZ5V1UdEC/7xd53rxop8aDsOV/gbmwDt8kuCktljidEmh
         xAzyNozER4wkseAYJV9FetPkDokjUwOWu+6V4T4d01+ueEPapwNGQ78r8nOX5E7lVv
         Xk9Kde49FTv5iS7RjPJoK6haQbwzNvwPYhZI2dMPnjP+z7OLXhFGH5kRMbrij6l0rG
         ZtoAijflwMYiStPT98Jf7hq7ZC+MT2FJ2H0jMFLbcPSCtm2uQ/fXQuO3HhZ6KGELB6
         kR4GtN1dUsB0L1/AfbWCNtXeUzbm5fNJ+1N0lZVDx9LOhe6V1db/Afd289ES0xWZ3j
         ReFKsmEtqfnHQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Sasha Levin <sashal@kernel.org>, axboe@fb.com,
        sagi@grimberg.me, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 6.1 10/10] nvme: also return I/O command effects from nvme_command_effects
Date:   Tue,  3 Jan 2023 13:39:34 -0500
Message-Id: <20230103183934.2022663-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230103183934.2022663-1-sashal@kernel.org>
References: <20230103183934.2022663-1-sashal@kernel.org>
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
index 108b5022cead..1ded96d1bfd2 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1069,6 +1069,18 @@ static u32 nvme_known_admin_effects(u8 opcode)
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
@@ -1076,16 +1088,24 @@ u32 nvme_command_effects(struct nvme_ctrl *ctrl, struct nvme_ns *ns, u8 opcode)
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

