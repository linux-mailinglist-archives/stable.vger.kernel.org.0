Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA94B2C092D
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387600AbgKWNEu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:04:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:35382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731761AbgKWMuz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:50:55 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3BEB20888;
        Mon, 23 Nov 2020 12:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135852;
        bh=3g/rRtmGg+lj73oJUQKZ1OcSx1/RXuH1sammQiy1D+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W1Chub7Ik2pvPh3g8pOBAwnrbcOuuqZjrI8JcWAr4RAozRGv5yrwWbB9ouU7YEAM3
         g3XEAiWudpawwZvnOY7iyd+qJSnAC09DpOLzumN9tKVA7vMM9cxEc+Av4jorRYRTX5
         MmMOSp2I8/zC1buqCjJBmjx2Q6xarj0jAWFxUYTo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.9 219/252] spi: Introduce device-managed SPI controller allocation
Date:   Mon, 23 Nov 2020 13:22:49 +0100
Message-Id: <20201123121846.144338401@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 5e844cc37a5cbaa460e68f9a989d321d63088a89 upstream.

SPI driver probing currently comprises two steps, whereas removal
comprises only one step:

    spi_alloc_master()
    spi_register_controller()

    spi_unregister_controller()

That's because spi_unregister_controller() calls device_unregister()
instead of device_del(), thereby releasing the reference on the
spi_controller which was obtained by spi_alloc_master().

An SPI driver's private data is contained in the same memory allocation
as the spi_controller struct.  Thus, once spi_unregister_controller()
has been called, the private data is inaccessible.  But some drivers
need to access it after spi_unregister_controller() to perform further
teardown steps.

Introduce devm_spi_alloc_master() and devm_spi_alloc_slave(), which
release a reference on the spi_controller struct only after the driver
has unbound, thereby keeping the memory allocation accessible.  Change
spi_unregister_controller() to not release a reference if the
spi_controller was allocated by one of these new devm functions.

The present commit is small enough to be backportable to stable.
It allows fixing drivers which use the private data in their ->remove()
hook after it's been freed.  It also allows fixing drivers which neglect
to release a reference on the spi_controller in the probe error path.

Long-term, most SPI drivers shall be moved over to the devm functions
introduced herein.  The few that can't shall be changed in a treewide
commit to explicitly release the last reference on the controller.
That commit shall amend spi_unregister_controller() to no longer release
a reference, thereby completing the migration.

As a result, the behaviour will be less surprising and more consistent
with subsystems such as IIO, which also includes the private data in the
allocation of the generic iio_dev struct, but calls device_del() in
iio_device_unregister().

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Link: https://lore.kernel.org/r/272bae2ef08abd21388c98e23729886663d19192.1605121038.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi.c       |   58 +++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/spi/spi.h |   19 +++++++++++++++
 2 files changed, 76 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -2442,6 +2442,49 @@ struct spi_controller *__spi_alloc_contr
 }
 EXPORT_SYMBOL_GPL(__spi_alloc_controller);
 
+static void devm_spi_release_controller(struct device *dev, void *ctlr)
+{
+	spi_controller_put(*(struct spi_controller **)ctlr);
+}
+
+/**
+ * __devm_spi_alloc_controller - resource-managed __spi_alloc_controller()
+ * @dev: physical device of SPI controller
+ * @size: how much zeroed driver-private data to allocate
+ * @slave: whether to allocate an SPI master (false) or SPI slave (true)
+ * Context: can sleep
+ *
+ * Allocate an SPI controller and automatically release a reference on it
+ * when @dev is unbound from its driver.  Drivers are thus relieved from
+ * having to call spi_controller_put().
+ *
+ * The arguments to this function are identical to __spi_alloc_controller().
+ *
+ * Return: the SPI controller structure on success, else NULL.
+ */
+struct spi_controller *__devm_spi_alloc_controller(struct device *dev,
+						   unsigned int size,
+						   bool slave)
+{
+	struct spi_controller **ptr, *ctlr;
+
+	ptr = devres_alloc(devm_spi_release_controller, sizeof(*ptr),
+			   GFP_KERNEL);
+	if (!ptr)
+		return NULL;
+
+	ctlr = __spi_alloc_controller(dev, size, slave);
+	if (ctlr) {
+		*ptr = ctlr;
+		devres_add(dev, ptr);
+	} else {
+		devres_free(ptr);
+	}
+
+	return ctlr;
+}
+EXPORT_SYMBOL_GPL(__devm_spi_alloc_controller);
+
 #ifdef CONFIG_OF
 static int of_spi_get_gpio_numbers(struct spi_controller *ctlr)
 {
@@ -2778,6 +2821,11 @@ int devm_spi_register_controller(struct
 }
 EXPORT_SYMBOL_GPL(devm_spi_register_controller);
 
+static int devm_spi_match_controller(struct device *dev, void *res, void *ctlr)
+{
+	return *(struct spi_controller **)res == ctlr;
+}
+
 static int __unregister(struct device *dev, void *null)
 {
 	spi_unregister_device(to_spi_device(dev));
@@ -2819,7 +2867,15 @@ void spi_unregister_controller(struct sp
 	list_del(&ctlr->list);
 	mutex_unlock(&board_lock);
 
-	device_unregister(&ctlr->dev);
+	device_del(&ctlr->dev);
+
+	/* Release the last reference on the controller if its driver
+	 * has not yet been converted to devm_spi_alloc_master/slave().
+	 */
+	if (!devres_find(ctlr->dev.parent, devm_spi_release_controller,
+			 devm_spi_match_controller, ctlr))
+		put_device(&ctlr->dev);
+
 	/* free bus id */
 	mutex_lock(&board_lock);
 	if (found == ctlr)
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -734,6 +734,25 @@ static inline struct spi_controller *spi
 	return __spi_alloc_controller(host, size, true);
 }
 
+struct spi_controller *__devm_spi_alloc_controller(struct device *dev,
+						   unsigned int size,
+						   bool slave);
+
+static inline struct spi_controller *devm_spi_alloc_master(struct device *dev,
+							   unsigned int size)
+{
+	return __devm_spi_alloc_controller(dev, size, false);
+}
+
+static inline struct spi_controller *devm_spi_alloc_slave(struct device *dev,
+							  unsigned int size)
+{
+	if (!IS_ENABLED(CONFIG_SPI_SLAVE))
+		return NULL;
+
+	return __devm_spi_alloc_controller(dev, size, true);
+}
+
 extern int spi_register_controller(struct spi_controller *ctlr);
 extern int devm_spi_register_controller(struct device *dev,
 					struct spi_controller *ctlr);


