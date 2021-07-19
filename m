Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E82D03CDB26
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244851AbhGSOl0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:41:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343738AbhGSOjn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:39:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BB2C61249;
        Mon, 19 Jul 2021 15:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707978;
        bh=zD4Wf14Ui7EbW8wYCW5BlyIC1U2GZrGZijH2h5s/Jtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h5aB2XqsWkXMAsOBMOT9HaJTzG1b6W/1ZWNZhRuvT5g0rPtSyAH/CJziK4ZuTIntZ
         Gif15oGursmK0d+J39IPdZuIqf1Aoasq3+xRUdGALCnF5KEHYj2nkKLjmFXs6bIoSv
         0GQY1A2Mr5HZSYbjw5LC278yeoKNAcR7qsJIErR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andreas Klinger <ak@it-klinger.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 131/315] iio: prox: srf08: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
Date:   Mon, 19 Jul 2021 16:50:20 +0200
Message-Id: <20210719144947.190525278@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 19f1a254fe4949fff1e67db386409f48cf438bd7 ]

To make code more readable, use a structure to express the channel
layout and ensure the timestamp is 8 byte aligned.

Found during an audit of all calls of uses of
iio_push_to_buffers_with_timestamp()

Fixes: 78f839029e1d ("iio: distance: srf08: add IIO driver for us ranger")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Andreas Klinger <ak@it-klinger.de>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20210501170121.512209-13-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/proximity/srf08.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/iio/proximity/srf08.c b/drivers/iio/proximity/srf08.c
index 9380d545aab1..d36f634a22d6 100644
--- a/drivers/iio/proximity/srf08.c
+++ b/drivers/iio/proximity/srf08.c
@@ -66,11 +66,11 @@ struct srf08_data {
 	int			range_mm;
 	struct mutex		lock;
 
-	/*
-	 * triggered buffer
-	 * 1x16-bit channel + 3x16 padding + 4x16 timestamp
-	 */
-	s16			buffer[8];
+	/* Ensure timestamp is naturally aligned */
+	struct {
+		s16 chan;
+		s64 timestamp __aligned(8);
+	} scan;
 
 	/* Sensor-Type */
 	enum srf08_sensor_type	sensor_type;
@@ -193,9 +193,9 @@ static irqreturn_t srf08_trigger_handler(int irq, void *p)
 
 	mutex_lock(&data->lock);
 
-	data->buffer[0] = sensor_data;
+	data->scan.chan = sensor_data;
 	iio_push_to_buffers_with_timestamp(indio_dev,
-						data->buffer, pf->timestamp);
+					   &data->scan, pf->timestamp);
 
 	mutex_unlock(&data->lock);
 err:
-- 
2.30.2



