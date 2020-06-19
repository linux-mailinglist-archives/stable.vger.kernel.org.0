Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9132201307
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392624AbgFSPT4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:19:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:45896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403877AbgFSPPU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:15:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE92A206DB;
        Fri, 19 Jun 2020 15:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579719;
        bh=0KyO+5mrWMuKtoyYwUv5HIPOy5RHKWqUa3tEeT5t9Q4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UarD7/46nNEYucoKFi+4LUU4x8fYivAdKZjwIT8VLf9xAxh4G9CvY0g0/KhFiA+vJ
         JaJrpYOvtYmYrWPJh35Y+psjaFk5tZpO+gNcrukUeGJRD6iL4K3Ds7zdxOmUHEhU/W
         Wl2C1wKMFBE9xMTUgT/bxBfsRapFeTt2qsWbBkKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.4 240/261] mtd: rawnand: Fix nand_gpio_waitrdy()
Date:   Fri, 19 Jun 2020 16:34:11 +0200
Message-Id: <20200619141701.384262685@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Brezillon <boris.brezillon@collabora.com>

commit e45a4b652dbd2f8b5a3b8e97e89f602a58cb28aa upstream.

Mimic what's done in nand_soft_waitrdy() and add one to the jiffies
timeout so we don't end up waiting less than actually required.

Reported-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Fixes: b0e137ad24b6c ("mtd: rawnand: Provide helper for polling GPIO R/B pin")
Cc: <stable@vger.kernel.org>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20200518155237.297549-1-boris.brezillon@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/raw/nand_base.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/mtd/nand/raw/nand_base.c
+++ b/drivers/mtd/nand/raw/nand_base.c
@@ -731,8 +731,14 @@ EXPORT_SYMBOL_GPL(nand_soft_waitrdy);
 int nand_gpio_waitrdy(struct nand_chip *chip, struct gpio_desc *gpiod,
 		      unsigned long timeout_ms)
 {
-	/* Wait until R/B pin indicates chip is ready or timeout occurs */
-	timeout_ms = jiffies + msecs_to_jiffies(timeout_ms);
+
+	/*
+	 * Wait until R/B pin indicates chip is ready or timeout occurs.
+	 * +1 below is necessary because if we are now in the last fraction
+	 * of jiffy and msecs_to_jiffies is 1 then we will wait only that
+	 * small jiffy fraction - possibly leading to false timeout.
+	 */
+	timeout_ms = jiffies + msecs_to_jiffies(timeout_ms) + 1;
 	do {
 		if (gpiod_get_value_cansleep(gpiod))
 			return 0;


