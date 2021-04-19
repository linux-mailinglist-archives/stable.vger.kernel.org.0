Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33EE6364154
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 14:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239045AbhDSMQ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 08:16:29 -0400
Received: from mx07-00178001.pphosted.com ([185.132.182.106]:43410 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239041AbhDSMQ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Apr 2021 08:16:29 -0400
Received: from pps.filterd (m0241204.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13JCBMi6028003;
        Mon, 19 Apr 2021 14:15:44 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=selector1;
 bh=oP6bwnD9fv0xHxu6w27iRBSjRpt2R2DDkqvUICCFy/4=;
 b=bVKVh8BeTuYDAxy5Xq+u3JtMEofaEcOoQulghesa8YNcIGBvjjvxXB1e6aFLeaCXRCL0
 s6+/ARF7zJNuJ8AJJUGA9HbNImOfstcfwgrgmAXQc3Dxa0W/efQvaX8a7WQ2z2G738M6
 CgLgRfl/pfolhevKctYmrB5ctnVATwqq0946vLEoIul8GgCHQbabRmabmGcqt0jpDJTp
 pxNs4oCt4EHFwevT43AbefFfXCc3gQJVWGBCdvuz/lyY8bTwXC/Bs29XJ/XFyNYLJQy4
 +sDR881ZsfGPVzkB942cx8rFmKw3mUhI23yjz7JCUoUXHBulUpXMw4aU5o9C6cP35grn qQ== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 380wj63h0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Apr 2021 14:15:44 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id BC2B6100034;
        Mon, 19 Apr 2021 14:15:43 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag2node3.st.com [10.75.127.6])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id B10192139BE;
        Mon, 19 Apr 2021 14:15:43 +0200 (CEST)
Received: from localhost (10.75.127.44) by SFHDAG2NODE3.st.com (10.75.127.6)
 with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 19 Apr 2021 14:15:43
 +0200
From:   <patrice.chotard@foss.st.com>
To:     Mark Brown <broonie@kernel.org>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>
CC:     <linux-spi@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <christophe.kerello@foss.st.com>,
        <patrice.chotard@foss.st.com>, <stable@vger.kernel.org>
Subject: [PATCH 1/3] spi: stm32-qspi: fix pm_runtime usage_count counter
Date:   Mon, 19 Apr 2021 14:15:39 +0200
Message-ID: <20210419121541.11617-2-patrice.chotard@foss.st.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210419121541.11617-1-patrice.chotard@foss.st.com>
References: <20210419121541.11617-1-patrice.chotard@foss.st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.44]
X-ClientProxiedBy: SFHDAG1NODE3.st.com (10.75.127.3) To SFHDAG2NODE3.st.com
 (10.75.127.6)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-19_07:2021-04-16,2021-04-19 signatures=0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Kerello <christophe.kerello@foss.st.com>

pm_runtime usage_count counter is not well managed.
pm_runtime_put_autosuspend callback drops the usage_counter but this
one has never been increased. Add pm_runtime_get_sync callback to bump up
the usage counter. It is also needed to use pm_runtime_force_suspend and
pm_runtime_force_resume APIs to handle properly the clock.

Fixes: 9d282c17b023 ("spi: stm32-qspi: Add pm_runtime support")
Signed-off-by: Christophe Kerello <christophe.kerello@foss.st.com>
Cc: stable@vger.kernel.org
---
 drivers/spi/spi-stm32-qspi.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-stm32-qspi.c b/drivers/spi/spi-stm32-qspi.c
index 947e6b9dc9f4..2786470a5201 100644
--- a/drivers/spi/spi-stm32-qspi.c
+++ b/drivers/spi/spi-stm32-qspi.c
@@ -727,21 +727,31 @@ static int __maybe_unused stm32_qspi_suspend(struct device *dev)
 {
 	pinctrl_pm_select_sleep_state(dev);
 
-	return 0;
+	return pm_runtime_force_suspend(dev);
 }
 
 static int __maybe_unused stm32_qspi_resume(struct device *dev)
 {
 	struct stm32_qspi *qspi = dev_get_drvdata(dev);
+	int ret;
+
+	ret = pm_runtime_force_resume(dev);
+	if (ret < 0)
+		return ret;
 
 	pinctrl_pm_select_default_state(dev);
-	clk_prepare_enable(qspi->clk);
+
+	ret = pm_runtime_get_sync(dev);
+	if (ret < 0) {
+		pm_runtime_put_noidle(dev);
+		return ret;
+	}
 
 	writel_relaxed(qspi->cr_reg, qspi->io_base + QSPI_CR);
 	writel_relaxed(qspi->dcr_reg, qspi->io_base + QSPI_DCR);
 
-	pm_runtime_mark_last_busy(qspi->dev);
-	pm_runtime_put_autosuspend(qspi->dev);
+	pm_runtime_mark_last_busy(dev);
+	pm_runtime_put_autosuspend(dev);
 
 	return 0;
 }
-- 
2.17.1

