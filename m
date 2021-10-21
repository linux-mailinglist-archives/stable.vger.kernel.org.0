Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1547643570A
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 02:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbhJUAYH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 20:24:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:42628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231540AbhJUAXu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 20:23:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D41B613A4;
        Thu, 21 Oct 2021 00:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634775695;
        bh=WZWeuxSRxl5SZVNa+xq55nivzTLb8h/2BA88j/0BeOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rrHy45QQMUHx73DZTVWBiVJwMRPAbe0H2hHzwnZSHr5zW5lkmSIzyWOL1nJEcxuDw
         qq+Uz2n5ESFhVbjWsLuSfijzOwOFW6yTtK28BY3e23qSOyXRZoH8YI9FUyxWtdXQA3
         t26o8RUNJGyI5EMQ7io9VViORcSWo6vsAXdCBiZOlzYiUkktJ+wk/SEa0lIB0UYLlt
         aC7a5Z0v1OXnhFefCue+HHuA1IEFsTj8jzFkwnJn3T33jk17Dtc5juuWWP4YhZ02Zy
         e0S/V6z75wSAXVfFH30lHQtHdjn0QSgYcMsgxYoKMGMNOXqm1wPYnUcWAdsUpp18oq
         mVUilMFU5p7Tg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Sasha Levin <sashal@kernel.org>,
        linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 20/26] spi: Fix deadlock when adding SPI controllers on SPI buses
Date:   Wed, 20 Oct 2021 20:20:17 -0400
Message-Id: <20211021002023.1128949-20-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211021002023.1128949-1-sashal@kernel.org>
References: <20211021002023.1128949-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 6098475d4cb48d821bdf453c61118c56e26294f0 ]

Currently we have a global spi_add_lock which we take when adding new
devices so that we can check that we're not trying to reuse a chip
select that's already controlled.  This means that if the SPI device is
itself a SPI controller and triggers the instantiation of further SPI
devices we trigger a deadlock as we try to register and instantiate
those devices while in the process of doing so for the parent controller
and hence already holding the global spi_add_lock.  Since we only care
about concurrency within a single SPI bus move the lock to be per
controller, avoiding the deadlock.

This can be easily triggered in the case of spi-mux.

Reported-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c       | 17 ++++++-----------
 include/linux/spi/spi.h |  3 +++
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index f95f7666cb5b..2c342bded058 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -480,12 +480,6 @@ static LIST_HEAD(spi_controller_list);
  */
 static DEFINE_MUTEX(board_lock);
 
-/*
- * Prevents addition of devices with same chip select and
- * addition of devices below an unregistering controller.
- */
-static DEFINE_MUTEX(spi_add_lock);
-
 /**
  * spi_alloc_device - Allocate a new SPI device
  * @ctlr: Controller to which device is connected
@@ -638,9 +632,9 @@ int spi_add_device(struct spi_device *spi)
 	 * chipselect **BEFORE** we call setup(), else we'll trash
 	 * its configuration.  Lock against concurrent add() calls.
 	 */
-	mutex_lock(&spi_add_lock);
+	mutex_lock(&ctlr->add_lock);
 	status = __spi_add_device(spi);
-	mutex_unlock(&spi_add_lock);
+	mutex_unlock(&ctlr->add_lock);
 	return status;
 }
 EXPORT_SYMBOL_GPL(spi_add_device);
@@ -660,7 +654,7 @@ static int spi_add_device_locked(struct spi_device *spi)
 	/* Set the bus ID string */
 	spi_dev_set_name(spi);
 
-	WARN_ON(!mutex_is_locked(&spi_add_lock));
+	WARN_ON(!mutex_is_locked(&ctlr->add_lock));
 	return __spi_add_device(spi);
 }
 
@@ -2832,6 +2826,7 @@ int spi_register_controller(struct spi_controller *ctlr)
 	spin_lock_init(&ctlr->bus_lock_spinlock);
 	mutex_init(&ctlr->bus_lock_mutex);
 	mutex_init(&ctlr->io_mutex);
+	mutex_init(&ctlr->add_lock);
 	ctlr->bus_lock_flag = 0;
 	init_completion(&ctlr->xfer_completion);
 	if (!ctlr->max_dma_len)
@@ -2968,7 +2963,7 @@ void spi_unregister_controller(struct spi_controller *ctlr)
 
 	/* Prevent addition of new devices, unregister existing ones */
 	if (IS_ENABLED(CONFIG_SPI_DYNAMIC))
-		mutex_lock(&spi_add_lock);
+		mutex_lock(&ctlr->add_lock);
 
 	device_for_each_child(&ctlr->dev, NULL, __unregister);
 
@@ -2999,7 +2994,7 @@ void spi_unregister_controller(struct spi_controller *ctlr)
 	mutex_unlock(&board_lock);
 
 	if (IS_ENABLED(CONFIG_SPI_DYNAMIC))
-		mutex_unlock(&spi_add_lock);
+		mutex_unlock(&ctlr->add_lock);
 }
 EXPORT_SYMBOL_GPL(spi_unregister_controller);
 
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index 97b8d12b5f2b..5d80c6fd2a22 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -527,6 +527,9 @@ struct spi_controller {
 	/* I/O mutex */
 	struct mutex		io_mutex;
 
+	/* Used to avoid adding the same CS twice */
+	struct mutex		add_lock;
+
 	/* lock and mutex for SPI bus locking */
 	spinlock_t		bus_lock_spinlock;
 	struct mutex		bus_lock_mutex;
-- 
2.33.0

