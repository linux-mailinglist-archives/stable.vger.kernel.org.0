Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9A660A956
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbiJXNSf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234325AbiJXNRb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:17:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8166050F8B;
        Mon, 24 Oct 2022 05:26:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60E9A61281;
        Mon, 24 Oct 2022 12:22:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A0FC433D7;
        Mon, 24 Oct 2022 12:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614176;
        bh=Ro8YsoiH1vaVl94vaZKoWoomP6ZZtJl0riym3dzXH/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P0eKcMRtlc2ZgU+YGFcFyQbau6gIASEl6Ka6d2OzWrMw0RmjxVvJcBU8kcTRuLOiL
         qm0yPXt9O8GVl7OSh0zuNZpggOuuNTJ0G+TI3CWUcqW06s9Sx2/VFE8aGQ76L6Gu/Z
         uhRdO0GgxbO6qd2qTx4ySR4HYirgc+iQjbLmZgOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuogee Hsieh <quic_khsieh@quicinc.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 162/390] drm/msm/dp: correct 1.62G link rate at dp_catalog_ctrl_config_msa()
Date:   Mon, 24 Oct 2022 13:29:19 +0200
Message-Id: <20221024113029.610820560@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuogee Hsieh <quic_khsieh@quicinc.com>

[ Upstream commit aa0bff10af1c4b92e6b56e3e1b7f81c660d3ba78 ]

At current implementation there is an extra 0 at 1.62G link rate which
cause no correct pixel_div selected for 1.62G link rate to calculate
mvid and nvid. This patch delete the extra 0 to have mvid and nvid be
calculated correctly.

Changes in v2:
-- fix Fixes tag's text

Changes in v3:
-- fix misspelling of "Reviewed-by"

Fixes: 937f941ca06f  ("drm/msm/dp: Use qmp phy for DP PLL and PHY")
Signed-off-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/499328/
Link: https://lore.kernel.org/r/1661372150-3764-1-git-send-email-quic_khsieh@quicinc.com
[DB: rewrapped commit message]
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_catalog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_catalog.c b/drivers/gpu/drm/msm/dp/dp_catalog.c
index 2da6982efdbf..613348b022fe 100644
--- a/drivers/gpu/drm/msm/dp/dp_catalog.c
+++ b/drivers/gpu/drm/msm/dp/dp_catalog.c
@@ -416,7 +416,7 @@ void dp_catalog_ctrl_config_msa(struct dp_catalog *dp_catalog,
 
 	if (rate == link_rate_hbr3)
 		pixel_div = 6;
-	else if (rate == 1620000 || rate == 270000)
+	else if (rate == 162000 || rate == 270000)
 		pixel_div = 2;
 	else if (rate == link_rate_hbr2)
 		pixel_div = 4;
-- 
2.35.1



