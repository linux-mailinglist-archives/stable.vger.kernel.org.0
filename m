Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBB812D04ED
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 13:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbgLFMxo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 07:53:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgLFMxo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Dec 2020 07:53:44 -0500
Received: from mailout1.hostsharing.net (mailout1.hostsharing.net [IPv6:2a01:37:1000::53df:5fcc:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB93C0613D0
        for <stable@vger.kernel.org>; Sun,  6 Dec 2020 04:53:04 -0800 (PST)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by mailout1.hostsharing.net (Postfix) with ESMTPS id 4C69E101903B7;
        Sun,  6 Dec 2020 13:52:26 +0100 (CET)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id E505E601805A;
        Sun,  6 Dec 2020 13:53:02 +0100 (CET)
X-Mailbox-Line: From f3b2cd978df11c532658412b28eae329b99d9eec Mon Sep 17 00:00:00 2001
Message-Id: <f3b2cd978df11c532658412b28eae329b99d9eec.1607259026.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Sun, 6 Dec 2020 13:53:00 +0100
Subject: [PATCH 4.4-stable 1/4] spi: Introduce device-managed SPI controller
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
---
 drivers/spi/spi.c       | 54 ++++++++++++++++++++++++++++++++++++++++-
 include/linux/spi/spi.h |  2 ++
 2 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 6ed2959ce4dc..ed87f71a428d 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1720,6 +1720,46 @@ struct spi_master *spi_alloc_master(struct device *dev, unsigned size)
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
@@ -1899,6 +1939,11 @@ int devm_spi_register_master(struct device *dev, struct spi_master *master)
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
@@ -1928,7 +1973,14 @@ void spi_unregister_master(struct spi_master *master)
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
 
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index cce80e6dc7d1..f5d387140c46 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -568,6 +568,8 @@ extern void spi_finalize_current_transfer(struct spi_master *master);
 /* the spi driver core manages memory for the spi_master classdev */
 extern struct spi_master *
 spi_alloc_master(struct device *host, unsigned size);
+extern struct spi_master *
+devm_spi_alloc_master(struct device *dev, unsigned int size);
 
 extern int spi_register_master(struct spi_master *master);
 extern int devm_spi_register_master(struct device *dev,
-- 
2.29.2

