Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A152D04D3
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 13:43:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727315AbgLFMk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 07:40:26 -0500
Received: from mailout2.hostsharing.net ([83.223.78.233]:60785 "EHLO
        mailout2.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgLFMk0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Dec 2020 07:40:26 -0500
X-Greylist: delayed 473 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Dec 2020 07:40:25 EST
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by mailout2.hostsharing.net (Postfix) with ESMTPS id 1D91910189B63;
        Sun,  6 Dec 2020 13:39:29 +0100 (CET)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id 8C8FA601805A;
        Sun,  6 Dec 2020 13:39:44 +0100 (CET)
X-Mailbox-Line: From 4a3ce9b0ebf2883bc24595f444723f5dee555c3d Mon Sep 17 00:00:00 2001
Message-Id: <4a3ce9b0ebf2883bc24595f444723f5dee555c3d.1607258208.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Sun, 6 Dec 2020 13:39:00 +0100
Subject: [PATCH 4.14-stable 1/5] spi: Introduce device-managed SPI controller
 allocation
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.com>
Cc:     Mark Brown <broonie@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5e844cc37a5cbaa460e68f9a989d321d63088a89 ]

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
---
 drivers/spi/spi.c       | 58 ++++++++++++++++++++++++++++++++++++++++-
 include/linux/spi/spi.h | 19 ++++++++++++++
 2 files changed, 76 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index acc8eeed73f0..ca9970a63fdf 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -2043,6 +2043,49 @@ struct spi_controller *__spi_alloc_controller(struct device *dev,
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
 static int of_spi_register_master(struct spi_controller *ctlr)
 {
@@ -2261,6 +2304,11 @@ int devm_spi_register_controller(struct device *dev,
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
@@ -2300,7 +2348,15 @@ void spi_unregister_controller(struct spi_controller *ctlr)
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
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index 7b2170bfd6e7..715bd276a041 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -638,6 +638,25 @@ static inline struct spi_controller *spi_alloc_slave(struct device *host,
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
-- 
2.29.2

