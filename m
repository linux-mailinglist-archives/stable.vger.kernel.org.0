Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDF0797D1
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390188AbfG2Tqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:46:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:35908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390195AbfG2Tqf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:46:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDB71205F4;
        Mon, 29 Jul 2019 19:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429594;
        bh=jKio98r7bD6DUVhaUeg7gcs55zmhKzD1WN9JN8IWG8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tZBdDU/rvx9tOLUTc5NH1ighH+BLPmBwnzaEJvxfX8leHIoXRmXDSiPhj99N3mer9
         iWld7mFO8S7g5azbyTwWvph2NQKeJkCkZEeoovTInDpLLHj2ndTaRl8kZ+nlQ5aH8J
         Amjt5DBIPVC+JycHFyL7ferxOy5tK8cKYTWNqTfo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabien Dessenne <fabien.dessenne@st.com>,
        Fabrice Gasnier <fabrice.gasnier@st.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 006/215] iio: adc: stm32-dfsdm: manage the get_irq error case
Date:   Mon, 29 Jul 2019 21:20:02 +0200
Message-Id: <20190729190740.785576967@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
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
index 19adc2b23472..588907cc3b6b 100644
--- a/drivers/iio/adc/stm32-dfsdm-adc.c
+++ b/drivers/iio/adc/stm32-dfsdm-adc.c
@@ -1456,6 +1456,12 @@ static int stm32_dfsdm_adc_probe(struct platform_device *pdev)
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



