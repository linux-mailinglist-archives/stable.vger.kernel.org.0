Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0EBB7953F
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389155AbfG2TkZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:40:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:55718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388588AbfG2TkZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:40:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4388D206DD;
        Mon, 29 Jul 2019 19:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429224;
        bh=C2RGfg0cJxGXzEoEg8FNKiIFxXbN0hdGRu6XWsmLnJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=athokIhJy3b7PRVxWYHWU3gHQnPUI9ebx+WqgmFwF3BmD3Ga0HMUFclqWYiPGhCrL
         a8BdkXtQy7l1A5/ojrbJCMdVaAW1uGx02I6l7vL0E4VIzvahN7KmFCeEFLhCZWpcwk
         q77Gglx6MZmKzbd7qERCObcL6IyHfdDUJ61ORQXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabien Dessenne <fabien.dessenne@st.com>,
        Fabrice Gasnier <fabrice.gasnier@st.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 003/113] iio: adc: stm32-dfsdm: manage the get_irq error case
Date:   Mon, 29 Jul 2019 21:21:30 +0200
Message-Id: <20190729190656.450569740@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190655.455345569@linuxfoundation.org>
References: <20190729190655.455345569@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 3e53ef91f826957dec013c47707ffc1bb42b42d7 ]

During probe, check the "get_irq" error value.

Signed-off-by: Fabien Dessenne <fabien.dessenne@st.com>
Acked-by: Fabrice Gasnier <fabrice.gasnier@st.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/stm32-dfsdm-adc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/iio/adc/stm32-dfsdm-adc.c b/drivers/iio/adc/stm32-dfsdm-adc.c
index fcd4a1c00ca0..15a115210108 100644
--- a/drivers/iio/adc/stm32-dfsdm-adc.c
+++ b/drivers/iio/adc/stm32-dfsdm-adc.c
@@ -1144,6 +1144,12 @@ static int stm32_dfsdm_adc_probe(struct platform_device *pdev)
 	 * So IRQ associated to filter instance 0 is dedicated to the Filter 0.
 	 */
 	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		if (irq != -EPROBE_DEFER)
+			dev_err(dev, "Failed to get IRQ: %d\n", irq);
+		return irq;
+	}
+
 	ret = devm_request_irq(dev, irq, stm32_dfsdm_irq,
 			       0, pdev->name, adc);
 	if (ret < 0) {
-- 
2.20.1



