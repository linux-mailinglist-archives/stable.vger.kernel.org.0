Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A885E2B66A7
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 15:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729331AbgKQNIw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:08:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:37518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729326AbgKQNIv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:08:51 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B41532468F;
        Tue, 17 Nov 2020 13:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618531;
        bh=hw0zv2f522OPGgfKPxzCuZETXRm58zVzGazybghGR9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hr1XLo6LJLfhmNItHlQCT7F723lYEjOMcJvEgX/mSOWI0U4rQr1mwTKX/glvjkfPq
         gxIs3+sg7YRX0OsrMcV60el2FW38qkd2EG+fVld7HHRmYkgWpYDbaSCYxh3zaigCxa
         AW2VyX22e4hQjGNp3Q9vNcHt34vcJqkd3D/A6EZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Chris Brandt <chris.brandt@renesas.com>
Subject: [PATCH 4.4 34/64] usb: cdc-acm: Add DISABLE_ECHO for Renesas USB Download mode
Date:   Tue, 17 Nov 2020 14:04:57 +0100
Message-Id: <20201117122107.838788611@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122106.144800239@linuxfoundation.org>
References: <20201117122106.144800239@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Brandt <chris.brandt@renesas.com>

commit 6d853c9e4104b4fc8d55dc9cd3b99712aa347174 upstream.

Renesas R-Car and RZ/G SoCs have a firmware download mode over USB.
However, on reset a banner string is transmitted out which is not expected
to be echoed back and will corrupt the protocol.

Cc: stable <stable@vger.kernel.org>
Acked-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Chris Brandt <chris.brandt@renesas.com>
Link: https://lore.kernel.org/r/20201111131209.3977903-1-chris.brandt@renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-acm.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1693,6 +1693,15 @@ static const struct usb_device_id acm_id
 	{ USB_DEVICE(0x0870, 0x0001), /* Metricom GS Modem */
 	.driver_info = NO_UNION_NORMAL, /* has no union descriptor */
 	},
+	{ USB_DEVICE(0x045b, 0x023c),	/* Renesas USB Download mode */
+	.driver_info = DISABLE_ECHO,	/* Don't echo banner */
+	},
+	{ USB_DEVICE(0x045b, 0x0248),	/* Renesas USB Download mode */
+	.driver_info = DISABLE_ECHO,	/* Don't echo banner */
+	},
+	{ USB_DEVICE(0x045b, 0x024D),	/* Renesas USB Download mode */
+	.driver_info = DISABLE_ECHO,	/* Don't echo banner */
+	},
 	{ USB_DEVICE(0x0e8d, 0x0003), /* FIREFLY, MediaTek Inc; andrey.arapov@gmail.com */
 	.driver_info = NO_UNION_NORMAL, /* has no union descriptor */
 	},


