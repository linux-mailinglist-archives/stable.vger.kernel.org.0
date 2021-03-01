Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A212C328CCF
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240196AbhCAS7P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:59:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:57716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240758AbhCASxf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:53:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41CA664D73;
        Mon,  1 Mar 2021 17:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619088;
        bh=uGeCvrXvkIZXwaJsRK/dnDpyIJ4WF/bDg3GeP8GaTNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h0QrW1j2AZphb6ogjZC8aDE/DSYHrQ2AGyD3kKnsNfx8BmNw+TXFcyC4cls33imOP
         VMO6yg2jF8F7qtbaBBGEZ/ySraloZbqlGQfNCKbNkLnhCTVtItpAYZlohyLbkHA04G
         TzFxInl7psY/z8QdFwdEbIdjTqPMz+eQwHi9N9gU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 297/663] power: supply: fix sbs-charger build, needs REGMAP_I2C
Date:   Mon,  1 Mar 2021 17:09:05 +0100
Message-Id: <20210301161156.527635058@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit a4bdea2004b28f47ab48ea99172eda8628f6fb44 ]

CHARGER_SBS should select REGMAP_I2C since it uses API(s) that are
provided by that Kconfig symbol.

Fixes these errors:

../drivers/power/supply/sbs-charger.c:149:21: error: variable ‘sbs_regmap’ has initializer but incomplete type
 static const struct regmap_config sbs_regmap = {
../drivers/power/supply/sbs-charger.c:150:3: error: ‘const struct regmap_config’ has no member named ‘reg_bits’
  .reg_bits = 8,
../drivers/power/supply/sbs-charger.c:155:23: error: ‘REGMAP_ENDIAN_LITTLE’ undeclared here (not in a function)
  .val_format_endian = REGMAP_ENDIAN_LITTLE, /* since based on SMBus */
../drivers/power/supply/sbs-charger.c: In function ‘sbs_probe’:
../drivers/power/supply/sbs-charger.c:183:17: error: implicit declaration of function ‘devm_regmap_init_i2c’; did you mean ‘devm_request_irq’? [-Werror=implicit-function-declaration]
  chip->regmap = devm_regmap_init_i2c(client, &sbs_regmap);
../drivers/power/supply/sbs-charger.c: At top level:
../drivers/power/supply/sbs-charger.c:149:35: error: storage size of ‘sbs_regmap’ isn’t known
 static const struct regmap_config sbs_regmap = {

Fixes: feb583e37f8a ("power: supply: add sbs-charger driver")
Reported-by: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/supply/Kconfig b/drivers/power/supply/Kconfig
index eec646c568b7b..1699b9269a78e 100644
--- a/drivers/power/supply/Kconfig
+++ b/drivers/power/supply/Kconfig
@@ -229,6 +229,7 @@ config BATTERY_SBS
 config CHARGER_SBS
 	tristate "SBS Compliant charger"
 	depends on I2C
+	select REGMAP_I2C
 	help
 	  Say Y to include support for SBS compliant battery chargers.
 
-- 
2.27.0



