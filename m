Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4B9859492B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353793AbiHOXi2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353984AbiHOXhH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:37:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE2A48CAF;
        Mon, 15 Aug 2022 13:09:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56A8860DEC;
        Mon, 15 Aug 2022 20:09:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41DBDC433D7;
        Mon, 15 Aug 2022 20:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594182;
        bh=jfJOzOwEKofhwCRjoQbs2HejMpK/kXhAVnPCBQ7kH4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ROVPfTnKivbh8TJPvH8TN/AtCFmb65bwF2Q7rAoL2RDSe5se0wnjPG+/rcAcKjjHd
         0nvL4vYlOmnxEU0BeXtD1tms0id1fSPpk0J++srVVGZQmGhCel9ipQd989DdPDLER6
         2jbJ/BImbYpAPZss+s//BeRHjAAWsDwmutkj5Bas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0391/1157] drm/display: Fix build error without CONFIG_OF
Date:   Mon, 15 Aug 2022 19:55:47 +0200
Message-Id: <20220815180455.330366372@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 876271118aa41097d035c84f99648746b4a125f3 ]

While CONFIG_OF is n but COMPILE_TEST is y, we got this:

WARNING: unmet direct dependencies detected for DRM_DP_AUX_BUS
  Depends on [n]: HAS_IOMEM [=y] && DRM [=y] && OF [=n]
  Selected by [y]:
  - DRM_MSM [=y] && HAS_IOMEM [=y] && DRM [=y] && (ARCH_QCOM || SOC_IMX5 || COMPILE_TEST [=y]) && COMMON_CLK [=y] && IOMMU_SUPPORT [=y] && (QCOM_OCMEM [=n] || QCOM_OCMEM [=n]=n) && (QCOM_LLCC [=y] || QCOM_LLCC [=y]=n) && (QCOM_COMMAND_DB [=n] || QCOM_COMMAND_DB [=n]=n)

Make DRM_DP_AUX_BUS depends on OF || COMPILE_TEST to fix this warning.

Fixes: 1e0f66420b13 ("drm/display: Introduce a DRM display-helper module")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220611041612.1976-1-yuehaibing@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/display/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/display/Kconfig b/drivers/gpu/drm/display/Kconfig
index 1b6e6af37546..09712b88a5b8 100644
--- a/drivers/gpu/drm/display/Kconfig
+++ b/drivers/gpu/drm/display/Kconfig
@@ -3,7 +3,7 @@
 config DRM_DP_AUX_BUS
 	tristate
 	depends on DRM
-	depends on OF
+	depends on OF || COMPILE_TEST
 
 config DRM_DISPLAY_HELPER
 	tristate
-- 
2.35.1



