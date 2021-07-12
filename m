Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334D03C4A01
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237757AbhGLGsD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:48:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:44284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238311AbhGLGrH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:47:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D15CC6124C;
        Mon, 12 Jul 2021 06:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072182;
        bh=iXdkt7lFSEcVEz9LqocFpVqjTAQ3P65zABd4cEeux3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z/Pn73IgtBi9xOs8pEB/MrgS86csj+ajLf4vZ/hgfHUBpXaqe2RQum7sJCdVwjNfR
         osER3giprICMPiDmDXsjZNpuH4e8J1OT6+13Ikj3n52dD0s7B1KVk4h1y7UwyNKkyT
         tvgzZG3PXitY9WWpPiYnwAzZ+98DIovYFrC5ZvmE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 336/593] drm/vc4: hdmi: Fix error path of hpd-gpios
Date:   Mon, 12 Jul 2021 08:08:16 +0200
Message-Id: <20210712060922.896458263@linuxfoundation.org>
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

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit e075a7811977ff51c917a65ed1896e08231d2615 ]

If the of_get_named_gpio_flags call fails in vc4_hdmi_bind, we jump to
the err_unprepare_hsm label. That label will then call
pm_runtime_disable and put_device on the DDC device.

We just retrieved the DDC device, so the latter is definitely justified.
However at that point we still haven't called pm_runtime_enable, so the
call to pm_runtime_disable is not supposed to be there.

Fixes: 10ee275cb12f ("drm/vc4: prepare for CEC support")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210524131852.263883-1-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 88a8cb840cd5..25a09aaf5883 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -1795,7 +1795,7 @@ static int vc4_hdmi_bind(struct device *dev, struct device *master, void *data)
 							     &hpd_gpio_flags);
 		if (vc4_hdmi->hpd_gpio < 0) {
 			ret = vc4_hdmi->hpd_gpio;
-			goto err_unprepare_hsm;
+			goto err_put_ddc;
 		}
 
 		vc4_hdmi->hpd_active_low = hpd_gpio_flags & OF_GPIO_ACTIVE_LOW;
@@ -1836,8 +1836,8 @@ err_destroy_conn:
 	vc4_hdmi_connector_destroy(&vc4_hdmi->connector);
 err_destroy_encoder:
 	drm_encoder_cleanup(encoder);
-err_unprepare_hsm:
 	pm_runtime_disable(dev);
+err_put_ddc:
 	put_device(&vc4_hdmi->ddc->dev);
 
 	return ret;
-- 
2.30.2



