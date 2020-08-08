Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F7723F9D2
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbgHHXiW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:38:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:52132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728269AbgHHXiV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:38:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D51702073E;
        Sat,  8 Aug 2020 23:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596929900;
        bh=lc7hxZLB0QegXEzX7NqRavm14GKELH629t/S1CVA/tI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=guN4eolZ7mIYWCGFzB0HIlx/EGdwVFVWQivMTvra6x0QgvymAkB6GYrfgRXiM28ht
         tSvZL8PqRsIBe+vninbHHzQkkPy33ShAzX2Mq964Vm0T/c8+vHaLsSLROv7VX1Ss8N
         OaBp6AqZZFEGiSrYheW7eWoaz+CjBrk4gO2UF5oI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Zapolskiy <vz@mleia.com>,
        Wen Yang <wenyang@linux.alibaba.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.7 40/58] regulator: fix memory leak on error path of regulator_register()
Date:   Sat,  8 Aug 2020 19:37:06 -0400
Message-Id: <20200808233724.3618168-40-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200808233724.3618168-1-sashal@kernel.org>
References: <20200808233724.3618168-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Zapolskiy <vz@mleia.com>

[ Upstream commit 9177514ce34902b3adb2abd490b6ad05d1cfcb43 ]

The change corrects registration and deregistration on error path
of a regulator, the problem was manifested by a reported memory
leak on deferred probe:

    as3722-regulator as3722-regulator: regulator 13 register failed -517

    # cat /sys/kernel/debug/kmemleak
    unreferenced object 0xecc43740 (size 64):
      comm "swapper/0", pid 1, jiffies 4294937640 (age 712.880s)
      hex dump (first 32 bytes):
        72 65 67 75 6c 61 74 6f 72 2e 32 34 00 5a 5a 5a  regulator.24.ZZZ
        5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
      backtrace:
        [<0c4c3d1c>] __kmalloc_track_caller+0x15c/0x2c0
        [<40c0ad48>] kvasprintf+0x64/0xd4
        [<109abd29>] kvasprintf_const+0x70/0x84
        [<c4215946>] kobject_set_name_vargs+0x34/0xa8
        [<62282ea2>] dev_set_name+0x40/0x64
        [<a39b6757>] regulator_register+0x3a4/0x1344
        [<16a9543f>] devm_regulator_register+0x4c/0x84
        [<51a4c6a1>] as3722_regulator_probe+0x294/0x754
        ...

The memory leak problem was introduced as a side ef another fix in
regulator_register() error path, I believe that the proper fix is
to decouple device_register() function into its two compounds and
initialize a struct device before assigning any values to its fields
and then using it before actual registration of a device happens.

This lets to call put_device() safely after initialization, and, since
now a release callback is called, kfree(rdev->constraints) shall be
removed to exclude a double free condition.

Fixes: a3cde9534ebd ("regulator: core: fix regulator_register() error paths to properly release rdev")
Signed-off-by: Vladimir Zapolskiy <vz@mleia.com>
Cc: Wen Yang <wenyang@linux.alibaba.com>
Link: https://lore.kernel.org/r/20200724005013.23278-1-vz@mleia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 7486f6e4e613c..0cb99bb090ef8 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -5005,7 +5005,6 @@ regulator_register(const struct regulator_desc *regulator_desc,
 	struct regulator_dev *rdev;
 	bool dangling_cfg_gpiod = false;
 	bool dangling_of_gpiod = false;
-	bool reg_device_fail = false;
 	struct device *dev;
 	int ret, i;
 
@@ -5134,10 +5133,12 @@ regulator_register(const struct regulator_desc *regulator_desc,
 	}
 
 	/* register with sysfs */
+	device_initialize(&rdev->dev);
 	rdev->dev.class = &regulator_class;
 	rdev->dev.parent = dev;
 	dev_set_name(&rdev->dev, "regulator.%lu",
 		    (unsigned long) atomic_inc_return(&regulator_no));
+	dev_set_drvdata(&rdev->dev, rdev);
 
 	/* set regulator constraints */
 	if (init_data)
@@ -5188,12 +5189,9 @@ regulator_register(const struct regulator_desc *regulator_desc,
 	    !rdev->desc->fixed_uV)
 		rdev->is_switch = true;
 
-	dev_set_drvdata(&rdev->dev, rdev);
-	ret = device_register(&rdev->dev);
-	if (ret != 0) {
-		reg_device_fail = true;
+	ret = device_add(&rdev->dev);
+	if (ret != 0)
 		goto unset_supplies;
-	}
 
 	rdev_init_debugfs(rdev);
 
@@ -5215,17 +5213,15 @@ regulator_register(const struct regulator_desc *regulator_desc,
 	mutex_unlock(&regulator_list_mutex);
 wash:
 	kfree(rdev->coupling_desc.coupled_rdevs);
-	kfree(rdev->constraints);
 	mutex_lock(&regulator_list_mutex);
 	regulator_ena_gpio_free(rdev);
 	mutex_unlock(&regulator_list_mutex);
+	put_device(&rdev->dev);
+	rdev = NULL;
 clean:
 	if (dangling_of_gpiod)
 		gpiod_put(config->ena_gpiod);
-	if (reg_device_fail)
-		put_device(&rdev->dev);
-	else
-		kfree(rdev);
+	kfree(rdev);
 	kfree(config);
 rinse:
 	if (dangling_cfg_gpiod)
-- 
2.25.1

