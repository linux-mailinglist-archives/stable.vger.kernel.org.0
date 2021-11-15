Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D04314513A1
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348532AbhKOTx7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:53:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:44632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343685AbhKOTVg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 133BF63384;
        Mon, 15 Nov 2021 18:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001870;
        bh=CNN4dH+4NmfZ2QAIoo9fKaV7TbgbqMFD1753YpD7gm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oImPJQtdXJX4lLm9pecrMHt3zBvxH70OXezK3PCubywhroWXv2BU6Jy95OUcz48i9
         8fHQnjEIkNCmm65s1TnfLYaPEOHFcVJXp8WgpLKx4Uc3PJNnM/h1G6VDENFsboFJtV
         Jta2d/GY6WvHqn2t7+u9kGA5+JzMWLSMJZuzOWjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 353/917] crypto: qat - power up 4xxx device
Date:   Mon, 15 Nov 2021 17:57:28 +0100
Message-Id: <20211115165440.719580780@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit ca605f97dae4bf070b7c584aec23c1c922e4d823 ]

After reset or boot, QAT 4xxx devices are inactive and require to be
explicitly activated.
This is done by writing the DRV_ACTIVE bit in the PM_INTERRUPT register
and polling the PM_INIT_STATE to make sure that the transaction has
completed properly.

If this is not done, the driver will fail the initialization sequence
reporting the following message:
    [   22.081193] 4xxx 0000:f7:00.0: enabling device (0140 -> 0142)
    [   22.720285] QAT: AE0 is inactive!!
    [   22.720287] QAT: failed to get device out of reset
    [   22.720288] 4xxx 0000:f7:00.0: qat_hal_clr_reset error
    [   22.720290] 4xxx 0000:f7:00.0: Failed to init the AEs
    [   22.720290] 4xxx 0000:f7:00.0: Failed to initialise Acceleration Engine
    [   22.720789] 4xxx 0000:f7:00.0: Resetting device qat_dev0
    [   22.825099] 4xxx: probe of 0000:f7:00.0 failed with error -14

The patch also temporarily disables the power management source of
interrupt, to avoid possible spurious interrupts as the power management
feature is not fully supported.

The device init function has been added to adf_dev_init(), and not in the
probe of 4xxx to make sure that the device is re-enabled in case of
reset.

Note that the error code reported by hw_data->init_device() in
adf_dev_init() has been shadowed for consistency with the other calls
in the same function.

Fixes: 8c8268166e83 ("crypto: qat - add qat_4xxx driver")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.c    | 31 +++++++++++++++++++
 .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.h    | 10 ++++++
 .../crypto/qat/qat_common/adf_accel_devices.h |  1 +
 drivers/crypto/qat/qat_common/adf_init.c      |  5 +++
 4 files changed, 47 insertions(+)

diff --git a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
index 33d8e50dcbdac..88c0ded411f15 100644
--- a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
 /* Copyright(c) 2020 Intel Corporation */
+#include <linux/iopoll.h>
 #include <adf_accel_devices.h>
 #include <adf_common_drv.h>
 #include <adf_pf2vf_msg.h>
@@ -161,6 +162,35 @@ static void adf_enable_ints(struct adf_accel_dev *accel_dev)
 	ADF_CSR_WR(addr, ADF_4XXX_SMIAPF_MASK_OFFSET, 0);
 }
 
+static int adf_init_device(struct adf_accel_dev *accel_dev)
+{
+	void __iomem *addr;
+	u32 status;
+	u32 csr;
+	int ret;
+
+	addr = (&GET_BARS(accel_dev)[ADF_4XXX_PMISC_BAR])->virt_addr;
+
+	/* Temporarily mask PM interrupt */
+	csr = ADF_CSR_RD(addr, ADF_4XXX_ERRMSK2);
+	csr |= ADF_4XXX_PM_SOU;
+	ADF_CSR_WR(addr, ADF_4XXX_ERRMSK2, csr);
+
+	/* Set DRV_ACTIVE bit to power up the device */
+	ADF_CSR_WR(addr, ADF_4XXX_PM_INTERRUPT, ADF_4XXX_PM_DRV_ACTIVE);
+
+	/* Poll status register to make sure the device is powered up */
+	ret = read_poll_timeout(ADF_CSR_RD, status,
+				status & ADF_4XXX_PM_INIT_STATE,
+				ADF_4XXX_PM_POLL_DELAY_US,
+				ADF_4XXX_PM_POLL_TIMEOUT_US, true, addr,
+				ADF_4XXX_PM_STATUS);
+	if (ret)
+		dev_err(&GET_DEV(accel_dev), "Failed to power up the device\n");
+
+	return ret;
+}
+
 static int adf_enable_pf2vf_comms(struct adf_accel_dev *accel_dev)
 {
 	return 0;
@@ -215,6 +245,7 @@ void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data)
 	hw_data->exit_arb = adf_exit_arb;
 	hw_data->get_arb_mapping = adf_get_arbiter_mapping;
 	hw_data->enable_ints = adf_enable_ints;
+	hw_data->init_device = adf_init_device;
 	hw_data->reset_device = adf_reset_flr;
 	hw_data->admin_ae_mask = ADF_4XXX_ADMIN_AE_MASK;
 	hw_data->uof_get_num_objs = uof_get_num_objs;
diff --git a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.h b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.h
index 4fe2a776293c2..924bac6feb372 100644
--- a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.h
+++ b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.h
@@ -62,6 +62,16 @@
 #define ADF_4XXX_ADMINMSGLR_OFFSET	(0x500578)
 #define ADF_4XXX_MAILBOX_BASE_OFFSET	(0x600970)
 
+/* Power management */
+#define ADF_4XXX_PM_POLL_DELAY_US	20
+#define ADF_4XXX_PM_POLL_TIMEOUT_US	USEC_PER_SEC
+#define ADF_4XXX_PM_STATUS		(0x50A00C)
+#define ADF_4XXX_PM_INTERRUPT		(0x50A028)
+#define ADF_4XXX_PM_DRV_ACTIVE		BIT(20)
+#define ADF_4XXX_PM_INIT_STATE		BIT(21)
+/* Power management source in ERRSOU2 and ERRMSK2 */
+#define ADF_4XXX_PM_SOU			BIT(18)
+
 /* Firmware Binaries */
 #define ADF_4XXX_FW		"qat_4xxx.bin"
 #define ADF_4XXX_MMP		"qat_4xxx_mmp.bin"
diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index 38c0af6d4e43e..580566cfcb04c 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -166,6 +166,7 @@ struct adf_hw_device_data {
 	int (*init_arb)(struct adf_accel_dev *accel_dev);
 	void (*exit_arb)(struct adf_accel_dev *accel_dev);
 	const u32 *(*get_arb_mapping)(void);
+	int (*init_device)(struct adf_accel_dev *accel_dev);
 	void (*disable_iov)(struct adf_accel_dev *accel_dev);
 	void (*configure_iov_threads)(struct adf_accel_dev *accel_dev,
 				      bool enable);
diff --git a/drivers/crypto/qat/qat_common/adf_init.c b/drivers/crypto/qat/qat_common/adf_init.c
index 60bc7b991d351..e3749e5817d94 100644
--- a/drivers/crypto/qat/qat_common/adf_init.c
+++ b/drivers/crypto/qat/qat_common/adf_init.c
@@ -79,6 +79,11 @@ int adf_dev_init(struct adf_accel_dev *accel_dev)
 		return -EFAULT;
 	}
 
+	if (hw_data->init_device && hw_data->init_device(accel_dev)) {
+		dev_err(&GET_DEV(accel_dev), "Failed to initialize device\n");
+		return -EFAULT;
+	}
+
 	if (hw_data->init_admin_comms && hw_data->init_admin_comms(accel_dev)) {
 		dev_err(&GET_DEV(accel_dev), "Failed initialize admin comms\n");
 		return -EFAULT;
-- 
2.33.0



