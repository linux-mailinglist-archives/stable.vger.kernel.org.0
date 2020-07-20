Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6652269F0
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732684AbgGTQat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:30:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730562AbgGTP5y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:57:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D60622CAF;
        Mon, 20 Jul 2020 15:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260673;
        bh=1H5+7kJO9eaqpbN5JgnI5mNMkNUZHr0WnC6h16aXQEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jEQ/lHdiIhVJCF/1YQjwx9oG0JIBMjpzzjat7V9/pYukZjj4/bc3M3FBi9/CA8Crc
         H9HlKvmWHes1dqob8Xna+mmey2EIknBXQDQ7vx/fYAFjhgaHEtREaLQCJDMbGSrSRd
         ze5oyXQcA6YZjmL3fc1bpAL8+0MrOgVd83whKNK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Tomasz Duszynski <tomasz.duszynski@octakon.com>,
        Stable@vger.kernel.org
Subject: [PATCH 5.4 053/215] iio:pressure:ms5611 Fix buffer element alignment
Date:   Mon, 20 Jul 2020 17:35:35 +0200
Message-Id: <20200720152822.732782291@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit 8db4afe163bbdd93dca6fcefbb831ef12ecc6b4d upstream.

One of a class of bugs pointed out by Lars in a recent review.
iio_push_to_buffers_with_timestamp assumes the buffer used is aligned
to the size of the timestamp (8 bytes).  This is not guaranteed in
this driver which uses an array of smaller elements on the stack.
Here there is no data leak possibility so use an explicit structure
on the stack to ensure alignment and nice readable fashion.

The forced alignment of ts isn't strictly necessary in this driver
as the padding will be correct anyway (there isn't any).  However
it is probably less fragile to have it there and it acts as
documentation of the requirement.

Fixes: 713bbb4efb9dc ("iio: pressure: ms5611: Add triggered buffer support")
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Tomasz Duszynski <tomasz.duszynski@octakon.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/pressure/ms5611_core.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/iio/pressure/ms5611_core.c
+++ b/drivers/iio/pressure/ms5611_core.c
@@ -212,16 +212,21 @@ static irqreturn_t ms5611_trigger_handle
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct ms5611_state *st = iio_priv(indio_dev);
-	s32 buf[4]; /* s32 (pressure) + s32 (temp) + 2 * s32 (timestamp) */
+	/* Ensure buffer elements are naturally aligned */
+	struct {
+		s32 channels[2];
+		s64 ts __aligned(8);
+	} scan;
 	int ret;
 
 	mutex_lock(&st->lock);
-	ret = ms5611_read_temp_and_pressure(indio_dev, &buf[1], &buf[0]);
+	ret = ms5611_read_temp_and_pressure(indio_dev, &scan.channels[1],
+					    &scan.channels[0]);
 	mutex_unlock(&st->lock);
 	if (ret < 0)
 		goto err;
 
-	iio_push_to_buffers_with_timestamp(indio_dev, buf,
+	iio_push_to_buffers_with_timestamp(indio_dev, &scan,
 					   iio_get_time_ns(indio_dev));
 
 err:


