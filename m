Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7A632E4274
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438563AbgL1PXD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:23:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:34824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408020AbgL1OBh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:01:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8628B206E5;
        Mon, 28 Dec 2020 14:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164082;
        bh=PKJn3+d49AZyCWIvBqInIUOl+zm6lm+zmz6v55aWkgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UPJG5POZtyaGPy7AUlcIHGK49wcVMLgkRsjViwiVK28eeQaWmOWXaR7o+J6mrFqPE
         40jk27rAeT4vLXV5FRO/flhVXar4A0tA8eL0N6bVGVXYfOzOKHCN42BIzGXc2qXBRO
         5pUDecDQcaSGisAQ3uWE/H7N6JvVJp3UQR+hNTUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 054/717] drm/bridge: tpd12s015: Fix irq registering in tpd12s015_probe
Date:   Mon, 28 Dec 2020 13:40:52 +0100
Message-Id: <20201228125023.582584608@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit c2530cc9610d84a5a0118ba40d0f09309605047f ]

gpiod_to_irq() return negative value in case of error,
the existing code doesn't handle negative error codes.
If the HPD gpio supports IRQs (gpiod_to_irq returns a
valid number), we use the IRQ. If it doesn't (gpiod_to_irq
returns an error), it gets polled via detect().

Fixes: cff5e6f7e83f ("drm/bridge: Add driver for the TI TPD12S015 HDMI level shifter")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20201102143024.26216-1-yuehaibing@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ti-tpd12s015.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/ti-tpd12s015.c b/drivers/gpu/drm/bridge/ti-tpd12s015.c
index 514cbf0eac75a..e0e015243a602 100644
--- a/drivers/gpu/drm/bridge/ti-tpd12s015.c
+++ b/drivers/gpu/drm/bridge/ti-tpd12s015.c
@@ -160,7 +160,7 @@ static int tpd12s015_probe(struct platform_device *pdev)
 
 	/* Register the IRQ if the HPD GPIO is IRQ-capable. */
 	tpd->hpd_irq = gpiod_to_irq(tpd->hpd_gpio);
-	if (tpd->hpd_irq) {
+	if (tpd->hpd_irq >= 0) {
 		ret = devm_request_threaded_irq(&pdev->dev, tpd->hpd_irq, NULL,
 						tpd12s015_hpd_isr,
 						IRQF_TRIGGER_RISING |
-- 
2.27.0



