Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 734AE667639
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237417AbjALOaG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:30:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237447AbjALO3P (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:29:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D268B5D884
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:20:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A735B81E6D
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:20:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99179C433F0;
        Thu, 12 Jan 2023 14:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533234;
        bh=QfecN/W1xWHTdKk7YmiCKb/CdqDCcyTjSsaAZqf7Xyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ymtyXinJ4qSlW9u1qk18AY/R/EI2G0NBlNj7CEoDNXJAfFLkcLYCrJpPyXjjAK2Op
         knNSSBwN1fh5k7OWuW1ioBWt3k2AQ8RX6CZ2h/H8V8tgLf72NnSHsSY4x5+1KzXwr/
         V0mwuozXhNH7Oi5UTzKquqeoR/+nVNydBNIxDcwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Al Cooper <alcooperx@gmail.com>,
        Justin Chen <justinpopo6@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 413/783] phy: usb: s2 WoL wakeup_count not incremented for USB->Eth devices
Date:   Thu, 12 Jan 2023 14:52:09 +0100
Message-Id: <20230112135543.454563556@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Al Cooper <alcooperx@gmail.com>

[ Upstream commit f7fc5b7090372fc4dd7798c874635ca41b8ba733 ]

The PHY's "wakeup_count" is not incrementing when waking from
WoL. The wakeup count can be found in sysfs at:
/sys/bus/platform/devices/rdb/*.usb-phy/power/wakeup_count.
The problem is that the system wakup event handler was being passed
the wrong "device" by the PHY driver.

Fixes: f1c0db40a3ad ("phy: usb: Add "wake on" functionality")
Signed-off-by: Al Cooper <alcooperx@gmail.com>
Signed-off-by: Justin Chen <justinpopo6@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/1665005418-15807-3-git-send-email-justinpopo6@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/broadcom/phy-brcm-usb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/phy/broadcom/phy-brcm-usb.c b/drivers/phy/broadcom/phy-brcm-usb.c
index b901a0d4e2a8..cd2240ea2c9a 100644
--- a/drivers/phy/broadcom/phy-brcm-usb.c
+++ b/drivers/phy/broadcom/phy-brcm-usb.c
@@ -101,9 +101,9 @@ static int brcm_pm_notifier(struct notifier_block *notifier,
 
 static irqreturn_t brcm_usb_phy_wake_isr(int irq, void *dev_id)
 {
-	struct phy *gphy = dev_id;
+	struct device *dev = dev_id;
 
-	pm_wakeup_event(&gphy->dev, 0);
+	pm_wakeup_event(dev, 0);
 
 	return IRQ_HANDLED;
 }
@@ -437,7 +437,7 @@ static int brcm_usb_phy_dvr_init(struct platform_device *pdev,
 	if (priv->wake_irq >= 0) {
 		err = devm_request_irq(dev, priv->wake_irq,
 				       brcm_usb_phy_wake_isr, 0,
-				       dev_name(dev), gphy);
+				       dev_name(dev), dev);
 		if (err < 0)
 			return err;
 		device_set_wakeup_capable(dev, 1);
-- 
2.35.1



