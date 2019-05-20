Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F26C522CC5
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 09:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730013AbfETHQw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 03:16:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:48714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726901AbfETHQw (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 20 May 2019 03:16:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2D1220856;
        Mon, 20 May 2019 07:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558336611;
        bh=raicJ8weuBzt+k3ZOHqstW3A3Sm5lUdJnGu284ufGLw=;
        h=Subject:To:From:Date:From;
        b=bMjwe9zzaq6vy3F0GX4smphrIWdMfWh4vAJgUBgaay2Vl5Wk3obxTR78ZKFQS+QnQ
         yKvln63kNDoekIzJwvIjH54yvkSXsotyXRdTQIxBecmn2kfx4XOmWIMwAt5OSbn7YJ
         FYJKY+LfND+CMO5stgRK+dPvnkOayDy/GepDVBzg=
Subject: patch "iio: dac: ds4422/ds4424 fix chip verification" added to staging-linus
To:     ruslan@babayev.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 May 2019 09:16:34 +0200
Message-ID: <155833659410395@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: dac: ds4422/ds4424 fix chip verification

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 60f2208699ec08ff9fdf1f97639a661a92a18f1c Mon Sep 17 00:00:00 2001
From: Ruslan Babayev <ruslan@babayev.com>
Date: Sun, 5 May 2019 12:24:37 -0700
Subject: iio: dac: ds4422/ds4424 fix chip verification

The ds4424_get_value function takes channel number as it's 3rd
argument and translates it internally into I2C address using
DS4424_DAC_ADDR macro. The caller ds4424_verify_chip was passing an
already translated I2C address as its last argument.

Signed-off-by: Ruslan Babayev <ruslan@babayev.com>
Cc: xe-linux-external@cisco.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/dac/ds4424.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/dac/ds4424.c b/drivers/iio/dac/ds4424.c
index 883a47562055..714a97f91319 100644
--- a/drivers/iio/dac/ds4424.c
+++ b/drivers/iio/dac/ds4424.c
@@ -166,7 +166,7 @@ static int ds4424_verify_chip(struct iio_dev *indio_dev)
 {
 	int ret, val;
 
-	ret = ds4424_get_value(indio_dev, &val, DS4424_DAC_ADDR(0));
+	ret = ds4424_get_value(indio_dev, &val, 0);
 	if (ret < 0)
 		dev_err(&indio_dev->dev,
 				"%s failed. ret: %d\n", __func__, ret);
-- 
2.21.0


