Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE85B3C4980
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236024AbhGLGpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:45:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:41506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238858AbhGLGoY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:44:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 539626101E;
        Mon, 12 Jul 2021 06:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072013;
        bh=JpTXsiQQ9JH2gK0bxZG6EvoQAV5Q+UX4WjpJvVL3vfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V94qmf0uRA6Sc1dg0n/yYMKYYrm+FaFwXvsPjWrfVIwGi8YM5cyOXz75uexXO5U82
         cEFBmUAHkHdBzpl9GyumFv0+9jeCfdKIG8lPdOgA6ge7Kbngz/KVteu6phqwY/gF3L
         6K868w/aOgWNGe5WDSXFnNeqXui7xTdrqDfBOq5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 317/593] drm/rockchip: lvds: Fix an error handling path
Date:   Mon, 12 Jul 2021 08:07:57 +0200
Message-Id: <20210712060920.314791372@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 3dfa159f6b0c054eb63673fbf643a5f2cc862e63 ]

'ret' is know to be 0 a this point. Checking the return value of
'phy_init()' and 'phy_set_mode()' was intended instead.

So add the missing assignments.

Fixes: cca1705c3d89 ("drm/rockchip: lvds: Add PX30 support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/248220d4815dc8c8088cebfab7d6df5f70518438.1619881852.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_lvds.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_lvds.c b/drivers/gpu/drm/rockchip/rockchip_lvds.c
index 41edd0a421b2..7c20b4a24a7e 100644
--- a/drivers/gpu/drm/rockchip/rockchip_lvds.c
+++ b/drivers/gpu/drm/rockchip/rockchip_lvds.c
@@ -499,11 +499,11 @@ static int px30_lvds_probe(struct platform_device *pdev,
 	if (IS_ERR(lvds->dphy))
 		return PTR_ERR(lvds->dphy);
 
-	phy_init(lvds->dphy);
+	ret = phy_init(lvds->dphy);
 	if (ret)
 		return ret;
 
-	phy_set_mode(lvds->dphy, PHY_MODE_LVDS);
+	ret = phy_set_mode(lvds->dphy, PHY_MODE_LVDS);
 	if (ret)
 		return ret;
 
-- 
2.30.2



