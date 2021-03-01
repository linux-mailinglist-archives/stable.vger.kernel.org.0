Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30972328C39
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240248AbhCASrM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:47:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:49690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239856AbhCASlY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:41:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA0E464FD5;
        Mon,  1 Mar 2021 17:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621042;
        bh=l4el9ZaN/0RBS//xc1d3IhpwfqxRyt1uNjFyJqmUeNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VfveZ5ykK8E6LhARtlJd24Bi0lU7ECqW9gBSl3Vtud8jN7Gm+R6+phd5GhX9d33g6
         KKtyMvAzrgkKFKKj4iFbbKlfiTwGc5Uac5i7jPtimfhMREKbcyC4MaVNRl53WNCmVE
         HVC0iF2/mXuUU4dgcq6Hjjj1yp6M+y3LbDludzmc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Samuel Holland <samuel@sholland.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 373/775] power: supply: axp20x_usb_power: Init work before enabling IRQs
Date:   Mon,  1 Mar 2021 17:09:01 +0100
Message-Id: <20210301161220.039307088@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit b5e8642ed95ff6ecc20cc6038fe831affa9d098c ]

The IRQ handler calls mod_delayed_work() on power->vbus_detect. However,
that work item is not initialized until after the IRQs are enabled. If
an IRQ is already pending when the driver is probed, the driver calls
mod_delayed_work() on an uninitialized work item, which causes an oops.

Fixes: bcfb7ae3f50b ("power: supply: axp20x_usb_power: Only poll while offline")
Signed-off-by: Samuel Holland <samuel@sholland.org>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/axp20x_usb_power.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/axp20x_usb_power.c b/drivers/power/supply/axp20x_usb_power.c
index 70b28b699a80c..8933ae26c3d69 100644
--- a/drivers/power/supply/axp20x_usb_power.c
+++ b/drivers/power/supply/axp20x_usb_power.c
@@ -593,6 +593,7 @@ static int axp20x_usb_power_probe(struct platform_device *pdev)
 	power->axp20x_id = axp_data->axp20x_id;
 	power->regmap = axp20x->regmap;
 	power->num_irqs = axp_data->num_irq_names;
+	INIT_DELAYED_WORK(&power->vbus_detect, axp20x_usb_power_poll_vbus);
 
 	if (power->axp20x_id == AXP202_ID) {
 		/* Enable vbus valid checking */
@@ -645,7 +646,6 @@ static int axp20x_usb_power_probe(struct platform_device *pdev)
 		}
 	}
 
-	INIT_DELAYED_WORK(&power->vbus_detect, axp20x_usb_power_poll_vbus);
 	if (axp20x_usb_vbus_needs_polling(power))
 		queue_delayed_work(system_power_efficient_wq, &power->vbus_detect, 0);
 
-- 
2.27.0



