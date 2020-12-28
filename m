Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6CCE2E3D22
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439730AbgL1OLv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:11:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:46306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439728AbgL1OLv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:11:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E601207B6;
        Mon, 28 Dec 2020 14:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164670;
        bh=wVy12jNep2eyFnbYJXmGX8vZ5VsGyWMcMzYPQVd6T7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wrgrGaoCqzb96/l1XlO14pOwThdJqNVDuIjZqnX11TNBIpCc9ri4iHSQo//OSkoR1
         sMSM58w7Af3PJvBAenrrvgTaMN5JyL2+PCXEOZte0ALOwCbvnAtX3sFNeNEUBxiQwH
         X/WOBMU3WQquYY7f1F43KNSOdNDwZxrVXGUjObMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 257/717] media: max9271: Fix GPIO enable/disable
Date:   Mon, 28 Dec 2020 13:44:15 +0100
Message-Id: <20201228125033.306315339@linuxfoundation.org>
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

From: Jacopo Mondi <jacopo+renesas@jmondi.org>

[ Upstream commit 909a0a189c677307edd461e21fd962784370d27f ]

Fix GPIO enable/disable operations which wrongly read the 0x0f register
to obtain the current mask of the enabled lines instead of using
the correct 0x0e register.

Also fix access to bit 0 of the register which is marked as reserved.

Fixes: 34009bffc1c6 ("media: i2c: Add RDACM20 driver")
Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/max9271.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/max9271.c b/drivers/media/i2c/max9271.c
index 0f6f7a092a463..c247db569bab0 100644
--- a/drivers/media/i2c/max9271.c
+++ b/drivers/media/i2c/max9271.c
@@ -223,12 +223,12 @@ int max9271_enable_gpios(struct max9271_device *dev, u8 gpio_mask)
 {
 	int ret;
 
-	ret = max9271_read(dev, 0x0f);
+	ret = max9271_read(dev, 0x0e);
 	if (ret < 0)
 		return 0;
 
 	/* BIT(0) reserved: GPO is always enabled. */
-	ret |= gpio_mask | BIT(0);
+	ret |= (gpio_mask & ~BIT(0));
 	ret = max9271_write(dev, 0x0e, ret);
 	if (ret < 0) {
 		dev_err(&dev->client->dev, "Failed to enable gpio (%d)\n", ret);
@@ -245,12 +245,12 @@ int max9271_disable_gpios(struct max9271_device *dev, u8 gpio_mask)
 {
 	int ret;
 
-	ret = max9271_read(dev, 0x0f);
+	ret = max9271_read(dev, 0x0e);
 	if (ret < 0)
 		return 0;
 
 	/* BIT(0) reserved: GPO cannot be disabled */
-	ret &= (~gpio_mask | BIT(0));
+	ret &= ~(gpio_mask | BIT(0));
 	ret = max9271_write(dev, 0x0e, ret);
 	if (ret < 0) {
 		dev_err(&dev->client->dev, "Failed to disable gpio (%d)\n", ret);
-- 
2.27.0



