Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41B4C452152
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346509AbhKPBDQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:03:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:44634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245591AbhKOTUs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C23CD63570;
        Mon, 15 Nov 2021 18:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001460;
        bh=HW6nPutcWlloH/E9S97N7iUJ55IMUk7U5UMFPTKBaOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c+rDbhYCWLvmJsMRyDpCVKuYUfZaCcK13GvNPCk2bCtrc1msOVNsigdj19AXZdLGE
         l1hNw7+oMF+WoWUCEQ3w0NlNrzCghkdl3Hm3JmyfcAscbZ+Jh/7/OBYXXk6Dwoqjk7
         esQi5f/GnikduE2VTcLmGY0ZphlCZK6RSVVoQtTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mihail Chindris <mihail.chindris@analog.com>,
        Alexandru Ardelean <ardeleanalex@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 167/917] drivers: iio: dac: ad5766: Fix dt property name
Date:   Mon, 15 Nov 2021 17:54:22 +0100
Message-Id: <20211115165434.430028278@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mihail Chindris <mihail.chindris@analog.com>

commit d9de0fbdeb0103a204055efb69cb5cc8f5f12a6a upstream.

In the documentation the name for the property is
output-range-microvolts which is a standard name, therefore this name
must be used.

Fixes: fd9373e41b9ba ("iio: dac: ad5766: add driver support for AD5766")
Signed-off-by: Mihail Chindris <mihail.chindris@analog.com>
Reviewed-by: Alexandru Ardelean <ardeleanalex@gmail.com>
Link: https://lore.kernel.org/r/20211007080035.2531-5-mihail.chindris@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/ad5766.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/iio/dac/ad5766.c
+++ b/drivers/iio/dac/ad5766.c
@@ -503,13 +503,13 @@ static int ad5766_get_output_range(struc
 	int i, ret, min, max, tmp[2];
 
 	ret = device_property_read_u32_array(&st->spi->dev,
-					     "output-range-voltage",
+					     "output-range-microvolts",
 					     tmp, 2);
 	if (ret)
 		return ret;
 
-	min = tmp[0] / 1000;
-	max = tmp[1] / 1000;
+	min = tmp[0] / 1000000;
+	max = tmp[1] / 1000000;
 	for (i = 0; i < ARRAY_SIZE(ad5766_span_tbl); i++) {
 		if (ad5766_span_tbl[i].min != min ||
 		    ad5766_span_tbl[i].max != max)


