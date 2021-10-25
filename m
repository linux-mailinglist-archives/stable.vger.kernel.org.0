Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944BD43A316
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237408AbhJYT4J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:56:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:42070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238978AbhJYTxy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:53:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4C5661263;
        Mon, 25 Oct 2021 19:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635191095;
        bh=wBMMXcHsacMg/RF9mmTos5XgdKFwCwBPUKoV0FrRWks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HeeGkB+9i/K1xlwVSylxCy4WOJyoXRJlEtQExoOMy+vxcEz3v/3i+jGPjo4E3rGAd
         PQIr9WQPSKgA2X+8dglNMT32w8BSQNJhehBQcM9Qg5mCVySf4J/UDsWQgFSXeSOmO3
         gCBWNreyRGnxNLbeT4A/Et+ZVFm5ui2YNCRuoBr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 143/169] spi-mux: Fix false-positive lockdep splats
Date:   Mon, 25 Oct 2021 21:15:24 +0200
Message-Id: <20211025191035.702202966@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 16a8e2fbb2d49111004efc1c7342e083eafabeb0 ]

io_mutex is taken by spi_setup() and spi-mux's .setup() callback calls
spi_setup() which results in a nested lock of io_mutex.

add_lock is taken by spi_add_device(). The device_add() call in there
can result in calling spi-mux's .probe() callback which registers its
own spi controller which in turn results in spi_add_device() being
called again.

To fix this initialize the controller's locks already in
spi_alloc_controller() to give spi_mux_probe() a chance to set the
lockdep subclass.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20211013133710.2679703-2-u.kleine-koenig@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mux.c |  7 +++++++
 drivers/spi/spi.c     | 12 ++++++------
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-mux.c b/drivers/spi/spi-mux.c
index 9708b7827ff7..f5d32ec4634e 100644
--- a/drivers/spi/spi-mux.c
+++ b/drivers/spi/spi-mux.c
@@ -137,6 +137,13 @@ static int spi_mux_probe(struct spi_device *spi)
 	priv = spi_controller_get_devdata(ctlr);
 	priv->spi = spi;
 
+	/*
+	 * Increase lockdep class as these lock are taken while the parent bus
+	 * already holds their instance's lock.
+	 */
+	lockdep_set_subclass(&ctlr->io_mutex, 1);
+	lockdep_set_subclass(&ctlr->add_lock, 1);
+
 	priv->mux = devm_mux_control_get(&spi->dev, NULL);
 	if (IS_ERR(priv->mux)) {
 		ret = dev_err_probe(&spi->dev, PTR_ERR(priv->mux),
diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 2c342bded058..3093e0041158 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -2549,6 +2549,12 @@ struct spi_controller *__spi_alloc_controller(struct device *dev,
 		return NULL;
 
 	device_initialize(&ctlr->dev);
+	INIT_LIST_HEAD(&ctlr->queue);
+	spin_lock_init(&ctlr->queue_lock);
+	spin_lock_init(&ctlr->bus_lock_spinlock);
+	mutex_init(&ctlr->bus_lock_mutex);
+	mutex_init(&ctlr->io_mutex);
+	mutex_init(&ctlr->add_lock);
 	ctlr->bus_num = -1;
 	ctlr->num_chipselect = 1;
 	ctlr->slave = slave;
@@ -2821,12 +2827,6 @@ int spi_register_controller(struct spi_controller *ctlr)
 			return id;
 		ctlr->bus_num = id;
 	}
-	INIT_LIST_HEAD(&ctlr->queue);
-	spin_lock_init(&ctlr->queue_lock);
-	spin_lock_init(&ctlr->bus_lock_spinlock);
-	mutex_init(&ctlr->bus_lock_mutex);
-	mutex_init(&ctlr->io_mutex);
-	mutex_init(&ctlr->add_lock);
 	ctlr->bus_lock_flag = 0;
 	init_completion(&ctlr->xfer_completion);
 	if (!ctlr->max_dma_len)
-- 
2.33.0



