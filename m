Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C35C507811
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 20:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356479AbiDSSTf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 14:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356603AbiDSSTI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 14:19:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E7A3DA72;
        Tue, 19 Apr 2022 11:13:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F60560AC0;
        Tue, 19 Apr 2022 18:13:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACFB4C385A7;
        Tue, 19 Apr 2022 18:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650392008;
        bh=KEKEDurTHdWIV53bP5ZnmLO8or544bc5KUoNgRMP9Hw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M1mt8aKHSJAU5rmV2BPVAm2iImokibOzP5jAAOs7QGHc4RFuTsr5Ss+7+Okre0Xcd
         HEjhk4sqoCSONvJB5NT13zXaAZ64zDTY+YdVnFlLIbdZsmDidYAbzlKHE+dgyYldr6
         cdFbquIVqV9juoUvMI36okV35YRSprqSz5/nxBT4Ov+WdzoV+RKNGvGm7EXt3XmAWW
         rDs+fioGJ3CDtJquhDBfgIYGplXCsaDRTmzjS0GYrA9arbqDh9Uppgzah5ey9NdR9y
         vTx44lg4aBgNmB6zYScjraMhodn3iWOLz/yz9Reqbwu8Pz8opZHjOUo5ZL+8HB3/+p
         9bMxEnCKbXtyQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Rob Clark <robdclark@gmail.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, sean@poorly.run,
        airlied@linux.ie, daniel@ffwll.ch, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 15/27] drm/msm: Stop using iommu_present()
Date:   Tue, 19 Apr 2022 14:12:30 -0400
Message-Id: <20220419181242.485308-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419181242.485308-1-sashal@kernel.org>
References: <20220419181242.485308-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit e2a88eabb02410267519b838fb9b79f5206769be ]

Even if some IOMMU has registered itself on the platform "bus", that
doesn't necessarily mean it provides translation for the device we
care about. Replace iommu_present() with a more appropriate check.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Rob Clark <robdclark@gmail.com>
Patchwork: https://patchwork.freedesktop.org/patch/480707/
Link: https://lore.kernel.org/r/5ab4f4574d7f3e042261da702d493ee40d003356.1649168268.git.robin.murphy@arm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index bbf999c66517..d6d40429016d 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -403,7 +403,7 @@ bool msm_use_mmu(struct drm_device *dev)
 	struct msm_drm_private *priv = dev->dev_private;
 
 	/* a2xx comes with its own MMU */
-	return priv->is_a2xx || iommu_present(&platform_bus_type);
+	return priv->is_a2xx || device_iommu_mapped(dev->dev);
 }
 
 static int msm_init_vram(struct drm_device *dev)
-- 
2.35.1

