Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9819B6DF3C
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729961AbfGSEdp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:33:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:34858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727344AbfGSECv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:02:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7375721852;
        Fri, 19 Jul 2019 04:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508971;
        bh=S/rJsy8G7o8vN+1VvSbzkJktlxPr15syvSlOs0q7d94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SMHL3BgygEXszUpaY61j4DGGN8whIW+aXZQj2rLHawRLVwZhUkR1c9XvXBCTdNhvY
         KQvjfQ5+bBYbFKBbaLkF/KsqOG4KR73JBUFOtv221XhMai4rAGKyCSNTDznRY+BDS/
         xnpxp/2CmZgpLxJiZEgp2w1XqWpCkNOv2tUhf/OQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabien Dessenne <fabien.dessenne@st.com>,
        Fabrice Gasnier <fabrice.gasnier@st.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 002/141] iio: adc: stm32-dfsdm: manage the get_irq error case
Date:   Fri, 19 Jul 2019 00:00:27 -0400
Message-Id: <20190719040246.15945-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040246.15945-1-sashal@kernel.org>
References: <20190719040246.15945-1-sashal@kernel.org>
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

