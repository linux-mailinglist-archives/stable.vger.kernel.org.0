Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 609B62ED25C
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729245AbhAGOcM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:32:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:45976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729236AbhAGOcL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:32:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46F5D23380;
        Thu,  7 Jan 2021 14:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610029911;
        bh=NXiBODZDOGHHsvjogMI2/69pXg+hQavbaRF2tkC24qE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y5YQcor0YL9REdcGWmiFjupDNQMHxW8BqaZ+EDKPQejbl2mdIbsL7gZqKqXvsv7PY
         AFNaetW+2gpcbUnEjW9yQg4NE8YnnGfTF+Id1exhc0yCkO/cNc+SyRkyA8bmWIV3iV
         rRoA3RRsvvtvJ2LOkr4tfdFzB/kmcahLt3AI47fU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Stable@vger.kernel.org,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.19 7/8] iio:magnetometer:mag3110: Fix alignment and data leak issues.
Date:   Thu,  7 Jan 2021 15:32:07 +0100
Message-Id: <20210107143048.590038459@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107143047.586006010@linuxfoundation.org>
References: <20210107143047.586006010@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit 89deb1334252ea4a8491d47654811e28b0790364 upstream

One of a class of bugs pointed out by Lars in a recent review.
iio_push_to_buffers_with_timestamp() assumes the buffer used is aligned
to the size of the timestamp (8 bytes).  This is not guaranteed in
this driver which uses an array of smaller elements on the stack.
As Lars also noted this anti pattern can involve a leak of data to
userspace and that indeed can happen here.  We close both issues by
moving to a suitable structure in the iio_priv() data.
This data is allocated with kzalloc() so no data can leak apart from
previous readings.

The explicit alignment of ts is not necessary in this case but
does make the code slightly less fragile so I have included it.

Fixes: 39631b5f9584 ("iio: Add Freescale mag3110 magnetometer driver")
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200920112742.170751-4-jic23@kernel.org
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/magnetometer/mag3110.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/iio/magnetometer/mag3110.c
+++ b/drivers/iio/magnetometer/mag3110.c
@@ -56,6 +56,12 @@ struct mag3110_data {
 	struct mutex lock;
 	u8 ctrl_reg1;
 	int sleep_val;
+	/* Ensure natural alignment of timestamp */
+	struct {
+		__be16 channels[3];
+		u8 temperature;
+		s64 ts __aligned(8);
+	} scan;
 };
 
 static int mag3110_request(struct mag3110_data *data)
@@ -387,10 +393,9 @@ static irqreturn_t mag3110_trigger_handl
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct mag3110_data *data = iio_priv(indio_dev);
-	u8 buffer[16]; /* 3 16-bit channels + 1 byte temp + padding + ts */
 	int ret;
 
-	ret = mag3110_read(data, (__be16 *) buffer);
+	ret = mag3110_read(data, data->scan.channels);
 	if (ret < 0)
 		goto done;
 
@@ -399,10 +404,10 @@ static irqreturn_t mag3110_trigger_handl
 			MAG3110_DIE_TEMP);
 		if (ret < 0)
 			goto done;
-		buffer[6] = ret;
+		data->scan.temperature = ret;
 	}
 
-	iio_push_to_buffers_with_timestamp(indio_dev, buffer,
+	iio_push_to_buffers_with_timestamp(indio_dev, &data->scan,
 		iio_get_time_ns(indio_dev));
 
 done:


