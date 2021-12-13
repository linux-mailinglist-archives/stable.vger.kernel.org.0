Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 768CD4728BE
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239405AbhLMKOh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:14:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241891AbhLMKGr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:06:47 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0157DC0A8893;
        Mon, 13 Dec 2021 01:51:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4D769CE0B59;
        Mon, 13 Dec 2021 09:51:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC3D9C341C5;
        Mon, 13 Dec 2021 09:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389067;
        bh=IcngUNkqDIZ7UUsfXclrbopSXN3a1H6m5c4J5sEZrWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TbzZpAuN8QgzVLUOFrqjf1C8N0oIyI6Sbf3Httg8DmwcwkJTthocZjZyq+t2TVkpM
         ruGBrO7i2LaudIl8UObD0JAi0KRDx8S7kj6QOLWDriMzqui46ot3NmhrjdBmmWM+83
         TNbV6u61jp2Dp2wp9U8RH7cxlgCHCsJ9gad6KLNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kister Genesis Jimenez <kister.jimenez@analog.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 106/132] iio: gyro: adxrs290: fix data signedness
Date:   Mon, 13 Dec 2021 10:30:47 +0100
Message-Id: <20211213092942.732305345@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kister Genesis Jimenez <kister.jimenez@analog.com>

commit fde272e78e004a45c7e4976876277d7e6a5a0ede upstream.

Properly sign-extend the rate and temperature data.

Fixes: 2c8920fff1457 ("iio: gyro: Add driver support for ADXRS290")
Signed-off-by: Kister Genesis Jimenez <kister.jimenez@analog.com>
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20211115104147.18669-1-nuno.sa@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/gyro/adxrs290.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/iio/gyro/adxrs290.c
+++ b/drivers/iio/gyro/adxrs290.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/bitfield.h>
+#include <linux/bitops.h>
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
@@ -124,7 +125,7 @@ static int adxrs290_get_rate_data(struct
 		goto err_unlock;
 	}
 
-	*val = temp;
+	*val = sign_extend32(temp, 15);
 
 err_unlock:
 	mutex_unlock(&st->lock);
@@ -146,7 +147,7 @@ static int adxrs290_get_temp_data(struct
 	}
 
 	/* extract lower 12 bits temperature reading */
-	*val = temp & 0x0FFF;
+	*val = sign_extend32(temp, 11);
 
 err_unlock:
 	mutex_unlock(&st->lock);


