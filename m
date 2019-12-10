Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C51E9119E25
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 23:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729077AbfLJWmf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 17:42:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:51392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728361AbfLJWbX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 17:31:23 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 186C02073D;
        Tue, 10 Dec 2019 22:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576017082;
        bh=mQCliQUuDvr0riFtN9VdVoENc7SI8ZrshGbUX15EB5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Go7+EBkpl6IcWC7kvHCvDCJDOZAtbUSrgqecb6ECYd1gduVBKiLeAsPx8oM13dvTl
         QUtwt9wnLdoOoDVFU40jPc5odaQ/uK6Wvq1/X3/UgntPyQdgaqpJMba88muY/TBzgh
         bfSaP+yRoOFc8ctSsozXEeSxFdZZQzCczQmtpEDo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 39/91] iio: pressure: zpa2326: fix iio_triggered_buffer_postenable position
Date:   Tue, 10 Dec 2019 17:29:43 -0500
Message-Id: <20191210223035.14270-39-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210223035.14270-1-sashal@kernel.org>
References: <20191210223035.14270-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandru Ardelean <alexandru.ardelean@analog.com>

[ Upstream commit fe2392c67db9730d46f11fc4fadfa7bffa8843fa ]

The iio_triggered_buffer_{predisable,postenable} functions attach/detach
the poll functions.

The iio_triggered_buffer_postenable() should be called before (to attach
the poll func) and then the

The iio_triggered_buffer_predisable() function is hooked directly without
anything, which is probably fine, as the postenable() version seems to also
do some reset/wake-up of the device.
This will mean it will be easier when removing it; i.e. it just gets
removed.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/pressure/zpa2326.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/iio/pressure/zpa2326.c b/drivers/iio/pressure/zpa2326.c
index cc002b958f7e8..e79729ee151ed 100644
--- a/drivers/iio/pressure/zpa2326.c
+++ b/drivers/iio/pressure/zpa2326.c
@@ -1255,6 +1255,11 @@ static int zpa2326_postenable_buffer(struct iio_dev *indio_dev)
 	const struct zpa2326_private *priv = iio_priv(indio_dev);
 	int                           err;
 
+	/* Plug our own trigger event handler. */
+	err = iio_triggered_buffer_postenable(indio_dev);
+	if (err)
+		goto err;
+
 	if (!priv->waken) {
 		/*
 		 * We were already power supplied. Just clear hardware FIFO to
@@ -1262,7 +1267,7 @@ static int zpa2326_postenable_buffer(struct iio_dev *indio_dev)
 		 */
 		err = zpa2326_clear_fifo(indio_dev, 0);
 		if (err)
-			goto err;
+			goto err_buffer_predisable;
 	}
 
 	if (!iio_trigger_using_own(indio_dev) && priv->waken) {
@@ -1272,16 +1277,13 @@ static int zpa2326_postenable_buffer(struct iio_dev *indio_dev)
 		 */
 		err = zpa2326_config_oneshot(indio_dev, priv->irq);
 		if (err)
-			goto err;
+			goto err_buffer_predisable;
 	}
 
-	/* Plug our own trigger event handler. */
-	err = iio_triggered_buffer_postenable(indio_dev);
-	if (err)
-		goto err;
-
 	return 0;
 
+err_buffer_predisable:
+	iio_triggered_buffer_predisable(indio_dev);
 err:
 	zpa2326_err(indio_dev, "failed to enable buffering (%d)", err);
 
-- 
2.20.1

