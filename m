Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E169548EB2
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343491AbiFMKpC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:45:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345302AbiFMKn2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:43:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC283D114;
        Mon, 13 Jun 2022 03:24:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56C0260EF8;
        Mon, 13 Jun 2022 10:24:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E361C34114;
        Mon, 13 Jun 2022 10:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115869;
        bh=sKX0f2rm6Nc1YFGOFE/L3d9cw9EMLZUO6+aNCr12AxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bEcecxQjrxNd+DcCc5+exRweSLSP4kJCha/9eLHaccUlDuT3lx1Pd5NW7cnb2QPqT
         6eT8d6j6Ml+swhqYzNCG7KuPSBcYQq8CdFRhFya6jbgAmNu1thJnpAUcC2E8N3wnQt
         Md3q5sy6nrs7cKloT5Y61q8J+EnPGBvpFwRnyLjA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miles Chen <miles.chen@mediatek.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Zhiqiang Lin <zhiqiang.lin@mediatek.com>,
        CK Hu <ck.hu@mediatek.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 052/218] drm/mediatek: Fix mtk_cec_mask()
Date:   Mon, 13 Jun 2022 12:08:30 +0200
Message-Id: <20220613094920.619626463@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094908.257446132@linuxfoundation.org>
References: <20220613094908.257446132@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miles Chen <miles.chen@mediatek.com>

[ Upstream commit 2c5d69b0a141e1e98febe3111e6f4fd8420493a5 ]

In current implementation, mtk_cec_mask() writes val into target register
and ignores the mask. After talking to our hdmi experts, mtk_cec_mask()
should read a register, clean only mask bits, and update (val | mask) bits
to the register.

Link: https://patchwork.kernel.org/project/linux-mediatek/patch/20220315232301.2434-1-miles.chen@mediatek.com/
Fixes: 8f83f26891e1 ("drm/mediatek: Add HDMI support")
Signed-off-by: Miles Chen <miles.chen@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Zhiqiang Lin <zhiqiang.lin@mediatek.com>
Cc: CK Hu <ck.hu@mediatek.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_cec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_cec.c b/drivers/gpu/drm/mediatek/mtk_cec.c
index 7a3eb8c17ef9..4e5482986dc2 100644
--- a/drivers/gpu/drm/mediatek/mtk_cec.c
+++ b/drivers/gpu/drm/mediatek/mtk_cec.c
@@ -91,7 +91,7 @@ static void mtk_cec_mask(struct mtk_cec *cec, unsigned int offset,
 	u32 tmp = readl(cec->regs + offset) & ~mask;
 
 	tmp |= val & mask;
-	writel(val, cec->regs + offset);
+	writel(tmp, cec->regs + offset);
 }
 
 void mtk_cec_set_hpd_event(struct device *dev,
-- 
2.35.1



