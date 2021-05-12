Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 348DE37CCC1
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235309AbhELQrO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:47:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243502AbhELQlW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:41:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAF3161C47;
        Wed, 12 May 2021 16:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835470;
        bh=xbT2XW6PjQa5RHI8VVnGO+ghPxl1pI3m+7GNfWb011w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fheViBufTZe2XQT2duWjilMpyKzONj0YSeGmGEiaBAsba9UVGRVAMuMjR0Usej5/V
         sbgl4ehy2QhgkK5vqPFmHkLoJ8nVIWkuPTm3sxlL1CpVnglAn47R3/aU66YTONn+wx
         gCd7+z51yxk0SEL7UrZzDocZ5JUzcav57su9ZIwg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 357/677] drm/panel-simple: Undo enable if HPD never asserts
Date:   Wed, 12 May 2021 16:46:43 +0200
Message-Id: <20210512144849.185582802@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 5e7222a3674ea7422370779884dd53aabe9e4a9d ]

If the HPD signal never asserts in panel_simple_prepare() and we
return an error, we should unset the enable GPIO and disable the
regulator to make it consistent for the caller.

At the moment I have some hardware where HPD sometimes doesn't assert.
Obviously that needs to be debugged, but this patch makes it so that
if I add a retry that I can make things work.

Fixes: 48834e6084f1 ("drm/panel-simple: Support hpd-gpios for delaying prepare()")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210115144345.v2.1.I33fcbd64ab409cfe4f9491bf449f51925a4d3281@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 4e2dad314c79..e8b1a0e873ea 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -406,7 +406,7 @@ static int panel_simple_prepare(struct drm_panel *panel)
 		if (IS_ERR(p->hpd_gpio)) {
 			err = panel_simple_get_hpd_gpio(panel->dev, p, false);
 			if (err)
-				return err;
+				goto error;
 		}
 
 		err = readx_poll_timeout(gpiod_get_value_cansleep, p->hpd_gpio,
@@ -418,13 +418,20 @@ static int panel_simple_prepare(struct drm_panel *panel)
 		if (err) {
 			dev_err(panel->dev,
 				"error waiting for hpd GPIO: %d\n", err);
-			return err;
+			goto error;
 		}
 	}
 
 	p->prepared_time = ktime_get();
 
 	return 0;
+
+error:
+	gpiod_set_value_cansleep(p->enable_gpio, 0);
+	regulator_disable(p->supply);
+	p->unprepared_time = ktime_get();
+
+	return err;
 }
 
 static int panel_simple_enable(struct drm_panel *panel)
-- 
2.30.2



