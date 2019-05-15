Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 809861F0F6
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731083AbfEOLW4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:22:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:33206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731285AbfEOLWz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:22:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A553B2089E;
        Wed, 15 May 2019 11:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919375;
        bh=qcZ9DuyaHf/31gsj4/zCbf4hOCJq6oueOdGqt2UEYxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k9AArpIWTeY/0i6LjI3g4d+eUpTdVrA+hehWaKRIAgXI3ydKebLrj+MGwO2zs/+Y5
         qwgmA0PJi1/1H73zHjr+84YeF/DHfMjBENXWZ9EPtPf9qWDVIvbIEwWde4z8XFp9MN
         UB8Ddpc9ubhmvNvNUDVihSmcT4G8fuiOYsgxK24U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 052/113] drm/sun4i: Set device driver data at bind time for use in unbind
Date:   Wed, 15 May 2019 12:55:43 +0200
Message-Id: <20190515090657.610205564@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090652.640988966@linuxfoundation.org>
References: <20190515090652.640988966@linuxfoundation.org>
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
index 8b0cd08034e0c..7cac01c72c027 100644
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



