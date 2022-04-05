Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA17C4F2BD6
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236928AbiDEJDq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237048AbiDEIRk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:17:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC6CAFB30;
        Tue,  5 Apr 2022 01:05:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BBC4B81BBC;
        Tue,  5 Apr 2022 08:04:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B082BC385A0;
        Tue,  5 Apr 2022 08:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145897;
        bh=jl+4nCqhoplCL8BSTrcvMb6idHEZMgoKG46ObsEUPOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ETs7QbbRa9bpUVJIUx57mcHFp2iMrjLVzCJM+A2UAPx7wYCzDtdDPrkA6MIOY4QNQ
         qGZ+0218nSIGyzmB2Im8noDft1y0Zex9gvrNO1RF1eh5+y7sHGGsbN6by5Zp3SIe4D
         bu1OkGHynlmdllsskyJY6GI+S3Yjr1KcFExnbhOI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuogee Hsieh <quic_khsieh@quicinc.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0569/1126] drm/msm/dp: always add fail-safe mode into connector mode list
Date:   Tue,  5 Apr 2022 09:21:56 +0200
Message-Id: <20220405070424.335567219@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

[ Upstream commit d4aca422539c441a7f3fec749287b36de37d9b6b ]

Some of DP link compliant test expects to return fail-safe mode
if prefer detailed timing mode can not be supported by mainlink's
lane and rate after link training. Therefore add fail-safe mode
into connector mode list as backup mode. This patch fixes test
case 4.2.2.1.

Changes in v2:
-- add Fixes text string

Fixes: 4b85d405cfe9 ( "drm/msm/dp: reduce link rate if failed at link training 1")
Signed-off-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/1643066274-25814-1-git-send-email-quic_khsieh@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_panel.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/msm/dp/dp_panel.c b/drivers/gpu/drm/msm/dp/dp_panel.c
index 71db10c0f262..f1418722c549 100644
--- a/drivers/gpu/drm/msm/dp/dp_panel.c
+++ b/drivers/gpu/drm/msm/dp/dp_panel.c
@@ -212,6 +212,11 @@ int dp_panel_read_sink_caps(struct dp_panel *dp_panel,
 		if (drm_add_modes_noedid(connector, 640, 480))
 			drm_set_preferred_mode(connector, 640, 480);
 		mutex_unlock(&connector->dev->mode_config.mutex);
+	} else {
+		/* always add fail-safe mode as backup mode */
+		mutex_lock(&connector->dev->mode_config.mutex);
+		drm_add_modes_noedid(connector, 640, 480);
+		mutex_unlock(&connector->dev->mode_config.mutex);
 	}
 
 	if (panel->aux_cfg_update_done) {
-- 
2.34.1



