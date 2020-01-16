Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E41913F371
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390187AbgAPRLP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:11:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:51444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729777AbgAPRLP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:11:15 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B94D24683;
        Thu, 16 Jan 2020 17:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194674;
        bh=DYh1De57UQsl31GQ9i432zoYRdgRGjmktJ9i0MJfymA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tWoIzkWlgmDIkeWAZsFoH8zAxWcXYcC76QZ7HGNB+JTXfuzv4CjtZ7sh95vc16tpK
         Yp8AGs3MbCHHhLm74/1eidxrkLK/NDaSIiTlwUqXY1wHruWqEQMz2vv/7/JaBZ48cO
         UrbUGw4DkM5gzkFS/nti31vjQnJkbZrVh7c96/I4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 521/671] usb: typec: tps6598x: Fix build error without CONFIG_REGMAP_I2C
Date:   Thu, 16 Jan 2020 12:02:39 -0500
Message-Id: <20200116170509.12787-258-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 35af2445dc306403254a181507b390ec9eb725d5 ]

If CONFIG_REGMAP_I2C is not set, building fails:

drivers/usb/typec/tps6598x.o: In function `tps6598x_probe':
tps6598x.c:(.text+0x5f0): undefined reference to `__devm_regmap_init_i2c'

Select REGMAP_I2C to fix this.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 0a4c005bd171 ("usb: typec: driver for TI TPS6598x USB Power Delivery controllers")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20190903121026.22148-1-yuehaibing@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/typec/Kconfig b/drivers/usb/typec/Kconfig
index 00878c386dd0..8445890accdf 100644
--- a/drivers/usb/typec/Kconfig
+++ b/drivers/usb/typec/Kconfig
@@ -95,6 +95,7 @@ source "drivers/usb/typec/ucsi/Kconfig"
 config TYPEC_TPS6598X
 	tristate "TI TPS6598x USB Power Delivery controller driver"
 	depends on I2C
+	select REGMAP_I2C
 	help
 	  Say Y or M here if your system has TI TPS65982 or TPS65983 USB Power
 	  Delivery controller.
-- 
2.20.1

