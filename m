Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61F4579576
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbfG2Tmt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:42:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389557AbfG2Tms (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:42:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D374721655;
        Mon, 29 Jul 2019 19:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429367;
        bh=zYpROnVsZzCeFQOKde21zbITF1meTJ/9cw4mH6Th/ng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lQhev5I49gD54aEhNO0iaa2kyq8OguweTL1UQXPsjo7BqXdYP67R9o4O/cZY89z4n
         1ueS2/uS/zY1qa9EcXu8lFDuMSOn1o6R2Of5WdV6FjBCdXn9pO06sXhdFYoh0UA0MV
         h7cPl6SpVmluHwwpmESp1IYTmttaLBjHHbOkcSN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@chromium.org>,
        Sean Paul <seanpaul@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 037/113] drm/msm: Depopulate platform on probe failure
Date:   Mon, 29 Jul 2019 21:22:04 +0200
Message-Id: <20190729190704.599374925@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190655.455345569@linuxfoundation.org>
References: <20190729190655.455345569@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 4368a1539c6b41ac3cddc06f5a5117952998804c ]

add_display_components() calls of_platform_populate, and we depopluate
on pdev remove, but not when probe fails. So if we get a probe deferral
in one of the components, we won't depopulate the platform. This causes
the core to keep references to devices which should be destroyed, which
causes issues when those same devices try to re-initialize on the next
probe attempt.

I think this is the reason we had issues with the gmu's device-managed
resources on deferral (worked around in commit 94e3a17f33a5).

Reviewed-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sean Paul <seanpaul@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20190617201301.133275-3-sean@poorly.run
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_drv.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index c1abad8a8612..ed9a3a1e50ef 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -1321,16 +1321,24 @@ static int msm_pdev_probe(struct platform_device *pdev)
 
 	ret = add_gpu_components(&pdev->dev, &match);
 	if (ret)
-		return ret;
+		goto fail;
 
 	/* on all devices that I am aware of, iommu's which can map
 	 * any address the cpu can see are used:
 	 */
 	ret = dma_set_mask_and_coherent(&pdev->dev, ~0);
 	if (ret)
-		return ret;
+		goto fail;
+
+	ret = component_master_add_with_match(&pdev->dev, &msm_drm_ops, match);
+	if (ret)
+		goto fail;
 
-	return component_master_add_with_match(&pdev->dev, &msm_drm_ops, match);
+	return 0;
+
+fail:
+	of_platform_depopulate(&pdev->dev);
+	return ret;
 }
 
 static int msm_pdev_remove(struct platform_device *pdev)
-- 
2.20.1



