Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 623582F1BAD
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 18:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbhAKRBI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 12:01:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:47860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725858AbhAKRBI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 12:01:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B7CA222B6;
        Mon, 11 Jan 2021 17:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610384427;
        bh=flzDpGqGuKLl3g0GFp5kyoYhW3vJRfYf5/SOC3rzPpY=;
        h=From:To:Cc:Subject:Date:From;
        b=VUmN+tp7y7gn3tyJ/URwH3F9wImx00R8cY+8eeX3iVqwdNJjxXLvZEoMk1olnVm44
         v7M13dw5U3oWKtS8XWjCHf8mXDSucdy8ac5DlAIz8dC9Y0y+LXUTlva3jlb6caRoC+
         7nIWnp4kHFVpNlOmy4MZJsXQtsQRD/JYXNoabhgpRFClbKerNS3AH0KOab1QzY0hC5
         BjuI4n255BkJyqyjPx93kM7kZeER59iB0LME7Esy4v59ugXjVznvxZj6Ccuv/AgzYh
         072gi0I5mH0zKk8Stp0TWrrZ/KzqY1Bx1rGIVdNF/FDqD0QeRfTbbY8v5X1JY0oH/t
         pdkMLThDbRitA==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1kz0YS-0003jj-KC; Mon, 11 Jan 2021 18:00:33 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, stable@vger.kernel.org,
        Charles Yeh <charlesyeh522@gmail.com>
Subject: [PATCH] USB: serial: pl2303: fix line-speed handling on newer chips
Date:   Mon, 11 Jan 2021 18:00:19 +0100
Message-Id: <20210111170019.14320-1-johan@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The latest chip family (HXN) apparently does not support setting the
line speed using divisors and instead needs to use the direct encoding
scheme for all rates.

This specifically enables 50, 110, 134, 200 bps and other rates not
supported by the original chip type.

Fixes: ebd09f1cd417 ("USB: serial: pl2303: add support for PL2303HXN")
Cc: stable@vger.kernel.org      # 5.5
Cc: Charles Yeh <charlesyeh522@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/pl2303.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index be8067017eaa..29dda60e3bcd 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -183,6 +183,7 @@ struct pl2303_type_data {
 	speed_t max_baud_rate;
 	unsigned long quirks;
 	unsigned int no_autoxonxoff:1;
+	unsigned int no_divisors:1;
 };
 
 struct pl2303_serial_private {
@@ -209,6 +210,7 @@ static const struct pl2303_type_data pl2303_type_data[TYPE_COUNT] = {
 	},
 	[TYPE_HXN] = {
 		.max_baud_rate		= 12000000,
+		.no_divisors		= true,
 	},
 };
 
@@ -571,8 +573,12 @@ static void pl2303_encode_baud_rate(struct tty_struct *tty,
 		baud = min_t(speed_t, baud, spriv->type->max_baud_rate);
 	/*
 	 * Use direct method for supported baud rates, otherwise use divisors.
+	 * Newer chip types do not support divisor encoding.
 	 */
-	baud_sup = pl2303_get_supported_baud_rate(baud);
+	if (spriv->type->no_divisors)
+		baud_sup = baud;
+	else
+		baud_sup = pl2303_get_supported_baud_rate(baud);
 
 	if (baud == baud_sup)
 		baud = pl2303_encode_baud_rate_direct(buf, baud);
-- 
2.26.2

