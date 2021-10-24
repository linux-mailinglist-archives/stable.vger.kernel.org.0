Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58419438881
	for <lists+stable@lfdr.de>; Sun, 24 Oct 2021 13:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbhJXLRr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Oct 2021 07:17:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:53000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231231AbhJXLRq (ORCPT <rfc822;Stable@vger.kernel.org>);
        Sun, 24 Oct 2021 07:17:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4B3460FED;
        Sun, 24 Oct 2021 11:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635074126;
        bh=9FZ6r/434A8szdEEa2OcTN8+QK0adzZSGjcPcRsHRys=;
        h=Subject:To:From:Date:From;
        b=OeDAPOKWUDxyXkIlpA2O53ggKSKkDBUa5BenwIU9NbCDcT+hNyn1bcRIxmswSGn67
         25mmiZERJybk+hi+ke/GSC4hnsXqO0d+CQJD3sA97njksie8nYng3WJT3FIaXjBNb5
         YMKxnu23bi9ldd2mFRnNvhqKJtyjORiQpUvU5CxQ=
Subject: patch "iio: dac: ad5446: Fix ad5622_write() return value" added to char-misc-next
To:     pekka.korpinen@iki.fi, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 24 Oct 2021 13:15:06 +0200
Message-ID: <1635074106218178@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: dac: ad5446: Fix ad5622_write() return value

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 558df982d4ead9cac628153d0d7b60feae05ddc8 Mon Sep 17 00:00:00 2001
From: Pekka Korpinen <pekka.korpinen@iki.fi>
Date: Wed, 29 Sep 2021 21:57:55 +0300
Subject: iio: dac: ad5446: Fix ad5622_write() return value

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
---
 drivers/iio/dac/ad5446.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/dac/ad5446.c b/drivers/iio/dac/ad5446.c
index 488ec69967d6..e50718422411 100644
--- a/drivers/iio/dac/ad5446.c
+++ b/drivers/iio/dac/ad5446.c
@@ -531,8 +531,15 @@ static int ad5622_write(struct ad5446_state *st, unsigned val)
 {
 	struct i2c_client *client = to_i2c_client(st->dev);
 	__be16 data = cpu_to_be16(val);
+	int ret;
+
+	ret = i2c_master_send(client, (char *)&data, sizeof(data));
+	if (ret < 0)
+		return ret;
+	if (ret != sizeof(data))
+		return -EIO;
 
-	return i2c_master_send(client, (char *)&data, sizeof(data));
+	return 0;
 }
 
 /*
-- 
2.33.1


