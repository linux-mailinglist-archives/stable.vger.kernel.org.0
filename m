Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94BBA6E040
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbfGSD4u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 23:56:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726075AbfGSD4t (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 23:56:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1845A21850;
        Fri, 19 Jul 2019 03:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508608;
        bh=8XDsGFM4Eq54gtQvck4W4e5XB0iP9xgO8YE6Tl1Io08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BhOCqz2KOyKevIE0Z/XDMWf7UGUhzl6lK8pMfU5HPnxqPXXYLQJTi/b2stA4YiCV4
         Rq0ZM0ZfK+iTlcLob60nNWJ8zBaY71AohJASa/EBdiZC+Grxiegiq0FnycD9ZqviO5
         Qo7R2Hj7uLDtBPKAXJ/neShIkcA+vPhLPTU3kdbA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabien Dessenne <fabien.dessenne@st.com>,
        Fabrice Gasnier <fabrice.gasnier@st.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 003/171] iio: adc: stm32-dfsdm: manage the get_irq error case
Date:   Thu, 18 Jul 2019 23:53:54 -0400
Message-Id: <20190719035643.14300-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabien Dessenne <fabien.dessenne@st.com>

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

