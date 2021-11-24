Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDC0E45BFEA
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346747AbhKXNCs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:02:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:37390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343777AbhKXNAr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:00:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D829061929;
        Wed, 24 Nov 2021 12:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757298;
        bh=KwLzD+VIyGZ1527+nuJDCM44Ugam0UarwOZlHu+FaXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vzBGh6wZ49CJauhuL0LKwc/U/qo0r+bjqgIfjn0hP2E/rqGoKjIzOUTv/xQfZ/Oov
         TokxGiG4M39ST7UN/7Aky0Lv0aDmZuAkxyi3Bo78uH6zrZs1vz1nzbAAZ9LGUQZbLC
         eqCs6eQaOF/lkl3FChukUPdY39vp/Wowgz3tHvt8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pekka Korpinen <pekka.korpinen@iki.fi>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.19 079/323] iio: dac: ad5446: Fix ad5622_write() return value
Date:   Wed, 24 Nov 2021 12:54:29 +0100
Message-Id: <20211124115721.541619664@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pekka Korpinen <pekka.korpinen@iki.fi>

commit 558df982d4ead9cac628153d0d7b60feae05ddc8 upstream.

On success i2c_master_send() returns the number of bytes written. The
call from iio_write_channel_info(), however, expects the return value to
be zero on success.

This bug causes incorrect consumption of the sysfs buffer in
iio_write_channel_info(). When writing more than two characters to
out_voltage0_raw, the ad5446 write handler is called multiple times
causing unexpected behavior.

Fixes: 3ec36a2cf0d5 ("iio:ad5446: Add support for I2C based DACs")
Signed-off-by: Pekka Korpinen <pekka.korpinen@iki.fi>
Link: https://lore.kernel.org/r/20210929185755.2384-1-pekka.korpinen@iki.fi
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/ad5446.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/iio/dac/ad5446.c
+++ b/drivers/iio/dac/ad5446.c
@@ -528,8 +528,15 @@ static int ad5622_write(struct ad5446_st
 {
 	struct i2c_client *client = to_i2c_client(st->dev);
 	__be16 data = cpu_to_be16(val);
+	int ret;
 
-	return i2c_master_send(client, (char *)&data, sizeof(data));
+	ret = i2c_master_send(client, (char *)&data, sizeof(data));
+	if (ret < 0)
+		return ret;
+	if (ret != sizeof(data))
+		return -EIO;
+
+	return 0;
 }
 
 /**


