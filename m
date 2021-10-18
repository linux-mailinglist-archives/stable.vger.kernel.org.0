Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 978B6431E54
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234409AbhJROAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:00:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:59060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234569AbhJRN6Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:58:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24A0461A3A;
        Mon, 18 Oct 2021 13:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564481;
        bh=UPo2vUMpgPMX4CcfMB7wLs5NFHOo5Db/er6Z7OtjNDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PGOfY7BOAcA+SP/X2Zofx6y43Y3jTRMJYsSuHioQNCe92OU+eAm98TBm+fGxxreLk
         yfU7BvScV7P0JuX1u1vTSWwHd3B8FMZ7DbZ1ZK/lXNefZuPpmnvya9B15Hgzs2kRG1
         gY2mZ2kEzZXajk4O5xqQq9DzBx4+iuIevINr7VXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Alexandru Ardelean <ardeleanalex@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.14 072/151] iio: adc128s052: Fix the error handling path of adc128_probe()
Date:   Mon, 18 Oct 2021 15:24:11 +0200
Message-Id: <20211018132343.024116132@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit bbcf40816b547b3c37af49168950491d20d81ce1 upstream.

A successful 'regulator_enable()' call should be balanced by a
corresponding 'regulator_disable()' call in the error handling path of the
probe, as already done in the remove function.

Update the error handling path accordingly.

Fixes: 913b86468674 ("iio: adc: Add TI ADC128S052")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Alexandru Ardelean <ardeleanalex@gmail.com>
Link: https://lore.kernel.org/r/85189f1cfcf6f5f7b42d8730966f2a074b07b5f5.1629542160.git.christophe.jaillet@wanadoo.fr
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ti-adc128s052.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/iio/adc/ti-adc128s052.c
+++ b/drivers/iio/adc/ti-adc128s052.c
@@ -171,7 +171,13 @@ static int adc128_probe(struct spi_devic
 	mutex_init(&adc->lock);
 
 	ret = iio_device_register(indio_dev);
+	if (ret)
+		goto err_disable_regulator;
 
+	return 0;
+
+err_disable_regulator:
+	regulator_disable(adc->reg);
 	return ret;
 }
 


