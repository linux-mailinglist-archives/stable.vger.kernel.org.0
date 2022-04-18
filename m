Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C413E50509B
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238546AbiDRM0t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238645AbiDRM0V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:26:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6487911156;
        Mon, 18 Apr 2022 05:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27060B80ED7;
        Mon, 18 Apr 2022 12:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68094C385A9;
        Mon, 18 Apr 2022 12:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284416;
        bh=wEqibby7SYUMkpvEnUyHpNDzShDLniGv9sMnw42cP9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZgvaTJh9+LigtGyg66NAR5yhabTW35bAf39sHgN63vzH2OB30nIIw2FSEHLq5qkY0
         xynXq7a6lDa/YjdPRKY4k/PU76bxjz76POyPT+6TyFxq+b9NTx+y9TS1rT8IsppjF4
         BZptR1VGCbR2oYhJPCIoKkaOt5GJsOUTbN+CYMPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sean Paul <seanpaul@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 091/219] drm/msm/dsi: Use connector directly in msm_dsi_manager_connector_init()
Date:   Mon, 18 Apr 2022 14:11:00 +0200
Message-Id: <20220418121209.149093580@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit 47b7de6b88b962ef339a2427a023d2a23d161654 ]

The member 'msm_dsi->connector' isn't assigned until
msm_dsi_manager_connector_init() returns (see msm_dsi_modeset_init() and
how it assigns the return value). Therefore this pointer is going to be
NULL here. Let's use 'connector' which is what was intended.

Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: Sean Paul <seanpaul@chromium.org>
Fixes: 6d5e78406991 ("drm/msm/dsi: Move dsi panel init into modeset init path")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/478693/
Link: https://lore.kernel.org/r/20220318000731.2823718-1-swboyd@chromium.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_manager.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_manager.c b/drivers/gpu/drm/msm/dsi/dsi_manager.c
index f19bae475c96..cd7b41b7d518 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_manager.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_manager.c
@@ -641,7 +641,7 @@ struct drm_connector *msm_dsi_manager_connector_init(u8 id)
 	return connector;
 
 fail:
-	connector->funcs->destroy(msm_dsi->connector);
+	connector->funcs->destroy(connector);
 	return ERR_PTR(ret);
 }
 
-- 
2.35.1



