Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D75B247165
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390940AbgHQS0Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:26:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:49304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388180AbgHQQCM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:02:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11C7520885;
        Mon, 17 Aug 2020 16:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680131;
        bh=dz10XqBAs0YnUMWe3V7njFohRwrxUEghfJ/mtHXucnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OKTSMeOALn9Xj7CmLHgG4FljEc3BhyaR94KYNE937dHAqOkz5qM7UcDaokXQuN3CW
         yv3G4ekFBDqH2xdZUUznAV37EC55r8WJQp2/GR1P2VWks79DjExTy8VIzT9wEgJaus
         ey6wBu3OCcU3YaIoBX4EnpMpxNUiVmIBdkYX3j7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Zapolskiy <vz@mleia.com>,
        Wen Yang <wenyang@linux.alibaba.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 034/270] regulator: fix memory leak on error path of regulator_register()
Date:   Mon, 17 Aug 2020 17:13:55 +0200
Message-Id: <20200817143757.494087256@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 0011bdc15afbb..a17aebe0aa7a7 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -4994,7 +4994,6 @@ regulator_register(const struct regulator_desc *regulator_desc,
 	struct regulator_dev *rdev;
 	bool dangling_cfg_gpiod = false;
 	bool dangling_of_gpiod = false;
-	bool reg_device_fail = false;
 	struct device *dev;
 	int ret, i;
 
@@ -5123,10 +5122,12 @@ regulator_register(const struct regulator_desc *regulator_desc,
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
@@ -5177,12 +5178,9 @@ regulator_register(const struct regulator_desc *regulator_desc,
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
 
@@ -5204,17 +5202,15 @@ regulator_register(const struct regulator_desc *regulator_desc,
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



