Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F00BB1F025
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731036AbfEOLlQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:41:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732458AbfEOL24 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:28:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DA8220843;
        Wed, 15 May 2019 11:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919736;
        bh=8ezDlsKr35RmZhEH5S5vIFwp/wkEY5n5UFVlWdhEcIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GE4dhFCGy/ZkX/YegIWAdDxgMDHDXG2iwrf9YH7+Wuw9SXxdRpDLwEDphMxMuQ7mf
         KwMzCEXHDTvQGIDJ88kHuPNekwzWOcLagUX+sCuWz+kaskrK7AYb8Rs69zyXY7OyEt
         urTBDuky3zWeDkPLMo/uDrU5ZE32rFDvmUgQECMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 072/137] drm/sun4i: Set device driver data at bind time for use in unbind
Date:   Wed, 15 May 2019 12:55:53 +0200
Message-Id: <20190515090658.660331445@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
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
index 9e4c375ccc96f..c6b65a9699794 100644
--- a/drivers/gpu/drm/sun4i/sun4i_drv.c
+++ b/drivers/gpu/drm/sun4i/sun4i_drv.c
@@ -85,6 +85,8 @@ static int sun4i_drv_bind(struct device *dev)
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



