Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B11613C510D
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239205AbhGLHgO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:36:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:52296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347108AbhGLHe0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:34:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 893F061419;
        Mon, 12 Jul 2021 07:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075078;
        bh=hOeneoQcegjwQom53rGxE159EsLoGOPGzcrG4FXfD4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z0E8PQwlxqWchoFgDCbCV7ZcDYApcnr7VJPzmY7YGhyMOrDEJ9Q+c2/kGlZTqBnP1
         nFwe+/2qKspPEIQ2ySXfg/sTjz/xIqNxNo4Ar7KdYgy2xgnO/S98TjbCnkPrRmgpDv
         r3q8n/vkDJmLzqiCNhQ3XZRst+EoBKG34oRA0b3M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Cline <jeremy@jcline.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.13 098/800] iio: accel: bmc150: Fix dereferencing the wrong pointer in bmc150_get/set_second_device
Date:   Mon, 12 Jul 2021 08:02:01 +0200
Message-Id: <20210712060926.844289602@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit f2bf22dc9ea8ead180fc0221874bd556bf1d2685 upstream.

The drvdata for iio-parent devices points to the struct iio_dev for
the iio-device. So by directly casting the return from i2c_get_clientdata()
to struct bmc150_accel_data * the code was ending up storing the second_dev
pointer in (and retrieving it from) some semi-random offset inside
struct iio_dev, rather then storing it in the second_dev member of the
bmc150_accel_data struct.

Fix the code to get the struct bmc150_accel_data * pointer to call
iio_priv() on the struct iio_dev * returned by i2c_get_clientdata(),
so that the correct pointer gets dereferenced.

This fixes the following oops on rmmod, caused by trying to
dereference the wrong return of bmc150_get_second_device():

[  238.980737] BUG: unable to handle page fault for address: 0000000000004710
[  238.980755] #PF: supervisor read access in kernel mode
[  238.980760] #PF: error_code(0x0000) - not-present page
...
[  238.980841]  i2c_unregister_device.part.0+0x19/0x60
[  238.980856]  0xffffffffc0815016
[  238.980863]  i2c_device_remove+0x25/0xb0
[  238.980869]  __device_release_driver+0x180/0x240
[  238.980876]  driver_detach+0xd4/0x120
[  238.980882]  bus_remove_driver+0x5b/0xd0
[  238.980888]  i2c_del_driver+0x44/0x70

While at it also remove the now no longer sensible checks for data
being NULL, iio_priv never returns NULL for an iio_dev with non 0
sized private-data.

Fixes: 5bfb3a4bd8f6 ("iio: accel: bmc150: Check for a second ACPI device for BOSC0200")
Cc: Jeremy Cline <jeremy@jcline.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/accel/bmc150-accel-core.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/drivers/iio/accel/bmc150-accel-core.c
+++ b/drivers/iio/accel/bmc150-accel-core.c
@@ -1810,10 +1810,7 @@ EXPORT_SYMBOL_GPL(bmc150_accel_core_prob
 
 struct i2c_client *bmc150_get_second_device(struct i2c_client *client)
 {
-	struct bmc150_accel_data *data = i2c_get_clientdata(client);
-
-	if (!data)
-		return NULL;
+	struct bmc150_accel_data *data = iio_priv(i2c_get_clientdata(client));
 
 	return data->second_device;
 }
@@ -1821,10 +1818,9 @@ EXPORT_SYMBOL_GPL(bmc150_get_second_devi
 
 void bmc150_set_second_device(struct i2c_client *client)
 {
-	struct bmc150_accel_data *data = i2c_get_clientdata(client);
+	struct bmc150_accel_data *data = iio_priv(i2c_get_clientdata(client));
 
-	if (data)
-		data->second_device = client;
+	data->second_device = client;
 }
 EXPORT_SYMBOL_GPL(bmc150_set_second_device);
 


