Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF6B2E428D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407774AbgL1PYL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:24:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:32768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436506AbgL1N7d (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:59:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E262205CB;
        Mon, 28 Dec 2020 13:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163958;
        bh=KYnaW5VT+LD4I7nr33q2mCTt112/n4SdXczon4C11ik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jIwLzJdb8QrFK0RdztBwSMmw0BjxM0uMPwoawX5kSGrPr/6ZIfLGqkwZ2O1dYzwX0
         OThgYanqno5Za08+hPMNAgmNgR19GuLxGmtpqdxqV+F1CCSrvZVW6HLMwiCoZqmYDs
         sAzTaPIQKLM4181AFc3TDBeu42nmLTvJsCTL4R3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 003/717] iio: adc: at91_adc: add Kconfig dep on the OF symbol and remove of_match_ptr()
Date:   Mon, 28 Dec 2020 13:40:01 +0100
Message-Id: <20201228125021.150202290@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandru Ardelean <alexandru.ardelean@analog.com>

[ Upstream commit f091d7c5fe6cc39e916b50f90e3cac67a032d0be ]

This tries to solve a warning reported by the lkp bot:

>> drivers/iio/adc/at91_adc.c:1439:34: warning: unused variable
>> 'at91_adc_dt_ids' [-Wunused-const-variable]
   static const struct of_device_id at91_adc_dt_ids[] = {
                                    ^
   1 warning generated.

This warning has appeared after the AT91_ADC driver compilation has been
enabled via the COMPILE_TEST symbol dependency.

The warning is caused by the 'of_match_ptr()' helper which returns NULL if
OF is undefined. This driver should build only for device-tree context, so
a dependency on the OF Kconfig symbol has been added.
Also, the usage of of_match_ptr() helper has been removed since it
shouldn't ever return NULL (because the driver should not be built for the
non-OF context).

Fixes: 4027860dcc4c ("iio: Kconfig: at91_adc: add COMPILE_TEST dependency to driver")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20200930135048.11530-4-alexandru.ardelean@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/Kconfig    | 2 +-
 drivers/iio/adc/at91_adc.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
index 91ae90514aff4..17e9ceb9c6c48 100644
--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -295,7 +295,7 @@ config ASPEED_ADC
 config AT91_ADC
 	tristate "Atmel AT91 ADC"
 	depends on ARCH_AT91 || COMPILE_TEST
-	depends on INPUT && SYSFS
+	depends on INPUT && SYSFS && OF
 	select IIO_BUFFER
 	select IIO_TRIGGERED_BUFFER
 	help
diff --git a/drivers/iio/adc/at91_adc.c b/drivers/iio/adc/at91_adc.c
index 9b2c548fae957..0a793e7cd53ee 100644
--- a/drivers/iio/adc/at91_adc.c
+++ b/drivers/iio/adc/at91_adc.c
@@ -1469,7 +1469,7 @@ static struct platform_driver at91_adc_driver = {
 	.id_table = at91_adc_ids,
 	.driver = {
 		   .name = DRIVER_NAME,
-		   .of_match_table = of_match_ptr(at91_adc_dt_ids),
+		   .of_match_table = at91_adc_dt_ids,
 		   .pm = &at91_adc_pm_ops,
 	},
 };
-- 
2.27.0



