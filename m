Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0BA431BB3
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232939AbhJRNeS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:34:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:41884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232645AbhJRNc2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:32:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B8AC6137C;
        Mon, 18 Oct 2021 13:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563761;
        bh=FtHYWU8uoNMGOPVzqaJt1WELjfnqZATizaoH4Hwrzac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GBfqpaoNFA6Hp4majXyLsOyDO7AdR0CCHLkkm5xKx6Sr4dvW0/zbmYlJy+zbCC+dP
         9eNiiHUVyaLoMmsgLi72YDTfwHO41HDwK+12aVJbm287JBTYPbpCde9NRKlKMzyJik
         etC7+A3nhBnkVC90HtAhSHaSKtEUs8PnVKaaXlpo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Alexandru Ardelean <ardeleanalex@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.19 28/50] iio: adc128s052: Fix the error handling path of adc128_probe()
Date:   Mon, 18 Oct 2021 15:24:35 +0200
Message-Id: <20211018132327.472943996@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132326.529486647@linuxfoundation.org>
References: <20211018132326.529486647@linuxfoundation.org>
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
@@ -168,7 +168,13 @@ static int adc128_probe(struct spi_devic
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
 


