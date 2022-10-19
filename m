Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73EA360443C
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 14:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbiJSMAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 08:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231908AbiJSL7V (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 07:59:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A8E01BB960;
        Wed, 19 Oct 2022 04:37:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E388B823C6;
        Wed, 19 Oct 2022 08:54:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ABABC433C1;
        Wed, 19 Oct 2022 08:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169697;
        bh=UX8Cs3Mm3tSWVe+7/xzWvQqmQ5T7ga5ab7VqL2bSUis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gZ+QEZ/WHmbDj7KqZuweukyTD7UpC2dFb+nNYVa6LQX603ui4qpZ31QH15cNiDc/u
         8ZlrvJczBqnL/tB8P6tGk8ZM+Ld8l+jv4T1ZJlWRt12M7CszelIA+CMgLFr8SDulNA
         9eedJ0yGIcmWHGhh9B1F9UTe0kLnFKw3elxHOOw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Dillon Min <dillon.minfei@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 373/862] drm/panel: use select for Ili9341 panel driver helpers
Date:   Wed, 19 Oct 2022 10:27:40 +0200
Message-Id: <20221019083306.471257645@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 84dfc46594b0167e5d3736273b0e0e05365da641 ]

Use 'select' instead of 'depends on' for DRM helpers for the
Ilitek ILI9341 panel driver.
This is what is done in the vast majority of other cases and
this makes it possible to fix a build error with drm_mipi_dbi.

Fixes: 5a04227326b0 ("drm/panel: Add ilitek ili9341 panel driver")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Dillon Min <dillon.minfei@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Noralf Trønnes <noralf@tronnes.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: dri-devel@lists.freedesktop.org
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220823004227.10820-1-rdunlap@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panel/Kconfig b/drivers/gpu/drm/panel/Kconfig
index a9043eacce97..a582ddd583c2 100644
--- a/drivers/gpu/drm/panel/Kconfig
+++ b/drivers/gpu/drm/panel/Kconfig
@@ -165,8 +165,8 @@ config DRM_PANEL_ILITEK_IL9322
 config DRM_PANEL_ILITEK_ILI9341
 	tristate "Ilitek ILI9341 240x320 QVGA panels"
 	depends on OF && SPI
-	depends on DRM_KMS_HELPER
-	depends on DRM_GEM_CMA_HELPER
+	select DRM_KMS_HELPER
+	select DRM_GEM_DMA_HELPER
 	depends on BACKLIGHT_CLASS_DEVICE
 	select DRM_MIPI_DBI
 	help
-- 
2.35.1



