Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B857137F90
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730577AbgAKKVB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:21:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:43522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729336AbgAKKVA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:21:00 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 482BE208E4;
        Sat, 11 Jan 2020 10:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738060;
        bh=fGh5qYSB3I35x/gwyaPv4GcNUN3Bj392V79vARehqmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gv4R/Buc3XU47CbsgQAxI/iAb0EYaGC5n2Ymlr6ADTvg/uGZ70+nDvGcGJIORP8d1
         2bHGp2h+AXHJaCHkDKkn179wLgC5aQ9maI+CBr2871/6K8wJLzpG6Ssk41Jl+hDfnI
         nameQlVUirgmmVUGA0JD840YtdpmQyA1mjMMmt3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wenyang@linux.alibaba.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 017/165] regulator: core: fix regulator_register() error paths to properly release rdev
Date:   Sat, 11 Jan 2020 10:48:56 +0100
Message-Id: <20200111094922.413716871@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index d66404920976..1dba0bdf3762 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -4992,6 +4992,7 @@ regulator_register(const struct regulator_desc *regulator_desc,
 	struct regulator_dev *rdev;
 	bool dangling_cfg_gpiod = false;
 	bool dangling_of_gpiod = false;
+	bool reg_device_fail = false;
 	struct device *dev;
 	int ret, i;
 
@@ -5177,7 +5178,7 @@ regulator_register(const struct regulator_desc *regulator_desc,
 	dev_set_drvdata(&rdev->dev, rdev);
 	ret = device_register(&rdev->dev);
 	if (ret != 0) {
-		put_device(&rdev->dev);
+		reg_device_fail = true;
 		goto unset_supplies;
 	}
 
@@ -5208,7 +5209,10 @@ regulator_register(const struct regulator_desc *regulator_desc,
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



