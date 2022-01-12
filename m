Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 367C648C65E
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 15:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354235AbiALOqP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 09:46:15 -0500
Received: from mx07-00178001.pphosted.com ([185.132.182.106]:52930 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241952AbiALOqO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jan 2022 09:46:14 -0500
Received: from pps.filterd (m0288072.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20CBMfZx006161;
        Wed, 12 Jan 2022 15:45:59 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=selector1;
 bh=PFOJ1LsMAP6bXSULAimH2RrG6EWZ3R86IFqcQserM2E=;
 b=gR3mTW6VGxbAGQblc9l7ZUntrUiuq9cBQ4wZSPIUXNpOhUhmxROiRk10SdemD2U8+YQ/
 l2TOpzRt+HfBe7vkS4GaoaF7mnsyoOLNc7e7gvSSTBvaWCQRQwJo3ZkiywC8JLZVfVh+
 XWUWeaclTc9i+D9zICQ7lZbh0E4GJvgqgVQHKVyatBZJEXQWQgeo3pKEVl+g7N8eele/
 JFZ+R3JErvjE6ZH5wm5KHOpimjmKGur/O0iZnKk0IPTwzeJH6jTvWgVZf4jwJ5z4FLe4
 zE0KMmkLmcsqafb7GJLkWgleHlaDRU8LUpd8VVVr/ndU0PJzZ7dHhSP2rleA+G2eU0je 1Q== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3dhtft2jvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 15:45:59 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id D6BB410002A;
        Wed, 12 Jan 2022 15:45:58 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag2node2.st.com [10.75.127.5])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id CB61123C6A2;
        Wed, 12 Jan 2022 15:45:58 +0100 (CET)
Received: from localhost (10.75.127.46) by SFHDAG2NODE2.st.com (10.75.127.5)
 with Microsoft SMTP Server (TLS) id 15.0.1497.26; Wed, 12 Jan 2022 15:45:58
 +0100
From:   <patrice.chotard@foss.st.com>
To:     Mark Brown <broonie@kernel.org>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>
CC:     <linux-spi@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <christophe.kerello@foss.st.com>,
        <patrice.chotard@foss.st.com>, <stable@vger.kernel.org>
Subject: [PATCH v2] spi: stm32-qspi: Update spi registering
Date:   Wed, 12 Jan 2022 15:44:24 +0100
Message-ID: <20220112144424.5278-1-patrice.chotard@foss.st.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.46]
X-ClientProxiedBy: SFHDAG2NODE2.st.com (10.75.127.5) To SFHDAG2NODE2.st.com
 (10.75.127.5)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-12_04,2022-01-11_01,2021-12-02_01
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Patrice Chotard <patrice.chotard@foss.st.com>

Some device driver need to communicate to qspi device during the remove
process, qspi controller must be functional when spi_unregister_master()
is called.

To ensure this, replace devm_spi_register_master() by spi_register_master()
and spi_unregister_master() is called directly in .remove callback before
stopping the qspi controller.

This issue was put in evidence using kernel v5.11 and later
with a spi-nor which supports the software reset feature introduced
by commit d73ee7534cc5 ("mtd: spi-nor: core: perform a Soft Reset on
shutdown")

Fixes: c530cd1d9d5e ("spi: spi-mem: add stm32 qspi controller")

Signed-off-by: Patrice Chotard <patrice.chotard@foss.st.com>
Cc: <stable@vger.kernel.org> # 5.8.x
---

v2: 
  _ update commit message
  _ make usage of devm_spi_alloc_master() instead of spi_alloc_master()

 drivers/spi/spi-stm32-qspi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-stm32-qspi.c b/drivers/spi/spi-stm32-qspi.c
index 514337c86d2c..09839a3dbb26 100644
--- a/drivers/spi/spi-stm32-qspi.c
+++ b/drivers/spi/spi-stm32-qspi.c
@@ -688,7 +688,7 @@ static int stm32_qspi_probe(struct platform_device *pdev)
 	struct resource *res;
 	int ret, irq;
 
-	ctrl = spi_alloc_master(dev, sizeof(*qspi));
+	ctrl = devm_spi_alloc_master(dev, sizeof(*qspi));
 	if (!ctrl)
 		return -ENOMEM;
 
@@ -784,7 +784,7 @@ static int stm32_qspi_probe(struct platform_device *pdev)
 	pm_runtime_enable(dev);
 	pm_runtime_get_noresume(dev);
 
-	ret = devm_spi_register_master(dev, ctrl);
+	ret = spi_register_master(ctrl);
 	if (ret)
 		goto err_pm_runtime_free;
 
@@ -817,6 +817,7 @@ static int stm32_qspi_remove(struct platform_device *pdev)
 	struct stm32_qspi *qspi = platform_get_drvdata(pdev);
 
 	pm_runtime_get_sync(qspi->dev);
+	spi_unregister_master(qspi->ctrl);
 	/* disable qspi */
 	writel_relaxed(0, qspi->io_base + QSPI_CR);
 	stm32_qspi_dma_free(qspi);
-- 
2.17.1

