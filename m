Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1235EA31B
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237651AbiIZLTm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237794AbiIZLTA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:19:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A4266132;
        Mon, 26 Sep 2022 03:38:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE2C760C07;
        Mon, 26 Sep 2022 10:36:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2251C433C1;
        Mon, 26 Sep 2022 10:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188602;
        bh=WEEfMD2dT1tFkX8ppiPqb6orrscDsDIG1alo8oNgaC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SWuRq9heBZQ7UwruvU7pIzRLfqTmrP2OKe4lMsKvko0/9z32IBBDY0z9ufxfSxPPX
         wkBMxXKM5rqLg8U56tWppdBwQVIUvnp7GTvbELWjbf2J9qK4/WXeKvIZoKf6G4DSYO
         rrtmcOtgYTD/u9o0rTY4Zwhs7xmQfVLnDTlGqOB8=
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
Subject: [PATCH 5.15 062/148] drm/mediatek: dsi: Add atomic {destroy,duplicate}_state, reset callbacks
Date:   Mon, 26 Sep 2022 12:11:36 +0200
Message-Id: <20220926100758.363532229@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
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
index ac14e598a14f..fc437d4d4e2d 100644
--- a/drivers/gpu/drm/mediatek/mtk_dsi.c
+++ b/drivers/gpu/drm/mediatek/mtk_dsi.c
@@ -796,10 +796,13 @@ static void mtk_dsi_bridge_atomic_post_disable(struct drm_bridge *bridge,
 
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



