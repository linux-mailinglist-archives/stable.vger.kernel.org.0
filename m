Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E312C46D3CC
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 13:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233844AbhLHM6H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 07:58:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbhLHM6H (ORCPT
        <rfc822;Stable@vger.kernel.org>); Wed, 8 Dec 2021 07:58:07 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A97C061746
        for <Stable@vger.kernel.org>; Wed,  8 Dec 2021 04:54:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9E9C3CE214F
        for <Stable@vger.kernel.org>; Wed,  8 Dec 2021 12:54:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50089C00446;
        Wed,  8 Dec 2021 12:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638968071;
        bh=4HecYuEfKou+h02Uo2MNK20aUwDdzAT18VWUuM4IRJc=;
        h=Subject:To:From:Date:From;
        b=kf03MpBHfLLEzcb0FIS/xLTfVrNdKUzNmCen66cdMY+QwviZ7d1T6id67/ILWQIlW
         6kdqnqe8t+PJ0CHOVpqgi0a598t51YEzjf7ExHGKQKhl6OAs/n0pdNFaroWIQVV9ZR
         4LPvFNILy17LCfHNKePnSQY739mRl2ERrWhFZWU4=
Subject: patch "iio: gyro: adxrs290: fix data signedness" added to char-misc-linus
To:     kister.jimenez@analog.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, andy.shevchenko@gmail.com,
        nuno.sa@analog.com
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 08 Dec 2021 13:53:57 +0100
Message-ID: <1638968037112163@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: gyro: adxrs290: fix data signedness

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From fde272e78e004a45c7e4976876277d7e6a5a0ede Mon Sep 17 00:00:00 2001
From: Kister Genesis Jimenez <kister.jimenez@analog.com>
Date: Mon, 15 Nov 2021 11:41:47 +0100
Subject: iio: gyro: adxrs290: fix data signedness
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Properly sign-extend the rate and temperature data.

Fixes: 2c8920fff1457 ("iio: gyro: Add driver support for ADXRS290")
Signed-off-by: Kister Genesis Jimenez <kister.jimenez@analog.com>
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20211115104147.18669-1-nuno.sa@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/gyro/adxrs290.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/gyro/adxrs290.c b/drivers/iio/gyro/adxrs290.c
index 3e0734ddafe3..600e9725da78 100644
--- a/drivers/iio/gyro/adxrs290.c
+++ b/drivers/iio/gyro/adxrs290.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/bitfield.h>
+#include <linux/bitops.h>
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
@@ -124,7 +125,7 @@ static int adxrs290_get_rate_data(struct iio_dev *indio_dev, const u8 cmd, int *
 		goto err_unlock;
 	}
 
-	*val = temp;
+	*val = sign_extend32(temp, 15);
 
 err_unlock:
 	mutex_unlock(&st->lock);
@@ -146,7 +147,7 @@ static int adxrs290_get_temp_data(struct iio_dev *indio_dev, int *val)
 	}
 
 	/* extract lower 12 bits temperature reading */
-	*val = temp & 0x0FFF;
+	*val = sign_extend32(temp, 11);
 
 err_unlock:
 	mutex_unlock(&st->lock);
-- 
2.34.1


