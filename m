Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5F53C5232
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349944AbhGLHpC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:45:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:49232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348811AbhGLHlY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:41:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 319FC601FE;
        Mon, 12 Jul 2021 07:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075515;
        bh=Auz1i9Vu8ZGHbO+T/8MnQgeUUVcxEUmWz8KkWj4sn7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nrj9Jr6lDGhI1ATMPIgDWiPbRUQ5UClbYjTrUPEqUkbCUnkw1rmqAdcAeoEgkRhsz
         lKXsA8LOGUAnH+xdvZu/qFoXptL8nLXTOpkSEmITeT0L2lP2oMq45IMFQ+ovaDUnks
         vYBviXtMVKhUuQVCZBPc4zxTQOA6VRi+OtLkL44k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Hsin-Hsiung Wang <hsin-hsiung.wang@mediatek.com>,
        Axel Lin <axel.lin@ingics.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 204/800] regulator: mt6358: Fix vdram2 .vsel_mask
Date:   Mon, 12 Jul 2021 08:03:47 +0200
Message-Id: <20210712060941.915450819@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 13cb6ac9a892..1d4eb5dc4fac 100644
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



