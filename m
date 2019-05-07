Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2492215BDC
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbfEGF5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:57:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726787AbfEGFhd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:37:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F5B9205ED;
        Tue,  7 May 2019 05:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207452;
        bh=5Q8YJgAUpknyzg1JZWzMxtKR7UGdxPt8wGysfVQeWLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sqapUEcDTJbY5ZteNh/7NxMKSmCoxnJwaZlZJUqdIjocSPf3ZpUAS1b+1lllbfC9b
         YrEkYiqIP/i6NFsfjjf6uPspKSXklFVIb9VgyPndHcca0PTqOcQPRGOq3Dw7ZEJBa1
         hr0/K3v2/hUsPT8qPwRjXoZzZQPjVV24itTpmLdU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 49/81] drm/sun4i: Set device driver data at bind time for use in unbind
Date:   Tue,  7 May 2019 01:35:20 -0400
Message-Id: <20190507053554.30848-49-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053554.30848-1-sashal@kernel.org>
References: <20190507053554.30848-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

[ Upstream commit 02b92adbe33e6dbd15dc6e32540b22f47c4ff0a2 ]

Our sun4i_drv_unbind gets the drm device using dev_get_drvdata.
However, that driver data is never set in sun4i_drv_bind.

Set it there to avoid getting a NULL pointer at unbind time.

Fixes: 9026e0d122ac ("drm: Add Allwinner A10 Display Engine support")
Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190418132727.5128-3-paul.kocialkowski@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun4i_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/sun4i/sun4i_drv.c b/drivers/gpu/drm/sun4i/sun4i_drv.c
index 8b0cd08034e0..7cac01c72c02 100644
--- a/drivers/gpu/drm/sun4i/sun4i_drv.c
+++ b/drivers/gpu/drm/sun4i/sun4i_drv.c
@@ -92,6 +92,8 @@ static int sun4i_drv_bind(struct device *dev)
 		ret = -ENOMEM;
 		goto free_drm;
 	}
+
+	dev_set_drvdata(dev, drm);
 	drm->dev_private = drv;
 	INIT_LIST_HEAD(&drv->frontend_list);
 	INIT_LIST_HEAD(&drv->engine_list);
-- 
2.20.1

