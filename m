Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13008CD61E
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729554AbfJFRn3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:43:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:43390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727782AbfJFRn1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:43:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CA7A20700;
        Sun,  6 Oct 2019 17:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383805;
        bh=GKjZy4P+9TGkqvMqU59odRlZDEdrfCj2aPgQx1WN0X4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=diLpX9mk4r2qa4KkFVVOP1xtr2D1lEKW3SkugwT3OkEaTUz7JauJoUckptdqAHXrs
         DzOI2rlPbarsOYd7yp8a86Qi0VoNLq/QeoyGLiRNE1v3mlzqv28Odh4SkuLOKRVhl+
         /1M9dZeaFrUG2Cf3e95vs89RGP8Sgzhj1OmmeK2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 085/166] i2c-cht-wc: Fix lockdep warning
Date:   Sun,  6 Oct 2019 19:20:51 +0200
Message-Id: <20191006171220.680908064@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 232219b9a464c2479c98aa589acb1bd3383ae9d6 ]

When the kernel is build with lockdep support and the i2c-cht-wc driver is
used, the following warning is shown:

[   66.674334] ======================================================
[   66.674337] WARNING: possible circular locking dependency detected
[   66.674340] 5.3.0-rc4+ #83 Not tainted
[   66.674342] ------------------------------------------------------
[   66.674345] systemd-udevd/1232 is trying to acquire lock:
[   66.674349] 00000000a74dab07 (intel_soc_pmic_chtwc:167:(&cht_wc_regmap_cfg)->lock){+.+.}, at: regmap_write+0x31/0x70
[   66.674360]
               but task is already holding lock:
[   66.674362] 00000000d44a85b7 (i2c_register_adapter){+.+.}, at: i2c_smbus_xfer+0x49/0xf0
[   66.674370]
               which lock already depends on the new lock.

[   66.674371]
               the existing dependency chain (in reverse order) is:
[   66.674374]
               -> #1 (i2c_register_adapter){+.+.}:
[   66.674381]        rt_mutex_lock_nested+0x46/0x60
[   66.674384]        i2c_smbus_xfer+0x49/0xf0
[   66.674387]        i2c_smbus_read_byte_data+0x45/0x70
[   66.674391]        cht_wc_byte_reg_read+0x35/0x50
[   66.674394]        _regmap_read+0x63/0x1a0
[   66.674396]        _regmap_update_bits+0xa8/0xe0
[   66.674399]        regmap_update_bits_base+0x63/0xa0
[   66.674403]        regmap_irq_update_bits.isra.0+0x3b/0x50
[   66.674406]        regmap_add_irq_chip+0x592/0x7a0
[   66.674409]        devm_regmap_add_irq_chip+0x89/0xed
[   66.674412]        cht_wc_probe+0x102/0x158
[   66.674415]        i2c_device_probe+0x95/0x250
[   66.674419]        really_probe+0xf3/0x380
[   66.674422]        driver_probe_device+0x59/0xd0
[   66.674425]        device_driver_attach+0x53/0x60
[   66.674428]        __driver_attach+0x92/0x150
[   66.674431]        bus_for_each_dev+0x7d/0xc0
[   66.674434]        bus_add_driver+0x14d/0x1f0
[   66.674437]        driver_register+0x6d/0xb0
[   66.674440]        i2c_register_driver+0x45/0x80
[   66.674445]        do_one_initcall+0x60/0x2f4
[   66.674450]        kernel_init_freeable+0x20d/0x2b4
[   66.674453]        kernel_init+0xa/0x10c
[   66.674457]        ret_from_fork+0x3a/0x50
[   66.674459]
               -> #0 (intel_soc_pmic_chtwc:167:(&cht_wc_regmap_cfg)->lock){+.+.}:
[   66.674465]        __lock_acquire+0xe07/0x1930
[   66.674468]        lock_acquire+0x9d/0x1a0
[   66.674472]        __mutex_lock+0xa8/0x9a0
[   66.674474]        regmap_write+0x31/0x70
[   66.674480]        cht_wc_i2c_adap_smbus_xfer+0x72/0x240 [i2c_cht_wc]
[   66.674483]        __i2c_smbus_xfer+0x1a3/0x640
[   66.674486]        i2c_smbus_xfer+0x67/0xf0
[   66.674489]        i2c_smbus_read_byte_data+0x45/0x70
[   66.674494]        bq24190_probe+0x26b/0x410 [bq24190_charger]
[   66.674497]        i2c_device_probe+0x189/0x250
[   66.674500]        really_probe+0xf3/0x380
[   66.674503]        driver_probe_device+0x59/0xd0
[   66.674506]        device_driver_attach+0x53/0x60
[   66.674509]        __driver_attach+0x92/0x150
[   66.674512]        bus_for_each_dev+0x7d/0xc0
[   66.674515]        bus_add_driver+0x14d/0x1f0
[   66.674518]        driver_register+0x6d/0xb0
[   66.674521]        i2c_register_driver+0x45/0x80
[   66.674524]        do_one_initcall+0x60/0x2f4
[   66.674528]        do_init_module+0x5c/0x230
[   66.674531]        load_module+0x2707/0x2a20
[   66.674534]        __do_sys_init_module+0x188/0x1b0
[   66.674537]        do_syscall_64+0x5c/0xb0
[   66.674541]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
[   66.674543]
               other info that might help us debug this:

[   66.674545]  Possible unsafe locking scenario:

[   66.674547]        CPU0                    CPU1
[   66.674548]        ----                    ----
[   66.674550]   lock(i2c_register_adapter);
[   66.674553]                                lock(intel_soc_pmic_chtwc:167:(&cht_wc_regmap_cfg)->lock);
[   66.674556]                                lock(i2c_register_adapter);
[   66.674559]   lock(intel_soc_pmic_chtwc:167:(&cht_wc_regmap_cfg)->lock);
[   66.674561]
                *** DEADLOCK ***

The problem is that the CHT Whiskey Cove PMIC's builtin i2c-adapter is
itself a part of an i2c-client (the PMIC). This means that transfers done
through it take adapter->bus_lock twice, once for the parent i2c-adapter
and once for its own bus_lock. Lockdep does not like this nested locking.

To make lockdep happy in the case of busses with muxes, the i2c-core's
i2c_adapter_lock_bus function calls:

 rt_mutex_lock_nested(&adapter->bus_lock, i2c_adapter_depth(adapter));

But i2c_adapter_depth only works when the direct parent of the adapter is
another adapter, as it is only meant for muxes. In this case there is an
i2c-client and MFD instantiated platform_device in the parent->child chain
between the 2 devices.

This commit overrides the default i2c_lock_operations, passing a hardcoded
depth of 1 to rt_mutex_lock_nested, making lockdep happy.

Note that if there were to be a mux attached to the i2c-wc-cht adapter,
this would break things again since the i2c-mux code expects the
root-adapter to have a locking depth of 0. But the i2c-wc-cht adapter
always has only 1 client directly attached in the form of the charger IC
paired with the CHT Whiskey Cove PMIC.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-cht-wc.c | 46 +++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/drivers/i2c/busses/i2c-cht-wc.c b/drivers/i2c/busses/i2c-cht-wc.c
index 66af44bfa67d5..f6546de66fbc8 100644
--- a/drivers/i2c/busses/i2c-cht-wc.c
+++ b/drivers/i2c/busses/i2c-cht-wc.c
@@ -178,6 +178,51 @@ static const struct i2c_algorithm cht_wc_i2c_adap_algo = {
 	.smbus_xfer = cht_wc_i2c_adap_smbus_xfer,
 };
 
+/*
+ * We are an i2c-adapter which itself is part of an i2c-client. This means that
+ * transfers done through us take adapter->bus_lock twice, once for our parent
+ * i2c-adapter and once to take our own bus_lock. Lockdep does not like this
+ * nested locking, to make lockdep happy in the case of busses with muxes, the
+ * i2c-core's i2c_adapter_lock_bus function calls:
+ * rt_mutex_lock_nested(&adapter->bus_lock, i2c_adapter_depth(adapter));
+ *
+ * But i2c_adapter_depth only works when the direct parent of the adapter is
+ * another adapter, as it is only meant for muxes. In our case there is an
+ * i2c-client and MFD instantiated platform_device in the parent->child chain
+ * between the 2 devices.
+ *
+ * So we override the default i2c_lock_operations and pass a hardcoded
+ * depth of 1 to rt_mutex_lock_nested, to make lockdep happy.
+ *
+ * Note that if there were to be a mux attached to our adapter, this would
+ * break things again since the i2c-mux code expects the root-adapter to have
+ * a locking depth of 0. But we always have only 1 client directly attached
+ * in the form of the Charger IC paired with the CHT Whiskey Cove PMIC.
+ */
+static void cht_wc_i2c_adap_lock_bus(struct i2c_adapter *adapter,
+				 unsigned int flags)
+{
+	rt_mutex_lock_nested(&adapter->bus_lock, 1);
+}
+
+static int cht_wc_i2c_adap_trylock_bus(struct i2c_adapter *adapter,
+				   unsigned int flags)
+{
+	return rt_mutex_trylock(&adapter->bus_lock);
+}
+
+static void cht_wc_i2c_adap_unlock_bus(struct i2c_adapter *adapter,
+				   unsigned int flags)
+{
+	rt_mutex_unlock(&adapter->bus_lock);
+}
+
+static const struct i2c_lock_operations cht_wc_i2c_adap_lock_ops = {
+	.lock_bus =    cht_wc_i2c_adap_lock_bus,
+	.trylock_bus = cht_wc_i2c_adap_trylock_bus,
+	.unlock_bus =  cht_wc_i2c_adap_unlock_bus,
+};
+
 /**** irqchip for the client connected to the extchgr i2c adapter ****/
 static void cht_wc_i2c_irq_lock(struct irq_data *data)
 {
@@ -286,6 +331,7 @@ static int cht_wc_i2c_adap_i2c_probe(struct platform_device *pdev)
 	adap->adapter.owner = THIS_MODULE;
 	adap->adapter.class = I2C_CLASS_HWMON;
 	adap->adapter.algo = &cht_wc_i2c_adap_algo;
+	adap->adapter.lock_ops = &cht_wc_i2c_adap_lock_ops;
 	strlcpy(adap->adapter.name, "PMIC I2C Adapter",
 		sizeof(adap->adapter.name));
 	adap->adapter.dev.parent = &pdev->dev;
-- 
2.20.1



