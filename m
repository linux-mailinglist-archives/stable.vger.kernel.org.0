Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15C9137CD40
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234312AbhELQxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:53:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:35488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243723AbhELQl6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:41:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3D8F61CF5;
        Wed, 12 May 2021 16:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835575;
        bh=JvBDpP3mmjc5PuCI5iA1DvKhvYE0lLnrakaqesy0jgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zQs7tY2+h7/E8a8j6r+5q+nKBQrc1UOwHPJ7diUn9ICU7RoJz59NcRLI3HLcDDkVC
         NWKWeBMkcuSZ+2TjhbHsuuhQWy2e3iBm+ns2KnxqQw39zrkNxSldnWrT281fsUvi2A
         4xb2hRq5P9zTUHSN2dqIKdmfPPT/h3I6i6ORKBpo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 399/677] drm/msm/dpu: enable DPU_SSPP_QOS_8LVL for SM8250
Date:   Wed, 12 May 2021 16:47:25 +0200
Message-Id: <20210512144850.591686271@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 095eed898485312f86b7cb593da4f9cd5c43fdb0 ]

SM8250 platform has a 8-Levels VIG QoS setting. This setting was missed
due to bad interaction with b8dab65b5ac3 ("drm/msm/dpu: Move
DPU_SSPP_QOS_8LVL bit to SDM845 and SC7180 masks"), which was applied in
parallel.

Fixes: d21fc5dfc3df ("drm/msm/dpu1: add support for qseed3lite used on sm8250")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20210318105435.2011222-1-dmitry.baryshkov@linaro.org
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
index 189f3533525c..e4444452759c 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
@@ -22,7 +22,7 @@
 	(VIG_MASK | BIT(DPU_SSPP_QOS_8LVL) | BIT(DPU_SSPP_SCALER_QSEED4))
 
 #define VIG_SM8250_MASK \
-	(VIG_MASK | BIT(DPU_SSPP_SCALER_QSEED3LITE))
+	(VIG_MASK | BIT(DPU_SSPP_QOS_8LVL) | BIT(DPU_SSPP_SCALER_QSEED3LITE))
 
 #define DMA_SDM845_MASK \
 	(BIT(DPU_SSPP_SRC) | BIT(DPU_SSPP_QOS) | BIT(DPU_SSPP_QOS_8LVL) |\
-- 
2.30.2



