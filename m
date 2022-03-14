Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C414D83CF
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240780AbiCNMVs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241879AbiCNMSc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:18:32 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786D41FCC1;
        Mon, 14 Mar 2022 05:13:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9FDB8CE1268;
        Mon, 14 Mar 2022 12:13:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D2CC340EC;
        Mon, 14 Mar 2022 12:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259987;
        bh=O0ug6X5FmoZy+XnlL4UfoS/smZJsR4Ea5iDiujXvNvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CNNFhF5NgmPTuYq2DXNRQNpDuHvhcceYdfHgY/okm59uqTLtHVrGlEynVfnLAyTOW
         IJHIUv9SX8gNmhRVAxHxTfXW0Nm6t/7rZCeXtxxt3uGyPfZ0k5gy4/4wHJ98GEntO0
         Lym7ywuHrJpDPtBSzAOfCIZ4wrcRywh4QYEd7uEY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        "=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" 
        <nfraprado@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 008/121] soc: mediatek: mt8192-mmsys: Fix dither to dsi0 paths input sel
Date:   Mon, 14 Mar 2022 12:53:11 +0100
Message-Id: <20220314112744.357937888@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
References: <20220314112744.120491875@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAD_ENC_HEADER,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit c432cd598a185afefba1ac3b0ee226f222f71341 ]

In commit d687e056a18f ("soc: mediatek: mmsys: Add mt8192 mmsys routing table"),
the mmsys routing table for mt8192 was introduced but the input selector
for DITHER->DSI0 has no value assigned to it.

This means that we are clearing bit 0 instead of setting it, blocking
communication between these two blocks; due to that, any display that
is connected to DSI0 will not work, as no data will go through.
The effect of that issue is that, during bootup, the DRM will block for
some time, while atomically waiting for a vblank that never happens;
later, the situation doesn't get better, leaving the display in a
non-functional state.

To fix this issue, fix the route entry in the table by assigning the
dither input selector to MT8192_DISP_DSI0_SEL_IN.

Fixes: d687e056a18f ("soc: mediatek: mmsys: Add mt8192 mmsys routing table")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Tested-by: Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
Reviewed-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Link: https://lore.kernel.org/r/20220128142056.359900-1-angelogioacchino.delregno@collabora.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/mediatek/mt8192-mmsys.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/mediatek/mt8192-mmsys.h b/drivers/soc/mediatek/mt8192-mmsys.h
index 6f0a57044a7b..6aae0b12b6ff 100644
--- a/drivers/soc/mediatek/mt8192-mmsys.h
+++ b/drivers/soc/mediatek/mt8192-mmsys.h
@@ -53,7 +53,8 @@ static const struct mtk_mmsys_routes mmsys_mt8192_routing_table[] = {
 		MT8192_AAL0_SEL_IN_CCORR0
 	}, {
 		DDP_COMPONENT_DITHER, DDP_COMPONENT_DSI0,
-		MT8192_DISP_DSI0_SEL_IN, MT8192_DSI0_SEL_IN_DITHER0
+		MT8192_DISP_DSI0_SEL_IN, MT8192_DSI0_SEL_IN_DITHER0,
+		MT8192_DSI0_SEL_IN_DITHER0
 	}, {
 		DDP_COMPONENT_RDMA0, DDP_COMPONENT_COLOR0,
 		MT8192_DISP_RDMA0_SOUT_SEL, MT8192_RDMA0_SOUT_COLOR0,
-- 
2.34.1



