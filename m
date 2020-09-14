Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6C13269276
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 19:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgINRFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 13:05:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:32878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726269AbgINNFZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Sep 2020 09:05:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4280522225;
        Mon, 14 Sep 2020 13:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600088669;
        bh=cIly/5z+st1Uow7ZPenOwpPHPjIa9UBrWv11R6UmPww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b0d9ElpZW3/Rdttx0jYuGDMIiyylq1k7g/4r5I5LETBu7HlDri3H/qnEDFZ1eoWnS
         6BibYJm64gmR0wP+Zlx7usS6BNlTKyqQ6uBEkvK6XyEL/CA1iFTYCeo/96poSi+pGK
         NYCOcfHZZa0i9gDebCt9/Dz7Csf5g0UnC8TH6+q4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evan Nimmo <evan.nimmo@alliedtelesis.co.nz>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 25/29] i2c: algo: pca: Reapply i2c bus settings after reset
Date:   Mon, 14 Sep 2020 09:03:54 -0400
Message-Id: <20200914130358.1804194-25-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914130358.1804194-1-sashal@kernel.org>
References: <20200914130358.1804194-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Nimmo <evan.nimmo@alliedtelesis.co.nz>

[ Upstream commit 0a355aeb24081e4538d4d424cd189f16c0bbd983 ]

If something goes wrong (such as the SCL being stuck low) then we need
to reset the PCA chip. The issue with this is that on reset we lose all
config settings and the chip ends up in a disabled state which results
in a lock up/high CPU usage. We need to re-apply any configuration that
had previously been set and re-enable the chip.

Signed-off-by: Evan Nimmo <evan.nimmo@alliedtelesis.co.nz>
Reviewed-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/algos/i2c-algo-pca.c | 35 +++++++++++++++++++++-----------
 include/linux/i2c-algo-pca.h     | 15 ++++++++++++++
 2 files changed, 38 insertions(+), 12 deletions(-)

diff --git a/drivers/i2c/algos/i2c-algo-pca.c b/drivers/i2c/algos/i2c-algo-pca.c
index 388978775be04..edc6985c696f0 100644
--- a/drivers/i2c/algos/i2c-algo-pca.c
+++ b/drivers/i2c/algos/i2c-algo-pca.c
@@ -41,8 +41,22 @@ static void pca_reset(struct i2c_algo_pca_data *adap)
 		pca_outw(adap, I2C_PCA_INDPTR, I2C_PCA_IPRESET);
 		pca_outw(adap, I2C_PCA_IND, 0xA5);
 		pca_outw(adap, I2C_PCA_IND, 0x5A);
+
+		/*
+		 * After a reset we need to re-apply any configuration
+		 * (calculated in pca_init) to get the bus in a working state.
+		 */
+		pca_outw(adap, I2C_PCA_INDPTR, I2C_PCA_IMODE);
+		pca_outw(adap, I2C_PCA_IND, adap->bus_settings.mode);
+		pca_outw(adap, I2C_PCA_INDPTR, I2C_PCA_ISCLL);
+		pca_outw(adap, I2C_PCA_IND, adap->bus_settings.tlow);
+		pca_outw(adap, I2C_PCA_INDPTR, I2C_PCA_ISCLH);
+		pca_outw(adap, I2C_PCA_IND, adap->bus_settings.thi);
+
+		pca_set_con(adap, I2C_PCA_CON_ENSIO);
 	} else {
 		adap->reset_chip(adap->data);
+		pca_set_con(adap, I2C_PCA_CON_ENSIO | adap->bus_settings.clock_freq);
 	}
 }
 
@@ -423,13 +437,14 @@ static int pca_init(struct i2c_adapter *adap)
 				" Use the nominal frequency.\n", adap->name);
 		}
 
-		pca_reset(pca_data);
-
 		clock = pca_clock(pca_data);
 		printk(KERN_INFO "%s: Clock frequency is %dkHz\n",
 		     adap->name, freqs[clock]);
 
-		pca_set_con(pca_data, I2C_PCA_CON_ENSIO | clock);
+		/* Store settings as these will be needed when the PCA chip is reset */
+		pca_data->bus_settings.clock_freq = clock;
+
+		pca_reset(pca_data);
 	} else {
 		int clock;
 		int mode;
@@ -496,19 +511,15 @@ static int pca_init(struct i2c_adapter *adap)
 			thi = tlow * min_thi / min_tlow;
 		}
 
+		/* Store settings as these will be needed when the PCA chip is reset */
+		pca_data->bus_settings.mode = mode;
+		pca_data->bus_settings.tlow = tlow;
+		pca_data->bus_settings.thi = thi;
+
 		pca_reset(pca_data);
 
 		printk(KERN_INFO
 		     "%s: Clock frequency is %dHz\n", adap->name, clock * 100);
-
-		pca_outw(pca_data, I2C_PCA_INDPTR, I2C_PCA_IMODE);
-		pca_outw(pca_data, I2C_PCA_IND, mode);
-		pca_outw(pca_data, I2C_PCA_INDPTR, I2C_PCA_ISCLL);
-		pca_outw(pca_data, I2C_PCA_IND, tlow);
-		pca_outw(pca_data, I2C_PCA_INDPTR, I2C_PCA_ISCLH);
-		pca_outw(pca_data, I2C_PCA_IND, thi);
-
-		pca_set_con(pca_data, I2C_PCA_CON_ENSIO);
 	}
 	udelay(500); /* 500 us for oscillator to stabilise */
 
diff --git a/include/linux/i2c-algo-pca.h b/include/linux/i2c-algo-pca.h
index d03071732db4a..7c522fdd9ea73 100644
--- a/include/linux/i2c-algo-pca.h
+++ b/include/linux/i2c-algo-pca.h
@@ -53,6 +53,20 @@
 #define I2C_PCA_CON_SI		0x08 /* Serial Interrupt */
 #define I2C_PCA_CON_CR		0x07 /* Clock Rate (MASK) */
 
+/**
+ * struct pca_i2c_bus_settings - The configured PCA i2c bus settings
+ * @mode: Configured i2c bus mode
+ * @tlow: Configured SCL LOW period
+ * @thi: Configured SCL HIGH period
+ * @clock_freq: The configured clock frequency
+ */
+struct pca_i2c_bus_settings {
+	int mode;
+	int tlow;
+	int thi;
+	int clock_freq;
+};
+
 struct i2c_algo_pca_data {
 	void 				*data;	/* private low level data */
 	void (*write_byte)		(void *data, int reg, int val);
@@ -64,6 +78,7 @@ struct i2c_algo_pca_data {
 	 * For PCA9665, use the frequency you want here. */
 	unsigned int			i2c_clock;
 	unsigned int			chip;
+	struct pca_i2c_bus_settings		bus_settings;
 };
 
 int i2c_pca_add_bus(struct i2c_adapter *);
-- 
2.25.1

