Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C123592222
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241305AbiHNPpC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:45:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232109AbiHNPnS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:43:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 766111C13D;
        Sun, 14 Aug 2022 08:33:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35B0D60D24;
        Sun, 14 Aug 2022 15:33:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50392C433C1;
        Sun, 14 Aug 2022 15:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491227;
        bh=XpSNX1f32Q6TMFam1wAor2QPc0RbNk2vlmC0HXRK4HU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nTDA0yUXb67z4KaGnZuOrP2Q2E0+03ffR51ILznesG+ZLq3f4m/MN9zTfZWYB05YR
         eRtYRkbfugxmP64vfnv2UzGAX1qG/EpjLHVMAtpyu+AUm5u/if1c2iln1dvArmQc+T
         wqAFWv39ke/nm8q+YSxHsqPyUt4ZMG4Vzjduit++56JlH07oczC6iBORjnNLKePmfJ
         StynqrNXV80CxghsIITPCZ+xnxPQSCBP0/OX9n6BY6Q0awzmN0XsaZxS3YAxdQ2AVl
         zee97TRXTmy8voZOwuMbrQvQKUS3z11e1O3Op/Tx2fb2GcnMCrShh6po8d/7Freufe
         LnbrNfKNNCzpQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oded Gabbay <ogabbay@kernel.org>, Sasha Levin <sashal@kernel.org>,
        gregkh@linuxfoundation.org, osharabi@habana.ai, obitton@habana.ai,
        ttayar@habana.ai, ynudelman@habana.ai, dliberman@habana.ai,
        fkassabri@habana.ai, dhirschfeld@habana.ai
Subject: [PATCH AUTOSEL 5.15 26/46] habanalabs/gaudi: mask constant value before cast
Date:   Sun, 14 Aug 2022 11:32:27 -0400
Message-Id: <20220814153247.2378312-26-sashal@kernel.org>
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

From: Oded Gabbay <ogabbay@kernel.org>

[ Upstream commit e3f49437a2e0221a387ecd192d742ae1434e1e3a ]

This fixes a sparse warning of
"cast truncates bits from constant value"

Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/gaudi/gaudi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/habanalabs/gaudi/gaudi.c b/drivers/misc/habanalabs/gaudi/gaudi.c
index 801acab048eb..8132200dca67 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi.c
@@ -3318,19 +3318,19 @@ static void gaudi_init_nic_qman(struct hl_device *hdev, u32 nic_offset,
 	u32 nic_qm_err_cfg, irq_handler_offset;
 	u32 q_off;
 
-	mtr_base_en_lo = lower_32_bits(CFG_BASE +
+	mtr_base_en_lo = lower_32_bits((CFG_BASE & U32_MAX) +
 			mmSYNC_MNGR_E_N_SYNC_MNGR_OBJS_MON_PAY_ADDRL_0);
 	mtr_base_en_hi = upper_32_bits(CFG_BASE +
 				mmSYNC_MNGR_E_N_SYNC_MNGR_OBJS_MON_PAY_ADDRL_0);
-	so_base_en_lo = lower_32_bits(CFG_BASE +
+	so_base_en_lo = lower_32_bits((CFG_BASE & U32_MAX) +
 				mmSYNC_MNGR_E_N_SYNC_MNGR_OBJS_SOB_OBJ_0);
 	so_base_en_hi = upper_32_bits(CFG_BASE +
 				mmSYNC_MNGR_E_N_SYNC_MNGR_OBJS_SOB_OBJ_0);
-	mtr_base_ws_lo = lower_32_bits(CFG_BASE +
+	mtr_base_ws_lo = lower_32_bits((CFG_BASE & U32_MAX) +
 				mmSYNC_MNGR_W_S_SYNC_MNGR_OBJS_MON_PAY_ADDRL_0);
 	mtr_base_ws_hi = upper_32_bits(CFG_BASE +
 				mmSYNC_MNGR_W_S_SYNC_MNGR_OBJS_MON_PAY_ADDRL_0);
-	so_base_ws_lo = lower_32_bits(CFG_BASE +
+	so_base_ws_lo = lower_32_bits((CFG_BASE & U32_MAX) +
 				mmSYNC_MNGR_W_S_SYNC_MNGR_OBJS_SOB_OBJ_0);
 	so_base_ws_hi = upper_32_bits(CFG_BASE +
 				mmSYNC_MNGR_W_S_SYNC_MNGR_OBJS_SOB_OBJ_0);
-- 
2.35.1

