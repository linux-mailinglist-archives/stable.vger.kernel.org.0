Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9DE472736
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240006AbhLMJ7L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:59:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237272AbhLMJyC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:54:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A0EAC08EE18;
        Mon, 13 Dec 2021 01:45:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9456B80E15;
        Mon, 13 Dec 2021 09:45:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C995C341C8;
        Mon, 13 Dec 2021 09:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388729;
        bh=FSu3AUO6nUxxKdLOSZ0hdx5HKORItOMZrktKX2NZuW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ltz56c8hPM1yA03agMo6oRhgvVIkjbuOw6TNi54VxVushJLrIdoim2VnhoXbyOedD
         j5ASg5ExHd8r0mcO1g+r/UWIqutC/8kLyZNy8f8+i0TfM8O+0V1khxeNZ5Q1kv8sbu
         arsyY6sK9UCPSoU7OQuTCyidulyFGoZQUReKgqU4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Andersen <jackoalan@gmail.com>,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 77/88] iio: dln2-adc: Fix lockdep complaint
Date:   Mon, 13 Dec 2021 10:30:47 +0100
Message-Id: <20211213092935.887051130@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092933.250314515@linuxfoundation.org>
References: <20211213092933.250314515@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Noralf Trønnes <noralf@tronnes.org>

commit 59f92868176f191eefde70d284bdfc1ed76a84bc upstream.

When reading the voltage:

$ cat /sys/bus/iio/devices/iio\:device0/in_voltage0_raw

Lockdep complains:

[  153.910616] ======================================================
[  153.916918] WARNING: possible circular locking dependency detected
[  153.923221] 5.14.0+ #5 Not tainted
[  153.926692] ------------------------------------------------------
[  153.932992] cat/717 is trying to acquire lock:
[  153.937525] c2585358 (&indio_dev->mlock){+.+.}-{3:3}, at: iio_device_claim_direct_mode+0x28/0x44
[  153.946541]
               but task is already holding lock:
[  153.952487] c2585860 (&dln2->mutex){+.+.}-{3:3}, at: dln2_adc_read_raw+0x94/0x2bc [dln2_adc]
[  153.961152]
               which lock already depends on the new lock.

Fix this by not calling into the iio core underneath the dln2->mutex lock.

Fixes: 7c0299e879dd ("iio: adc: Add support for DLN2 ADC")
Cc: Jack Andersen <jackoalan@gmail.com>
Signed-off-by: Noralf Trønnes <noralf@tronnes.org>
Link: https://lore.kernel.org/r/20211018113731.25723-1-noralf@tronnes.org
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/dln2-adc.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/iio/adc/dln2-adc.c
+++ b/drivers/iio/adc/dln2-adc.c
@@ -248,7 +248,6 @@ static int dln2_adc_set_chan_period(stru
 static int dln2_adc_read(struct dln2_adc *dln2, unsigned int channel)
 {
 	int ret, i;
-	struct iio_dev *indio_dev = platform_get_drvdata(dln2->pdev);
 	u16 conflict;
 	__le16 value;
 	int olen = sizeof(value);
@@ -257,13 +256,9 @@ static int dln2_adc_read(struct dln2_adc
 		.chan = channel,
 	};
 
-	ret = iio_device_claim_direct_mode(indio_dev);
-	if (ret < 0)
-		return ret;
-
 	ret = dln2_adc_set_chan_enabled(dln2, channel, true);
 	if (ret < 0)
-		goto release_direct;
+		return ret;
 
 	ret = dln2_adc_set_port_enabled(dln2, true, &conflict);
 	if (ret < 0) {
@@ -300,8 +295,6 @@ disable_port:
 	dln2_adc_set_port_enabled(dln2, false, NULL);
 disable_chan:
 	dln2_adc_set_chan_enabled(dln2, channel, false);
-release_direct:
-	iio_device_release_direct_mode(indio_dev);
 
 	return ret;
 }
@@ -337,10 +330,16 @@ static int dln2_adc_read_raw(struct iio_
 
 	switch (mask) {
 	case IIO_CHAN_INFO_RAW:
+		ret = iio_device_claim_direct_mode(indio_dev);
+		if (ret < 0)
+			return ret;
+
 		mutex_lock(&dln2->mutex);
 		ret = dln2_adc_read(dln2, chan->channel);
 		mutex_unlock(&dln2->mutex);
 
+		iio_device_release_direct_mode(indio_dev);
+
 		if (ret < 0)
 			return ret;
 


