Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A50101216F0
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730504AbfLPSJu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:09:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:52472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730500AbfLPSJt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:09:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8518120700;
        Mon, 16 Dec 2019 18:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519789;
        bh=7lH2J8jbJLx5db/U3NXg0SHa+gy/pg/2nY0NAcJSs5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ImhPIFTm+kze106Up4R4Yjvs4lH99rL8R+XyoQO1ShWMTUKPJmybg/QlkrhuHa2I8
         ziEr2FEt6UEdNZwmwMgoVibqEWCvGCr/wpBx7XTv+Bt0jG1UwESkx5VgObSC6Yq4R4
         2vonsGD0DfcFvyTUU8zd0F4uZb9Ql7PmoOgS/NZk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Robert=20W=C3=B6rle?= <rwoerle@mibtec.de>,
        Beniamin Bia <beniamin.bia@analog.com>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.3 032/180] iio: adc: ad7606: fix reading unnecessary data from device
Date:   Mon, 16 Dec 2019 18:47:52 +0100
Message-Id: <20191216174813.559785560@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Beniamin Bia <beniamin.bia@analog.com>

commit 341826a065660d1b77d89e6335b6095cd654271c upstream.

When a conversion result is being read from ADC, the driver reads the
number of channels + 1 because it thinks that IIO_CHAN_SOFT_TIMESTAMP
is also a physical channel. This patch fixes this issue.

Fixes: 2985a5d88455 ("staging: iio: adc: ad7606: Move out of staging")
Reported-by: Robert Wörle <rwoerle@mibtec.de>
Signed-off-by: Beniamin Bia <beniamin.bia@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/ad7606.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/ad7606.c
+++ b/drivers/iio/adc/ad7606.c
@@ -57,7 +57,7 @@ static int ad7606_reset(struct ad7606_st
 
 static int ad7606_read_samples(struct ad7606_state *st)
 {
-	unsigned int num = st->chip_info->num_channels;
+	unsigned int num = st->chip_info->num_channels - 1;
 	u16 *data = st->data;
 	int ret;
 


