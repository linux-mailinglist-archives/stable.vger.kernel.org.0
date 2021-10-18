Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF1E431C0C
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232922AbhJRNhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:37:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:54296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232224AbhJRNfp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:35:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4C3B613AD;
        Mon, 18 Oct 2021 13:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563852;
        bh=SySqrQ+lfqHHssJ5qAd4vWhK4QkCQgUagnZ1BBmiY84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j/jUHKRxiNBh7BSYp5gn8Tw6dK5dHnzGDmSjtoBIfzSdCgszaP6Z5VGPdd3XhcgfD
         FBQdsxyD1f03g2u6vwq68T1hwwWzF+eZJC1dnKMnnFgncfI+BFmcCNW+/zEQNuLPCc
         5cxAnJp5N4boo962uov7x5stypTJ+APHB3ffSv14=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Alexandru Ardelean <ardeleanalex@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 39/69] iio: adc128s052: Fix the error handling path of adc128_probe()
Date:   Mon, 18 Oct 2021 15:24:37 +0200
Message-Id: <20211018132330.770101397@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132329.453964125@linuxfoundation.org>
References: <20211018132329.453964125@linuxfoundation.org>
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
@@ -172,7 +172,13 @@ static int adc128_probe(struct spi_devic
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
 


