Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA90581CE3
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730645AbfHENYT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:24:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:32828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730971AbfHENYT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:24:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92A9C2087B;
        Mon,  5 Aug 2019 13:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011458;
        bh=dJ6eF9Ln8U7bkQe9KNDZRmgsHgayYzmLEycoAeDZu5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bzI/gcF2lM/JrqWSDEy51v4/pvtL2+CF3o5laPO6MXrnoghUxvgD6BQGfLsXzfP5i
         nVB3PDKaHNAmx+cVqPhNoyHVvt5G1FcqmRSnOM+5+4Dz53CvM58altfHEW5fdo0t54
         KZZa4ljA1QMuGe5nHtQRNp1t8hABe4YDYEKg3YGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Raag Jadav <raagjadav@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 5.2 095/131] i2c: at91: disable TXRDY interrupt after sending data
Date:   Mon,  5 Aug 2019 15:03:02 +0200
Message-Id: <20190805124958.328486837@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

commit d12e3aae160fb26b534c4496b211d6e60a5179ed upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-at91-master.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/i2c/busses/i2c-at91-master.c
+++ b/drivers/i2c/busses/i2c-at91-master.c
@@ -122,9 +122,11 @@ static void at91_twi_write_next_byte(str
 	writeb_relaxed(*dev->buf, dev->base + AT91_TWI_THR);
 
 	/* send stop when last byte has been written */
-	if (--dev->buf_len == 0)
+	if (--dev->buf_len == 0) {
 		if (!dev->use_alt_cmd)
 			at91_twi_write(dev, AT91_TWI_CR, AT91_TWI_STOP);
+		at91_twi_write(dev, AT91_TWI_IDR, AT91_TWI_TXRDY);
+	}
 
 	dev_dbg(dev->dev, "wrote 0x%x, to go %zu\n", *dev->buf, dev->buf_len);
 
@@ -542,9 +544,8 @@ static int at91_do_twi_transfer(struct a
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
 


