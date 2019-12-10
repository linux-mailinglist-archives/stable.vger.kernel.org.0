Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1DC1192F1
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727564AbfLJVEu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:04:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:50134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727425AbfLJVEt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:04:49 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AE4B2468D;
        Tue, 10 Dec 2019 21:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576011889;
        bh=HTOXOZVVDa4aNhC93hQvuBntretGu9CwYuO3o4qqzYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0MdKkxVmQ24bTHpEGJnvyYNwxFI9pAYqu5Hsbgk9remG/qIDkqw983O21vmnlolzY
         IkKcrDpFdGvLcuxJhhPESjCzddL7LhMae3w4h2A1siHsjyrmLN/z3j5kGtG3vuP65g
         vc/3PtM76jC6WWryL7dePEWdr+Nq2tbdY57r/ED4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 039/350] media: max2175: Fix build error without CONFIG_REGMAP_I2C
Date:   Tue, 10 Dec 2019 15:58:51 -0500
Message-Id: <20191210210402.8367-39-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210402.8367-1-sashal@kernel.org>
References: <20191210210402.8367-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 36756fbff1e4a31d71d262ae6a04a20b38efa874 ]

If CONFIG_REGMAP_I2C is not set, building fails:

drivers/media/i2c/max2175.o: In function `max2175_probe':
max2175.c:(.text+0x1404): undefined reference to `__devm_regmap_init_i2c'

Select REGMAP_I2C to fix this.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: b47b79d8a231 ("[media] media: i2c: max2175: Add MAX2175 support")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 7eee1812bba36..fcffcc31d168a 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -1113,6 +1113,7 @@ comment "SDR tuner chips"
 config SDR_MAX2175
 	tristate "Maxim 2175 RF to Bits tuner"
 	depends on VIDEO_V4L2 && MEDIA_SDR_SUPPORT && I2C
+	select REGMAP_I2C
 	help
 	  Support for Maxim 2175 tuner. It is an advanced analog/digital
 	  radio receiver with RF-to-Bits front-end designed for SDR solutions.
-- 
2.20.1

