Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB336578ED
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233240AbiL1Ozq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:55:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233250AbiL1Ozl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:55:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1529011A33
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:55:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A709861544
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:55:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDD47C433D2;
        Wed, 28 Dec 2022 14:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239340;
        bh=XgFeTa220N2NpGRV84aUNCHedg3qYGSsjgMk0T/IRg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yob7XInulFbcTpkAACPvCCMhBbwIrHpUZKrTl1qfSHqG/MbtzLU8KvNnmkwb2LIQO
         EJMidl3Os/sz6Rg2cX1dn2lZQ/JvEe5pCUk9BKjQcwZnZTNtnhsM0hDZyTnh2zz4NZ
         AEzqcgTAnp1wgW/Pwpll7i8eCrKBKo/YscjP7PtU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rob Clark <robdclark@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Akhil P Oommen <quic_akhilpo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 208/731] drm/msm/a6xx: Fix speed-bin detection vs probe-defer
Date:   Wed, 28 Dec 2022 15:35:15 +0100
Message-Id: <20221228144302.588737590@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit f6d1918794ef92b4e26b80c3d40365347b76b1fd ]

If we get an error (other than -ENOENT) we need to propagate that up the
stack.  Otherwise if the nvmem driver hasn't probed yet, we'll end up
end up claiming that we support all the OPPs which is not likely to be
true (and on some generations impossible to be true, ie. if there are
conflicting OPPs).

v2: Update commit msg, gc unused label, etc
v3: Add previously missing \n's

Fixes: fe7952c629da ("drm/msm: Add speed-bin support to a618 gpu")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Akhil P Oommen <quic_akhilpo@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/511690/
Link: https://lore.kernel.org/r/20221115154637.1613968-1-robdclark@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index c0dec5b919d4..2d07c02c59f1 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -1746,7 +1746,7 @@ static u32 fuse_to_supp_hw(struct device *dev, struct adreno_rev rev, u32 fuse)
 
 	if (val == UINT_MAX) {
 		DRM_DEV_ERROR(dev,
-			"missing support for speed-bin: %u. Some OPPs may not be supported by hardware",
+			"missing support for speed-bin: %u. Some OPPs may not be supported by hardware\n",
 			fuse);
 		return UINT_MAX;
 	}
@@ -1756,7 +1756,7 @@ static u32 fuse_to_supp_hw(struct device *dev, struct adreno_rev rev, u32 fuse)
 
 static int a6xx_set_supported_hw(struct device *dev, struct adreno_rev rev)
 {
-	u32 supp_hw = UINT_MAX;
+	u32 supp_hw;
 	u32 speedbin;
 	int ret;
 
@@ -1768,15 +1768,13 @@ static int a6xx_set_supported_hw(struct device *dev, struct adreno_rev rev)
 	if (ret == -ENOENT) {
 		return 0;
 	} else if (ret) {
-		DRM_DEV_ERROR(dev,
-			      "failed to read speed-bin (%d). Some OPPs may not be supported by hardware",
-			      ret);
-		goto done;
+		dev_err_probe(dev, ret,
+			      "failed to read speed-bin. Some OPPs may not be supported by hardware\n");
+		return ret;
 	}
 
 	supp_hw = fuse_to_supp_hw(dev, rev, speedbin);
 
-done:
 	ret = devm_pm_opp_set_supported_hw(dev, &supp_hw, 1);
 	if (ret)
 		return ret;
-- 
2.35.1



