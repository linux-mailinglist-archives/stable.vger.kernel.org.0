Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8919A657DDB
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234045AbiL1Prl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:47:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234088AbiL1Pr1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:47:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B79AF63
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:47:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2AFBD6156E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:47:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B9E4C433D2;
        Wed, 28 Dec 2022 15:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242445;
        bh=Vs2THPZN1bFtpTqzRY0XrXk4Nj4RfuADrKV69XLaEak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RGEVocwSuvs92p8jIV0vRyckMHYncjgBKM0AgCFgnzg3dJQTFiWZ4ZP22Gykslz+7
         G4kU95dxFZY1egPypIzToUHFRN5nwck1kozyx8Dp1rLO6Bvd2Ibxx4LV0oAeSLG6LB
         57Z/Y4Etol6U1pHTC+QFtlj2snd16Cg2R4YaFPaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Chun-Jie Chen <chun-jie.chen@mediatek.com>,
        Allen-KH Cheng <allen-kh.cheng@mediatek.com>,
        Chen-Yu Tsai <wenst@chromium.org>,
        Miles Chen <miles.chen@mediatek.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 604/731] soc: mediatek: pm-domains: Fix the power glitch issue
Date:   Wed, 28 Dec 2022 15:41:51 +0100
Message-Id: <20221228144314.044471070@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Chun-Jie Chen <chun-jie.chen@mediatek.com>

[ Upstream commit dba8eb83af9dd757ef645b52200775e86883d858 ]

Power reset maybe generate unexpected signal. In order to avoid
the glitch issue, we need to enable isolation first to guarantee the
stable signal when power reset is triggered.

Fixes: 59b644b01cf4 ("soc: mediatek: Add MediaTek SCPSYS power domains")
Signed-off-by: Chun-Jie Chen <chun-jie.chen@mediatek.com>
Signed-off-by: Allen-KH Cheng <allen-kh.cheng@mediatek.com>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Miles Chen <miles.chen@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20221014102029.1162-1-allen-kh.cheng@mediatek.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/mediatek/mtk-pm-domains.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/mediatek/mtk-pm-domains.c b/drivers/soc/mediatek/mtk-pm-domains.c
index afd2fd74802d..52ecde8e446c 100644
--- a/drivers/soc/mediatek/mtk-pm-domains.c
+++ b/drivers/soc/mediatek/mtk-pm-domains.c
@@ -272,9 +272,9 @@ static int scpsys_power_off(struct generic_pm_domain *genpd)
 	clk_bulk_disable_unprepare(pd->num_subsys_clks, pd->subsys_clks);
 
 	/* subsys power off */
-	regmap_clear_bits(scpsys->base, pd->data->ctl_offs, PWR_RST_B_BIT);
 	regmap_set_bits(scpsys->base, pd->data->ctl_offs, PWR_ISO_BIT);
 	regmap_set_bits(scpsys->base, pd->data->ctl_offs, PWR_CLK_DIS_BIT);
+	regmap_clear_bits(scpsys->base, pd->data->ctl_offs, PWR_RST_B_BIT);
 	regmap_clear_bits(scpsys->base, pd->data->ctl_offs, PWR_ON_2ND_BIT);
 	regmap_clear_bits(scpsys->base, pd->data->ctl_offs, PWR_ON_BIT);
 
-- 
2.35.1



