Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72A42314333
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 23:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbhBHWvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 17:51:06 -0500
Received: from smtp-out.xnet.cz ([178.217.244.18]:53862 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229623AbhBHWvG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 17:51:06 -0500
X-Greylist: delayed 544 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Feb 2021 17:51:05 EST
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id 77D793ADE;
        Mon,  8 Feb 2021 23:41:17 +0100 (CET)
Received: by meh.true.cz (OpenSMTPD) with ESMTP id f7b814b6;
        Mon, 8 Feb 2021 23:40:59 +0100 (CET)
From:   =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
To:     Tomasz Duszynski <tomasz.duszynski@octakon.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>
Cc:     =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] iio: chemical: scd30: fix Oops due to missing parent device
Date:   Mon,  8 Feb 2021 23:39:47 +0100
Message-Id: <20210208223947.32344-1-ynezz@true.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

My machine Oopsed while testing SCD30 sensor in interrupt driven mode:

 Unable to handle kernel NULL pointer dereference at virtual address 00000188
 pgd = (ptrval)
 [00000188] *pgd=00000000
 Internal error: Oops: 5 [#1] SMP ARM
 Modules linked in:
 CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.4.96+ #473
 Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
 PC is at _raw_spin_lock_irqsave+0x10/0x4c
 LR is at devres_add+0x18/0x38
 ...
 [<8070ecac>] (_raw_spin_lock_irqsave) from [<804916a8>] (devres_add+0x18/0x38)
 [<804916a8>] (devres_add) from [<805ef708>] (devm_iio_trigger_alloc+0x5c/0x7c)
 [<805ef708>] (devm_iio_trigger_alloc) from [<805f0a90>] (scd30_probe+0x1d4/0x3f0)
 [<805f0a90>] (scd30_probe) from [<805f10fc>] (scd30_i2c_probe+0x54/0x64)
 [<805f10fc>] (scd30_i2c_probe) from [<80583390>] (i2c_device_probe+0x150/0x278)
 [<80583390>] (i2c_device_probe) from [<8048e6c0>] (really_probe+0x1f8/0x360)

I've found out, that it's due to missing parent/owner device in iio_dev struct
which then leads to NULL pointer dereference during spinlock while registering
the device resource via devres_add().

Cc: <stable@vger.kernel.org> # v5.9+
Fixes: 64b3d8b1b0f5 ("iio: chemical: scd30: add core driver")
Signed-off-by: Petr Štetiar <ynezz@true.cz>
---
 drivers/iio/chemical/scd30_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/chemical/scd30_core.c b/drivers/iio/chemical/scd30_core.c
index 4d0d798c7cd3..33aa6eb1963d 100644
--- a/drivers/iio/chemical/scd30_core.c
+++ b/drivers/iio/chemical/scd30_core.c
@@ -697,6 +697,7 @@ int scd30_probe(struct device *dev, int irq, const char *name, void *priv,
 
 	dev_set_drvdata(dev, indio_dev);
 
+	indio_dev->dev.parent = dev;
 	indio_dev->info = &scd30_info;
 	indio_dev->name = name;
 	indio_dev->channels = scd30_channels;
