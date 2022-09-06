Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9195AEBBE
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233270AbiIFOAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240669AbiIFN6N (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:58:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC9B182D01;
        Tue,  6 Sep 2022 06:42:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49FF2B8162F;
        Tue,  6 Sep 2022 13:41:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F2BC433D7;
        Tue,  6 Sep 2022 13:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471700;
        bh=eRs0J5tzpn54uD4h7rQQv0l+Vqhz6Xssugk/gCLIuNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RNGsOHYsJ1YcNiQiHLCBOpSX7FvyOmkQcfbK3TS5rXz9WI6uUpI1612fdMeUuhNI0
         cUlrxW0XR5CeK61Pk5gMF+wFlx5/8VGn4Fi8xUN/9BmPTd9pOdJiVDMXVrxIhncFYf
         DTuoLAb3/wim4t9CQ82wCYG9N4f3j8X72yuJH2aA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuogee Hsieh <quic_khsieh@quicinc.com>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Douglas Anderson <dianders@chromium.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 001/155] drm/msm/dp: make eDP panel as the first connected connector
Date:   Tue,  6 Sep 2022 15:29:09 +0200
Message-Id: <20220906132829.483548687@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
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

From: Kuogee Hsieh <quic_khsieh@quicinc.com>

[ Upstream commit deffa2d75db7e7a9a1fe3dad4f99310bff7b6449 ]

Some userspace presumes that the first connected connector is the main
display, where it's supposed to display e.g. the login screen. For
laptops, this should be the main panel.

This patch call drm_helper_move_panel_connectors_to_head() after
drm_bridge_connector_init() to make sure eDP stay at head of
connected connector list. This fixes unexpected corruption happen
at eDP panel if eDP is not placed at head of connected connector
list.

Changes in v2:
-- move drm_helper_move_panel_connectors_to_head() to
		dpu_kms_drm_obj_init()

Changes in v4:
-- move drm_helper_move_panel_connectors_to_head() to msm_drm_init()

Signed-off-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Fixes: ef7837ff091c ("drm/msm/dp: Add DP controllers for sc7280")
Patchwork: https://patchwork.freedesktop.org/patch/492581/
Link: https://lore.kernel.org/r/1657135928-31195-1-git-send-email-quic_khsieh@quicinc.com
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index 14ab9a627d8b0..7c0314d6566af 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -424,6 +424,8 @@ static int msm_drm_init(struct device *dev, const struct drm_driver *drv)
 		}
 	}
 
+	drm_helper_move_panel_connectors_to_head(ddev);
+
 	ddev->mode_config.funcs = &mode_config_funcs;
 	ddev->mode_config.helper_private = &mode_config_helper_funcs;
 
-- 
2.35.1



