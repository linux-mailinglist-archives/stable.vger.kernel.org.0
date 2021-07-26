Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 439A03D5FDA
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236764AbhGZPTW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:19:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:60054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236609AbhGZPTH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:19:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C942560F6E;
        Mon, 26 Jul 2021 15:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315175;
        bh=olJvFdMxbt3wMLmS/bfiTseS4BVIvIa66jJPgdVTTns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=st/pNzG0NkIYcJRe1DJKN2LitLhHS9bkhemzrMDaLAz96Mxk1pmejbUIKmHj6jwwM
         DXYn3NewMN6xll31aHH/8JfMEeH913sdgheuJEwKPgUfoTv+i+eDxg+giX/kLhbPL2
         5SyP9uhAf3/RxunlS8ntfPiSaeP97DUjLsACHctI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 067/108] drm/panel: raspberrypi-touchscreen: Prevent double-free
Date:   Mon, 26 Jul 2021 17:39:08 +0200
Message-Id: <20210726153833.844180608@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153831.696295003@linuxfoundation.org>
References: <20210726153831.696295003@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 7bbcb919e32d776ca8ddce08abb391ab92eef6a9 ]

The mipi_dsi_device allocated by mipi_dsi_device_register_full() is
already free'd on release.

Fixes: 2f733d6194bd ("drm/panel: Add support for the Raspberry Pi 7" Touchscreen.")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210720134525.563936-9-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c b/drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c
index 2aa89eaecf6f..bdb4d59c8127 100644
--- a/drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c
+++ b/drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c
@@ -453,7 +453,6 @@ static int rpi_touchscreen_remove(struct i2c_client *i2c)
 	drm_panel_remove(&ts->base);
 
 	mipi_dsi_device_unregister(ts->dsi);
-	kfree(ts->dsi);
 
 	return 0;
 }
-- 
2.30.2



