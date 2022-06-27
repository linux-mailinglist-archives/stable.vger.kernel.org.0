Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 318F855E2FD
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234782AbiF0LYk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234741AbiF0LYX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:24:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC1726579;
        Mon, 27 Jun 2022 04:24:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 685A261366;
        Mon, 27 Jun 2022 11:24:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60DD3C3411D;
        Mon, 27 Jun 2022 11:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329061;
        bh=fNCokIlPXv3LxEl/Ny3/4Y5p9HvmwaTsoXsf4L9t5Is=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M9Szu7tcYjnvk1UouvUTal9jYadGaSTcerZOgXvBhom+CHECGVQtc3VUs8z1imx6x
         OhPZj9d80mlCVXy/RQVikZHgzcUZppC2VvvncE9zRlvXt5PdaQMGaZy5PsCSac8wuj
         nUYitUVY35H2lFGTVRcWDLHstZs/ROLsQ/+jyzTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 036/102] drm/msm/mdp4: Fix refcount leak in mdp4_modeset_init_intf
Date:   Mon, 27 Jun 2022 13:20:47 +0200
Message-Id: <20220627111934.535322164@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111933.455024953@linuxfoundation.org>
References: <20220627111933.455024953@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit b9cc4598607cb7f7eae5c75fc1e3209cd52ff5e0 ]

of_graph_get_remote_node() returns remote device node pointer with
refcount incremented, we should use of_node_put() on it
when not need anymore.
Add missing of_node_put() to avoid refcount leak.

Fixes: 86418f90a4c1 ("drm: convert drivers to use of_graph_get_remote_node")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/488473/
Link: https://lore.kernel.org/r/20220607110841.53889-1-linmq006@gmail.com
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c b/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
index 913de5938782..b4d0bfc83d70 100644
--- a/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
+++ b/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
@@ -221,6 +221,7 @@ static int mdp4_modeset_init_intf(struct mdp4_kms *mdp4_kms,
 		encoder = mdp4_lcdc_encoder_init(dev, panel_node);
 		if (IS_ERR(encoder)) {
 			DRM_DEV_ERROR(dev->dev, "failed to construct LCDC encoder\n");
+			of_node_put(panel_node);
 			return PTR_ERR(encoder);
 		}
 
@@ -230,6 +231,7 @@ static int mdp4_modeset_init_intf(struct mdp4_kms *mdp4_kms,
 		connector = mdp4_lvds_connector_init(dev, panel_node, encoder);
 		if (IS_ERR(connector)) {
 			DRM_DEV_ERROR(dev->dev, "failed to initialize LVDS connector\n");
+			of_node_put(panel_node);
 			return PTR_ERR(connector);
 		}
 
-- 
2.35.1



