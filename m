Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E8537CAED
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235139AbhELQc4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:32:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241289AbhELQ07 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:26:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B10461624;
        Wed, 12 May 2021 15:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834684;
        bh=wxD8AFbGpoOfeXevNcUMJoCvT6v6q1kwq9vR7kQkreE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=andAGdTS5k5yzq+qw7W3wcUkG7EKmhrllp1H/zdMkPPgh3hyCsBGk9VT3xzQ8+Uz/
         pAQGyQN+7ntHrI/3/Uhc3KZqIIwUs024TORGUOA1T5ddtjsxQVrgh78M3VTgBcM1Z3
         oiHLxWlKVYNS7gxKdb+wV7Z5D5QXMKe3qSTNefFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Alexandru Ardelean <ardeleanalex@gmail.com>,
        Stable@vger.kernel.org
Subject: [PATCH 5.12 043/677] iio:adc:ad7476: Fix remove handling
Date:   Wed, 12 May 2021 16:41:29 +0200
Message-Id: <20210512144838.637566867@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit 6baee4bd63f5fdf1716f88e95c21a683e94fe30d upstream.

This driver was in an odd half way state between devm based cleanup
and manual cleanup (most of which was missing).
I would guess something went wrong with a rebase or similar.
Anyhow, this basically finishes the job as a precursor to improving
the regulator handling.

Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Fixes: 4bb2b8f94ace3 ("iio: adc: ad7476: implement devm_add_action_or_reset")
Cc: Michael Hennerich <michael.hennerich@analog.com>
Reviewed-by: Alexandru Ardelean <ardeleanalex@gmail.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210401171759.318140-2-jic23@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7476.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

--- a/drivers/iio/adc/ad7476.c
+++ b/drivers/iio/adc/ad7476.c
@@ -321,25 +321,15 @@ static int ad7476_probe(struct spi_devic
 	spi_message_init(&st->msg);
 	spi_message_add_tail(&st->xfer, &st->msg);
 
-	ret = iio_triggered_buffer_setup(indio_dev, NULL,
-			&ad7476_trigger_handler, NULL);
+	ret = devm_iio_triggered_buffer_setup(&spi->dev, indio_dev, NULL,
+					      &ad7476_trigger_handler, NULL);
 	if (ret)
-		goto error_disable_reg;
+		return ret;
 
 	if (st->chip_info->reset)
 		st->chip_info->reset(st);
 
-	ret = iio_device_register(indio_dev);
-	if (ret)
-		goto error_ring_unregister;
-	return 0;
-
-error_ring_unregister:
-	iio_triggered_buffer_cleanup(indio_dev);
-error_disable_reg:
-	regulator_disable(st->reg);
-
-	return ret;
+	return devm_iio_device_register(&spi->dev, indio_dev);
 }
 
 static const struct spi_device_id ad7476_id[] = {


