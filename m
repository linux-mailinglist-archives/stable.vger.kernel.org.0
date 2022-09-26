Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03E785EA1E5
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236977AbiIZLAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237090AbiIZK6q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:58:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378525AC5B;
        Mon, 26 Sep 2022 03:30:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C606A60C13;
        Mon, 26 Sep 2022 10:29:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F52C433D6;
        Mon, 26 Sep 2022 10:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188171;
        bh=YYTFbARachQY8D+x5GJQOXKPYgbQ+8PCBvzfA+jz50c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d7VRM57vd77C53bTPZLAUveK+MQIMkUJ+mAR46cIzrsmmG0ZZtXmeI3uWVKVWiJKb
         zYQ5Fxs9ysoR9FxAXFzTzV34TbBG229NCJ7FaU0nMIAW5kGSyp3ZdCIH5W9hMS1/6D
         8r8gTiAdS5w3LcYYAHU5d9ROUHyK01TZYyRFH+2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Chen-Yu Tsai <wenst@chromium.org>,
        "=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" 
        <nfraprado@collabora.com>, Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 064/141] drm/mediatek: dsi: Add atomic {destroy,duplicate}_state, reset callbacks
Date:   Mon, 26 Sep 2022 12:11:30 +0200
Message-Id: <20220926100756.761322528@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAD_ENC_HEADER,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit eeda05b5e92f51d9a09646ecb493f0a1e872a6ef ]

Add callbacks for atomic_destroy_state, atomic_duplicate_state and
atomic_reset to restore functionality of the DSI driver: this solves
vblank timeouts when another bridge is present in the chain.

Tested bridge chain: DSI <=> ANX7625 => aux-bus panel

Fixes: 7f6335c6a258 ("drm/mediatek: Modify dsi funcs to atomic operations")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Tested-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Tested-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Link: https://patchwork.kernel.org/project/linux-mediatek/patch/20220721172727.14624-1-angelogioacchino.delregno@collabora.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_dsi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/mediatek/mtk_dsi.c b/drivers/gpu/drm/mediatek/mtk_dsi.c
index 7d37d2a01e3c..b8c1a3c1c517 100644
--- a/drivers/gpu/drm/mediatek/mtk_dsi.c
+++ b/drivers/gpu/drm/mediatek/mtk_dsi.c
@@ -791,10 +791,13 @@ static void mtk_dsi_bridge_atomic_post_disable(struct drm_bridge *bridge,
 
 static const struct drm_bridge_funcs mtk_dsi_bridge_funcs = {
 	.attach = mtk_dsi_bridge_attach,
+	.atomic_destroy_state = drm_atomic_helper_bridge_destroy_state,
 	.atomic_disable = mtk_dsi_bridge_atomic_disable,
+	.atomic_duplicate_state = drm_atomic_helper_bridge_duplicate_state,
 	.atomic_enable = mtk_dsi_bridge_atomic_enable,
 	.atomic_pre_enable = mtk_dsi_bridge_atomic_pre_enable,
 	.atomic_post_disable = mtk_dsi_bridge_atomic_post_disable,
+	.atomic_reset = drm_atomic_helper_bridge_reset,
 	.mode_set = mtk_dsi_bridge_mode_set,
 };
 
-- 
2.35.1



