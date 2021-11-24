Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 836D745C64E
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351691AbhKXOGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:06:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:53830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348765AbhKXOEm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:04:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 030FC6331C;
        Wed, 24 Nov 2021 13:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759496;
        bh=FbbNEhmcIzY0h8QyWaJ2d1XU9PgVs/EuXzfXvZs22Rg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S3cSNQWdA4PO0+JnVBG61CQuDcUYwpMWyPoz9w3zvhl2k41g/9AvUeWAUgN9vLApd
         g0iK7au/tXmav6W5DJrq8durqF52Ze2QOAjKjNzivDrG3IR9zr5i61b3MyWuN0tE+L
         3cLXadk8EcVYax3OmRf8itsuz0/QqlezOfjaq4q0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Lukas Wunner <lukas@wunner.de>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 229/279] spi: fix use-after-free of the add_lock mutex
Date:   Wed, 24 Nov 2021 12:58:36 +0100
Message-Id: <20211124115726.660387569@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

commit 6c53b45c71b4920b5e62f0ea8079a1da382b9434 upstream.

Commit 6098475d4cb4 ("spi: Fix deadlock when adding SPI controllers on
SPI buses") introduced a per-controller mutex. But mutex_unlock() of
said lock is called after the controller is already freed:

  spi_unregister_controller(ctlr)
  -> put_device(&ctlr->dev)
    -> spi_controller_release(dev)
  -> mutex_unlock(&ctrl->add_lock)

Move the put_device() after the mutex_unlock().

Fixes: 6098475d4cb4 ("spi: Fix deadlock when adding SPI controllers on SPI buses")
Signed-off-by: Michael Walle <michael@walle.cc>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org # v5.15
Link: https://lore.kernel.org/r/20211111083713.3335171-1-michael@walle.cc
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -3020,12 +3020,6 @@ void spi_unregister_controller(struct sp
 
 	device_del(&ctlr->dev);
 
-	/* Release the last reference on the controller if its driver
-	 * has not yet been converted to devm_spi_alloc_master/slave().
-	 */
-	if (!ctlr->devm_allocated)
-		put_device(&ctlr->dev);
-
 	/* free bus id */
 	mutex_lock(&board_lock);
 	if (found == ctlr)
@@ -3034,6 +3028,12 @@ void spi_unregister_controller(struct sp
 
 	if (IS_ENABLED(CONFIG_SPI_DYNAMIC))
 		mutex_unlock(&ctlr->add_lock);
+
+	/* Release the last reference on the controller if its driver
+	 * has not yet been converted to devm_spi_alloc_master/slave().
+	 */
+	if (!ctlr->devm_allocated)
+		put_device(&ctlr->dev);
 }
 EXPORT_SYMBOL_GPL(spi_unregister_controller);
 


