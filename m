Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1BAE409211
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242785AbhIMOHo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:07:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344629AbhIMOFT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:05:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68F9861A6D;
        Mon, 13 Sep 2021 13:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540390;
        bh=UHnM0abFLM3GYy1xujHHxOcpr7Sy645WE1ZG2tBFY/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PLvclnCil46LD6nOhuOJQbjzVpPcGIIC9/36p7pxyICmYqTqur2ZLXQSB/fhlXe8B
         ZHdYZIKuWczwfERt2ZmpOr1NYBOXCJYzUMQL1GBlAsH6CuccvcvomwreQaY73RldXY
         iUIqP8MF0GNuIcqiTz217ZfSYTaiwZTlZIBgeuCw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 174/300] drm/msm/dsi: Fix some reference counted resource leaks
Date:   Mon, 13 Sep 2021 15:13:55 +0200
Message-Id: <20210913131115.280239497@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 6977cc89c87506ff17e6c05f0e37f46752256e82 ]

'of_find_device_by_node()' takes a reference that must be released when
not needed anymore.
This is expected to be done in 'dsi_destroy()'.

However, there are 2 issues in 'dsi_get_phy()'.

First, if 'of_find_device_by_node()' succeeds but 'platform_get_drvdata()'
returns NULL, 'msm_dsi->phy_dev' will still be NULL, and the reference
won't be released in 'dsi_destroy()'.

Secondly, as 'of_find_device_by_node()' already takes a reference, there is
no need for an additional 'get_device()'.

Move the assignment to 'msm_dsi->phy_dev' a few lines above and remove the
unneeded 'get_device()' to solve both issues.

Fixes: ec31abf6684e ("drm/msm/dsi: Separate PHY to another platform device")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/f15bc57648a00e7c99f943903468a04639d50596.1628241097.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi.c b/drivers/gpu/drm/msm/dsi/dsi.c
index 627048851d99..7e364b9c9f9e 100644
--- a/drivers/gpu/drm/msm/dsi/dsi.c
+++ b/drivers/gpu/drm/msm/dsi/dsi.c
@@ -26,8 +26,10 @@ static int dsi_get_phy(struct msm_dsi *msm_dsi)
 	}
 
 	phy_pdev = of_find_device_by_node(phy_node);
-	if (phy_pdev)
+	if (phy_pdev) {
 		msm_dsi->phy = platform_get_drvdata(phy_pdev);
+		msm_dsi->phy_dev = &phy_pdev->dev;
+	}
 
 	of_node_put(phy_node);
 
@@ -36,8 +38,6 @@ static int dsi_get_phy(struct msm_dsi *msm_dsi)
 		return -EPROBE_DEFER;
 	}
 
-	msm_dsi->phy_dev = get_device(&phy_pdev->dev);
-
 	return 0;
 }
 
-- 
2.30.2



