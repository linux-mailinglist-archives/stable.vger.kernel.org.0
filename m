Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB6713C4F29
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241580AbhGLHXX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:23:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:59546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344909AbhGLHVd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:21:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4529660FF1;
        Mon, 12 Jul 2021 07:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074325;
        bh=e/KKfcWa+CIdZ83CTH8/LMGfbSFDCGfD8TBqyrOQMtM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VdRElPuuQBKARbeG1U0Ah23hsdB+4vre0og5XSZ39ybgr/7/jhfyiPHv1f7TMz4wE
         czvV0JQId+wrV3iDn2hmlxo25ecJHvu7mWdkVsv0IAqdqKKuVn30clheeKxLwab9qh
         bBo8eu2afikwTNhMhQZPPlMSx3PnrlLxSxsWMTYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andreas Klinger <ak@it-klinger.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 543/700] iio: prox: srf08: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
Date:   Mon, 12 Jul 2021 08:10:26 +0200
Message-Id: <20210712061034.112651345@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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
index 70beac5c9c1d..9b0886760f76 100644
--- a/drivers/iio/proximity/srf08.c
+++ b/drivers/iio/proximity/srf08.c
@@ -63,11 +63,11 @@ struct srf08_data {
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
@@ -190,9 +190,9 @@ static irqreturn_t srf08_trigger_handler(int irq, void *p)
 
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



