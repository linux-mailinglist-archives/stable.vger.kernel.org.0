Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3FB92E67D6
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633596AbgL1Q30 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:29:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:34940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730697AbgL1NHM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:07:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6601B206ED;
        Mon, 28 Dec 2020 13:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160792;
        bh=U/rmShT16J06mM0R42BKT9PDN+UC8RCxGEEbHBvPTYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yCi+N6lTd85IRVYYfm1VnMS/kiPEH/tB8D+f1RoE5Qw0o2vu2nbk3Gu4Xw+kIx7e4
         hDSP5iVQLa4IYeY+AQIBYMB82KFXalUGKbJmCz2iNNGBWGfyTUUm3Is3+5PGQryi5J
         v8ETHDwdk9Wrn2Kunk+d2iRQfbuOFnQa3kzjZmtM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Peter Meerwald <pmeerw@pmeerw.net>, Stable@vger.kernel.org
Subject: [PATCH 4.9 172/175] iio:pressure:mpl3115: Force alignment of buffer
Date:   Mon, 28 Dec 2020 13:50:25 +0100
Message-Id: <20201228124901.562817115@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit 198cf32f0503d2ad60d320b95ef6fb8243db857f upstream.

Whilst this is another case of the issue Lars reported with
an array of elements of smaller than 8 bytes being passed
to iio_push_to_buffers_with_timestamp(), the solution here is
a bit different from the other cases and relies on __aligned
working on the stack (true since 4.6?)

This one is unusual.  We have to do an explicit memset() each time
as we are reading 3 bytes into a potential 4 byte channel which
may sometimes be a 2 byte channel depending on what is enabled.
As such, moving the buffer to the heap in the iio_priv structure
doesn't save us much.  We can't use a nice explicit structure
on the stack either as the data channels have different storage
sizes and are all separately controlled.

Fixes: cc26ad455f57 ("iio: Add Freescale MPL3115A2 pressure / temperature sensor driver")
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc: Peter Meerwald <pmeerw@pmeerw.net>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200920112742.170751-7-jic23@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/pressure/mpl3115.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/iio/pressure/mpl3115.c
+++ b/drivers/iio/pressure/mpl3115.c
@@ -139,7 +139,14 @@ static irqreturn_t mpl3115_trigger_handl
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct mpl3115_data *data = iio_priv(indio_dev);
-	u8 buffer[16]; /* 32-bit channel + 16-bit channel + padding + ts */
+	/*
+	 * 32-bit channel + 16-bit channel + padding + ts
+	 * Note that it is possible for only one of the first 2
+	 * channels to be enabled. If that happens, the first element
+	 * of the buffer may be either 16 or 32-bits.  As such we cannot
+	 * use a simple structure definition to express this data layout.
+	 */
+	u8 buffer[16] __aligned(8);
 	int ret, pos = 0;
 
 	mutex_lock(&data->lock);


