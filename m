Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8523796B3
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404072AbfG2Tyi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:54:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404073AbfG2Tyh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:54:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15A69204EC;
        Mon, 29 Jul 2019 19:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564430076;
        bh=GBPPaGxrCNpYyAZszl07+DyHsr+jJxr0l5+IvGAZjtM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gaOnQGEA1BrVWUFO3rVnZAQ44TBa4r5NxvdhO02G7QEtuhVGLifP3Y7yUf30WGmnP
         bvWqyr5ojtCcTipwlOu5IqV15hUeaFNWzgKgGk5Gvh7pBDszjGXlHKx4U6bIOtzeaC
         smfVnXCmiox6+jbYdMzdMQapyke8E0+rFNdca9dU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Bunk <bunk@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Arseny Solokha <asolokha@kb.kras.ru>
Subject: [PATCH 5.2 188/215] eeprom: make older eeprom drivers select NVMEM_SYSFS
Date:   Mon, 29 Jul 2019 21:23:04 +0200
Message-Id: <20190729190812.669585679@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arseny Solokha <asolokha@kb.kras.ru>

commit 1b5621832f9bd9899370ea6928462cd02ebe7dc0 upstream.

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
Link: https://lore.kernel.org/r/20190716111236.27803-1-asolokha@kb.kras.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/eeprom/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

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


