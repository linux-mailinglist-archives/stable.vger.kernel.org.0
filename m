Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09B7D22CC3
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 09:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730366AbfETHQq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 03:16:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:48632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726940AbfETHQq (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 20 May 2019 03:16:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86F5220851;
        Mon, 20 May 2019 07:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558336606;
        bh=/tfZ1LBo/Z6VlWAnrRCA8FOJbVoNNzVZRlLsbg6Bk0s=;
        h=Subject:To:From:Date:From;
        b=jpSfEutTpzTUSiWcD9uBNpHFuc59ChVlNOdG/6N8GYi1cBMRbbIUEc34LOnFfUVhH
         +Sj54oUiXBDCyO09udv27clOWwTnXPm+PFIuMufmfcLgA4qO5Z3nBB+Ts47Ooi+aqm
         fQ+R4+RVSTWZQjH2nvQZ/aO/zUdC4r8C2W/57G4o=
Subject: patch "iio: adc: ads124: avoid buffer overflow" added to staging-linus
To:     vincent.stehle@laposte.net, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, dmurphy@ti.com, mojha@codeaurora.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 May 2019 09:16:33 +0200
Message-ID: <1558336593254142@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: ads124: avoid buffer overflow

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 0db8aa49a97e7f40852a64fd35abcc1292a7c365 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
Date: Sun, 31 Mar 2019 20:54:23 +0200
Subject: iio: adc: ads124: avoid buffer overflow
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When initializing the priv->data array starting from index 1, there is one
less element to consider than when initializing the full array.

Fixes: e717f8c6dfec8f76 ("iio: adc: Add the TI ads124s08 ADC code")
Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>
Reviewed-by: Dan Murphy <dmurphy@ti.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/ti-ads124s08.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ti-ads124s08.c b/drivers/iio/adc/ti-ads124s08.c
index 53f17e4f2f23..552c2be8d87a 100644
--- a/drivers/iio/adc/ti-ads124s08.c
+++ b/drivers/iio/adc/ti-ads124s08.c
@@ -202,7 +202,7 @@ static int ads124s_read(struct iio_dev *indio_dev, unsigned int chan)
 	};
 
 	priv->data[0] = ADS124S08_CMD_RDATA;
-	memset(&priv->data[1], ADS124S08_CMD_NOP, sizeof(priv->data));
+	memset(&priv->data[1], ADS124S08_CMD_NOP, sizeof(priv->data) - 1);
 
 	ret = spi_sync_transfer(priv->spi, t, ARRAY_SIZE(t));
 	if (ret < 0)
-- 
2.21.0


