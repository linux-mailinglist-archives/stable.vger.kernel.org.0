Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88B3466C6CE
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233112AbjAPQZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:25:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233077AbjAPQYr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:24:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED2512B293
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:13:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8784660FDF
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:13:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C84DC433D2;
        Mon, 16 Jan 2023 16:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885609;
        bh=+uu0PwB9lsmN4vCpKbduM73AybgmqwhJPD1L8xcPIfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HXfSBcVgEu0sAD6Xh8ayVBBarsLN0Vu8yvOnG89fqyXDhTgH1Bw+gE1yQY+4nhpHU
         NP1Vko7yC55sYA3P5PvEHRZEZVCoIA8wZJHLMHWRYHSEcI5pNibtkI5Na4M20o6jpG
         nXKz7dSEr37rIkP5SnKzXbFWHdfwlXW6ZWVlKIzw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marek Vasut <marex@denx.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 116/658] drm/panel/panel-sitronix-st7701: Remove panel on DSI attach failure
Date:   Mon, 16 Jan 2023 16:43:24 +0100
Message-Id: <20230116154914.804274188@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit c62102165dd79284d42383d2f7ed17301bd8e629 ]

In case mipi_dsi_attach() fails, call drm_panel_remove() to
avoid memory leak.

Fixes: 849b2e3ff969 ("drm/panel: Add Sitronix ST7701 panel driver")
Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20221014231106.468063-1-marex@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-sitronix-st7701.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-sitronix-st7701.c b/drivers/gpu/drm/panel/panel-sitronix-st7701.c
index 09c5d9a6f9fa..638f605acb2d 100644
--- a/drivers/gpu/drm/panel/panel-sitronix-st7701.c
+++ b/drivers/gpu/drm/panel/panel-sitronix-st7701.c
@@ -392,7 +392,15 @@ static int st7701_dsi_probe(struct mipi_dsi_device *dsi)
 	st7701->dsi = dsi;
 	st7701->desc = desc;
 
-	return mipi_dsi_attach(dsi);
+	ret = mipi_dsi_attach(dsi);
+	if (ret)
+		goto err_attach;
+
+	return 0;
+
+err_attach:
+	drm_panel_remove(&st7701->panel);
+	return ret;
 }
 
 static int st7701_dsi_remove(struct mipi_dsi_device *dsi)
-- 
2.35.1



