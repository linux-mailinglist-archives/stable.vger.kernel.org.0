Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCB4B1F6B
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729865AbfIMNT2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:19:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:47556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729863AbfIMNT2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:19:28 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2CB1206A5;
        Fri, 13 Sep 2019 13:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380767;
        bh=txUuZQMTu44dx0/gJStgUKSlPnx9hoCMQyPa3qKsVeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C6KRhjntheITAX7Tvdxcb3z8dvtg4him0O9A7jVfz0MFoYw6SyZHpHIpYfaGckiDY
         7Pes/3WqD0Wvsd2kSQxMaJy+WPbLza+XKECSYBT4JTIEe/+mAKLA7D984N4SHkJAKf
         qeSvJYjS9hN26DgXvU1YlzCvSxGEfbwKQC6U1ZcA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Raag Jadav <raagjadav@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 172/190] i2c: at91: disable TXRDY interrupt after sending data
Date:   Fri, 13 Sep 2019 14:07:07 +0100
Message-Id: <20190913130613.507083280@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d12e3aae160fb26b534c4496b211d6e60a5179ed ]

Driver was not disabling TXRDY interrupt after last TX byte.
This caused interrupt storm until transfer timeouts for slow
or broken device on the bus. The patch fixes the interrupt storm
on my SAMA5D2-based board.

Cc: stable@vger.kernel.org # 5.2.x
[v5.2 introduced file split; the patch should apply to i2c-at91.c before the split]
Fixes: fac368a04048 ("i2c: at91: add new driver")
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Acked-by: Ludovic Desroches <ludovic.desroches@microchip.com>
Tested-by: Raag Jadav <raagjadav@gmail.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-at91.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
index 3f3e8b3bf5ff9..0998a388d2ed5 100644
--- a/drivers/i2c/busses/i2c-at91.c
+++ b/drivers/i2c/busses/i2c-at91.c
@@ -270,9 +270,11 @@ static void at91_twi_write_next_byte(struct at91_twi_dev *dev)
 	writeb_relaxed(*dev->buf, dev->base + AT91_TWI_THR);
 
 	/* send stop when last byte has been written */
-	if (--dev->buf_len == 0)
+	if (--dev->buf_len == 0) {
 		if (!dev->use_alt_cmd)
 			at91_twi_write(dev, AT91_TWI_CR, AT91_TWI_STOP);
+		at91_twi_write(dev, AT91_TWI_IDR, AT91_TWI_TXRDY);
+	}
 
 	dev_dbg(dev->dev, "wrote 0x%x, to go %zu\n", *dev->buf, dev->buf_len);
 
@@ -690,9 +692,8 @@ static int at91_do_twi_transfer(struct at91_twi_dev *dev)
 		} else {
 			at91_twi_write_next_byte(dev);
 			at91_twi_write(dev, AT91_TWI_IER,
-				       AT91_TWI_TXCOMP |
-				       AT91_TWI_NACK |
-				       AT91_TWI_TXRDY);
+				       AT91_TWI_TXCOMP | AT91_TWI_NACK |
+				       (dev->buf_len ? AT91_TWI_TXRDY : 0));
 		}
 	}
 
-- 
2.20.1



