Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC5B5F2981
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbiJCHUe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbiJCHTD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:19:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB7A4371BA;
        Mon,  3 Oct 2022 00:15:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7778E60F9F;
        Mon,  3 Oct 2022 07:14:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A84C433C1;
        Mon,  3 Oct 2022 07:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781288;
        bh=lrsdqu+BAskSM20BQvvpxStKuyljtS3aDCsayyh4pxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c1f7qxj/3i7pdNANqzhbDwRzhgRiK8iRu05HLdZSjz5x1CMpkr6EeLQtRMZ336Fgi
         rdGotnakxvmE3XJk5IhH7kWklyqIgR2ix71dXd44tGpMmsnnPFRGK08gOE/XkQaKUJ
         6T8ON7y72Yx6VH4+G/jQOpg136zpLnvY7i33Pczc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Norris <briannorris@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 067/101] Revert "drm: bridge: analogix/dp: add panel prepare/unprepare in suspend/resume time"
Date:   Mon,  3 Oct 2022 09:11:03 +0200
Message-Id: <20221003070726.139073944@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
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

From: Brian Norris <briannorris@chromium.org>

[ Upstream commit cc62d98bd56d45de4531844ca23913a15136c05b ]

This reverts commit 211f276ed3d96e964d2d1106a198c7f4a4b3f4c0.

For quite some time, core DRM helpers already ensure that any relevant
connectors/CRTCs/etc. are disabled, as well as their associated
components (e.g., bridges) when suspending the system. Thus,
analogix_dp_bridge_{enable,disable}() already get called, which in turn
call drm_panel_{prepare,unprepare}(). This makes these drm_panel_*()
calls redundant.

Besides redundancy, there are a few problems with this handling:

(1) drm_panel_{prepare,unprepare}() are *not* reference-counted APIs and
are not in general designed to be handled by multiple callers --
although some panel drivers have a coarse 'prepared' flag that mitigates
some damage, at least. So at a minimum this is redundant and confusing,
but in some cases, this could be actively harmful.

(2) The error-handling is a bit non-standard. We ignored errors in
suspend(), but handled errors in resume(). And recently, people noticed
that the clk handling is unbalanced in error paths, and getting *that*
right is not actually trivial, given the current way errors are mostly
ignored.

(3) In the particular way analogix_dp_{suspend,resume}() get used (e.g.,
in rockchip_dp_*(), as a late/early callback), we don't necessarily have
a proper PM relationship between the DP/bridge device and the panel
device. So while the DP bridge gets resumed, the panel's parent device
(e.g., platform_device) may still be suspended, and so any prepare()
calls may fail.

So remove the superfluous, possibly-harmful suspend()/resume() handling
of panel state.

Fixes: 211f276ed3d9 ("drm: bridge: analogix/dp: add panel prepare/unprepare in suspend/resume time")
Link: https://lore.kernel.org/all/Yv2CPBD3Picg%2FgVe@google.com/
Signed-off-by: Brian Norris <briannorris@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220822180729.1.I8ac5abe3a4c1c6fd5c061686c6e883c22f69022c@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
index 01c8b80e34ec..41431b9d55bd 100644
--- a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
+++ b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
@@ -1863,12 +1863,6 @@ EXPORT_SYMBOL_GPL(analogix_dp_remove);
 int analogix_dp_suspend(struct analogix_dp_device *dp)
 {
 	clk_disable_unprepare(dp->clock);
-
-	if (dp->plat_data->panel) {
-		if (drm_panel_unprepare(dp->plat_data->panel))
-			DRM_ERROR("failed to turnoff the panel\n");
-	}
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(analogix_dp_suspend);
@@ -1883,13 +1877,6 @@ int analogix_dp_resume(struct analogix_dp_device *dp)
 		return ret;
 	}
 
-	if (dp->plat_data->panel) {
-		if (drm_panel_prepare(dp->plat_data->panel)) {
-			DRM_ERROR("failed to setup the panel\n");
-			return -EBUSY;
-		}
-	}
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(analogix_dp_resume);
-- 
2.35.1



