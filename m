Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2052B25773A
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 12:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726459AbgHaK0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 06:26:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726106AbgHaK0G (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 31 Aug 2020 06:26:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B34120DD4;
        Mon, 31 Aug 2020 10:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598869566;
        bh=tGebCXJfYVlnAjrsDURbDfRzPdEnZcRgjugBqtiArGQ=;
        h=Subject:To:From:Date:From;
        b=mxbKsGAJyZK0PhFqhWukLPix/Zl+UXMCg3CeLRI5JOz7w5B8Zr8PgTIV/I11h2wcw
         VUdV+EfoNk2eFH/4B7UzNoWo5zmKVOnzb6LNsuM5qe/Eoqmv3aiADL7kwnpb4zpNoE
         +q9osenlf/lQLuZ6l1A51XsJdjegC08hM57CB2t4=
Subject: patch "iio: adc: ti-ads1015: fix conversion when CONFIG_PM is not set" added to staging-linus
To:     fido_max@inbox.ru, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, andriy.shevchenko@linux.intel.com,
        bigunclemax@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Aug 2020 12:26:12 +0200
Message-ID: <1598869572476@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: ti-ads1015: fix conversion when CONFIG_PM is not set

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From e71e6dbe96ac80ac2aebe71a6a942e7bd60e7596 Mon Sep 17 00:00:00 2001
From: Maxim Kochetkov <fido_max@inbox.ru>
Date: Mon, 3 Aug 2020 08:04:05 +0300
Subject: iio: adc: ti-ads1015: fix conversion when CONFIG_PM is not set

To stop conversion ads1015_set_power_state() function call unimplemented
function __pm_runtime_suspend() from pm_runtime_put_autosuspend()
if CONFIG_PM is not set.
In case of CONFIG_PM is not set: __pm_runtime_suspend() returns -ENOSYS,
so ads1015_read_raw() failed because ads1015_set_power_state() returns an
error.

If CONFIG_PM is disabled, there is no need to start/stop conversion.
Fix it by adding return 0 function variant if CONFIG_PM is not set.

Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
Fixes: ecc24e72f437 ("iio: adc: Add TI ADS1015 ADC driver support")
Tested-by: Maxim Kiselev <bigunclemax@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/ti-ads1015.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/iio/adc/ti-ads1015.c b/drivers/iio/adc/ti-ads1015.c
index f42ab112986e..9fef39bcf997 100644
--- a/drivers/iio/adc/ti-ads1015.c
+++ b/drivers/iio/adc/ti-ads1015.c
@@ -316,6 +316,7 @@ static const struct iio_chan_spec ads1115_channels[] = {
 	IIO_CHAN_SOFT_TIMESTAMP(ADS1015_TIMESTAMP),
 };
 
+#ifdef CONFIG_PM
 static int ads1015_set_power_state(struct ads1015_data *data, bool on)
 {
 	int ret;
@@ -333,6 +334,15 @@ static int ads1015_set_power_state(struct ads1015_data *data, bool on)
 	return ret < 0 ? ret : 0;
 }
 
+#else /* !CONFIG_PM */
+
+static int ads1015_set_power_state(struct ads1015_data *data, bool on)
+{
+	return 0;
+}
+
+#endif /* !CONFIG_PM */
+
 static
 int ads1015_get_adc_result(struct ads1015_data *data, int chan, int *val)
 {
-- 
2.28.0


