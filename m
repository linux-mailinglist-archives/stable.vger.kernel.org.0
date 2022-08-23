Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2313459DF15
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353286AbiHWK1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354438AbiHWKZh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:25:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD790A4054;
        Tue, 23 Aug 2022 02:05:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A1036158C;
        Tue, 23 Aug 2022 09:05:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B71C433C1;
        Tue, 23 Aug 2022 09:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245501;
        bh=vtRXCHze60S9N+iuu3PGeK93PaQSS+De1RgKrNFEUBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x/HusN+Ae4yvwFpTWZuoSp8NF+IdXf3jdljKxbIObVjXBR32RTZF/J+k8sylpzyL9
         bRtVwwC5Q8HBRDal8z3o/58hy+V8GwZfPs5XV3f3f5ba95YQzwy9tyzllpCuScw4De
         Dij1n70jq4XObPXF5pofkigM2RUlTxaKUwCQzPiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jitao Shi <jitao.shi@mediatek.com>,
        Xinlei Lee <xinlei.lee@mediatek.com>,
        Rex-BC Chen <rex-bc.chen@mediatek.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 071/287] drm/mediatek: Add pull-down MIPI operation in mtk_dsi_poweroff function
Date:   Tue, 23 Aug 2022 10:24:00 +0200
Message-Id: <20220823080102.623144799@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xinlei Lee <xinlei.lee@mediatek.com>

[ Upstream commit fa5d0a0205c34734c5b8daa77e39ac2817f63a10 ]

In the dsi_enable function, mtk_dsi_rxtx_control is to
pull up the MIPI signal operation. Before dsi_disable,
MIPI should also be pulled down by writing a register
instead of disabling dsi.

If disable dsi without pulling the mipi signal low, the value of
the register will still maintain the setting of the mipi signal being
pulled high.
After resume, even if the mipi signal is not pulled high, it will still
be in the high state.

Fixes: 2e54c14e310f ("drm/mediatek: Add DSI sub driver")

Link: https://patchwork.kernel.org/project/linux-mediatek/patch/1653012007-11854-5-git-send-email-xinlei.lee@mediatek.com/
Signed-off-by: Jitao Shi <jitao.shi@mediatek.com>
Signed-off-by: Xinlei Lee <xinlei.lee@mediatek.com>
Reviewed-by: Rex-BC Chen <rex-bc.chen@mediatek.com>
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_dsi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/mediatek/mtk_dsi.c b/drivers/gpu/drm/mediatek/mtk_dsi.c
index 0dd317ac5fe5..a629a69c2756 100644
--- a/drivers/gpu/drm/mediatek/mtk_dsi.c
+++ b/drivers/gpu/drm/mediatek/mtk_dsi.c
@@ -651,6 +651,8 @@ static void mtk_dsi_poweroff(struct mtk_dsi *dsi)
 	mtk_dsi_reset_engine(dsi);
 	mtk_dsi_lane0_ulp_mode_enter(dsi);
 	mtk_dsi_clk_ulp_mode_enter(dsi);
+	/* set the lane number as 0 to pull down mipi */
+	writel(0, dsi->regs + DSI_TXRX_CTRL);
 
 	mtk_dsi_disable(dsi);
 
-- 
2.35.1



