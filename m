Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C12731F22D
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729889AbfEOLOO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:14:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730085AbfEOLON (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:14:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA92120881;
        Wed, 15 May 2019 11:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918853;
        bh=2h4RZBvYY35P/AdQ40WgdooKRgk8s+apePeMFdS1hiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qL1LA2snmI73JoZ8EyOdFcMjMtSJhEOCmqq5FiEypRqEKm6q4UQYTssWRIC9loQl8
         BlRD6FB5Oq2AYttHr7x7cEKpB1JWqnJcVHFbMCjt+sX/mB3w9o5YKmFN6UWJzbX6dX
         IYRH5mTXuIPnZuJUsAk/WQKIUXLsjhqKGdQyK14U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 24/51] drm/sun4i: Set device driver data at bind time for use in unbind
Date:   Wed, 15 May 2019 12:55:59 +0200
Message-Id: <20190515090624.134510798@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090616.669619870@linuxfoundation.org>
References: <20190515090616.669619870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 97828faf2a1ff..d58991b06a470 100644
--- a/drivers/gpu/drm/sun4i/sun4i_drv.c
+++ b/drivers/gpu/drm/sun4i/sun4i_drv.c
@@ -137,6 +137,8 @@ static int sun4i_drv_bind(struct device *dev)
 		ret = -ENOMEM;
 		goto free_drm;
 	}
+
+	dev_set_drvdata(dev, drm);
 	drm->dev_private = drv;
 
 	drm_vblank_init(drm, 1);
-- 
2.20.1



