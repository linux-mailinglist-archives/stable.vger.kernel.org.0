Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC53B1861F0
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 03:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729936AbgCPCen (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Mar 2020 22:34:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:38380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729927AbgCPCem (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Mar 2020 22:34:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F63E20726;
        Mon, 16 Mar 2020 02:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584326081;
        bh=ZZnHNSt6W/dTcHetd5j2f9gR0uIYQG3CneTi7NAPW7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NQnrHBW05I8nEmX1nlaw15c5nzfM4fjbkrSV+1Ns7ZmQk3Bbi/gqyqPe/eccb9PVU
         ywUv2SMaz7/xy7UGIsXMg8PaDx2HE0iIZOz/KMrC6PPMbOyyq6Ee0LmhNw21fSPAah
         cjzdIvogJdx9PZ05HRFDSHARe9Br3iwWR91RPGmk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aaro Koskinen <aaro.koskinen@nokia.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 26/35] spi: spi_register_controller(): free bus id on error paths
Date:   Sun, 15 Mar 2020 22:34:02 -0400
Message-Id: <20200316023411.1263-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200316023411.1263-1-sashal@kernel.org>
References: <20200316023411.1263-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaro Koskinen <aaro.koskinen@nokia.com>

[ Upstream commit f9981d4f50b475d7dbb70f3022b87a3c8bba9fd6 ]

Some error paths leave the bus id allocated. As a result the IDR
allocation will fail after a deferred probe. Fix by freeing the bus id
always on error.

Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
Message-Id: <20200304111740.27915-1-aaro.koskinen@nokia.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 26b91ee0855dc..c186d3a944cd0 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -2452,7 +2452,7 @@ int spi_register_controller(struct spi_controller *ctlr)
 		if (ctlr->use_gpio_descriptors) {
 			status = spi_get_gpio_descs(ctlr);
 			if (status)
-				return status;
+				goto free_bus_id;
 			/*
 			 * A controller using GPIO descriptors always
 			 * supports SPI_CS_HIGH if need be.
@@ -2462,7 +2462,7 @@ int spi_register_controller(struct spi_controller *ctlr)
 			/* Legacy code path for GPIOs from DT */
 			status = of_spi_get_gpio_numbers(ctlr);
 			if (status)
-				return status;
+				goto free_bus_id;
 		}
 	}
 
@@ -2470,17 +2470,14 @@ int spi_register_controller(struct spi_controller *ctlr)
 	 * Even if it's just one always-selected device, there must
 	 * be at least one chipselect.
 	 */
-	if (!ctlr->num_chipselect)
-		return -EINVAL;
+	if (!ctlr->num_chipselect) {
+		status = -EINVAL;
+		goto free_bus_id;
+	}
 
 	status = device_add(&ctlr->dev);
-	if (status < 0) {
-		/* free bus id */
-		mutex_lock(&board_lock);
-		idr_remove(&spi_master_idr, ctlr->bus_num);
-		mutex_unlock(&board_lock);
-		goto done;
-	}
+	if (status < 0)
+		goto free_bus_id;
 	dev_dbg(dev, "registered %s %s\n",
 			spi_controller_is_slave(ctlr) ? "slave" : "master",
 			dev_name(&ctlr->dev));
@@ -2496,11 +2493,7 @@ int spi_register_controller(struct spi_controller *ctlr)
 		status = spi_controller_initialize_queue(ctlr);
 		if (status) {
 			device_del(&ctlr->dev);
-			/* free bus id */
-			mutex_lock(&board_lock);
-			idr_remove(&spi_master_idr, ctlr->bus_num);
-			mutex_unlock(&board_lock);
-			goto done;
+			goto free_bus_id;
 		}
 	}
 	/* add statistics */
@@ -2515,7 +2508,12 @@ int spi_register_controller(struct spi_controller *ctlr)
 	/* Register devices from the device tree and ACPI */
 	of_register_spi_devices(ctlr);
 	acpi_register_spi_devices(ctlr);
-done:
+	return status;
+
+free_bus_id:
+	mutex_lock(&board_lock);
+	idr_remove(&spi_master_idr, ctlr->bus_num);
+	mutex_unlock(&board_lock);
 	return status;
 }
 EXPORT_SYMBOL_GPL(spi_register_controller);
-- 
2.20.1

