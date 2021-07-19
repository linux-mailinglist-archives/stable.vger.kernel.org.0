Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 263A73CDBDC
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238838AbhGSOuH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:50:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:40458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344442AbhGSOst (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:48:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8092C61428;
        Mon, 19 Jul 2021 15:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708546;
        bh=fmTeVbOhB7xFhuh5dd5RZEiD25zAeDs96ZiXlw2fpLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ETccxTKbKKKAia1QDAw6btE7AOkiByx3P4pygTYk8k5eGhEW2XjYw8YuIH8e7Pbh9
         obhaoC33KG3v6EZ5nW/xabrrWZzbR32hOhrlr6eBffdVttmPSpvC0TcmXoE5mktGH1
         RK2S2ik43ca14jUkYxeAdMlYAev9API1+tKq8U5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, frank zago <frank@zago.net>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.19 033/421] iio: light: tcs3472: do not free unallocated IRQ
Date:   Mon, 19 Jul 2021 16:47:24 +0200
Message-Id: <20210719144947.382439489@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: frank zago <frank@zago.net>

commit 7cd04c863f9e1655d607705455e7714f24451984 upstream.

Allocating an IRQ is conditional to the IRQ existence, but freeing it
was not. If no IRQ was allocate, the driver would still try to free
IRQ 0. Add the missing checks.

This fixes the following trace when the driver is removed:

[  100.667788] Trying to free already-free IRQ 0
[  100.667793] WARNING: CPU: 0 PID: 2315 at kernel/irq/manage.c:1826 free_irq+0x1fd/0x370
...
[  100.667914] Call Trace:
[  100.667920]  tcs3472_remove+0x3a/0x90 [tcs3472]
[  100.667927]  i2c_device_remove+0x2b/0xa0

Signed-off-by: frank zago <frank@zago.net>
Link: https://lore.kernel.org/r/20210427022017.19314-2-frank@zago.net
Fixes: 9d2f715d592e ("iio: light: tcs3472: support out-of-threshold events")
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/light/tcs3472.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/iio/light/tcs3472.c
+++ b/drivers/iio/light/tcs3472.c
@@ -535,7 +535,8 @@ static int tcs3472_probe(struct i2c_clie
 	return 0;
 
 free_irq:
-	free_irq(client->irq, indio_dev);
+	if (client->irq)
+		free_irq(client->irq, indio_dev);
 buffer_cleanup:
 	iio_triggered_buffer_cleanup(indio_dev);
 	return ret;
@@ -563,7 +564,8 @@ static int tcs3472_remove(struct i2c_cli
 	struct iio_dev *indio_dev = i2c_get_clientdata(client);
 
 	iio_device_unregister(indio_dev);
-	free_irq(client->irq, indio_dev);
+	if (client->irq)
+		free_irq(client->irq, indio_dev);
 	iio_triggered_buffer_cleanup(indio_dev);
 	tcs3472_powerdown(iio_priv(indio_dev));
 


