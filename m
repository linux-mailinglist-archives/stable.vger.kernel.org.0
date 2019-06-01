Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46CCC31F3D
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbfFANSi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:18:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:45688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727850AbfFANSh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:18:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A421D272AC;
        Sat,  1 Jun 2019 13:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395117;
        bh=k7qAy5CUsxcDgaelIj/rQx3NsXyDYYToboFli8rpOjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R5PGF9OYBO2/dT32nSQOHOQVrX2+BzI/ovUEO8W0O9FGqgnnj7OArR77BlUWQ8EnW
         WhpsBhZaAZMXgel8LfkFxAWiwFLhdxaSZ3wBkQnQKkd9wQkCl4B7OKwpINv7kkVEs+
         tv/eRYyqvgmihuBzr3PbY8aYUWy58JNlPIJh+tu0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabien Dessenne <fabien.dessenne@st.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 041/186] mailbox: stm32-ipcc: check invalid irq
Date:   Sat,  1 Jun 2019 09:14:17 -0400
Message-Id: <20190601131653.24205-41-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601131653.24205-1-sashal@kernel.org>
References: <20190601131653.24205-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabien Dessenne <fabien.dessenne@st.com>

[ Upstream commit 68a1c8485cf83734d4da9d81cd3b5d2ae7c0339b ]

On failure of_irq_get() returns a negative value or zero, which is
not handled as an error in the existing implementation.
Instead of using this API, use platform_get_irq() that returns
exclusively a negative value on failure.
Also, do not output an error log in case of defer probe error.

Signed-off-by: Fabien Dessenne <fabien.dessenne@st.com>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/stm32-ipcc.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/mailbox/stm32-ipcc.c b/drivers/mailbox/stm32-ipcc.c
index 210fe504f5aee..f91dfb1327c7c 100644
--- a/drivers/mailbox/stm32-ipcc.c
+++ b/drivers/mailbox/stm32-ipcc.c
@@ -8,9 +8,9 @@
 #include <linux/bitfield.h>
 #include <linux/clk.h>
 #include <linux/interrupt.h>
+#include <linux/io.h>
 #include <linux/mailbox_controller.h>
 #include <linux/module.h>
-#include <linux/of_irq.h>
 #include <linux/platform_device.h>
 #include <linux/pm_wakeirq.h>
 
@@ -240,9 +240,11 @@ static int stm32_ipcc_probe(struct platform_device *pdev)
 
 	/* irq */
 	for (i = 0; i < IPCC_IRQ_NUM; i++) {
-		ipcc->irqs[i] = of_irq_get_byname(dev->of_node, irq_name[i]);
+		ipcc->irqs[i] = platform_get_irq_byname(pdev, irq_name[i]);
 		if (ipcc->irqs[i] < 0) {
-			dev_err(dev, "no IRQ specified %s\n", irq_name[i]);
+			if (ipcc->irqs[i] != -EPROBE_DEFER)
+				dev_err(dev, "no IRQ specified %s\n",
+					irq_name[i]);
 			ret = ipcc->irqs[i];
 			goto err_clk;
 		}
@@ -263,9 +265,10 @@ static int stm32_ipcc_probe(struct platform_device *pdev)
 
 	/* wakeup */
 	if (of_property_read_bool(np, "wakeup-source")) {
-		ipcc->wkp = of_irq_get_byname(dev->of_node, "wakeup");
+		ipcc->wkp = platform_get_irq_byname(pdev, "wakeup");
 		if (ipcc->wkp < 0) {
-			dev_err(dev, "could not get wakeup IRQ\n");
+			if (ipcc->wkp != -EPROBE_DEFER)
+				dev_err(dev, "could not get wakeup IRQ\n");
 			ret = ipcc->wkp;
 			goto err_clk;
 		}
-- 
2.20.1

