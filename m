Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4AD01483E2
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390591AbgAXLhy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:37:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:47348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404113AbgAXL37 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:29:59 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39B0420704;
        Fri, 24 Jan 2020 11:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865398;
        bh=W45XOoLMzbAI65/IHnzY6REvpYYvljmHOutDO7b+rjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pLUXasJsJpxn96MGSunmlT/yO34S/XZZnmyL+CyF6A4yrCK2paw2Tt3dlOHr30/v7
         syzmSmIoLi0sFpKwdgQGugoJZ8sK94ltbuoEdJKD+XfGQfMUQCjfnaCYept9MSS9sk
         TBLWoM55S2IIwMC1WA9FKvJmy0ziMJF4uGcyw0z4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 535/639] usb: typec: tps6598x: Fix build error without CONFIG_REGMAP_I2C
Date:   Fri, 24 Jan 2020 10:31:45 +0100
Message-Id: <20200124093155.990352673@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 00878c386dd09..8445890accdfe 100644
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



