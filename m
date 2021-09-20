Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E924411F4E
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348591AbhITRkB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:40:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:40662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244672AbhITRiZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:38:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99FF061B3A;
        Mon, 20 Sep 2021 17:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157631;
        bh=bII51P2tUfCms6tTx8mM/wUna+3XggKrf2IkC5LWlpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hkLjjLM7l98gsx5hfmiD4tAupmhvvsSXr/fDvZcE6eRLKUU/fRygCSzYiekd6hg0O
         o3jkW0rm0UkQhhujF+k1IY1IGt3H4nsgi3x6yDiGpgFj4nE6mxB4ANwqQb67IcdxGC
         9Uifjxe7dbUiRiqexiu/fT51JB7uS3IYGd5X2/hI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 080/293] drm/msm/dsi: Fix some reference counted resource leaks
Date:   Mon, 20 Sep 2021 18:40:42 +0200
Message-Id: <20210920163936.008400859@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
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
index ff8164cc6738..822cef472a7e 100644
--- a/drivers/gpu/drm/msm/dsi/dsi.c
+++ b/drivers/gpu/drm/msm/dsi/dsi.c
@@ -34,8 +34,10 @@ static int dsi_get_phy(struct msm_dsi *msm_dsi)
 	}
 
 	phy_pdev = of_find_device_by_node(phy_node);
-	if (phy_pdev)
+	if (phy_pdev) {
 		msm_dsi->phy = platform_get_drvdata(phy_pdev);
+		msm_dsi->phy_dev = &phy_pdev->dev;
+	}
 
 	of_node_put(phy_node);
 
@@ -44,8 +46,6 @@ static int dsi_get_phy(struct msm_dsi *msm_dsi)
 		return -EPROBE_DEFER;
 	}
 
-	msm_dsi->phy_dev = get_device(&phy_pdev->dev);
-
 	return 0;
 }
 
-- 
2.30.2



