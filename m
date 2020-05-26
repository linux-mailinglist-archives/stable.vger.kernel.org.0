Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6E45198F29
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730506AbgCaJBI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:01:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:40164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730490AbgCaJBH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:01:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E737120848;
        Tue, 31 Mar 2020 09:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645266;
        bh=gFz0AHUfNBGQrSN7xcAOj65QeONXXdylWCBDDmIvE3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z0Kx/FkVffIszYzLV0cDg5l3Z4XpIHOceMWnIBB/YBz0yK/ajiVNSef6ZYtuAHYrt
         hLx7b40fPChC8paddgXKC/AoKQOsuvp/djFYdpuO9xL7/2YMSm64xmBXZ72fwQ7L9c
         ngQNiNjfDwKBFbnLiosZnn2Lpkb3R9NwNag1W8MM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 5.6 15/23] staging: wfx: fix init/remove vs IRQ race
Date:   Tue, 31 Mar 2020 10:59:27 +0200
Message-Id: <20200331085315.125120268@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085308.098696461@linuxfoundation.org>
References: <20200331085308.098696461@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

commit 4033714d6cbe04893aa0708d1fcaa45dd8eb3f53 upstream.

Current code races in init/exit with interrupt handlers. This is noticed
by the warning below. Fix it by using devres for ordering allocations and
IRQ de/registration.

WARNING: CPU: 0 PID: 827 at drivers/staging/wfx/bus_spi.c:142 wfx_spi_irq_handler+0x5c/0x64 [wfx]
race condition in driver init/deinit

Cc: stable@vger.kernel.org
Fixes: 0096214a59a7 ("staging: wfx: add support for I/O access")
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Reviewed-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
Link: https://lore.kernel.org/r/f0c66cbb3110c2736cd4357c753fba8c14ee3aee.1581416843.git.mirq-linux@rere.qmqm.pl
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/wfx/bus_sdio.c |   15 ++++++---------
 drivers/staging/wfx/bus_spi.c  |   27 ++++++++++++++-------------
 drivers/staging/wfx/main.c     |   21 +++++++++++++--------
 drivers/staging/wfx/main.h     |    1 -
 4 files changed, 33 insertions(+), 31 deletions(-)

--- a/drivers/staging/wfx/bus_sdio.c
+++ b/drivers/staging/wfx/bus_sdio.c
@@ -200,25 +200,23 @@ static int wfx_sdio_probe(struct sdio_fu
 	if (ret)
 		goto err0;
 
-	ret = wfx_sdio_irq_subscribe(bus);
-	if (ret)
-		goto err1;
-
 	bus->core = wfx_init_common(&func->dev, &wfx_sdio_pdata,
 				    &wfx_sdio_hwbus_ops, bus);
 	if (!bus->core) {
 		ret = -EIO;
-		goto err2;
+		goto err1;
 	}
 
+	ret = wfx_sdio_irq_subscribe(bus);
+	if (ret)
+		goto err1;
+
 	ret = wfx_probe(bus->core);
 	if (ret)
-		goto err3;
+		goto err2;
 
 	return 0;
 
-err3:
-	wfx_free_common(bus->core);
 err2:
 	wfx_sdio_irq_unsubscribe(bus);
 err1:
@@ -234,7 +232,6 @@ static void wfx_sdio_remove(struct sdio_
 	struct wfx_sdio_priv *bus = sdio_get_drvdata(func);
 
 	wfx_release(bus->core);
-	wfx_free_common(bus->core);
 	wfx_sdio_irq_unsubscribe(bus);
 	sdio_claim_host(func);
 	sdio_disable_func(func);
--- a/drivers/staging/wfx/bus_spi.c
+++ b/drivers/staging/wfx/bus_spi.c
@@ -156,6 +156,11 @@ static void wfx_spi_request_rx(struct wo
 	wfx_bh_request_rx(bus->core);
 }
 
+static void wfx_flush_irq_work(void *w)
+{
+	flush_work(w);
+}
+
 static size_t wfx_spi_align_size(void *priv, size_t size)
 {
 	// Most of SPI controllers avoid DMA if buffer size is not 32bit aligned
@@ -211,22 +216,23 @@ static int wfx_spi_probe(struct spi_devi
 		udelay(2000);
 	}
 
-	ret = devm_request_irq(&func->dev, func->irq, wfx_spi_irq_handler,
-			       IRQF_TRIGGER_RISING, "wfx", bus);
-	if (ret)
-		return ret;
-
 	INIT_WORK(&bus->request_rx, wfx_spi_request_rx);
 	bus->core = wfx_init_common(&func->dev, &wfx_spi_pdata,
 				    &wfx_spi_hwbus_ops, bus);
 	if (!bus->core)
 		return -EIO;
 
-	ret = wfx_probe(bus->core);
+	ret = devm_add_action_or_reset(&func->dev, wfx_flush_irq_work,
+				       &bus->request_rx);
 	if (ret)
-		wfx_free_common(bus->core);
+		return ret;
+
+	ret = devm_request_irq(&func->dev, func->irq, wfx_spi_irq_handler,
+			       IRQF_TRIGGER_RISING, "wfx", bus);
+	if (ret)
+		return ret;
 
-	return ret;
+	return wfx_probe(bus->core);
 }
 
 static int wfx_spi_remove(struct spi_device *func)
@@ -234,11 +240,6 @@ static int wfx_spi_remove(struct spi_dev
 	struct wfx_spi_priv *bus = spi_get_drvdata(func);
 
 	wfx_release(bus->core);
-	wfx_free_common(bus->core);
-	// A few IRQ will be sent during device release. Hopefully, no IRQ
-	// should happen after wdev/wvif are released.
-	devm_free_irq(&func->dev, func->irq, bus);
-	flush_work(&bus->request_rx);
 	return 0;
 }
 
--- a/drivers/staging/wfx/main.c
+++ b/drivers/staging/wfx/main.c
@@ -262,6 +262,16 @@ static int wfx_send_pdata_pds(struct wfx
 	return ret;
 }
 
+static void wfx_free_common(void *data)
+{
+	struct wfx_dev *wdev = data;
+
+	mutex_destroy(&wdev->rx_stats_lock);
+	mutex_destroy(&wdev->conf_mutex);
+	wfx_tx_queues_deinit(wdev);
+	ieee80211_free_hw(wdev->hw);
+}
+
 struct wfx_dev *wfx_init_common(struct device *dev,
 				const struct wfx_platform_data *pdata,
 				const struct hwbus_ops *hwbus_ops,
@@ -332,15 +342,10 @@ struct wfx_dev *wfx_init_common(struct d
 	wfx_init_hif_cmd(&wdev->hif_cmd);
 	wfx_tx_queues_init(wdev);
 
-	return wdev;
-}
+	if (devm_add_action_or_reset(dev, wfx_free_common, wdev))
+		return NULL;
 
-void wfx_free_common(struct wfx_dev *wdev)
-{
-	mutex_destroy(&wdev->rx_stats_lock);
-	mutex_destroy(&wdev->conf_mutex);
-	wfx_tx_queues_deinit(wdev);
-	ieee80211_free_hw(wdev->hw);
+	return wdev;
 }
 
 int wfx_probe(struct wfx_dev *wdev)
--- a/drivers/staging/wfx/main.h
+++ b/drivers/staging/wfx/main.h
@@ -34,7 +34,6 @@ struct wfx_dev *wfx_init_common(struct d
 				const struct wfx_platform_data *pdata,
 				const struct hwbus_ops *hwbus_ops,
 				void *hwbus_priv);
-void wfx_free_common(struct wfx_dev *wdev);
 
 int wfx_probe(struct wfx_dev *wdev);
 void wfx_release(struct wfx_dev *wdev);


