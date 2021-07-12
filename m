Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD1523C477C
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235922AbhGLGc5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:32:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:46224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235858AbhGLG3g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:29:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11257611AF;
        Mon, 12 Jul 2021 06:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071165;
        bh=xougpzLdySV4jand12tnZxdIfNORjh8lOV4mlje6WPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cF5NekA4R/kD7rquDc8E8czUCNG2X0ngDETIJlRXiUb256VUrbOSQYgOBp4WqdfDu
         UFGow8/fWRvRPHVtOPQbXCEbFt8gN4fe0QIgDvdIWsbzNAtUQSh6oMWitghySU9OXu
         EZOBfEMrFo22YipCPZh7ssmrJqQxzgU7LZjDfuoA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 260/348] iio: accel: bma180: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
Date:   Mon, 12 Jul 2021 08:10:44 +0200
Message-Id: <20210712060737.645169845@linuxfoundation.org>
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

[ Upstream commit fc36da3131a747a9367a05caf06de19be1bcc972 ]

To make code more readable, use a structure to express the channel
layout and ensure the timestamp is 8 byte aligned.

Found during an audit of all calls of this function.

Fixes: b9a6a237ffc9 ("iio:bma180: Drop _update_scan_mode()")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Peter Meerwald <pmeerw@pmeerw.net>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20210501170121.512209-2-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/bma180.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/accel/bma180.c b/drivers/iio/accel/bma180.c
index 1574e4604a4f..aa301c606346 100644
--- a/drivers/iio/accel/bma180.c
+++ b/drivers/iio/accel/bma180.c
@@ -119,7 +119,11 @@ struct bma180_data {
 	int scale;
 	int bw;
 	bool pmode;
-	u8 buff[16]; /* 3x 16-bit + 8-bit + padding + timestamp */
+	/* Ensure timestamp is naturally aligned */
+	struct {
+		s16 chan[4];
+		s64 timestamp __aligned(8);
+	} scan;
 };
 
 enum bma180_chan {
@@ -675,12 +679,12 @@ static irqreturn_t bma180_trigger_handler(int irq, void *p)
 			mutex_unlock(&data->mutex);
 			goto err;
 		}
-		((s16 *)data->buff)[i++] = ret;
+		data->scan.chan[i++] = ret;
 	}
 
 	mutex_unlock(&data->mutex);
 
-	iio_push_to_buffers_with_timestamp(indio_dev, data->buff, time_ns);
+	iio_push_to_buffers_with_timestamp(indio_dev, &data->scan, time_ns);
 err:
 	iio_trigger_notify_done(indio_dev->trig);
 
-- 
2.30.2



