Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCA23D6184
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbhGZPcN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:32:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:44988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238116AbhGZP3p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:29:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E8F660C40;
        Mon, 26 Jul 2021 16:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315814;
        bh=q5e0xfw4WCM4vPj13P4RMlAVFyKjGNn2WZYQz8k0qxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bjHVYpGWvdK3u3GDUzF97gjI8bPYfr1bxde04BU0RmEMaEdWixU1p4a4+G+/N+w24
         X251Ob3TUqrEZeEYrLMlQEDERFj/C7nJ6wL7oMqUjGl4D7YnJKWWJz2pjy/4+MVVff
         uEXXxzZpG/nRcGQGomQeom/N5SseTnjs5F1rMpTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 078/223] drm/vc4: hdmi: Drop devm interrupt handler for CEC interrupts
Date:   Mon, 26 Jul 2021 17:37:50 +0200
Message-Id: <20210726153848.801898635@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 32a19de21ae40f0601f48575b610dde4f518ccc6 ]

The CEC interrupt handlers are registered through the
devm_request_threaded_irq function. However, while free_irq is indeed
called properly when the device is unbound or bind fails, it's called
after unbind or bind is done.

In our particular case, it means that on failure it creates a window
where our interrupt handler can be called, but we're freeing every
resource (CEC adapter, DRM objects, etc.) it might need.

In order to address this, let's switch to the non-devm variant to
control better when the handler will be unregistered and allow us to
make it safe.

Fixes: 15b4511a4af6 ("drm/vc4: add HDMI CEC support")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210707095112.1469670-2-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 49 +++++++++++++++++++++++-----------
 1 file changed, 33 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 188b74c9e9ff..edee565334d8 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -1690,38 +1690,46 @@ static int vc4_hdmi_cec_init(struct vc4_hdmi *vc4_hdmi)
 	vc4_hdmi_cec_update_clk_div(vc4_hdmi);
 
 	if (vc4_hdmi->variant->external_irq_controller) {
-		ret = devm_request_threaded_irq(&pdev->dev,
-						platform_get_irq_byname(pdev, "cec-rx"),
-						vc4_cec_irq_handler_rx_bare,
-						vc4_cec_irq_handler_rx_thread, 0,
-						"vc4 hdmi cec rx", vc4_hdmi);
+		ret = request_threaded_irq(platform_get_irq_byname(pdev, "cec-rx"),
+					   vc4_cec_irq_handler_rx_bare,
+					   vc4_cec_irq_handler_rx_thread, 0,
+					   "vc4 hdmi cec rx", vc4_hdmi);
 		if (ret)
 			goto err_delete_cec_adap;
 
-		ret = devm_request_threaded_irq(&pdev->dev,
-						platform_get_irq_byname(pdev, "cec-tx"),
-						vc4_cec_irq_handler_tx_bare,
-						vc4_cec_irq_handler_tx_thread, 0,
-						"vc4 hdmi cec tx", vc4_hdmi);
+		ret = request_threaded_irq(platform_get_irq_byname(pdev, "cec-tx"),
+					   vc4_cec_irq_handler_tx_bare,
+					   vc4_cec_irq_handler_tx_thread, 0,
+					   "vc4 hdmi cec tx", vc4_hdmi);
 		if (ret)
-			goto err_delete_cec_adap;
+			goto err_remove_cec_rx_handler;
 	} else {
 		HDMI_WRITE(HDMI_CEC_CPU_MASK_SET, 0xffffffff);
 
-		ret = devm_request_threaded_irq(&pdev->dev, platform_get_irq(pdev, 0),
-						vc4_cec_irq_handler,
-						vc4_cec_irq_handler_thread, 0,
-						"vc4 hdmi cec", vc4_hdmi);
+		ret = request_threaded_irq(platform_get_irq(pdev, 0),
+					   vc4_cec_irq_handler,
+					   vc4_cec_irq_handler_thread, 0,
+					   "vc4 hdmi cec", vc4_hdmi);
 		if (ret)
 			goto err_delete_cec_adap;
 	}
 
 	ret = cec_register_adapter(vc4_hdmi->cec_adap, &pdev->dev);
 	if (ret < 0)
-		goto err_delete_cec_adap;
+		goto err_remove_handlers;
 
 	return 0;
 
+err_remove_handlers:
+	if (vc4_hdmi->variant->external_irq_controller)
+		free_irq(platform_get_irq_byname(pdev, "cec-tx"), vc4_hdmi);
+	else
+		free_irq(platform_get_irq(pdev, 0), vc4_hdmi);
+
+err_remove_cec_rx_handler:
+	if (vc4_hdmi->variant->external_irq_controller)
+		free_irq(platform_get_irq_byname(pdev, "cec-rx"), vc4_hdmi);
+
 err_delete_cec_adap:
 	cec_delete_adapter(vc4_hdmi->cec_adap);
 
@@ -1730,6 +1738,15 @@ err_delete_cec_adap:
 
 static void vc4_hdmi_cec_exit(struct vc4_hdmi *vc4_hdmi)
 {
+	struct platform_device *pdev = vc4_hdmi->pdev;
+
+	if (vc4_hdmi->variant->external_irq_controller) {
+		free_irq(platform_get_irq_byname(pdev, "cec-rx"), vc4_hdmi);
+		free_irq(platform_get_irq_byname(pdev, "cec-tx"), vc4_hdmi);
+	} else {
+		free_irq(platform_get_irq(pdev, 0), vc4_hdmi);
+	}
+
 	cec_unregister_adapter(vc4_hdmi->cec_adap);
 }
 #else
-- 
2.30.2



