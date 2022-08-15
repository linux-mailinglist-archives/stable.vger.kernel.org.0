Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D63F6593F84
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346557AbiHOUyO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346562AbiHOUw6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:52:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8674F6443;
        Mon, 15 Aug 2022 12:10:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2A14B81109;
        Mon, 15 Aug 2022 19:10:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C0EC433C1;
        Mon, 15 Aug 2022 19:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590638;
        bh=VTOtyVBISkeg2LXdvA8xIlbkH26cTOLWS3LXku/n0/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YT9bGNZPjFfY6mKC5DpC6BcU2lsM9F/K+6tW9f7wbK2yOp+t4TjhRXq1WOltX3dFD
         VpeBeovovTMFBPelWkQR2Ly9YkRcNHKMEWvJLVFlwCIcMjthhYecj4to4RZwAa6XGE
         f9mZnVlIVY4eYGLBtOJx8NY6al2fCV3QwjGk8dPQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jitao Shi <jitao.shi@mediatek.com>,
        Xinlei Lee <xinlei.lee@mediatek.com>,
        Rex-BC Chen <rex-bc.chen@mediatek.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0323/1095] drm/mediatek: Add pull-down MIPI operation in mtk_dsi_poweroff function
Date:   Mon, 15 Aug 2022 19:55:22 +0200
Message-Id: <20220815180443.146895295@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index 3a6ee6e9ad2c..f0f523bdafb8 100644
--- a/drivers/gpu/drm/mediatek/mtk_dsi.c
+++ b/drivers/gpu/drm/mediatek/mtk_dsi.c
@@ -682,6 +682,8 @@ static void mtk_dsi_poweroff(struct mtk_dsi *dsi)
 	mtk_dsi_reset_engine(dsi);
 	mtk_dsi_lane0_ulp_mode_enter(dsi);
 	mtk_dsi_clk_ulp_mode_enter(dsi);
+	/* set the lane number as 0 to pull down mipi */
+	writel(0, dsi->regs + DSI_TXRX_CTRL);
 
 	mtk_dsi_disable(dsi);
 
-- 
2.35.1



