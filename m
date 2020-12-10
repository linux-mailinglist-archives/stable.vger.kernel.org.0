Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 242232D6719
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 20:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390146AbgLJO2n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:28:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:36492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729124AbgLJO2l (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:28:41 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.4 31/39] spi: Introduce device-managed SPI controller allocation
Date:   Thu, 10 Dec 2020 15:26:42 +0100
Message-Id: <20201210142602.433038422@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142600.887734129@linuxfoundation.org>
References: <20201210142600.887734129@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit 5e844cc37a5cbaa460e68f9a989d321d63088a89 ]

SPI driver probing currently comprises two steps, whereas removal
comprises only one step:

    spi_alloc_master()
    spi_register_master()

    spi_unregister_master()

That's because spi_unregister_master() calls device_unregister()
instead of device_del(), thereby releasing the reference on the
spi_master which was obtained by spi_alloc_master().

An SPI driver's private data is contained in the same memory allocation
as the spi_master struct.  Thus, once spi_unregister_master() has been
called, the private data is inaccessible.  But some drivers need to
access it after spi_unregister_master() to perform further teardown
steps.

Introduce devm_spi_alloc_master(), which releases a reference on the
spi_master struct only after the driver has unbound, thereby keeping the
memory allocation accessible.  Change spi_unregister_master() to not
release a reference if the spi_master was allocated by the new devm
function.

The present commit is small enough to be backportable to stable.
It allows fixing drivers which use the private data in their ->remove()
hook after it's been freed.  It also allows fixing drivers which neglect
to release a reference on the spi_master in the probe error path.

Long-term, most SPI drivers shall be moved over to the devm function
introduced herein.  The few that can't shall be changed in a treewide
commit to explicitly release the last reference on the master.
That commit shall amend spi_unregister_master() to no longer release
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
 drivers/spi/spi.c       |   54 +++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/spi/spi.h |    2 +
 2 files changed, 55 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1720,6 +1720,46 @@ struct spi_master *spi_alloc_master(stru
 }
 EXPORT_SYMBOL_GPL(spi_alloc_master);
 
+static void devm_spi_release_master(struct device *dev, void *master)
+{
+	spi_master_put(*(struct spi_master **)master);
+}
+
+/**
+ * devm_spi_alloc_master - resource-managed spi_alloc_master()
+ * @dev: physical device of SPI master
+ * @size: how much zeroed driver-private data to allocate
+ * Context: can sleep
+ *
+ * Allocate an SPI master and automatically release a reference on it
+ * when @dev is unbound from its driver.  Drivers are thus relieved from
+ * having to call spi_master_put().
+ *
+ * The arguments to this function are identical to spi_alloc_master().
+ *
+ * Return: the SPI master structure on success, else NULL.
+ */
+struct spi_master *devm_spi_alloc_master(struct device *dev, unsigned int size)
+{
+	struct spi_master **ptr, *master;
+
+	ptr = devres_alloc(devm_spi_release_master, sizeof(*ptr),
+			   GFP_KERNEL);
+	if (!ptr)
+		return NULL;
+
+	master = spi_alloc_master(dev, size);
+	if (master) {
+		*ptr = master;
+		devres_add(dev, ptr);
+	} else {
+		devres_free(ptr);
+	}
+
+	return master;
+}
+EXPORT_SYMBOL_GPL(devm_spi_alloc_master);
+
 #ifdef CONFIG_OF
 static int of_spi_register_master(struct spi_master *master)
 {
@@ -1899,6 +1939,11 @@ int devm_spi_register_master(struct devi
 }
 EXPORT_SYMBOL_GPL(devm_spi_register_master);
 
+static int devm_spi_match_master(struct device *dev, void *res, void *master)
+{
+	return *(struct spi_master **)res == master;
+}
+
 static int __unregister(struct device *dev, void *null)
 {
 	spi_unregister_device(to_spi_device(dev));
@@ -1928,7 +1973,14 @@ void spi_unregister_master(struct spi_ma
 	list_del(&master->list);
 	mutex_unlock(&board_lock);
 
-	device_unregister(&master->dev);
+	device_del(&master->dev);
+
+	/* Release the last reference on the master if its driver
+	 * has not yet been converted to devm_spi_alloc_master().
+	 */
+	if (!devres_find(master->dev.parent, devm_spi_release_master,
+			 devm_spi_match_master, master))
+		put_device(&master->dev);
 }
 EXPORT_SYMBOL_GPL(spi_unregister_master);
 
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -568,6 +568,8 @@ extern void spi_finalize_current_transfe
 /* the spi driver core manages memory for the spi_master classdev */
 extern struct spi_master *
 spi_alloc_master(struct device *host, unsigned size);
+extern struct spi_master *
+devm_spi_alloc_master(struct device *dev, unsigned int size);
 
 extern int spi_register_master(struct spi_master *master);
 extern int devm_spi_register_master(struct device *dev,


