Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99A175920CB
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240320AbiHNPa4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240466AbiHNPaC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:30:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FDA812AC9;
        Sun, 14 Aug 2022 08:29:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F5A5B80B4D;
        Sun, 14 Aug 2022 15:29:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E8CC433D7;
        Sun, 14 Aug 2022 15:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660490956;
        bh=fNAOU3nn93Lkm95oCUBoM40Bm7uOivsDjII/2NQw4E8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bOVnXQbxQeSFv2ShricM+qfU4X+8mJHkQI/bjT2ALGJb2P4i9wYZzSiKo54WbQxSE
         5JFzpASJpVY/M4shLx22HYCVdGn9XfkN+DIqe5jwT1iBaYdym3vBgpUD3ZQH/4EGPM
         6Xsfem3jgkgKFjnf2Mqi57MvM5ZKYn8BZwWH6HuWOfVYtGO7RjDNqdcbpnejrg9FeI
         lfSGQczNA+x5Kf8ttIuTVzTYllX5qhS+EsmxKAmxZ0JoBB1g3t8mLebE3Pf27vzgCl
         XbcI/vAVv6u2BNnHx8I40iB72o+fEzS33/wVlpICcb/E96vPtCy05p+NP+rQNyaYvV
         iJExjKMIEezzg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oded Gabbay <ogabbay@kernel.org>, Sasha Levin <sashal@kernel.org>,
        gregkh@linuxfoundation.org, osharabi@habana.ai, obitton@habana.ai,
        ttayar@habana.ai, ynudelman@habana.ai, dliberman@habana.ai,
        fkassabri@habana.ai, dhirschfeld@habana.ai
Subject: [PATCH AUTOSEL 5.19 36/64] habanalabs/gaudi: mask constant value before cast
Date:   Sun, 14 Aug 2022 11:24:09 -0400
Message-Id: <20220814152437.2374207-36-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814152437.2374207-1-sashal@kernel.org>
References: <20220814152437.2374207-1-sashal@kernel.org>
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
index 3fb221f2e393..b33616aacb33 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi.c
@@ -3339,19 +3339,19 @@ static void gaudi_init_nic_qman(struct hl_device *hdev, u32 nic_offset,
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

