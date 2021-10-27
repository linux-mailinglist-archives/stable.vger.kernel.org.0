Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E900E43C693
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 11:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238911AbhJ0JjW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 05:39:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:42320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236741AbhJ0JjV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Oct 2021 05:39:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B41AA61056;
        Wed, 27 Oct 2021 09:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635327416;
        bh=A8O+IbmeT4Ni9leqpFCK7Sh5SliDMz7ykYVWOa64PM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TNzAfPjxky7ZjycSkbCRlLNsBmsn7qYHuJukCXyaImeI9a4NqXwCP6rxql0Uy2CN6
         5lb8OpycM0+kA0IXo9iJvc3wvyV/GuWougHpDyJ3LNhmnaEb+TyNuII2TiPJKMJWLr
         GLRpdsJkbDCbpkB0uArV7KNn9g1/oN6agLJ/TQSDSpN99Vh0qL9lQG7Zt/giWVHeX8
         9GSkuyv3q//I14VANGpdIbxYmgccXL5i2Cqc9Sv7ghotUvz7YAK0NiLKj9XVqd1r3r
         j2w27HJNVKpe8n6OERrNZirc2Argo5+kBkFhuTGC+vOhVoJ5QHDJXGKllQJ/prx3+8
         rVneSCxfF1X7Q==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mffMP-00083a-38; Wed, 27 Oct 2021 11:36:41 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org,
        Luca Ellero <luca.ellero@brickedbrain.com>
Subject: [PATCH v2 1/2] comedi: ni_usb6501: fix NULL-deref in command paths
Date:   Wed, 27 Oct 2021 11:35:28 +0200
Message-Id: <20211027093529.30896-2-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211027093529.30896-1-johan@kernel.org>
References: <20211027093529.30896-1-johan@kernel.org>
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
 drivers/comedi/drivers/ni_usb6501.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/comedi/drivers/ni_usb6501.c b/drivers/comedi/drivers/ni_usb6501.c
index 5b6d9d783b2f..c42987b74b1d 100644
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
@@ -501,6 +505,12 @@ static int ni6501_find_endpoints(struct comedi_device *dev)
 	if (!devpriv->ep_rx || !devpriv->ep_tx)
 		return -ENODEV;
 
+	if (usb_endpoint_maxp(devpriv->ep_rx) < RX_MAX_SIZE)
+		return -ENODEV;
+
+	if (usb_endpoint_maxp(devpriv->ep_tx) < TX_MAX_SIZE)
+		return -ENODEV;
+
 	return 0;
 }
 
-- 
2.32.0

