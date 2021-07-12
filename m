Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E73583C53A5
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348354AbhGLHzc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:55:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:36654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350572AbhGLHvK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4388D611AC;
        Mon, 12 Jul 2021 07:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075980;
        bh=Teb3dnRvIWvnA7vSgfo+/9Y4c4Ws69bBcwaleKYUrnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bJfW6O3ri2TaDbEBiEL85kTjRMFxtLUV+UTFX2JI2+BfJlHZ/lKuQvhPijenZ2fGv
         wrxtjJ/W0F548vv6dkpu1ftPILNr7fIGYXz5L0h6tYG879ZsdqY3lXj/lR33nTFSZZ
         OaNKaO875PDxxi4yIBWLoYNMnU0ImR2BiH3cUrds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 447/800] drm/vc4: hdmi: Fix error path of hpd-gpios
Date:   Mon, 12 Jul 2021 08:07:50 +0200
Message-Id: <20210712061014.678270063@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
index 8106b5634fe1..e94730beb15b 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -2000,7 +2000,7 @@ static int vc4_hdmi_bind(struct device *dev, struct device *master, void *data)
 							     &hpd_gpio_flags);
 		if (vc4_hdmi->hpd_gpio < 0) {
 			ret = vc4_hdmi->hpd_gpio;
-			goto err_unprepare_hsm;
+			goto err_put_ddc;
 		}
 
 		vc4_hdmi->hpd_active_low = hpd_gpio_flags & OF_GPIO_ACTIVE_LOW;
@@ -2041,8 +2041,8 @@ err_destroy_conn:
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



