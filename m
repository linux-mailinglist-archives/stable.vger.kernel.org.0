Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1563BB36B
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232809AbhGDXSG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:18:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:57074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233894AbhGDXOo (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:14:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 786D56144E;
        Sun,  4 Jul 2021 23:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440240;
        bh=w9dbD+sdlf57EC9sS/z688WVEVIgvZnb6vC79ehbFsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i2TFkGBigiAFuKcZrixxhFS31AhEbD61ZCiu0yanoj8wKcy40Zo+FbCkurDqwrb5k
         l6YwHe1J3RxFs8sZ9YpizrgfTGGX2wLMY4LwicPEeOR0qXbkqOkrbMyzPmgZ3njz8B
         mIR0//uRqhqy9cHb0YjTJ3kfmH8ddnjDZ5zRpl7PZNSgy8oodMh8vmCaOCRZPHqfXc
         LhHvmkoNsKO5yLFSNxCeb55h3jfvWkFpKmXMT1xSz5gxum5cjYWsAvfXRK4Tkmzi9t
         dsWzOnO8+166Fl69WZE3/jEbkiQ58sxGTJGtVhgr8hU6lVu49t1LZg3wMPukwS9eYN
         wVIjsGpMe4OXA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hsin-Hsiung Wang <hsin-hsiung.wang@mediatek.com>,
        Axel Lin <axel.lin@ingics.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 48/50] regulator: mt6358: Fix vdram2 .vsel_mask
Date:   Sun,  4 Jul 2021 19:09:36 -0400
Message-Id: <20210704230938.1490742-48-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230938.1490742-1-sashal@kernel.org>
References: <20210704230938.1490742-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hsin-Hsiung Wang <hsin-hsiung.wang@mediatek.com>

[ Upstream commit 50c9462edcbf900f3d5097ca3ad60171346124de ]

The valid vsel value are 0 and 12, so the .vsel_mask should be 0xf.

Signed-off-by: Hsin-Hsiung Wang <hsin-hsiung.wang@mediatek.com>
Reviewed-by: Axel Lin <axel.lin@ingics.com>
Link: https://lore.kernel.org/r/1624424169-510-1-git-send-email-hsin-hsiung.wang@mediatek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/mt6358-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/mt6358-regulator.c b/drivers/regulator/mt6358-regulator.c
index ba42682e06f3..40e09b1d323d 100644
--- a/drivers/regulator/mt6358-regulator.c
+++ b/drivers/regulator/mt6358-regulator.c
@@ -457,7 +457,7 @@ static struct mt6358_regulator_info mt6358_regulators[] = {
 	MT6358_REG_FIXED("ldo_vaud28", VAUD28,
 			 MT6358_LDO_VAUD28_CON0, 0, 2800000),
 	MT6358_LDO("ldo_vdram2", VDRAM2, vdram2_voltages, vdram2_idx,
-		   MT6358_LDO_VDRAM2_CON0, 0, MT6358_LDO_VDRAM2_ELR0, 0x10, 0),
+		   MT6358_LDO_VDRAM2_CON0, 0, MT6358_LDO_VDRAM2_ELR0, 0xf, 0),
 	MT6358_LDO("ldo_vsim1", VSIM1, vsim_voltages, vsim_idx,
 		   MT6358_LDO_VSIM1_CON0, 0, MT6358_VSIM1_ANA_CON0, 0xf00, 8),
 	MT6358_LDO("ldo_vibr", VIBR, vibr_voltages, vibr_idx,
-- 
2.30.2

