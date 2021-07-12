Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9D83C4719
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234348AbhGLGbR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:31:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:46224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235157AbhGLG2Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:28:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3299561004;
        Mon, 12 Jul 2021 06:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071076;
        bh=iOCJ63eUXxFDlQ8FN5hBdPSYIDOOypkaYhYrxvoP5e8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1i+zkRd4Cx4+0IVXlFODJP4Bvqsyfk4Jb5Pa/zI4yjvPTdpXeITcZtMDIXKT7SX08
         FYAa2CCUgEUH4WdEbvnE6gxlUSt6tbRSHiMZKURAK1xLJ4ftshz9w3gbXLlAF/RsQG
         jPy1TrlC2AexUNatHssYxF9ZDQt9jpWtw1A1C1Fw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 265/348] iio: accel: mxc4005: Fix overread of data and alignment issue.
Date:   Mon, 12 Jul 2021 08:10:49 +0200
Message-Id: <20210712060738.532620700@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit f65802284a3a337510d7f8f916c97d66c74f2e71 ]

The bulk read size is based on the size of an array that also has
space for the timestamp alongside the channels.
Fix that and also fix alignment of the buffer passed
to iio_push_to_buffers_with_timestamp.

Found during an audit of all calls to this function.

Fixes: 1ce0eda0f757 ("iio: mxc4005: add triggered buffer mode for mxc4005")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20210501170121.512209-6-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/mxc4005.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/accel/mxc4005.c b/drivers/iio/accel/mxc4005.c
index 9d07642c0de1..d81b02642a0b 100644
--- a/drivers/iio/accel/mxc4005.c
+++ b/drivers/iio/accel/mxc4005.c
@@ -56,7 +56,11 @@ struct mxc4005_data {
 	struct mutex mutex;
 	struct regmap *regmap;
 	struct iio_trigger *dready_trig;
-	__be16 buffer[8];
+	/* Ensure timestamp is naturally aligned */
+	struct {
+		__be16 chans[3];
+		s64 timestamp __aligned(8);
+	} scan;
 	bool trigger_enabled;
 };
 
@@ -135,7 +139,7 @@ static int mxc4005_read_xyz(struct mxc4005_data *data)
 	int ret;
 
 	ret = regmap_bulk_read(data->regmap, MXC4005_REG_XOUT_UPPER,
-			       data->buffer, sizeof(data->buffer));
+			       data->scan.chans, sizeof(data->scan.chans));
 	if (ret < 0) {
 		dev_err(data->dev, "failed to read axes\n");
 		return ret;
@@ -301,7 +305,7 @@ static irqreturn_t mxc4005_trigger_handler(int irq, void *private)
 	if (ret < 0)
 		goto err;
 
-	iio_push_to_buffers_with_timestamp(indio_dev, data->buffer,
+	iio_push_to_buffers_with_timestamp(indio_dev, &data->scan,
 					   pf->timestamp);
 
 err:
-- 
2.30.2



