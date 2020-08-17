Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28F45246B82
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388102AbgHQP5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:57:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387578AbgHQP4R (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:56:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 964DB214F1;
        Mon, 17 Aug 2020 15:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679777;
        bh=SrnGT9mFV8mx+n9fnp7oqTYm1Ykr9auihTd+1/BmR7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v4mE/JoFX6tey03BInvUA7OdZjP6Wg1h1KFr5uvegBeSR2/ddrr+jBoWO+auIBeGg
         uHSKgLhBR3b4lSB8T1VpnCj+qCl/JjLTslpu9J1SJaikqUmMxtMQ9wOt9XxzZ/F0FB
         yU0vVJzBmvSdO9R56XQWLSUAVWwG61pP6efZS1Y8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brant Merryman <brant.merryman@silabs.com>,
        Phu Luu <phu.luu@silabs.com>, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.7 331/393] USB: serial: cp210x: enable usb generic throttle/unthrottle
Date:   Mon, 17 Aug 2020 17:16:21 +0200
Message-Id: <20200817143835.652817219@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brant Merryman <brant.merryman@silabs.com>

commit 4387b3dbb079d482d3c2b43a703ceed4dd27ed28 upstream.

Assign the .throttle and .unthrottle functions to be generic function
in the driver structure to prevent data loss that can otherwise occur
if the host does not enable USB throttling.

Signed-off-by: Brant Merryman <brant.merryman@silabs.com>
Co-developed-by: Phu Luu <phu.luu@silabs.com>
Signed-off-by: Phu Luu <phu.luu@silabs.com>
Link: https://lore.kernel.org/r/57401AF3-9961-461F-95E1-F8AFC2105F5E@silabs.com
[ johan: fix up tags ]
Fixes: 39a66b8d22a3 ("[PATCH] USB: CP2101 Add support for flow control")
Cc: stable <stable@vger.kernel.org>     # 2.6.12
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/cp210x.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -272,6 +272,8 @@ static struct usb_serial_driver cp210x_d
 	.break_ctl		= cp210x_break_ctl,
 	.set_termios		= cp210x_set_termios,
 	.tx_empty		= cp210x_tx_empty,
+	.throttle		= usb_serial_generic_throttle,
+	.unthrottle		= usb_serial_generic_unthrottle,
 	.tiocmget		= cp210x_tiocmget,
 	.tiocmset		= cp210x_tiocmset,
 	.attach			= cp210x_attach,


