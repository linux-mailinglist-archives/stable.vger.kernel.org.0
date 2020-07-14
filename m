Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2C921FAA5
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730342AbgGNSyX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:54:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:51796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730340AbgGNSyW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:54:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E55522BEB;
        Tue, 14 Jul 2020 18:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752862;
        bh=RE38XazNYCwzs9eu9smfOGnUknFmGMxPfCedVsBQs2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TGlqMsA0Sot+P2y1LZfgO2M8At5LmYO6aGmDC25CIpsc1k6LRbLX2QTGWF3fQh12o
         2/ILn98C+OWfOCgj4T+AipUTDvAxiGQaNCLRv+iRJZhq+8Jpgqcf7/2/aLPykyUs5g
         vbVjdepSwPO7/Myl2Z7qhi/YBHITqDLdvmupp7Ys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 014/166] drm: mcde: Fix display initialization problem
Date:   Tue, 14 Jul 2020 20:42:59 +0200
Message-Id: <20200714184116.579691657@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit b984b6d8b52372b98cce0a6ff6c2787f50665b87 ]

The following bug appeared in the MCDE driver/display
initialization during the recent merge window.

First the place we call drm_fbdev_generic_setup() in the
wrong place: this needs to be called AFTER calling
drm_dev_register() else we get this splat:

 ------------[ cut here ]------------
WARNING: CPU: 0 PID: 1 at ../drivers/gpu/drm/drm_fb_helper.c:2198 drm_fbdev_generic_setup+0x164/0x1a8
mcde a0350000.mcde: Device has not been registered.
Modules linked in:
Hardware name: ST-Ericsson Ux5x0 platform (Device Tree Support)
[<c010e704>] (unwind_backtrace) from [<c010a86c>] (show_stack+0x10/0x14)
[<c010a86c>] (show_stack) from [<c0414f38>] (dump_stack+0x9c/0xb0)
[<c0414f38>] (dump_stack) from [<c0121c8c>] (__warn+0xb8/0xd0)
[<c0121c8c>] (__warn) from [<c0121d18>] (warn_slowpath_fmt+0x74/0xb8)
[<c0121d18>] (warn_slowpath_fmt) from [<c04b154c>] (drm_fbdev_generic_setup+0x164/0x1a8)
[<c04b154c>] (drm_fbdev_generic_setup) from [<c04ed278>] (mcde_drm_bind+0xc4/0x160)
[<c04ed278>] (mcde_drm_bind) from [<c04f06b8>] (try_to_bring_up_master+0x15c/0x1a4)
(...)

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20200613223027.4189309-1-linus.walleij@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mcde/mcde_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mcde/mcde_drv.c b/drivers/gpu/drm/mcde/mcde_drv.c
index f28cb7a576ba4..1e7c5aa4d5e62 100644
--- a/drivers/gpu/drm/mcde/mcde_drv.c
+++ b/drivers/gpu/drm/mcde/mcde_drv.c
@@ -208,7 +208,6 @@ static int mcde_modeset_init(struct drm_device *drm)
 
 	drm_mode_config_reset(drm);
 	drm_kms_helper_poll_init(drm);
-	drm_fbdev_generic_setup(drm, 32);
 
 	return 0;
 
@@ -275,6 +274,8 @@ static int mcde_drm_bind(struct device *dev)
 	if (ret < 0)
 		goto unbind;
 
+	drm_fbdev_generic_setup(drm, 32);
+
 	return 0;
 
 unbind:
-- 
2.25.1



