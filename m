Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0523A62A9
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234778AbhFNLDL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:03:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:36110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233876AbhFNLAr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:00:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4039761923;
        Mon, 14 Jun 2021 10:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667408;
        bh=YRMay8thZ0nlC5flkiLkObHqdLYZbsL4DqvJVinmzz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UICN08J8iktBux82GJigYjnbg/Hl/uaseG5RzSfgnnQ+B5JxWaZcoEbUsN2n6j3Nq
         sshz1eU4kS+7zLTcIf/dWLeKq7pHAv5assZjIlhilue/tqCTJKbwBZ0XaLNrJgyFS1
         VWyzsTBFo3wzOw9TAEkV16HKQ67Z92YJO6gA/3lU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Saravana Kannan <saravanak@google.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.10 042/131] spi: Cleanup on failure of initial setup
Date:   Mon, 14 Jun 2021 12:26:43 +0200
Message-Id: <20210614102654.444584174@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit 2ec6f20b33eb4f62ab90bdcd620436c883ec3af6 ]

Commit c7299fea6769 ("spi: Fix spi device unregister flow") changed the
SPI core's behavior if the ->setup() hook returns an error upon adding
an spi_device:  Before, the ->cleanup() hook was invoked to free any
allocations that were made by ->setup().  With the commit, that's no
longer the case, so the ->setup() hook is expected to free the
allocations itself.

I've identified 5 drivers which depend on the old behavior and am fixing
them up hereinafter: spi-bitbang.c spi-fsl-spi.c spi-omap-uwire.c
spi-omap2-mcspi.c spi-pxa2xx.c

Importantly, ->setup() is not only invoked on spi_device *addition*:
It may subsequently be called to *change* SPI parameters.  If changing
these SPI parameters fails, freeing memory allocations would be wrong.
That should only be done if the spi_device is finally destroyed.
I am therefore using a bool "initial_setup" in 4 of the affected drivers
to differentiate between the invocation on *adding* the spi_device and
any subsequent invocations: spi-bitbang.c spi-fsl-spi.c spi-omap-uwire.c
spi-omap2-mcspi.c

In spi-pxa2xx.c, it seems the ->setup() hook can only fail on spi_device
addition, not any subsequent calls.  It therefore doesn't need the bool.

It's worth noting that 5 other drivers already perform a cleanup if the
->setup() hook fails.  Before c7299fea6769, they caused a double-free
if ->setup() failed on spi_device addition.  Since the commit, they're
fine.  These drivers are: spi-mpc512x-psc.c spi-pl022.c spi-s3c64xx.c
spi-st-ssc4.c spi-tegra114.c

(spi-pxa2xx.c also already performs a cleanup, but only in one of
several error paths.)

Fixes: c7299fea6769 ("spi: Fix spi device unregister flow")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: Saravana Kannan <saravanak@google.com>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com> # pxa2xx
Link: https://lore.kernel.org/r/f76a0599469f265b69c371538794101fa37b5536.1622149321.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bitbang.c     | 18 ++++++++++++++----
 drivers/spi/spi-fsl-spi.c     |  4 ++++
 drivers/spi/spi-omap-uwire.c  |  9 ++++++++-
 drivers/spi/spi-omap2-mcspi.c | 33 ++++++++++++++++++++-------------
 drivers/spi/spi-pxa2xx.c      |  9 ++++++++-
 5 files changed, 54 insertions(+), 19 deletions(-)

diff --git a/drivers/spi/spi-bitbang.c b/drivers/spi/spi-bitbang.c
index 1a7352abd878..3d8948a17095 100644
--- a/drivers/spi/spi-bitbang.c
+++ b/drivers/spi/spi-bitbang.c
@@ -181,6 +181,8 @@ int spi_bitbang_setup(struct spi_device *spi)
 {
 	struct spi_bitbang_cs	*cs = spi->controller_state;
 	struct spi_bitbang	*bitbang;
+	bool			initial_setup = false;
+	int			retval;
 
 	bitbang = spi_master_get_devdata(spi->master);
 
@@ -189,22 +191,30 @@ int spi_bitbang_setup(struct spi_device *spi)
 		if (!cs)
 			return -ENOMEM;
 		spi->controller_state = cs;
+		initial_setup = true;
 	}
 
 	/* per-word shift register access, in hardware or bitbanging */
 	cs->txrx_word = bitbang->txrx_word[spi->mode & (SPI_CPOL|SPI_CPHA)];
-	if (!cs->txrx_word)
-		return -EINVAL;
+	if (!cs->txrx_word) {
+		retval = -EINVAL;
+		goto err_free;
+	}
 
 	if (bitbang->setup_transfer) {
-		int retval = bitbang->setup_transfer(spi, NULL);
+		retval = bitbang->setup_transfer(spi, NULL);
 		if (retval < 0)
-			return retval;
+			goto err_free;
 	}
 
 	dev_dbg(&spi->dev, "%s, %u nsec/bit\n", __func__, 2 * cs->nsecs);
 
 	return 0;
+
+err_free:
+	if (initial_setup)
+		kfree(cs);
+	return retval;
 }
 EXPORT_SYMBOL_GPL(spi_bitbang_setup);
 
diff --git a/drivers/spi/spi-fsl-spi.c b/drivers/spi/spi-fsl-spi.c
index d0e5aa18b7ba..bdf94cc7be1a 100644
--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -440,6 +440,7 @@ static int fsl_spi_setup(struct spi_device *spi)
 {
 	struct mpc8xxx_spi *mpc8xxx_spi;
 	struct fsl_spi_reg __iomem *reg_base;
+	bool initial_setup = false;
 	int retval;
 	u32 hw_mode;
 	struct spi_mpc8xxx_cs *cs = spi_get_ctldata(spi);
@@ -452,6 +453,7 @@ static int fsl_spi_setup(struct spi_device *spi)
 		if (!cs)
 			return -ENOMEM;
 		spi_set_ctldata(spi, cs);
+		initial_setup = true;
 	}
 	mpc8xxx_spi = spi_master_get_devdata(spi->master);
 
@@ -475,6 +477,8 @@ static int fsl_spi_setup(struct spi_device *spi)
 	retval = fsl_spi_setup_transfer(spi, NULL);
 	if (retval < 0) {
 		cs->hw_mode = hw_mode; /* Restore settings */
+		if (initial_setup)
+			kfree(cs);
 		return retval;
 	}
 
diff --git a/drivers/spi/spi-omap-uwire.c b/drivers/spi/spi-omap-uwire.c
index 71402f71ddd8..df28c6664aba 100644
--- a/drivers/spi/spi-omap-uwire.c
+++ b/drivers/spi/spi-omap-uwire.c
@@ -424,15 +424,22 @@ done:
 static int uwire_setup(struct spi_device *spi)
 {
 	struct uwire_state *ust = spi->controller_state;
+	bool initial_setup = false;
+	int status;
 
 	if (ust == NULL) {
 		ust = kzalloc(sizeof(*ust), GFP_KERNEL);
 		if (ust == NULL)
 			return -ENOMEM;
 		spi->controller_state = ust;
+		initial_setup = true;
 	}
 
-	return uwire_setup_transfer(spi, NULL);
+	status = uwire_setup_transfer(spi, NULL);
+	if (status && initial_setup)
+		kfree(ust);
+
+	return status;
 }
 
 static void uwire_cleanup(struct spi_device *spi)
diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index d4c9510af393..3596bbe4b776 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -1032,8 +1032,22 @@ static void omap2_mcspi_release_dma(struct spi_master *master)
 	}
 }
 
+static void omap2_mcspi_cleanup(struct spi_device *spi)
+{
+	struct omap2_mcspi_cs	*cs;
+
+	if (spi->controller_state) {
+		/* Unlink controller state from context save list */
+		cs = spi->controller_state;
+		list_del(&cs->node);
+
+		kfree(cs);
+	}
+}
+
 static int omap2_mcspi_setup(struct spi_device *spi)
 {
+	bool			initial_setup = false;
 	int			ret;
 	struct omap2_mcspi	*mcspi = spi_master_get_devdata(spi->master);
 	struct omap2_mcspi_regs	*ctx = &mcspi->ctx;
@@ -1051,35 +1065,28 @@ static int omap2_mcspi_setup(struct spi_device *spi)
 		spi->controller_state = cs;
 		/* Link this to context save list */
 		list_add_tail(&cs->node, &ctx->cs);
+		initial_setup = true;
 	}
 
 	ret = pm_runtime_get_sync(mcspi->dev);
 	if (ret < 0) {
 		pm_runtime_put_noidle(mcspi->dev);
+		if (initial_setup)
+			omap2_mcspi_cleanup(spi);
 
 		return ret;
 	}
 
 	ret = omap2_mcspi_setup_transfer(spi, NULL);
+	if (ret && initial_setup)
+		omap2_mcspi_cleanup(spi);
+
 	pm_runtime_mark_last_busy(mcspi->dev);
 	pm_runtime_put_autosuspend(mcspi->dev);
 
 	return ret;
 }
 
-static void omap2_mcspi_cleanup(struct spi_device *spi)
-{
-	struct omap2_mcspi_cs	*cs;
-
-	if (spi->controller_state) {
-		/* Unlink controller state from context save list */
-		cs = spi->controller_state;
-		list_del(&cs->node);
-
-		kfree(cs);
-	}
-}
-
 static irqreturn_t omap2_mcspi_irq_handler(int irq, void *data)
 {
 	struct omap2_mcspi *mcspi = data;
diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index d6b534d38e5d..56a62095ec8c 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1254,6 +1254,8 @@ static int setup_cs(struct spi_device *spi, struct chip_data *chip,
 		chip->gpio_cs_inverted = spi->mode & SPI_CS_HIGH;
 
 		err = gpiod_direction_output(gpiod, !chip->gpio_cs_inverted);
+		if (err)
+			gpiod_put(chip->gpiod_cs);
 	}
 
 	return err;
@@ -1267,6 +1269,7 @@ static int setup(struct spi_device *spi)
 	struct driver_data *drv_data =
 		spi_controller_get_devdata(spi->controller);
 	uint tx_thres, tx_hi_thres, rx_thres;
+	int err;
 
 	switch (drv_data->ssp_type) {
 	case QUARK_X1000_SSP:
@@ -1413,7 +1416,11 @@ static int setup(struct spi_device *spi)
 	if (drv_data->ssp_type == CE4100_SSP)
 		return 0;
 
-	return setup_cs(spi, chip, chip_info);
+	err = setup_cs(spi, chip, chip_info);
+	if (err)
+		kfree(chip);
+
+	return err;
 }
 
 static void cleanup(struct spi_device *spi)
-- 
2.30.2



