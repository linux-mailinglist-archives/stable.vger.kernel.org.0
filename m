Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBFAA24B4D2
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730840AbgHTKNF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:13:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:55480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731096AbgHTKMw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:12:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8876D206DA;
        Thu, 20 Aug 2020 10:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918371;
        bh=RY+bUR6q62ndFq4NTc+Ra1HAuUXfTe8JDs9v63RZvMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DdnbodhE+eaVzUrTtM8aYAUp/1FV+zSsuO4vcpAT9JcA6Co9wITqXQf4Vp94KkMJk
         ChTu9rNAUZhI4jxkyilGghheWCNi5fm8iwPBCJ5qiRkOj9JYzzNlX2B4uhTxbeCU9n
         fsCPL24TCj3N02GqB09V6aW+/hN0bvjj+/rTPQa4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brant Merryman <brant.merryman@silabs.com>,
        Phu Luu <phu.luu@silabs.com>, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 145/228] USB: serial: cp210x: enable usb generic throttle/unthrottle
Date:   Thu, 20 Aug 2020 11:22:00 +0200
Message-Id: <20200820091614.826651760@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
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
@@ -271,6 +271,8 @@ static struct usb_serial_driver cp210x_d
 	.break_ctl		= cp210x_break_ctl,
 	.set_termios		= cp210x_set_termios,
 	.tx_empty		= cp210x_tx_empty,
+	.throttle		= usb_serial_generic_throttle,
+	.unthrottle		= usb_serial_generic_unthrottle,
 	.tiocmget		= cp210x_tiocmget,
 	.tiocmset		= cp210x_tiocmset,
 	.attach			= cp210x_attach,


