Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A464C2E3F08
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504827AbgL1Ocw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:32:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:40806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504825AbgL1Ocv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:32:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12A682242A;
        Mon, 28 Dec 2020 14:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165930;
        bh=Obl9+OB4r785Gas4K/VY2GM9eBdcvFh1TwPDckgHm+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yBP92gOInYiDxXN0P+0pLNQaTBnEsX9+jzdrZ5elcDFPs2PX/pLjBCbmtFytnHUWI
         3o+0g2ll2HATa7+IcWSpPmkIzc/3kKV4KHk+IrzRPDPZOxpOS7RGvyuIEsPl7S91na
         Ws24elJ/KaGHmJAc5teWgsogsKoGkbVfetAtgTMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, Stable@vger.kernel.org
Subject: [PATCH 5.10 678/717] iio:light:st_uvis25: Fix timestamp alignment and prevent data leak.
Date:   Mon, 28 Dec 2020 13:51:16 +0100
Message-Id: <20201228125053.469965466@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit d837a996f57c29a985177bc03b0e599082047f27 upstream.

One of a class of bugs pointed out by Lars in a recent review.
iio_push_to_buffers_with_timestamp() assumes the buffer used is aligned
to the size of the timestamp (8 bytes).  This is not guaranteed in
this driver which uses an array of smaller elements on the stack.
As Lars also noted this anti pattern can involve a leak of data to
userspace and that indeed can happen here.  We close both issues by
moving to a suitable structure in the iio_priv()

This data is allocated with kzalloc() so no data can leak apart
from previous readings.

A local unsigned int variable is used for the regmap call so it
is clear there is no potential issue with writing into the padding
of the structure.

Fixes: 3025c8688c1e ("iio: light: add support for UVIS25 sensor")
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200920112742.170751-3-jic23@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/light/st_uvis25.h      |    5 +++++
 drivers/iio/light/st_uvis25_core.c |    8 +++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/iio/light/st_uvis25.h
+++ b/drivers/iio/light/st_uvis25.h
@@ -27,6 +27,11 @@ struct st_uvis25_hw {
 	struct iio_trigger *trig;
 	bool enabled;
 	int irq;
+	/* Ensure timestamp is naturally aligned */
+	struct {
+		u8 chan;
+		s64 ts __aligned(8);
+	} scan;
 };
 
 extern const struct dev_pm_ops st_uvis25_pm_ops;
--- a/drivers/iio/light/st_uvis25_core.c
+++ b/drivers/iio/light/st_uvis25_core.c
@@ -232,17 +232,19 @@ static const struct iio_buffer_setup_ops
 
 static irqreturn_t st_uvis25_buffer_handler_thread(int irq, void *p)
 {
-	u8 buffer[ALIGN(sizeof(u8), sizeof(s64)) + sizeof(s64)];
 	struct iio_poll_func *pf = p;
 	struct iio_dev *iio_dev = pf->indio_dev;
 	struct st_uvis25_hw *hw = iio_priv(iio_dev);
+	unsigned int val;
 	int err;
 
-	err = regmap_read(hw->regmap, ST_UVIS25_REG_OUT_ADDR, (int *)buffer);
+	err = regmap_read(hw->regmap, ST_UVIS25_REG_OUT_ADDR, &val);
 	if (err < 0)
 		goto out;
 
-	iio_push_to_buffers_with_timestamp(iio_dev, buffer,
+	hw->scan.chan = val;
+
+	iio_push_to_buffers_with_timestamp(iio_dev, &hw->scan,
 					   iio_get_time_ns(iio_dev));
 
 out:


