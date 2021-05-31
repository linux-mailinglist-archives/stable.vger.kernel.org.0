Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD45395B3A
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbhEaNSb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:18:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:53662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231691AbhEaNSY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:18:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 333506135C;
        Mon, 31 May 2021 13:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467003;
        bh=rwBrV/Kt9NkPQJ18K7sO6VBaCn6N3+qHMVU/GcKZ438=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ftj2HzChMc75k2H1gKM94p95NfN58wmiMsWTn59e+GJNkqhDu/vx8AZhDw7ch/Bez
         nAQs7RZoS0tl9x8tRllkuPnKhfGDlImgD821KWcvuFjJ6NPDdGVGJI/5bNWS3Qy0Hn
         eFi0DlT3Zs4kjxt+mfm/6/UN9dj8hvVkYQ+TNF5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "William A. Kennington III" <wak@google.com>,
        Mark Brown <broonie@kernel.org>, Lukas Wunner <lukas@wunner.de>
Subject: [PATCH 4.4 20/54] spi: Fix use-after-free with devm_spi_alloc_*
Date:   Mon, 31 May 2021 15:13:46 +0200
Message-Id: <20210531130635.728966293@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130635.070310929@linuxfoundation.org>
References: <20210531130635.070310929@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: William A. Kennington III <wak@google.com>

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
[lukas: backport to v4.4.270]
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi.c       |    9 ++-------
 include/linux/spi/spi.h |    3 +++
 2 files changed, 5 insertions(+), 7 deletions(-)

--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1762,6 +1762,7 @@ struct spi_master *devm_spi_alloc_master
 
 	master = spi_alloc_master(dev, size);
 	if (master) {
+		master->devm_allocated = true;
 		*ptr = master;
 		devres_add(dev, ptr);
 	} else {
@@ -1951,11 +1952,6 @@ int devm_spi_register_master(struct devi
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
@@ -1994,8 +1990,7 @@ void spi_unregister_master(struct spi_ma
 	/* Release the last reference on the master if its driver
 	 * has not yet been converted to devm_spi_alloc_master().
 	 */
-	if (!devres_find(master->dev.parent, devm_spi_release_master,
-			 devm_spi_match_master, master))
+	if (!master->devm_allocated)
 		put_device(&master->dev);
 
 	if (IS_ENABLED(CONFIG_SPI_DYNAMIC))
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -425,6 +425,9 @@ struct spi_master {
 #define SPI_MASTER_MUST_RX      BIT(3)		/* requires rx */
 #define SPI_MASTER_MUST_TX      BIT(4)		/* requires tx */
 
+	/* flag indicating this is a non-devres managed controller */
+	bool			devm_allocated;
+
 	/* lock and mutex for SPI bus locking */
 	spinlock_t		bus_lock_spinlock;
 	struct mutex		bus_lock_mutex;


