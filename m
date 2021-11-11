Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D529444D344
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 09:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbhKKIkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 03:40:42 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:33933 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbhKKIkm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 03:40:42 -0500
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 5DC6E22247;
        Thu, 11 Nov 2021 09:37:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1636619868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=QQI7x+XgqHwEkx4/5d9UjlzYDztSEMInJWg1DOUwNqk=;
        b=wA+n6bz/9MpligwWUj6hol/eJXgKOvHdQsoV2lkQiVs3yRXwbZxxhzLMXDLvFdqyiFC4+n
        xm+B3OMolZPPwh1SE07NuwptgykHISCsktQAPgQ2dAj6r992eepQGo6Ukzppa6DmSgdMd7
        DAmJMRf4ZOYKolSpywnnmdNK2TPYg9o=
From:   Michael Walle <michael@walle.cc>
To:     linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Michael Walle <michael@walle.cc>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Lukas Wunner <lukas@wunner.de>,
        stable@vger.kernel.org
Subject: [PATCH] spi: fix use-after-free of the add_lock mutex
Date:   Thu, 11 Nov 2021 09:37:13 +0100
Message-Id: <20211111083713.3335171-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
changes since RFC:
 - fix call graph indendation in commit message

 drivers/spi/spi.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index b23e675953e1..fdd530b150a7 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -3099,12 +3099,6 @@ void spi_unregister_controller(struct spi_controller *ctlr)
 
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
@@ -3113,6 +3107,12 @@ void spi_unregister_controller(struct spi_controller *ctlr)
 
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
 
-- 
2.30.2

