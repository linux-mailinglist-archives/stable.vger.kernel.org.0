Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE2F3A6299
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234606AbhFNLC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:02:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235211AbhFNLA0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:00:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A19961629;
        Mon, 14 Jun 2021 10:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667379;
        bh=9e+LP6ImzOzhs1q4SDn5l6/ZmimNdfb7PiDANUF2OK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ThRx4GL4b2Qj1cQdxZEc+FtJRYn0CTklTZ/hUCXpFCdJwW8O/TQF7BfokB4lgjEB/
         Ju+pdIlXOkD3q9K8kTkbHEzNJtDADAQthSJvR92CvD9vQJH+eGXu6gHIvTw2iTXUgW
         il7S1KfrrEE8bMfgc+9P2YGfGMnSRQSXVSgJP5mk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Saravana Kannan <saravanak@google.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 004/131] spi: Fix spi device unregister flow
Date:   Mon, 14 Jun 2021 12:26:05 +0200
Message-Id: <20210614102653.118436524@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a6f1e94af13c..96560853b3a3 100644
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
@@ -550,6 +546,12 @@ static int spi_dev_check(struct device *dev, void *data)
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
@@ -614,11 +616,13 @@ int spi_add_device(struct spi_device *spi)
 
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
@@ -705,6 +709,8 @@ void spi_unregister_device(struct spi_device *spi)
 	if (!spi)
 		return;
 
+	spi_cleanup(spi);
+
 	if (spi->dev.of_node) {
 		of_node_clear_flag(spi->dev.of_node, OF_POPULATED);
 		of_node_put(spi->dev.of_node);
-- 
2.30.2



