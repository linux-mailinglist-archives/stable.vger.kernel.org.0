Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F82F2E3743
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 13:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728082AbgL1MxK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 07:53:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:49776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728066AbgL1MxF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:53:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C557321D94;
        Mon, 28 Dec 2020 12:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609159938;
        bh=G7nfxjCotE97zJO4ym3np8gBJMDq0VUkcAbkBtEJTXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DJeh66hTUgm4ki0YvsU2Ab5sA6aEFliEwIBp4JJ3fpWVw8J05afj70nCvLxBwXl/Q
         J3T6Ah+Wqkw1ivV3ysFabqSM8Da29tUsxH387rUx9Nr/c8exSgN76xTLLFcsMybWeB
         fTVg79Hvs3vMTilc3Yvwm+Rfc27OkErxKXonXIwE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Octavian Purdila <octavian.purdila@intel.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Mark Brown <broonie@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.4 008/132] spi: Prevent adding devices below an unregistering controller
Date:   Mon, 28 Dec 2020 13:48:12 +0100
Message-Id: <20201228124846.806218057@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
References: <20201228124846.409999325@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit ddf75be47ca748f8b12d28ac64d624354fddf189 upstream

CONFIG_OF_DYNAMIC and CONFIG_ACPI allow adding SPI devices at runtime
using a DeviceTree overlay or DSDT patch.  CONFIG_SPI_SLAVE allows the
same via sysfs.

But there are no precautions to prevent adding a device below a
controller that's being removed.  Such a device is unusable and may not
even be able to unbind cleanly as it becomes inaccessible once the
controller has been torn down.  E.g. it is then impossible to quiesce
the device's interrupt.

of_spi_notify() and acpi_spi_notify() do hold a ref on the controller,
but otherwise run lockless against spi_unregister_controller().

Fix by holding the spi_add_lock in spi_unregister_controller() and
bailing out of spi_add_device() if the controller has been unregistered
concurrently.

Fixes: ce79d54ae447 ("spi/of: Add OF notifier handler")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org # v3.19+
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Octavian Purdila <octavian.purdila@intel.com>
Cc: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Link: https://lore.kernel.org/r/a8c3205088a969dc8410eec1eba9aface60f36af.1596451035.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/Kconfig |    3 +++
 drivers/spi/spi.c   |   21 ++++++++++++++++++++-
 2 files changed, 23 insertions(+), 1 deletion(-)

--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -706,4 +706,7 @@ endif # SPI_MASTER
 
 # (slave support would go here)
 
+config SPI_DYNAMIC
+	def_bool ACPI || OF_DYNAMIC || SPI_SLAVE
+
 endif # SPI
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -418,6 +418,12 @@ static LIST_HEAD(spi_master_list);
  */
 static DEFINE_MUTEX(board_lock);
 
+/*
+ * Prevents addition of devices with same chip select and
+ * addition of devices below an unregistering controller.
+ */
+static DEFINE_MUTEX(spi_add_lock);
+
 /**
  * spi_alloc_device - Allocate a new SPI device
  * @master: Controller to which device is connected
@@ -496,7 +502,6 @@ static int spi_dev_check(struct device *
  */
 int spi_add_device(struct spi_device *spi)
 {
-	static DEFINE_MUTEX(spi_add_lock);
 	struct spi_master *master = spi->master;
 	struct device *dev = master->dev.parent;
 	int status;
@@ -525,6 +530,13 @@ int spi_add_device(struct spi_device *sp
 		goto done;
 	}
 
+	/* Controller may unregister concurrently */
+	if (IS_ENABLED(CONFIG_SPI_DYNAMIC) &&
+	    !device_is_registered(&master->dev)) {
+		status = -ENODEV;
+		goto done;
+	}
+
 	if (master->cs_gpios)
 		spi->cs_gpio = master->cs_gpios[spi->chip_select];
 
@@ -1962,6 +1974,10 @@ static int __unregister(struct device *d
  */
 void spi_unregister_master(struct spi_master *master)
 {
+	/* Prevent addition of new devices, unregister existing ones */
+	if (IS_ENABLED(CONFIG_SPI_DYNAMIC))
+		mutex_lock(&spi_add_lock);
+
 	device_for_each_child(&master->dev, NULL, __unregister);
 
 	if (master->queued) {
@@ -1981,6 +1997,9 @@ void spi_unregister_master(struct spi_ma
 	if (!devres_find(master->dev.parent, devm_spi_release_master,
 			 devm_spi_match_master, master))
 		put_device(&master->dev);
+
+	if (IS_ENABLED(CONFIG_SPI_DYNAMIC))
+		mutex_unlock(&spi_add_lock);
 }
 EXPORT_SYMBOL_GPL(spi_unregister_master);
 


