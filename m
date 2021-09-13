Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA44240924C
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244556AbhIMOK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:10:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:59952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344155AbhIMOIs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:08:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15223613CF;
        Mon, 13 Sep 2021 13:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540462;
        bh=/d29cnrykMJAM59XlqfxgJ4cJ/6LbmA653H3HbDyPWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aq0yZv8HNvBSyo/KHuEr2DVi5oUHaBHQaEq+L0JN+2UWlU3scgwWl0Hk0ugdOtoSn
         1zqDcuB5UzQt1UxVDvLBQ3PQDOT11WRxiSx1ja7K+q6sRxcHFtTly4rGI8lP0DsGRU
         9r0u7Xwu2i/qOyCK7xnNrkcybaxQa+41xcU+RPcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 204/300] hwmon: (pmbus/bpa-rs600) Dont use rated limits as warn limits
Date:   Mon, 13 Sep 2021 15:14:25 +0200
Message-Id: <20210913131116.259565724@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

[ Upstream commit 7a8c68c57fd09541377f6971f25efdeb9a926c37 ]

In the initial implementation a number of PMBUS_x_WARN_LIMITs were
mapped to MFR fields. This was incorrect as these MFR limits reflect the
rated limit as opposed to a limit which will generate warning. Instead
return -ENXIO like we were already doing for other WARN_LIMITs.

Subsequently these rated limits have been exposed generically as new
fields in the sysfs ABI so the values are still available.

Fixes: 15b2703e5e02 ("hwmon: (pmbus) Add driver for BluTek BPA-RS600")
Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Link: https://lore.kernel.org/r/20210812014000.26293-2-chris.packham@alliedtelesis.co.nz
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/bpa-rs600.c | 25 -------------------------
 1 file changed, 25 deletions(-)

diff --git a/drivers/hwmon/pmbus/bpa-rs600.c b/drivers/hwmon/pmbus/bpa-rs600.c
index 2be69fedfa36..be76efe67d83 100644
--- a/drivers/hwmon/pmbus/bpa-rs600.c
+++ b/drivers/hwmon/pmbus/bpa-rs600.c
@@ -12,15 +12,6 @@
 #include <linux/pmbus.h>
 #include "pmbus.h"
 
-#define BPARS600_MFR_VIN_MIN	0xa0
-#define BPARS600_MFR_VIN_MAX	0xa1
-#define BPARS600_MFR_IIN_MAX	0xa2
-#define BPARS600_MFR_PIN_MAX	0xa3
-#define BPARS600_MFR_VOUT_MIN	0xa4
-#define BPARS600_MFR_VOUT_MAX	0xa5
-#define BPARS600_MFR_IOUT_MAX	0xa6
-#define BPARS600_MFR_POUT_MAX	0xa7
-
 static int bpa_rs600_read_byte_data(struct i2c_client *client, int page, int reg)
 {
 	int ret;
@@ -81,29 +72,13 @@ static int bpa_rs600_read_word_data(struct i2c_client *client, int page, int pha
 
 	switch (reg) {
 	case PMBUS_VIN_UV_WARN_LIMIT:
-		ret = pmbus_read_word_data(client, 0, 0xff, BPARS600_MFR_VIN_MIN);
-		break;
 	case PMBUS_VIN_OV_WARN_LIMIT:
-		ret = pmbus_read_word_data(client, 0, 0xff, BPARS600_MFR_VIN_MAX);
-		break;
 	case PMBUS_VOUT_UV_WARN_LIMIT:
-		ret = pmbus_read_word_data(client, 0, 0xff, BPARS600_MFR_VOUT_MIN);
-		break;
 	case PMBUS_VOUT_OV_WARN_LIMIT:
-		ret = pmbus_read_word_data(client, 0, 0xff, BPARS600_MFR_VOUT_MAX);
-		break;
 	case PMBUS_IIN_OC_WARN_LIMIT:
-		ret = pmbus_read_word_data(client, 0, 0xff, BPARS600_MFR_IIN_MAX);
-		break;
 	case PMBUS_IOUT_OC_WARN_LIMIT:
-		ret = pmbus_read_word_data(client, 0, 0xff, BPARS600_MFR_IOUT_MAX);
-		break;
 	case PMBUS_PIN_OP_WARN_LIMIT:
-		ret = pmbus_read_word_data(client, 0, 0xff, BPARS600_MFR_PIN_MAX);
-		break;
 	case PMBUS_POUT_OP_WARN_LIMIT:
-		ret = pmbus_read_word_data(client, 0, 0xff, BPARS600_MFR_POUT_MAX);
-		break;
 	case PMBUS_VIN_UV_FAULT_LIMIT:
 	case PMBUS_VIN_OV_FAULT_LIMIT:
 	case PMBUS_VOUT_UV_FAULT_LIMIT:
-- 
2.30.2



