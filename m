Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8D56A736
	for <lists+stable@lfdr.de>; Tue, 16 Jul 2019 13:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733269AbfGPLTB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jul 2019 07:19:01 -0400
Received: from ispman.iskranet.ru ([62.213.33.10]:55722 "EHLO
        ispman.iskranet.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387484AbfGPLTA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jul 2019 07:19:00 -0400
X-Greylist: delayed 377 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Jul 2019 07:19:00 EDT
Received: by ispman.iskranet.ru (Postfix, from userid 8)
        id 1D50E8217EA; Tue, 16 Jul 2019 18:12:39 +0700 (KRAT)
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on ispman.iskranet.ru
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=4.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.3.2
Received: from KB016249.iskra.kb (unknown [62.213.40.60])
        (Authenticated sender: asolokha@kb.kras.ru)
        by ispman.iskranet.ru (Postfix) with ESMTPA id 477D98217E7;
        Tue, 16 Jul 2019 18:12:37 +0700 (KRAT)
From:   Arseny Solokha <asolokha@kb.kras.ru>
To:     linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Arseny Solokha <asolokha@kb.kras.ru>,
        Adrian Bunk <bunk@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH] eeprom: make older eeprom drivers select NVMEM_SYSFS
Date:   Tue, 16 Jul 2019 18:12:36 +0700
Message-Id: <20190716111236.27803-1-asolokha@kb.kras.ru>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

misc/eeprom/{at24,at25,eeprom_93xx46} drivers all register their
corresponding devices in the nvmem framework in compat mode which requires
nvmem sysfs interface to be present. The latter, however, has been split
out from nvmem under a separate Kconfig in commit ae0c2d725512 ("nvmem:
core: add NVMEM_SYSFS Kconfig"). As a result, probing certain I2C-attached
EEPROMs now fails with

  at24: probe of 0-0050 failed with error -38

because of a stub implementation of nvmem_sysfs_setup_compat()
in drivers/nvmem/nvmem.h. Update the nvmem dependency for these drivers
so they could load again:

  at24 0-0050: 32768 byte 24c256 EEPROM, writable, 64 bytes/write

Cc: Adrian Bunk <bunk@kernel.org>
Cc: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: Arseny Solokha <asolokha@kb.kras.ru>
---
 drivers/misc/eeprom/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/misc/eeprom/Kconfig b/drivers/misc/eeprom/Kconfig
index f88094719552..f2abe27010ef 100644
--- a/drivers/misc/eeprom/Kconfig
+++ b/drivers/misc/eeprom/Kconfig
@@ -5,6 +5,7 @@ config EEPROM_AT24
 	tristate "I2C EEPROMs / RAMs / ROMs from most vendors"
 	depends on I2C && SYSFS
 	select NVMEM
+	select NVMEM_SYSFS
 	select REGMAP_I2C
 	help
 	  Enable this driver to get read/write support to most I2C EEPROMs
@@ -34,6 +35,7 @@ config EEPROM_AT25
 	tristate "SPI EEPROMs from most vendors"
 	depends on SPI && SYSFS
 	select NVMEM
+	select NVMEM_SYSFS
 	help
 	  Enable this driver to get read/write support to most SPI EEPROMs,
 	  after you configure the board init code to know about each eeprom
@@ -80,6 +82,7 @@ config EEPROM_93XX46
 	depends on SPI && SYSFS
 	select REGMAP
 	select NVMEM
+	select NVMEM_SYSFS
 	help
 	  Driver for the microwire EEPROM chipsets 93xx46x. The driver
 	  supports both read and write commands and also the command to
-- 
2.22.0

