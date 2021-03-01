Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6571328E37
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234676AbhCATZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:25:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:46160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241421AbhCATVo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:21:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FA5065243;
        Mon,  1 Mar 2021 17:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619637;
        bh=sL1zLTgzyVQcrdT1sm43KNumDWpFDbBz6iB+WqQirwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L6GIPJuqjn0EGmVHbEXr9slXtkYcgmiNwMWUaolWUP+l4pGD5EjHT5gH2vNYBwIS7
         FwSFpKSsJ3Cl6qHHas/jKFEGBVyTOeKr4BgA8JeiTbnlaUOmYhFvD+J+eJafCOtHNt
         b5s0gfl8myXS9Lp+DKPSbpkuXFOLf0DFxDwYtm7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Charles Yeh <charlesyeh522@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 496/663] USB: serial: pl2303: fix line-speed handling on newer chips
Date:   Mon,  1 Mar 2021 17:12:24 +0100
Message-Id: <20210301161206.387314281@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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


