Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4CB657C37
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233788AbiL1PaN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:30:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233810AbiL1PaH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:30:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA40815827
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:30:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46C9E6152F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:30:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A701C433D2;
        Wed, 28 Dec 2022 15:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241405;
        bh=B68q5T78n7dr+S61wMS3XTRFdpHHBm+HfEgSLaRmF0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BwyeygwWmzgXgDAiffxGyW8KSM/gJi6KUKc0IiS47cQIxlLtWd8KRHFFuellQ8Xx5
         XedPzUL9KwKa5bPsnuad4pxx1W+Cy6DG6goIevLOEwuXhfj0Ejh6maJanuCaJR8AXA
         U9G8fBydljDc8LoaDEcU+s3w0bhcnm1wfoW4jg+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0280/1073] drm/msm/dsi: Disallow 8 BPC DSC configuration for alternative BPC values
Date:   Wed, 28 Dec 2022 15:31:08 +0100
Message-Id: <20221228144335.626537455@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit d053fbc449c47517b1f6516dbce2f917f2a9f51d ]

According to the `/* bpc 8 */` comment below only values for a
bits_per_component of 8 are currently hardcoded in place.  This is
further confirmed by downstream sources [1] containing different
constants for other BPC values (and different initial_offset too,
with an extra dependency on bits_per_pixel).  Prevent future mishaps by
explicitly disallowing any other bits_per_component value until the
right parameters are put in place and tested.

[1]: https://git.codelinaro.org/clo/la/platform/vendor/opensource/display-drivers/-/blob/DISPLAY.LA.2.0.r1-08000-WAIPIO.0/msm/sde_dsc_helper.c#L110-139

Fixes: b9080324d6ca ("drm/msm/dsi: add support for dsc data")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Patchwork: https://patchwork.freedesktop.org/patch/508942/
Link: https://lore.kernel.org/r/20221026182824.876933-9-marijn.suijten@somainline.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index 27fef5169bed..c5805416854f 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -1848,6 +1848,11 @@ static int dsi_populate_dsc_params(struct msm_dsi_host *msm_host, struct drm_dsc
 		return -EINVAL;
 	}
 
+	if (dsc->bits_per_component != 8) {
+		DRM_DEV_ERROR(&msm_host->pdev->dev, "DSI does not support bits_per_component != 8 yet\n");
+		return -EOPNOTSUPP;
+	}
+
 	dsc->rc_model_size = 8192;
 	dsc->first_line_bpg_offset = 12;
 	dsc->rc_edge_factor = 6;
-- 
2.35.1



