Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 921A91B7566
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 14:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgDXMWo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 08:22:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:51876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727038AbgDXMWo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 08:22:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4D542087E;
        Fri, 24 Apr 2020 12:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587730963;
        bh=mdQmb9MY40kZXt9reDoHxPqXLcnVg4QMo5kwsMaw1y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VLKf6glMWqi6r9dgnSJqpNYdy+13/fZlg0u5mTXM9CVDAJqA77fWvYYns5eKzAJmp
         0X7VA7YTdK6rByoo78G+5WfvKe2LiB7rUk8SLEq+stU1BeiBjU4fuY4Oci9lmWiG4C
         DAiz+mo3E/8NPqB+sZZe1De/KjnWkve1zcXaPGr0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ann T Ropea <bedhanger@gmx.de>, Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 05/38] hwmon: (drivetemp) Use drivetemp's true module name in Kconfig section
Date:   Fri, 24 Apr 2020 08:22:03 -0400
Message-Id: <20200424122237.9831-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200424122237.9831-1-sashal@kernel.org>
References: <20200424122237.9831-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ann T Ropea <bedhanger@gmx.de>

[ Upstream commit 6bdf8f3efe867c5893e27431a555e41f54ed7f9a ]

The addition of the support for reading the temperature of ATA drives as
per commit 5b46903d8bf3 ("hwmon: Driver for disk and solid state drives
with temperature sensors") lists in the respective Kconfig section the
name of the module to be optionally built as "satatemp".

However, building the kernel modules with "CONFIG_SENSORS_DRIVETEMP=m",
does not generate a file named "satatemp.ko".

Instead, the rest of the original commit uses the term "drivetemp" and
a file named "drivetemp.ko" ends up in the kernel's modules directory.
This file has the right ingredients:

	$ strings /path/to/drivetemp.ko | grep ^description
	description=Hard drive temperature monitor

and modprobing it produces the expected result:

	# drivetemp is not loaded
	$ sensors -u drivetemp-scsi-4-0
	Specified sensor(s) not found!
	$ sudo modprobe drivetemp
	$ sensors -u drivetemp-scsi-4-0
	drivetemp-scsi-4-0
	Adapter: SCSI adapter
	temp1:
	  temp1_input: 35.000
	  temp1_max: 60.000
	  temp1_min: 0.000
	  temp1_crit: 70.000
	  temp1_lcrit: -40.000
	  temp1_lowest: 20.000
	  temp1_highest: 36.000

Fix Kconfig by referring to the true name of the module.

Fixes: 5b46903d8bf3 ("hwmon: Driver for disk and solid state drives with temperature sensors")
Signed-off-by: Ann T Ropea <bedhanger@gmx.de>
Link: https://lore.kernel.org/r/20200406235521.185309-1-bedhanger@gmx.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 47ac20aee06fc..4c1c61aa4b82e 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -403,7 +403,7 @@ config SENSORS_DRIVETEMP
 	  hard disk drives.
 
 	  This driver can also be built as a module. If so, the module
-	  will be called satatemp.
+	  will be called drivetemp.
 
 config SENSORS_DS620
 	tristate "Dallas Semiconductor DS620"
-- 
2.20.1

