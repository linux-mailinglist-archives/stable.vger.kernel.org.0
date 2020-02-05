Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 404D515399A
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 21:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbgBEUia (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 15:38:30 -0500
Received: from mga11.intel.com ([192.55.52.93]:9266 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726534AbgBEUia (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Feb 2020 15:38:30 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Feb 2020 12:38:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,407,1574150400"; 
   d="scan'208";a="235715558"
Received: from gtobin-mobl1.ger.corp.intel.com (HELO localhost) ([10.251.85.85])
  by orsmga006.jf.intel.com with ESMTP; 05 Feb 2020 12:38:25 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-integrity@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andrey Pronin <apronin@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>, stable@vger.kernel.org,
        Alexander Steffen <Alexander.Steffen@infineon.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Stuebner <heiko@sntech.de>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] tpm: Revert tpm_tis_spi_mod.ko to tpm_tis_spi.ko.
Date:   Wed,  5 Feb 2020 22:38:18 +0200
Message-Id: <20200205203818.4679-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Revert tpm_tis_spi_mod.ko back to tpm_tis_spi.ko as the rename could break
the build script. This can be achieved by renaming tpm_tis_spi.c as
tpm_tis_spi_main.c. Then tpm_tis_spi-y can be used inside the makefile.

Cc: Andrey Pronin <apronin@chromium.org>
Cc: Stephen Boyd <swboyd@chromium.org>
Cc: stable@vger.kernel.org
Fixes: 797c0113c9a4 ("tpm: tpm_tis_spi: Support cr50 devices")
Reported-by: Alexander Steffen <Alexander.Steffen@infineon.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/Makefile                              | 8 +++++---
 drivers/char/tpm/{tpm_tis_spi.c => tpm_tis_spi_main.c} | 0
 2 files changed, 5 insertions(+), 3 deletions(-)
 rename drivers/char/tpm/{tpm_tis_spi.c => tpm_tis_spi_main.c} (100%)

diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index 5a0d99d4fec0..9567e5197f74 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -21,9 +21,11 @@ tpm-$(CONFIG_EFI) += eventlog/efi.o
 tpm-$(CONFIG_OF) += eventlog/of.o
 obj-$(CONFIG_TCG_TIS_CORE) += tpm_tis_core.o
 obj-$(CONFIG_TCG_TIS) += tpm_tis.o
-obj-$(CONFIG_TCG_TIS_SPI) += tpm_tis_spi_mod.o
-tpm_tis_spi_mod-y := tpm_tis_spi.o
-tpm_tis_spi_mod-$(CONFIG_TCG_TIS_SPI_CR50) += tpm_tis_spi_cr50.o
+
+obj-$(CONFIG_TCG_TIS_SPI) += tpm_tis_spi.o
+tpm_tis_spi-y := tpm_tis_spi_main.o
+tpm_tis_spi-$(CONFIG_TCG_TIS_SPI_CR50) += tpm_tis_spi_cr50.o
+
 obj-$(CONFIG_TCG_TIS_I2C_ATMEL) += tpm_i2c_atmel.o
 obj-$(CONFIG_TCG_TIS_I2C_INFINEON) += tpm_i2c_infineon.o
 obj-$(CONFIG_TCG_TIS_I2C_NUVOTON) += tpm_i2c_nuvoton.o
diff --git a/drivers/char/tpm/tpm_tis_spi.c b/drivers/char/tpm/tpm_tis_spi_main.c
similarity index 100%
rename from drivers/char/tpm/tpm_tis_spi.c
rename to drivers/char/tpm/tpm_tis_spi_main.c
-- 
2.20.1

