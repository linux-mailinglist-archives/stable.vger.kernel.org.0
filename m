Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2EA657C0D
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233479AbiL1P2a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:28:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233788AbiL1P2S (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:28:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33CF0140CF
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:28:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5B2C6154D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:28:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB239C433EF;
        Wed, 28 Dec 2022 15:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241296;
        bh=dFXC/ABF4qD/kQ/+FO+hc/5QahOtsfa6J+G1j6QWqek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nN2SzzsA3uNvqqZ1mY2cmui/AAkeO/JPD1cPEypEyhkQj8DIQpinsTk7GjQ2XkMX4
         pTegyULBJDDGD4te63TvAbfnFsADn+lfdcmIr6NTMeH1rhgle037dfAZLoQ/mMZWIO
         HBIj+AOXVo6Rs1jxZjqbm7I0hlL6g04WEAfuxvC0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marek Vasut <marex@denx.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0263/1073] drm/panel/panel-sitronix-st7701: Remove panel on DSI attach failure
Date:   Wed, 28 Dec 2022 15:30:51 +0100
Message-Id: <20221228144335.159051771@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index 320a2a8fd459..098955526b68 100644
--- a/drivers/gpu/drm/panel/panel-sitronix-st7701.c
+++ b/drivers/gpu/drm/panel/panel-sitronix-st7701.c
@@ -384,7 +384,15 @@ static int st7701_dsi_probe(struct mipi_dsi_device *dsi)
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



