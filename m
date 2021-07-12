Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5401A3C4D7F
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241341AbhGLHNR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:13:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:42642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243485AbhGLHHG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:07:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEDBA613B6;
        Mon, 12 Jul 2021 07:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073458;
        bh=TK6R9Sn00wxee5dTU11HDuRB9a21Bio05lZ+Ll0oo2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WJWdbra0vtq3GU6j2RjnKZI7CkNchsulx6WVWySGBRlGmtKDM5PofuEAEhDJbJg/7
         mzSUCREU5e+goP7AEAv0NDYh9YXHqP1BYCASve4pMhsEAqDUT6hLDKCDDsUu/XSAuU
         ZbWvpuINAYx+fc0zqTLHRBlyFLnqWsY0x7CwLyNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 248/700] spi: Allow to have all native CSs in use along with GPIOs
Date:   Mon, 12 Jul 2021 08:05:31 +0200
Message-Id: <20210712061002.052906866@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit dbaca8e56ea3f23fa215f48c2d46dd03ede06e02 ]

The commit 7d93aecdb58d ("spi: Add generic support for unused native cs
with cs-gpios") excludes the valid case for the controllers that doesn't
need to switch native CS in order to perform the transfer, i.e. when

  0		native
  ...		...
  <n> - 1	native
  <n>		GPIO
  <n> + 1	GPIO
  ...		...

where <n> defines maximum of native CSs supported by the controller.

To allow this, bail out from spi_get_gpio_descs() conditionally for
the controllers which explicitly marked with SPI_MASTER_GPIO_SS.

Fixes: 7d93aecdb58d ("spi: Add generic support for unused native cs with cs-gpios")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20210420164425.40287-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 789354ee6a11..af126053213f 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -2631,8 +2631,9 @@ static int spi_get_gpio_descs(struct spi_controller *ctlr)
 	}
 
 	ctlr->unused_native_cs = ffz(native_cs_mask);
-	if (num_cs_gpios && ctlr->max_native_cs &&
-	    ctlr->unused_native_cs >= ctlr->max_native_cs) {
+
+	if ((ctlr->flags & SPI_MASTER_GPIO_SS) && num_cs_gpios &&
+	    ctlr->max_native_cs && ctlr->unused_native_cs >= ctlr->max_native_cs) {
 		dev_err(dev, "No unused native chip select available\n");
 		return -EINVAL;
 	}
-- 
2.30.2



