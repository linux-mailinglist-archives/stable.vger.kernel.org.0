Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 006E03942EE
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 14:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbhE1MvT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 08:51:19 -0400
Received: from bmailout1.hostsharing.net ([83.223.95.100]:54783 "EHLO
        bmailout1.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbhE1MvT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 May 2021 08:51:19 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 May 2021 08:51:18 EDT
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id A235F30000644
        for <stable@vger.kernel.org>; Fri, 28 May 2021 14:43:05 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 95DE419E841; Fri, 28 May 2021 14:43:05 +0200 (CEST)
X-Original-To: lukas@wunner.de
Received: from mailin3.hostsharing.net (mailin3.hostsharing.net [176.9.242.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by h08.hostsharing.net (Postfix) with ESMTPS id 5CA6611B178
        for <lukas@wunner.de>; Fri, 28 May 2021 08:23:44 +0200 (CEST)
Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [176.9.242.62])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailin3.hostsharing.net (Postfix) with ESMTPS id EEF8481DF5
        for <lukas@wunner.de>; Fri, 28 May 2021 08:23:43 +0200 (CEST)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id C43F1100FC065;
        Fri, 28 May 2021 08:23:43 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 8AABD132D6A; Fri, 28 May 2021 08:23:43 +0200 (CEST)
Date:   Fri, 28 May 2021 08:23:43 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     "William A. Kennington III" <wak@google.com>,
        Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v4.9-stable] spi: Fix use-after-free with devm_spi_alloc_*
Message-ID: <20210528062343.GA29343@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Greg, Dear Sasha,

please consider applying the patch below to v4.9-stable.

It is a backport of upstream commit 794aaf01444d, which has already
been applied to all stable kernels going back to v4.14.

Thanks!

Lukas

-- >8 --

From: "William A. Kennington III" <wak@google.com>
Date: Wed, 7 Apr 2021 02:55:27 -0700
Subject: [PATCH] spi: Fix use-after-free with devm_spi_alloc_*

commit 794aaf01444d4e765e2b067cba01cc69c1c68ed9 upstream.

We can't rely on the contents of the devres list during
spi_unregister_controller(), as the list is already torn down at the
time we perform devres_find() for devm_spi_release_controller. This
causes devices registered with devm_spi_alloc_{master,slave}() to be
mistakenly identified as legacy, non-devm managed devices and have their
reference counters decremented below 0.

------------[ cut here ]------------
WARNING: CPU: 1 PID: 660 at lib/refcount.c:28 refcount_warn_saturate+0x108/0x174
[<b0396f04>] (refcount_warn_saturate) from [<b03c56a4>] (kobject_put+0x90/0x98)
[<b03c5614>] (kobject_put) from [<b0447b4c>] (put_device+0x20/0x24)
 r4:b6700140
[<b0447b2c>] (put_device) from [<b07515e8>] (devm_spi_release_controller+0x3c/0x40)
[<b07515ac>] (devm_spi_release_controller) from [<b045343c>] (release_nodes+0x84/0xc4)
 r5:b6700180 r4:b6700100
[<b04533b8>] (release_nodes) from [<b0454160>] (devres_release_all+0x5c/0x60)
 r8:b1638c54 r7:b117ad94 r6:b1638c10 r5:b117ad94 r4:b163dc10
[<b0454104>] (devres_release_all) from [<b044e41c>] (__device_release_driver+0x144/0x1ec)
 r5:b117ad94 r4:b163dc10
[<b044e2d8>] (__device_release_driver) from [<b044f70c>] (device_driver_detach+0x84/0xa0)
 r9:00000000 r8:00000000 r7:b117ad94 r6:b163dc54 r5:b1638c10 r4:b163dc10
[<b044f688>] (device_driver_detach) from [<b044d274>] (unbind_store+0xe4/0xf8)

Instead, determine the devm allocation state as a flag on the
controller which is guaranteed to be stable during cleanup.

Fixes: 5e844cc37a5c ("spi: Introduce device-managed SPI controller allocation")
Signed-off-by: William A. Kennington III <wak@google.com>
Link: https://lore.kernel.org/r/20210407095527.2771582-1-wak@google.com
Signed-off-by: Mark Brown <broonie@kernel.org>
[lukas: backport to v4.9.270]
Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 drivers/spi/spi.c       | 9 ++-------
 include/linux/spi/spi.h | 3 +++
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index f0ba5eb26128..84e2296c45a2 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1869,6 +1869,7 @@ struct spi_master *devm_spi_alloc_master(struct device *dev, unsigned int size)
 
 	master = spi_alloc_master(dev, size);
 	if (master) {
+		master->devm_allocated = true;
 		*ptr = master;
 		devres_add(dev, ptr);
 	} else {
@@ -2059,11 +2060,6 @@ int devm_spi_register_master(struct device *dev, struct spi_master *master)
 }
 EXPORT_SYMBOL_GPL(devm_spi_register_master);
 
-static int devm_spi_match_master(struct device *dev, void *res, void *master)
-{
-	return *(struct spi_master **)res == master;
-}
-
 static int __unregister(struct device *dev, void *null)
 {
 	spi_unregister_device(to_spi_device(dev));
@@ -2102,8 +2098,7 @@ void spi_unregister_master(struct spi_master *master)
 	/* Release the last reference on the master if its driver
 	 * has not yet been converted to devm_spi_alloc_master().
 	 */
-	if (!devres_find(master->dev.parent, devm_spi_release_master,
-			 devm_spi_match_master, master))
+	if (!master->devm_allocated)
 		put_device(&master->dev);
 
 	if (IS_ENABLED(CONFIG_SPI_DYNAMIC))
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index 8470695e5dd7..9c8445f1af0c 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -443,6 +443,9 @@ struct spi_master {
 #define SPI_MASTER_MUST_RX      BIT(3)		/* requires rx */
 #define SPI_MASTER_MUST_TX      BIT(4)		/* requires tx */
 
+	/* flag indicating this is a non-devres managed controller */
+	bool			devm_allocated;
+
 	/*
 	 * on some hardware transfer / message size may be constrained
 	 * the limit may depend on device transfer settings
-- 
2.31.1

