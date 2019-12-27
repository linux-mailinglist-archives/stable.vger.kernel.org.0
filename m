Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2DF212B63F
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727432AbfL0RlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:41:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:37578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727423AbfL0RlX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:41:23 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECF2621775;
        Fri, 27 Dec 2019 17:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468482;
        bh=Ap0eT4B2IZ5lOyKqoub0MsmgTbdszsLuhRkh7djPqtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xCe7ECCA9bi2M7/DKa4QeazwYjEt11/TfGLWF7Y6Ic8BvucITeJEBUPDRO0HrKeNO
         2bAY0bt2nm0WkKJSlHtGz4POPBh2r6AlmKKvghRV9ccBXAlNFyDGCjS2I8T7yGvfDX
         opOeDuFfWKOmFrbemKHLRDNMQGmC5xH6IgH65KZg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wen Yang <wenyang@linux.alibaba.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 021/187] regulator: core: fix regulator_register() error paths to properly release rdev
Date:   Fri, 27 Dec 2019 12:38:09 -0500
Message-Id: <20191227174055.4923-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Yang <wenyang@linux.alibaba.com>

[ Upstream commit a3cde9534ebdafe18a9bbab208df724c57e6c8e8 ]

There are several issues with the error handling code of
the regulator_register() function:
        ret = device_register(&rdev->dev);
        if (ret != 0) {
                put_device(&rdev->dev); --> rdev released
                goto unset_supplies;
        }
...
unset_supplies:
...
        unset_regulator_supplies(rdev); --> use-after-free
...
clean:
        if (dangling_of_gpiod)
                gpiod_put(config->ena_gpiod);
        kfree(rdev);                     --> double free

We add a variable to record the failure of device_register() and
move put_device() down a bit to avoid the above issues.

Fixes: c438b9d01736 ("regulator: core: Move registration of regulator device")
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org
Link: https://lore.kernel.org/r/20191201030250.38074-1-wenyang@linux.alibaba.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 71c1467e1e2e..8f5c028090e9 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -4990,6 +4990,7 @@ regulator_register(const struct regulator_desc *regulator_desc,
 	struct regulator_dev *rdev;
 	bool dangling_cfg_gpiod = false;
 	bool dangling_of_gpiod = false;
+	bool reg_device_fail = false;
 	struct device *dev;
 	int ret, i;
 
@@ -5175,7 +5176,7 @@ regulator_register(const struct regulator_desc *regulator_desc,
 	dev_set_drvdata(&rdev->dev, rdev);
 	ret = device_register(&rdev->dev);
 	if (ret != 0) {
-		put_device(&rdev->dev);
+		reg_device_fail = true;
 		goto unset_supplies;
 	}
 
@@ -5205,7 +5206,10 @@ regulator_register(const struct regulator_desc *regulator_desc,
 clean:
 	if (dangling_of_gpiod)
 		gpiod_put(config->ena_gpiod);
-	kfree(rdev);
+	if (reg_device_fail)
+		put_device(&rdev->dev);
+	else
+		kfree(rdev);
 	kfree(config);
 rinse:
 	if (dangling_cfg_gpiod)
-- 
2.20.1

