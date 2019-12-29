Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C58C12C7A2
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730709AbfL2Roc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:44:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:52712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730703AbfL2Roc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:44:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F245A208C4;
        Sun, 29 Dec 2019 17:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641471;
        bh=bD0+Jkeh5DbPFw8gqoCbG0aPOY5p4NbFTfI9ipiAsko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fCgrBs/QI0bVh+RSZXGRsDpOZeNKVV1mZ9KTPNTu2jKoEwhqAb7cMNftwjcJXAl0P
         9AEJz39XLzZPiKDnxxanOLZYDCbAJ+At3SV9FSfB/HATzuU2o11ELjjeZGiUwmXoA6
         6la8TpEvTTu0KBmugodAIbINFj1ZvBcKO6D6Lh8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 079/434] media: max2175: Fix build error without CONFIG_REGMAP_I2C
Date:   Sun, 29 Dec 2019 18:22:12 +0100
Message-Id: <20191229172706.847494239@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 7eee1812bba3..fcffcc31d168 100644
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



