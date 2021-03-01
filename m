Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20CE432910D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243182AbhCAUSm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:18:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:40906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242712AbhCAULH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:11:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EE92653C3;
        Mon,  1 Mar 2021 18:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621642;
        bh=sL1zLTgzyVQcrdT1sm43KNumDWpFDbBz6iB+WqQirwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K/4/LomWlv3G0jM3wKEnyWHkmTMkbBBgaga/z068wHx0IUPH7RLc3dWeQbBPdkoUR
         EELR95VN7lKMhsEFDdy63qRkEkJxxwoiAvPwMeeWhW8tTzuc4WYJ5SC0sAUL4iDCEg
         jP2q0BGjTd3VXFH9WLFBt5gjfsKUYb6tOmFwGalU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Charles Yeh <charlesyeh522@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.11 589/775] USB: serial: pl2303: fix line-speed handling on newer chips
Date:   Mon,  1 Mar 2021 17:12:37 +0100
Message-Id: <20210301161230.544303797@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 979d9cbe75b922ab1695b8ad5576115774f72e62 upstream.

The latest chip family (HXN) apparently does not support setting the
line speed using divisors and instead needs to use the direct encoding
scheme for all rates.

This specifically enables 50, 110, 134, 200 bps and other rates not
supported by the original chip type.

Fixes: ebd09f1cd417 ("USB: serial: pl2303: add support for PL2303HXN")
Cc: stable@vger.kernel.org      # 5.5
Cc: Charles Yeh <charlesyeh522@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/pl2303.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -183,6 +183,7 @@ struct pl2303_type_data {
 	speed_t max_baud_rate;
 	unsigned long quirks;
 	unsigned int no_autoxonxoff:1;
+	unsigned int no_divisors:1;
 };
 
 struct pl2303_serial_private {
@@ -209,6 +210,7 @@ static const struct pl2303_type_data pl2
 	},
 	[TYPE_HXN] = {
 		.max_baud_rate		= 12000000,
+		.no_divisors		= true,
 	},
 };
 
@@ -571,8 +573,12 @@ static void pl2303_encode_baud_rate(stru
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


