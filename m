Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 586AFE695D
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729660AbfJ0Vfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:35:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728076AbfJ0VIJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:08:09 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CC602064A;
        Sun, 27 Oct 2019 21:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210488;
        bh=wgCt+YZ5RNpB3TdtQz/yGRs20B5SCGe3XuJHby44QTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mt8W1y+gfTu/qZpRGWN2KwhVDulGpR6E0xVYwy2hey3/4z8NZjTHtS7fquyRfkMJA
         AJQsXMt9Hn2FAq2J5J6EQpHQsHsjBMelBhXHzE5HfZQAMQZ2qQDW9RgdjwaGPDAMmd
         SkfDZZ9KQQ4uOMl7z5vtk1oZPZ5nnpuqq+17EJPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH 4.14 032/119] usb: udc: lpc32xx: fix bad bit shift operation
Date:   Sun, 27 Oct 2019 22:00:09 +0100
Message-Id: <20191027203310.316790937@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
References: <20191027203259.948006506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo A. R. Silva <gustavo@embeddedor.com>

commit b987b66ac3a2bc2f7b03a0ba48a07dc553100c07 upstream.

It seems that the right variable to use in this case is *i*, instead of
*n*, otherwise there is an undefined behavior when right shifiting by more
than 31 bits when multiplying n by 8; notice that *n* can take values
equal or greater than 4 (4, 8, 16, ...).

Also, notice that under the current conditions (bl = 3), we are skiping
the handling of bytes 3, 7, 31... So, fix this by updating this logic
and limit *bl* up to 4 instead of up to 3.

This fix is based on function udc_stuff_fifo().

Addresses-Coverity-ID: 1454834 ("Bad bit shift operation")
Fixes: 24a28e428351 ("USB: gadget driver for LPC32xx")
Cc: stable@vger.kernel.org
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Link: https://lore.kernel.org/r/20191014191830.GA10721@embeddedor
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/udc/lpc32xx_udc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/gadget/udc/lpc32xx_udc.c
+++ b/drivers/usb/gadget/udc/lpc32xx_udc.c
@@ -1178,11 +1178,11 @@ static void udc_pop_fifo(struct lpc32xx_
 			tmp = readl(USBD_RXDATA(udc->udp_baseaddr));
 
 			bl = bytes - n;
-			if (bl > 3)
-				bl = 3;
+			if (bl > 4)
+				bl = 4;
 
 			for (i = 0; i < bl; i++)
-				data[n + i] = (u8) ((tmp >> (n * 8)) & 0xFF);
+				data[n + i] = (u8) ((tmp >> (i * 8)) & 0xFF);
 		}
 		break;
 


