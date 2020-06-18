Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFEBF1FDFD8
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731109AbgFRBnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:43:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:38038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732210AbgFRB3A (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:29:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B2082220A;
        Thu, 18 Jun 2020 01:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443739;
        bh=CryLUDvGXkgUR5k66ISKOBbT+s4DXfJg1hJXZ1rf0sI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vls+pd1fe4dyEzY7CSXPK7j9FGhYOmWhQfAMW0/evGOK14cCwxeHdqrGxX63SrIFc
         D3AVXbo+RtVaPaTThyw1xxxIzw1ujF6ZQ5MrddmaNrl1AxVsYl18CM2JnxwCWfYEC7
         ZS2VGpfTywbH79vq5qZ+1EDaZXQcEP2xx+FTIg2k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lars-Peter Clausen <lars@metafoo.de>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 30/80] iio: buffer: Don't allow buffers without any channels enabled to be activated
Date:   Wed, 17 Jun 2020 21:27:29 -0400
Message-Id: <20200618012819.609778-30-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012819.609778-1-sashal@kernel.org>
References: <20200618012819.609778-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>

[ Upstream commit b7329249ea5b08b2a1c2c3f24a2f4c495c4f14b8 ]

Before activating a buffer make sure that at least one channel is enabled.
Activating a buffer with 0 channels enabled doesn't make too much sense and
disallowing this case makes sure that individual driver don't have to add
special case code to handle it.

Currently, without this patch enabling a buffer is possible and no error is
produced. With this patch -EINVAL is returned.

An example of execution with this patch and some instrumented print-code:
   root@analog:~# cd /sys/bus/iio/devices/iio\:device3/buffer
   root@analog:/sys/bus/iio/devices/iio:device3/buffer# echo 1 > enable
   0: iio_verify_update 748 indio_dev->masklength 2 *insert_buffer->scan_mask 00000000
   1: iio_verify_update 753
   2:__iio_update_buffers 1115 ret -22
   3: iio_buffer_store_enable 1241 ret -22
   -bash: echo: write error: Invalid argument
1, 2 & 3 are exit-error paths. 0 the first print in iio_verify_update()
rergardless of error path.

Without this patch (and same instrumented print-code):
   root@analog:~# cd /sys/bus/iio/devices/iio\:device3/buffer
   root@analog:/sys/bus/iio/devices/iio:device3/buffer# echo 1 > enable
   0: iio_verify_update 748 indio_dev->masklength 2 *insert_buffer->scan_mask 00000000
   root@analog:/sys/bus/iio/devices/iio:device3/buffer#
Buffer is enabled with no error.

Note from Jonathan: Probably not suitable for automatic application to stable.
This has been there from the very start.  It tidies up an odd corner
case but won't effect any 'real' users.

Fixes: 84b36ce5f79c0 ("staging:iio: Add support for multiple buffers")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/industrialio-buffer.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-buffer.c
index 2f037cd59d53..2b680e65b4dd 100644
--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -667,6 +667,13 @@ static int iio_verify_update(struct iio_dev *indio_dev,
 	bool scan_timestamp;
 	unsigned int modes;
 
+	if (insert_buffer &&
+	    bitmap_empty(insert_buffer->scan_mask, indio_dev->masklength)) {
+		dev_dbg(&indio_dev->dev,
+			"At least one scan element must be enabled first\n");
+		return -EINVAL;
+	}
+
 	memset(config, 0, sizeof(*config));
 	config->watermark = ~0;
 
-- 
2.25.1

