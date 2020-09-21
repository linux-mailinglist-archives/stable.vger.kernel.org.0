Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45675272D53
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729209AbgIUQjP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:39:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:40070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728626AbgIUQir (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:38:47 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 090AF238EE;
        Mon, 21 Sep 2020 16:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706326;
        bh=68ifFe8bMTvCqox7vYKsjUGQ2ojIVQTihFkdsvI06uY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ENYhqvifKUwsAeo2cJzW81lv8IyZjZ7eA2Ydu59S78uPYI+awmo3hxtMDdK+ynBDN
         vuZwRcmY+YwDlqpH455ohZv+k3ZNnLGcaypx2Uldjl8ZK+J3/DWeZAAOWwFpR/jxI8
         KgaHcoeZ0bwef3obzoIGkSVqpaYsUIgCq7VzqPRM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Kochetkov <fido_max@inbox.ru>,
        Maxim Kiselev <bigunclemax@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.14 25/94] iio: adc: ti-ads1015: fix conversion when CONFIG_PM is not set
Date:   Mon, 21 Sep 2020 18:27:12 +0200
Message-Id: <20200921162036.705978514@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.541285330@linuxfoundation.org>
References: <20200921162035.541285330@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
@@ -312,6 +312,7 @@ static const struct iio_chan_spec ads111
 	IIO_CHAN_SOFT_TIMESTAMP(ADS1015_TIMESTAMP),
 };
 
+#ifdef CONFIG_PM
 static int ads1015_set_power_state(struct ads1015_data *data, bool on)
 {
 	int ret;
@@ -329,6 +330,15 @@ static int ads1015_set_power_state(struc
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


