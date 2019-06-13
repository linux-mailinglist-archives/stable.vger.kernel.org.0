Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1FC44056
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732787AbfFMQFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:05:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:35060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731342AbfFMIqf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:46:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AD9020851;
        Thu, 13 Jun 2019 08:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415595;
        bh=jEd49Y0EF33OVMoZCwSWixaVI9LfQ5+lkZaujtTC+K8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NsdihqMOl1kqvyPn/kSoUTeQ1hIkj5DRlz4En3y9mX5FvM435x9cXymc2+CoZKo42
         PtZN++AW98RZWu7rdL7no24Pjy0vip/WRghUn1u2LAUArBIIr7yTQisZSvVNMT+k3Z
         LPTKLp9Ghl4erilSZEkBec4gGmsQE8rRHQGqC8OI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabien Dessenne <fabien.dessenne@st.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 040/155] mailbox: stm32-ipcc: check invalid irq
Date:   Thu, 13 Jun 2019 10:32:32 +0200
Message-Id: <20190613075655.342720138@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 210fe504f5ae..f91dfb1327c7 100644
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



