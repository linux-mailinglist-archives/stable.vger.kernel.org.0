Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C236A12C805
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731802AbfL2RuL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:50:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:34306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731792AbfL2RuH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:50:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6966A21744;
        Sun, 29 Dec 2019 17:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641806;
        bh=LmHqfFxiheRtiU4eLA/bg/3osjTRGv2BZcCh/NmvOto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mOE9gJ3kwIOJ+b8zohGUmJCwCRU3CkqJuq8pPZsRLOWZEF0XFc2DXq+lsEoPkCu3Y
         OlRsuJOV4HZmlmujY/bz/8HVCm5NVvuu15V4LHfMePETKP9ioqHjM3D1yYom6VaPmx
         0e0pRftWy5uIA8XmgC+fh9VubCDw8EvPuUdSwJQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 218/434] iio: dln2-adc: fix iio_triggered_buffer_postenable() position
Date:   Sun, 29 Dec 2019 18:24:31 +0100
Message-Id: <20191229172716.317844159@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandru Ardelean <alexandru.ardelean@analog.com>

[ Upstream commit a7bddfe2dfce1d8859422124abe1964e0ecd386e ]

The iio_triggered_buffer_postenable() hook should be called first to
attach the poll function. The iio_triggered_buffer_predisable() hook is
called last (as is it should).

This change moves iio_triggered_buffer_postenable() to be called first. It
adds iio_triggered_buffer_predisable() on the error paths of the postenable
hook.
For the predisable hook, some code-paths have been changed to make sure
that the iio_triggered_buffer_predisable() hook gets called in case there
is an error before it.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/dln2-adc.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/iio/adc/dln2-adc.c b/drivers/iio/adc/dln2-adc.c
index 5fa78c273a25..65c7c9329b1c 100644
--- a/drivers/iio/adc/dln2-adc.c
+++ b/drivers/iio/adc/dln2-adc.c
@@ -524,6 +524,10 @@ static int dln2_adc_triggered_buffer_postenable(struct iio_dev *indio_dev)
 	u16 conflict;
 	unsigned int trigger_chan;
 
+	ret = iio_triggered_buffer_postenable(indio_dev);
+	if (ret)
+		return ret;
+
 	mutex_lock(&dln2->mutex);
 
 	/* Enable ADC */
@@ -537,6 +541,7 @@ static int dln2_adc_triggered_buffer_postenable(struct iio_dev *indio_dev)
 				(int)conflict);
 			ret = -EBUSY;
 		}
+		iio_triggered_buffer_predisable(indio_dev);
 		return ret;
 	}
 
@@ -550,6 +555,7 @@ static int dln2_adc_triggered_buffer_postenable(struct iio_dev *indio_dev)
 		mutex_unlock(&dln2->mutex);
 		if (ret < 0) {
 			dev_dbg(&dln2->pdev->dev, "Problem in %s\n", __func__);
+			iio_triggered_buffer_predisable(indio_dev);
 			return ret;
 		}
 	} else {
@@ -557,12 +563,12 @@ static int dln2_adc_triggered_buffer_postenable(struct iio_dev *indio_dev)
 		mutex_unlock(&dln2->mutex);
 	}
 
-	return iio_triggered_buffer_postenable(indio_dev);
+	return 0;
 }
 
 static int dln2_adc_triggered_buffer_predisable(struct iio_dev *indio_dev)
 {
-	int ret;
+	int ret, ret2;
 	struct dln2_adc *dln2 = iio_priv(indio_dev);
 
 	mutex_lock(&dln2->mutex);
@@ -577,12 +583,14 @@ static int dln2_adc_triggered_buffer_predisable(struct iio_dev *indio_dev)
 	ret = dln2_adc_set_port_enabled(dln2, false, NULL);
 
 	mutex_unlock(&dln2->mutex);
-	if (ret < 0) {
+	if (ret < 0)
 		dev_dbg(&dln2->pdev->dev, "Problem in %s\n", __func__);
-		return ret;
-	}
 
-	return iio_triggered_buffer_predisable(indio_dev);
+	ret2 = iio_triggered_buffer_predisable(indio_dev);
+	if (ret == 0)
+		ret = ret2;
+
+	return ret;
 }
 
 static const struct iio_buffer_setup_ops dln2_adc_buffer_setup_ops = {
-- 
2.20.1



