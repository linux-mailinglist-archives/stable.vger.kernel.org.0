Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB5AB2264BB
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729387AbgGTPrm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:47:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:42968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730780AbgGTPrm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:47:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3E342065E;
        Mon, 20 Jul 2020 15:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260061;
        bh=CxX0AJT363wpSILQqMtjxZO6oSEWTDFfl6+P8HsqE2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fyBPHYfB/NYnPrnRBeusP3l9AV4uPs2A+9iAa9xoUZ+rLsEe7VyIkNnyuP60RoScX
         XekkOhWWxnk1kHO3IeUBo6cRZV2xtdFWmMlQFeYOHvYcpSR/E3KIiW8/u95q8DLzl6
         XkPcn9qtEgVMm3byGM/C/JgdU1RfP+wJbkvZ4Cg4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Stable@vger.kernel.org
Subject: [PATCH 4.14 062/125] iio:magnetometer:ak8974: Fix alignment and data leak issues
Date:   Mon, 20 Jul 2020 17:36:41 +0200
Message-Id: <20200720152806.033894436@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152802.929969555@linuxfoundation.org>
References: <20200720152802.929969555@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit 838e00b13bfd4cac8b24df25bfc58e2eb99bcc70 upstream.

One of a class of bugs pointed out by Lars in a recent review.
iio_push_to_buffers_with_timestamp assumes the buffer used is aligned
to the size of the timestamp (8 bytes).  This is not guaranteed in
this driver which uses an array of smaller elements on the stack.
As Lars also noted this anti pattern can involve a leak of data to
userspace and that indeed can happen here.  We close both issues by
moving to a suitable structure in the iio_priv() data.

This data is allocated with kzalloc so no data can leak appart from
previous readings.

Fixes: 7c94a8b2ee8cf ("iio: magn: add a driver for AK8974")
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/magnetometer/ak8974.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/iio/magnetometer/ak8974.c
+++ b/drivers/iio/magnetometer/ak8974.c
@@ -184,6 +184,11 @@ struct ak8974 {
 	bool drdy_irq;
 	struct completion drdy_complete;
 	bool drdy_active_low;
+	/* Ensure timestamp is naturally aligned */
+	struct {
+		__le16 channels[3];
+		s64 ts __aligned(8);
+	} scan;
 };
 
 static const char ak8974_reg_avdd[] = "avdd";
@@ -580,7 +585,6 @@ static void ak8974_fill_buffer(struct ii
 {
 	struct ak8974 *ak8974 = iio_priv(indio_dev);
 	int ret;
-	__le16 hw_values[8]; /* Three axes + 64bit padding */
 
 	pm_runtime_get_sync(&ak8974->i2c->dev);
 	mutex_lock(&ak8974->lock);
@@ -590,13 +594,13 @@ static void ak8974_fill_buffer(struct ii
 		dev_err(&ak8974->i2c->dev, "error triggering measure\n");
 		goto out_unlock;
 	}
-	ret = ak8974_getresult(ak8974, hw_values);
+	ret = ak8974_getresult(ak8974, ak8974->scan.channels);
 	if (ret) {
 		dev_err(&ak8974->i2c->dev, "error getting measures\n");
 		goto out_unlock;
 	}
 
-	iio_push_to_buffers_with_timestamp(indio_dev, hw_values,
+	iio_push_to_buffers_with_timestamp(indio_dev, &ak8974->scan,
 					   iio_get_time_ns(indio_dev));
 
  out_unlock:


