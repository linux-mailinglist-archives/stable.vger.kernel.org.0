Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A33C7EB4EC
	for <lists+stable@lfdr.de>; Thu, 31 Oct 2019 17:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728529AbfJaQoR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Oct 2019 12:44:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:36964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728521AbfJaQoR (ORCPT <rfc822;Stable@vger.kernel.org>);
        Thu, 31 Oct 2019 12:44:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50E902087F;
        Thu, 31 Oct 2019 16:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572540256;
        bh=3jyAeDEiVjPh9Ma1XdygByQM0jdLNfc2ofUasgdbCAU=;
        h=Subject:To:From:Date:From;
        b=szLudTfOepy6PQuRSy/aPNGJl46/jnQkbsreM9qy/YI+9ObLe6u0QZDhlq2dGTgyQ
         lEs8z1WUtoDmigUBb4DijVAmLoNbwNsimyf9KQ/Wgcy7Of7mtyZEAWW8h7rV+79wrL
         q8F8JlIHpCflBVfZNRsyXqBM4MXjJMpz/hYuN3iA=
Subject: patch "iio: imu: adis16480: make sure provided frequency is positive" added to staging-linus
To:     alexandru.ardelean@analog.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 31 Oct 2019 17:44:14 +0100
Message-ID: <157254025423595@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: imu: adis16480: make sure provided frequency is positive

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 24e1eb5c0d78cfb9750b690bbe997d4d59170258 Mon Sep 17 00:00:00 2001
From: Alexandru Ardelean <alexandru.ardelean@analog.com>
Date: Tue, 8 Oct 2019 17:15:37 +0300
Subject: iio: imu: adis16480: make sure provided frequency is positive

It could happen that either `val` or `val2` [provided from userspace] is
negative. In that case the computed frequency could get a weird value.

Fix this by checking that neither of the 2 variables is negative, and check
that the computed result is not-zero.

Fixes: e4f959390178 ("iio: imu: adis16480 switch sampling frequency attr to core support")
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/imu/adis16480.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/imu/adis16480.c b/drivers/iio/imu/adis16480.c
index b99d73887c9f..8743b2f376e2 100644
--- a/drivers/iio/imu/adis16480.c
+++ b/drivers/iio/imu/adis16480.c
@@ -317,8 +317,11 @@ static int adis16480_set_freq(struct iio_dev *indio_dev, int val, int val2)
 	struct adis16480 *st = iio_priv(indio_dev);
 	unsigned int t, reg;
 
+	if (val < 0 || val2 < 0)
+		return -EINVAL;
+
 	t =  val * 1000 + val2 / 1000;
-	if (t <= 0)
+	if (t == 0)
 		return -EINVAL;
 
 	/*
-- 
2.23.0


