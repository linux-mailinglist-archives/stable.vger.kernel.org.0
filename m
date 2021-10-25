Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6108843952A
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 13:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233257AbhJYLsp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 07:48:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233249AbhJYLsn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 07:48:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DFA161050;
        Mon, 25 Oct 2021 11:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635162381;
        bh=+mqhTnTRdKxzatm608pkboowK18/NX3Pb/cHz5A3cJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ir6eCJ1DUOEYHgiq+ORiqwF3mb+j3YuAI938zPYtAA9dcFBXjBYAzjAgueUmGuZ+x
         DMsIChP5M9kmsn4GXMxPbWC+YYSTchd5XZi+AUjmgFEebJuQbH7ODbxDuX/zkwcBL3
         u1Isp7x9L4pir+B3spedmn7LeRNGvXRFhXWUrvqS4mqlttA/R+HYukzdSsaxOIYjYS
         hSvmEW5WhzKewAmoaHB+R2tJIpAmrPM86ny2qxYgIkfgpWNJ68gkLzfucBrlR5xJBk
         M+enBOgsTtXzbvJRSFE8I/svxHfYVe42EoskmpTspMRynvSHjY73dWbs7B5Z0V49By
         U0v7oJ/l9u9gQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1meyQW-0001DD-5B; Mon, 25 Oct 2021 13:46:04 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org,
        Luca Ellero <luca.ellero@brickedbrain.com>
Subject: [PATCH 1/5] comedi: ni_usb6501: fix NULL-deref in command paths
Date:   Mon, 25 Oct 2021 13:45:28 +0200
Message-Id: <20211025114532.4599-2-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211025114532.4599-1-johan@kernel.org>
References: <20211025114532.4599-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The driver uses endpoint-sized USB transfer buffers but had no sanity
checks on the sizes. This can lead to zero-size-pointer dereferences or
overflowed transfer buffers in ni6501_port_command() and
ni6501_counter_command() if a (malicious) device has smaller max-packet
sizes than expected (or when doing descriptor fuzz testing).

Add the missing sanity checks to probe().

Fixes: a03bb00e50ab ("staging: comedi: add NI USB-6501 support")
Cc: stable@vger.kernel.org      # 3.18
Cc: Luca Ellero <luca.ellero@brickedbrain.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/comedi/drivers/ni_usb6501.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/comedi/drivers/ni_usb6501.c b/drivers/comedi/drivers/ni_usb6501.c
index 5b6d9d783b2f..eb2e5c23f25d 100644
--- a/drivers/comedi/drivers/ni_usb6501.c
+++ b/drivers/comedi/drivers/ni_usb6501.c
@@ -144,6 +144,10 @@ static const u8 READ_COUNTER_RESPONSE[]	= {0x00, 0x01, 0x00, 0x10,
 					   0x00, 0x00, 0x00, 0x02,
 					   0x00, 0x00, 0x00, 0x00};
 
+/* Largest supported packets */
+static const size_t TX_MAX_SIZE	= sizeof(SET_PORT_DIR_REQUEST);
+static const size_t RX_MAX_SIZE	= sizeof(READ_PORT_RESPONSE);
+
 enum commands {
 	READ_PORT,
 	WRITE_PORT,
@@ -486,12 +490,16 @@ static int ni6501_find_endpoints(struct comedi_device *dev)
 		ep_desc = &iface_desc->endpoint[i].desc;
 
 		if (usb_endpoint_is_bulk_in(ep_desc)) {
+			if (usb_endpoint_maxp(ep_desc) < RX_MAX_SIZE)
+				continue;
 			if (!devpriv->ep_rx)
 				devpriv->ep_rx = ep_desc;
 			continue;
 		}
 
 		if (usb_endpoint_is_bulk_out(ep_desc)) {
+			if (usb_endpoint_maxp(ep_desc) < TX_MAX_SIZE)
+				continue;
 			if (!devpriv->ep_tx)
 				devpriv->ep_tx = ep_desc;
 			continue;
-- 
2.32.0

