Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7CB013E1C4
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729325AbgAPQvv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:51:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:34712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727015AbgAPQvv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:51:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A76420730;
        Thu, 16 Jan 2020 16:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193510;
        bh=W4bmo0XoLxtIi+BLTG5NtjsIrm85yVa7XtYFfNDdbvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y3EG3l1cMY7e2a8f+wOLbSHbPHQdS0K80r3T6lHOC3zWEzAMXXlbK0p7JQAL/mVjB
         YZOpwHMPcTtavGn+69eaKFLS4eyPQaX0gOvm6z2f+Y+WtWt0ChI7rtmiDi/MilroZj
         ST7l+sV8GOa8Lk1Sk3CfC8TnJ1EaPQXzAsIZ5u8E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Stephen Boyd <swboyd@chromium.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 093/205] pinctrl: sh-pfc: Do not use platform_get_irq() to count interrupts
Date:   Thu, 16 Jan 2020 11:41:08 -0500
Message-Id: <20200116164300.6705-93-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit ad7fe1a1a35994a201497443b5140bf54b074cca ]

As platform_get_irq() now prints an error when the interrupt does not
exist, counting interrupts by looping until failure causes the printing
of scary messages like:

    sh-pfc e6060000.pin-controller: IRQ index 0 not found

Fix this by using the platform_irq_count() helper instead.

Fixes: 7723f4c5ecdb8d83 ("driver core: platform: Add an error message to platform_get_irq*()")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/20191016142601.28255-1-geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sh-pfc/core.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/pinctrl/sh-pfc/core.c b/drivers/pinctrl/sh-pfc/core.c
index b8640ad41bef..ce983247c9e2 100644
--- a/drivers/pinctrl/sh-pfc/core.c
+++ b/drivers/pinctrl/sh-pfc/core.c
@@ -29,12 +29,12 @@
 static int sh_pfc_map_resources(struct sh_pfc *pfc,
 				struct platform_device *pdev)
 {
-	unsigned int num_windows, num_irqs;
 	struct sh_pfc_window *windows;
 	unsigned int *irqs = NULL;
+	unsigned int num_windows;
 	struct resource *res;
 	unsigned int i;
-	int irq;
+	int num_irqs;
 
 	/* Count the MEM and IRQ resources. */
 	for (num_windows = 0;; num_windows++) {
@@ -42,17 +42,13 @@ static int sh_pfc_map_resources(struct sh_pfc *pfc,
 		if (!res)
 			break;
 	}
-	for (num_irqs = 0;; num_irqs++) {
-		irq = platform_get_irq(pdev, num_irqs);
-		if (irq == -EPROBE_DEFER)
-			return irq;
-		if (irq < 0)
-			break;
-	}
-
 	if (num_windows == 0)
 		return -EINVAL;
 
+	num_irqs = platform_irq_count(pdev);
+	if (num_irqs < 0)
+		return num_irqs;
+
 	/* Allocate memory windows and IRQs arrays. */
 	windows = devm_kcalloc(pfc->dev, num_windows, sizeof(*windows),
 			       GFP_KERNEL);
-- 
2.20.1

