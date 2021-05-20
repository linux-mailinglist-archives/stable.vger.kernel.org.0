Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5795638A737
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235233AbhETKg2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:36:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:33412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237083AbhETKcc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:32:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D002F614A5;
        Thu, 20 May 2021 09:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504356;
        bh=WrsVI5mFToELXjgqq2dNUjbXEKgp08fYpZquCyhtomw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y1xkw0J2oT3wbj3si29TUKrEzBYIHsvSE1wRlztBaZdwUwzUupsrlic0BvSFtIs2x
         yWvWUwrwZl6C1HXwsXpAZt6cpUI5lBjjfQ/gHreL+3RNjzH3+ftXOIkS68xDuosk9H
         43xB31x49NbzsMOgsMxqfNsd3TBogodNbJwYexy0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "William A. Kennington III" <wak@google.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 165/323] spi: Fix use-after-free with devm_spi_alloc_*
Date:   Thu, 20 May 2021 11:20:57 +0200
Message-Id: <20210520092125.760183751@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: William A. Kennington III <wak@google.com>

[ Upstream commit 794aaf01444d4e765e2b067cba01cc69c1c68ed9 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c       | 9 ++-------
 include/linux/spi/spi.h | 3 +++
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index ca9970a63fdf..da71a53b0df7 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -2076,6 +2076,7 @@ struct spi_controller *__devm_spi_alloc_controller(struct device *dev,
 
 	ctlr = __spi_alloc_controller(dev, size, slave);
 	if (ctlr) {
+		ctlr->devm_allocated = true;
 		*ptr = ctlr;
 		devres_add(dev, ptr);
 	} else {
@@ -2304,11 +2305,6 @@ int devm_spi_register_controller(struct device *dev,
 }
 EXPORT_SYMBOL_GPL(devm_spi_register_controller);
 
-static int devm_spi_match_controller(struct device *dev, void *res, void *ctlr)
-{
-	return *(struct spi_controller **)res == ctlr;
-}
-
 static int __unregister(struct device *dev, void *null)
 {
 	spi_unregister_device(to_spi_device(dev));
@@ -2353,8 +2349,7 @@ void spi_unregister_controller(struct spi_controller *ctlr)
 	/* Release the last reference on the controller if its driver
 	 * has not yet been converted to devm_spi_alloc_master/slave().
 	 */
-	if (!devres_find(ctlr->dev.parent, devm_spi_release_controller,
-			 devm_spi_match_controller, ctlr))
+	if (!ctlr->devm_allocated)
 		put_device(&ctlr->dev);
 
 	/* free bus id */
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index 715bd276a041..a8f6606dd498 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -452,6 +452,9 @@ struct spi_controller {
 
 #define SPI_MASTER_GPIO_SS		BIT(5)	/* GPIO CS must select slave */
 
+	/* flag indicating this is a non-devres managed controller */
+	bool			devm_allocated;
+
 	/* flag indicating this is an SPI slave controller */
 	bool			slave;
 
-- 
2.30.2



