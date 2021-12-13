Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 968B04726AC
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237065AbhLMJxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:53:53 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37964 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234969AbhLMJvd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:51:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B4E6B80E0B;
        Mon, 13 Dec 2021 09:51:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3816FC341C8;
        Mon, 13 Dec 2021 09:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389090;
        bh=9FdpmkzTWuaFh15PEjKrURtIJNq4boE8px8lf9ZVNtU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nW2TAT46vwqfg5rKZq3H9pQHhrn5GdTMqyK1/ZruJx+HkE6lMJ37u4lX/DyeE2o5n
         mhy56yuEmwzycT/GsFDL6mlVMa7AklfiSuyKFzzytA4wADA5rw0Z8Bki0TXB6GeBMq
         tWTmwzXQ8euLthvgG5r2kI4VAF73NT3gavKUnsMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 113/132] iio: itg3200: Call iio_trigger_notify_done() on error
Date:   Mon, 13 Dec 2021 10:30:54 +0100
Message-Id: <20211213092942.976649820@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>

commit 67fe29583e72b2103abb661bb58036e3c1f00277 upstream.

IIO trigger handlers must call iio_trigger_notify_done() when done. This
must be done even when an error occurred. Otherwise the trigger will be
seen as busy indefinitely and the trigger handler will never be called
again.

The itg3200 driver neglects to call iio_trigger_notify_done() when there is
an error reading the gyro data. Fix this by making sure that
iio_trigger_notify_done() is included in the error exit path.

Fixes: 9dbf091da080 ("iio: gyro: Add itg3200")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Link: https://lore.kernel.org/r/20211101144055.13858-1-lars@metafoo.de
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/gyro/itg3200_buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/gyro/itg3200_buffer.c
+++ b/drivers/iio/gyro/itg3200_buffer.c
@@ -61,9 +61,9 @@ static irqreturn_t itg3200_trigger_handl
 
 	iio_push_to_buffers_with_timestamp(indio_dev, &scan, pf->timestamp);
 
+error_ret:
 	iio_trigger_notify_done(indio_dev->trig);
 
-error_ret:
 	return IRQ_HANDLED;
 }
 


