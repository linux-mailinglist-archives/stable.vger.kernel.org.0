Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBA3254204
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 11:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728265AbgH0JX5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 05:23:57 -0400
Received: from smtp1.de.adit-jv.com ([93.241.18.167]:43529 "EHLO
        smtp1.de.adit-jv.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728487AbgH0JX5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Aug 2020 05:23:57 -0400
Received: from localhost (smtp1.de.adit-jv.com [127.0.0.1])
        by smtp1.de.adit-jv.com (Postfix) with ESMTP id F04863C057C;
        Thu, 27 Aug 2020 11:23:53 +0200 (CEST)
Received: from smtp1.de.adit-jv.com ([127.0.0.1])
        by localhost (smtp1.de.adit-jv.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id HaCos8lTjjoA; Thu, 27 Aug 2020 11:23:48 +0200 (CEST)
Received: from HI2EXCH01.adit-jv.com (hi2exch01.adit-jv.com [10.72.92.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp1.de.adit-jv.com (Postfix) with ESMTPS id D048D3C0016;
        Thu, 27 Aug 2020 11:23:48 +0200 (CEST)
Received: from lxhi-065.adit-jv.com (10.72.94.25) by HI2EXCH01.adit-jv.com
 (10.72.92.24) with Microsoft SMTP Server (TLS) id 14.3.487.0; Thu, 27 Aug
 2020 11:23:48 +0200
From:   Eugeniu Rosca <erosca@de.adit-jv.com>
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        <linux-i2c@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <stable@vger.kernel.org>, Eugeniu Rosca <roscaeugeniu@gmail.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Andy Lowe <andy_lowe@mentor.com>
Subject: [PATCH v2] i2c: i2c-rcar: Auto select RESET_CONTROLLER
Date:   Thu, 27 Aug 2020 11:23:30 +0200
Message-ID: <20200827092330.16435-1-erosca@de.adit-jv.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.72.94.25]
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dirk Behme <dirk.behme@de.bosch.com>

The i2c-rcar driver utilizes the Generic Reset Controller kernel
feature, so select the RESET_CONTROLLER option when the I2C_RCAR
option is selected.

Fixes: 2b16fd63059ab9 ("i2c: rcar: handle RXDMA HW behaviour on Gen3")
Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Dirk Behme <dirk.behme@de.bosch.com>
Signed-off-by: Andy Lowe <andy_lowe@mentor.com>
[erosca: Add "if ARCH_RCAR_GEN3" on Wolfram's request]
Signed-off-by: Eugeniu Rosca <erosca@de.adit-jv.com>
---
v2:
 - Append "if ARCH_RCAR_GEN3" to "select", as requested by Wolfram
   in https://lore.kernel.org/linux-i2c/20200824120734.GA2500@ninjato/

v1:
 - https://lore.kernel.org/linux-i2c/20200824062623.9346-1-erosca@de.adit-jv.com/
---
 drivers/i2c/busses/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 293e7a0760e7..7ccbfbcb02e9 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -1181,6 +1181,7 @@ config I2C_RCAR
 	tristate "Renesas R-Car I2C Controller"
 	depends on ARCH_RENESAS || COMPILE_TEST
 	select I2C_SLAVE
+	select RESET_CONTROLLER if ARCH_RCAR_GEN3
 	help
 	  If you say yes to this option, support will be included for the
 	  R-Car I2C controller.
-- 
2.28.0

