Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3896722698E
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387994AbgGTQ1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:27:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:60628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732287AbgGTP7n (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:59:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D5F822BEF;
        Mon, 20 Jul 2020 15:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260783;
        bh=OrUqV8JJjkoxK8FuCM07uleGXeKVco3gz7e0rfHRBo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0L3YDBptN8h1RGID9SxAOYrhicAsc9OUFIlqETxLVyvkR/QI+vMYnDl0HpahfxlPW
         MxmgckBE/Y5jFXVcHJpoQB6HpQS5cofl/MyTIdl5S5qwCxJPKQCwO2uqHAnboP0TRa
         jwTaIasCMYaZEaybs7CppkGB1xSlSIytXVqIFqbg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        "Andrew F. Davis" <afd@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 093/215] iio:health:afe4404 Fix timestamp alignment and prevent data leak.
Date:   Mon, 20 Jul 2020 17:36:15 +0200
Message-Id: <20200720152824.632533390@linuxfoundation.org>
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

[ Upstream commit f88ecccac4be348bbcc6d056bdbc622a8955c04d ]

One of a class of bugs pointed out by Lars in a recent review.
iio_push_to_buffers_with_timestamp assumes the buffer used is aligned
to the size of the timestamp (8 bytes).  This is not guaranteed in
this driver which uses a 40 byte array of smaller elements on the stack.
As Lars also noted this anti pattern can involve a leak of data to
userspace and that indeed can happen here.  We close both issues by
moving to a suitable structure in the iio_priv() data with alignment
explicitly requested.  This data is allocated with kzalloc so no
data can leak appart from previous readings.

Fixes: 87aec56e27ef ("iio: health: Add driver for the TI AFE4404 heart monitor")
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Andrew F. Davis <afd@ti.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/health/afe4404.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/health/afe4404.c b/drivers/iio/health/afe4404.c
index e728bbb21ca88..cebb1fd4d0b15 100644
--- a/drivers/iio/health/afe4404.c
+++ b/drivers/iio/health/afe4404.c
@@ -83,6 +83,7 @@ static const struct reg_field afe4404_reg_fields[] = {
  * @regulator: Pointer to the regulator for the IC
  * @trig: IIO trigger for this device
  * @irq: ADC_RDY line interrupt number
+ * @buffer: Used to construct a scan to push to the iio buffer.
  */
 struct afe4404_data {
 	struct device *dev;
@@ -91,6 +92,7 @@ struct afe4404_data {
 	struct regulator *regulator;
 	struct iio_trigger *trig;
 	int irq;
+	s32 buffer[10] __aligned(8);
 };
 
 enum afe4404_chan_id {
@@ -328,17 +330,17 @@ static irqreturn_t afe4404_trigger_handler(int irq, void *private)
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct afe4404_data *afe = iio_priv(indio_dev);
 	int ret, bit, i = 0;
-	s32 buffer[10];
 
 	for_each_set_bit(bit, indio_dev->active_scan_mask,
 			 indio_dev->masklength) {
 		ret = regmap_read(afe->regmap, afe4404_channel_values[bit],
-				  &buffer[i++]);
+				  &afe->buffer[i++]);
 		if (ret)
 			goto err;
 	}
 
-	iio_push_to_buffers_with_timestamp(indio_dev, buffer, pf->timestamp);
+	iio_push_to_buffers_with_timestamp(indio_dev, afe->buffer,
+					   pf->timestamp);
 err:
 	iio_trigger_notify_done(indio_dev->trig);
 
-- 
2.25.1



