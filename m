Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7514226B451
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727245AbgIOXVg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:21:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727207AbgIOOiG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:38:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D177923C85;
        Tue, 15 Sep 2020 14:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180104;
        bh=T/7IdzVg6tDw67/+oxDC7F3CgpDRdRW6AuPkmcHjzRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j/88OTIpaoTF2vy157+lqzeidpPsS/MEEAa/jgqC+8H9ogh6E9km3jufybo91SBRq
         N2kmA+VRYIFA9cIjsIi9L1ygc3nE4gUnLW3oh0uWVYJNs6o1tYBnwMsLSxmbgk3ovM
         2Rnt9E7Glcd98fiWb9tQwMxobJ6IVw0RMuNLr7TI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Kochetkov <fido_max@inbox.ru>,
        Maxim Kiselev <bigunclemax@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.8 110/177] iio: adc: ti-ads1015: fix conversion when CONFIG_PM is not set
Date:   Tue, 15 Sep 2020 16:13:01 +0200
Message-Id: <20200915140658.920543178@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Kochetkov <fido_max@inbox.ru>

commit e71e6dbe96ac80ac2aebe71a6a942e7bd60e7596 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/ti-ads1015.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/iio/adc/ti-ads1015.c
+++ b/drivers/iio/adc/ti-ads1015.c
@@ -316,6 +316,7 @@ static const struct iio_chan_spec ads111
 	IIO_CHAN_SOFT_TIMESTAMP(ADS1015_TIMESTAMP),
 };
 
+#ifdef CONFIG_PM
 static int ads1015_set_power_state(struct ads1015_data *data, bool on)
 {
 	int ret;
@@ -333,6 +334,15 @@ static int ads1015_set_power_state(struc
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


