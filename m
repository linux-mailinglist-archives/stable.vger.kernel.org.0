Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85B2C12C5B5
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729254AbfL2RkQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:40:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:60002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728801AbfL2Rb7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:31:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DCAD21744;
        Sun, 29 Dec 2019 17:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640718;
        bh=Bw3+aSuAoag2j3kzU+Ti1k3Yxe/htlhVQFUQABZt2Pw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ToV17xg12DvIfjQ0fI2DwYQPXA1xE2WG3UsKodKYMg1gqoIvdxirTO1BlYi6/A8NU
         5BUEZgDw+ZL0fiNbBOMX0fRP1nRwdiAE4uZ7cXYpjirAJvKg/EBagt5k6Zt5psYkRg
         yQqxXlbjiVvw3ZUtKpS/MjsFpaGVcIAMgWwx53Cw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 110/219] iio: dln2-adc: fix iio_triggered_buffer_postenable() position
Date:   Sun, 29 Dec 2019 18:18:32 +0100
Message-Id: <20191229162525.302479149@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
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
index c64c6675cae6..4ab052d76d9f 100644
--- a/drivers/iio/adc/dln2-adc.c
+++ b/drivers/iio/adc/dln2-adc.c
@@ -527,6 +527,10 @@ static int dln2_adc_triggered_buffer_postenable(struct iio_dev *indio_dev)
 	u16 conflict;
 	unsigned int trigger_chan;
 
+	ret = iio_triggered_buffer_postenable(indio_dev);
+	if (ret)
+		return ret;
+
 	mutex_lock(&dln2->mutex);
 
 	/* Enable ADC */
@@ -540,6 +544,7 @@ static int dln2_adc_triggered_buffer_postenable(struct iio_dev *indio_dev)
 				(int)conflict);
 			ret = -EBUSY;
 		}
+		iio_triggered_buffer_predisable(indio_dev);
 		return ret;
 	}
 
@@ -553,6 +558,7 @@ static int dln2_adc_triggered_buffer_postenable(struct iio_dev *indio_dev)
 		mutex_unlock(&dln2->mutex);
 		if (ret < 0) {
 			dev_dbg(&dln2->pdev->dev, "Problem in %s\n", __func__);
+			iio_triggered_buffer_predisable(indio_dev);
 			return ret;
 		}
 	} else {
@@ -560,12 +566,12 @@ static int dln2_adc_triggered_buffer_postenable(struct iio_dev *indio_dev)
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
@@ -580,12 +586,14 @@ static int dln2_adc_triggered_buffer_predisable(struct iio_dev *indio_dev)
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



