Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64DB3422228
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 11:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233574AbhJEJXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 05:23:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:38080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233782AbhJEJXi (ORCPT <rfc822;Stable@vger.kernel.org>);
        Tue, 5 Oct 2021 05:23:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49DDF61165;
        Tue,  5 Oct 2021 09:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633425708;
        bh=tlNEdvybavkQTGJt7NDuSPlZukz+FIf+iHVkT6yyd3U=;
        h=Subject:To:From:Date:From;
        b=ri4VS4NpTB1Nzsw52YWuHizCnghjdHcOAEOUwL0naLs9cBYy5WnEIrb+3YL71J6aB
         ooY53u4QYEXdNn1NzJScuoFxv+cGgeDJlsxbwVsGHde08+ETQjWP3KV/RZlTZky4Eb
         sdjVP/qqVj2WPAngNzrCjSnGfHbvvOx+GQ/cC/Qo=
Subject: patch "iio: adis16475: fix deadlock on frequency set" added to staging-linus
To:     nuno.sa@analog.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, ardeleanalex@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 05 Oct 2021 11:21:25 +0200
Message-ID: <1633425685140177@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adis16475: fix deadlock on frequency set

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 9da1b86865ab4376408c58cd9fec332c8bdb5c73 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>
Date: Mon, 20 Sep 2021 11:00:47 +0200
Subject: iio: adis16475: fix deadlock on frequency set
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

With commit 39c024b51b560
("iio: adis16475: improve sync scale mode handling"), two deadlocks were
introduced:
 1) The call to 'adis_write_reg_16()' was not changed to it's unlocked
    version.
 2) The lock was not being released on the success path of the function.

This change fixes both these issues.

Fixes: 39c024b51b560 ("iio: adis16475: improve sync scale mode handling")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: Alexandru Ardelean <ardeleanalex@gmail.com>
Link: https://lore.kernel.org/r/20210920090047.74903-1-nuno.sa@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/imu/adis16475.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/imu/adis16475.c b/drivers/iio/imu/adis16475.c
index eb48102f9424..287fff39a927 100644
--- a/drivers/iio/imu/adis16475.c
+++ b/drivers/iio/imu/adis16475.c
@@ -353,10 +353,11 @@ static int adis16475_set_freq(struct adis16475 *st, const u32 freq)
 	if (dec > st->info->max_dec)
 		dec = st->info->max_dec;
 
-	ret = adis_write_reg_16(&st->adis, ADIS16475_REG_DEC_RATE, dec);
+	ret = __adis_write_reg_16(&st->adis, ADIS16475_REG_DEC_RATE, dec);
 	if (ret)
 		goto error;
 
+	adis_dev_unlock(&st->adis);
 	/*
 	 * If decimation is used, then gyro and accel data will have meaningful
 	 * bits on the LSB registers. This info is used on the trigger handler.
-- 
2.33.0


