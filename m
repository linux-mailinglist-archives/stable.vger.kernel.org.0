Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2882439A6BC
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbhFCRJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:09:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:40212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230247AbhFCRJX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:09:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D294613F1;
        Thu,  3 Jun 2021 17:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740058;
        bh=M/5NejGzPjHEsCiI1zU6wysLuJGHBUueDoeg9EZU1Eg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PRZNJz0vDq6lVPOkSUWQvtxaZedIGznIVzUbbUd10f6ao5m2TsmjPxd6a+4cXU4BY
         4Cb+dXhXnPMWOAqg+GtsBMR7kpsALzmHLtgoC6Cr1gtrSRzLGdAkvLmwtsHMZlGpMd
         pRtEXJJE5VV8cJj1T4xn4MAaiMy9wxyaZ+zxnB69eMod9Vi6gmAJmdhEfDt8h1puBg
         DJO9/uVUuJrLkWxAuRXAlly2XS/Tw3hq4fLMyhMKF/To85l7+8N0GgvkCYG1RJLKc7
         n+izGNYJS3RsuKMG80YE2/n4GnC2ZJtcoFj4FkL+T76rFHQFcybTA9+Kx6IP8UjHFg
         o8H41RlodVZDg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Saravana Kannan <saravanak@google.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 03/43] spi: Fix spi device unregister flow
Date:   Thu,  3 Jun 2021 13:06:53 -0400
Message-Id: <20210603170734.3168284-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170734.3168284-1-sashal@kernel.org>
References: <20210603170734.3168284-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saravana Kannan <saravanak@google.com>

[ Upstream commit c7299fea67696db5bd09d924d1f1080d894f92ef ]

When an SPI device is unregistered, the spi->controller->cleanup() is
called in the device's release callback. That's wrong for a couple of
reasons:

1. spi_dev_put() can be called before spi_add_device() is called. And
   it's spi_add_device() that calls spi_setup(). This will cause clean()
   to get called without the spi device ever being setup.

2. There's no guarantee that the controller's driver would be present by
   the time the spi device's release function gets called.

3. It also causes "sleeping in atomic context" stack dump[1] when device
   link deletion code does a put_device() on the spi device.

Fix these issues by simply moving the cleanup from the device release
callback to the actual spi_unregister_device() function.

[1] - https://lore.kernel.org/lkml/CAHp75Vc=FCGcUyS0v6fnxme2YJ+qD+Y-hQDQLa2JhWNON9VmsQ@mail.gmail.com/

Signed-off-by: Saravana Kannan <saravanak@google.com>
Link: https://lore.kernel.org/r/20210426235638.1285530-1-saravanak@google.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 8da4fe475b84..4278d9a63636 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -47,10 +47,6 @@ static void spidev_release(struct device *dev)
 {
 	struct spi_device	*spi = to_spi_device(dev);
 
-	/* spi controllers may cleanup for released devices */
-	if (spi->controller->cleanup)
-		spi->controller->cleanup(spi);
-
 	spi_controller_put(spi->controller);
 	kfree(spi->driver_override);
 	kfree(spi);
@@ -558,6 +554,12 @@ static int spi_dev_check(struct device *dev, void *data)
 	return 0;
 }
 
+static void spi_cleanup(struct spi_device *spi)
+{
+	if (spi->controller->cleanup)
+		spi->controller->cleanup(spi);
+}
+
 /**
  * spi_add_device - Add spi_device allocated with spi_alloc_device
  * @spi: spi_device to register
@@ -622,11 +624,13 @@ int spi_add_device(struct spi_device *spi)
 
 	/* Device may be bound to an active driver when this returns */
 	status = device_add(&spi->dev);
-	if (status < 0)
+	if (status < 0) {
 		dev_err(dev, "can't add %s, status %d\n",
 				dev_name(&spi->dev), status);
-	else
+		spi_cleanup(spi);
+	} else {
 		dev_dbg(dev, "registered child %s\n", dev_name(&spi->dev));
+	}
 
 done:
 	mutex_unlock(&spi_add_lock);
@@ -713,6 +717,8 @@ void spi_unregister_device(struct spi_device *spi)
 	if (!spi)
 		return;
 
+	spi_cleanup(spi);
+
 	if (spi->dev.of_node) {
 		of_node_clear_flag(spi->dev.of_node, OF_POPULATED);
 		of_node_put(spi->dev.of_node);
-- 
2.30.2

