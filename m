Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA8524FAF0
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 12:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbgHXIcN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:32:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:38624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgHXIcH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:32:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8346207D3;
        Mon, 24 Aug 2020 08:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598257926;
        bh=sTDj6tq+HN2wll79e4raXCRY8XbX4Md6sOVXV9rrXZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qfvOGSZwFCXC/SNJLrXvFrKCtkSRUBlTyp9D6u/Gt/7xQ/XF5+9nOti7MpmZPLgC2
         6TG/huoJnU1X3lWlSH8wgbdNeJ1mdCkX8cFf92peL5B1PrE1ArFtUd2lxJs7HeNpOX
         RD+RiqjmHOflZm8YrD+78TBKMwPHJqb73Q/4rLfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Octavian Purdila <octavian.purdila@intel.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.8 011/148] spi: Prevent adding devices below an unregistering controller
Date:   Mon, 24 Aug 2020 10:28:29 +0200
Message-Id: <20200824082414.497192453@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit ddf75be47ca748f8b12d28ac64d624354fddf189 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/Kconfig |    3 +++
 drivers/spi/spi.c   |   21 ++++++++++++++++++++-
 2 files changed, 23 insertions(+), 1 deletion(-)

--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -999,4 +999,7 @@ config SPI_SLAVE_SYSTEM_CONTROL
 
 endif # SPI_SLAVE
 
+config SPI_DYNAMIC
+	def_bool ACPI || OF_DYNAMIC || SPI_SLAVE
+
 endif # SPI
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -475,6 +475,12 @@ static LIST_HEAD(spi_controller_list);
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
  * @ctlr: Controller to which device is connected
@@ -554,7 +560,6 @@ static int spi_dev_check(struct device *
  */
 int spi_add_device(struct spi_device *spi)
 {
-	static DEFINE_MUTEX(spi_add_lock);
 	struct spi_controller *ctlr = spi->controller;
 	struct device *dev = ctlr->dev.parent;
 	int status;
@@ -582,6 +587,13 @@ int spi_add_device(struct spi_device *sp
 		goto done;
 	}
 
+	/* Controller may unregister concurrently */
+	if (IS_ENABLED(CONFIG_SPI_DYNAMIC) &&
+	    !device_is_registered(&ctlr->dev)) {
+		status = -ENODEV;
+		goto done;
+	}
+
 	/* Descriptors take precedence */
 	if (ctlr->cs_gpiods)
 		spi->cs_gpiod = ctlr->cs_gpiods[spi->chip_select];
@@ -2764,6 +2776,10 @@ void spi_unregister_controller(struct sp
 	struct spi_controller *found;
 	int id = ctlr->bus_num;
 
+	/* Prevent addition of new devices, unregister existing ones */
+	if (IS_ENABLED(CONFIG_SPI_DYNAMIC))
+		mutex_lock(&spi_add_lock);
+
 	device_for_each_child(&ctlr->dev, NULL, __unregister);
 
 	/* First make sure that this controller was ever added */
@@ -2784,6 +2800,9 @@ void spi_unregister_controller(struct sp
 	if (found == ctlr)
 		idr_remove(&spi_master_idr, id);
 	mutex_unlock(&board_lock);
+
+	if (IS_ENABLED(CONFIG_SPI_DYNAMIC))
+		mutex_unlock(&spi_add_lock);
 }
 EXPORT_SYMBOL_GPL(spi_unregister_controller);
 


