Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2B4D45BB1E
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242252AbhKXMQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:16:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:41248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242461AbhKXMOn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:14:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4067E610CE;
        Wed, 24 Nov 2021 12:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755780;
        bh=Zfl6Mzx7Wck22GmN37gVFkiXUWqLneZp62EFCFkZ8Jo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E2Xr7OmNG1VRW5PDniOkEuH+2OrO1HckfYt4G+KF7Ly3/iynGMNiNit35Db5cxH71
         XzL0PxGEQPDlI9n2Q1FD/aTgtmrU/cfKylsl4UwhDhCKtxk6tWaBnoOgZozQTEAMHk
         1Hbk5al7YhYBcoACrD6DhMtrJcT2JPacwnGkCqxM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pekka Korpinen <pekka.korpinen@iki.fi>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.9 053/207] iio: dac: ad5446: Fix ad5622_write() return value
Date:   Wed, 24 Nov 2021 12:55:24 +0100
Message-Id: <20211124115705.640977206@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
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
@@ -510,8 +510,15 @@ static int ad5622_write(struct ad5446_st
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


