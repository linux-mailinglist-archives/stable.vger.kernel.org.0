Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E11A544C7B9
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232974AbhKJSyi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 13:54:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:48126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233169AbhKJSwp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:52:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E106D61381;
        Wed, 10 Nov 2021 18:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636570094;
        bh=r9c4M28T/B5cCe7kYAPWH6EhTTjF4No8DvsRibfL7NY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=btGiTFuC9k2H/cf0PZrI18iGAdtBcK4aqc6mO6GFFnqyvEu6zPkJXwwzaRGY46mzq
         gbU+iVTN2UKTri+WuBl5loD5632ZrU2fSOjFmKMoZg2WuhnTZ/DnS7t97b4dIm18sU
         Ep9Qa4VguyvKyUAZycGq+qLNialDe+divoGRB4IY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Ellero <luca.ellero@brickedbrain.com>,
        Ian Abbott <abbotti@mev.co.uk>, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 14/21] comedi: ni_usb6501: fix NULL-deref in command paths
Date:   Wed, 10 Nov 2021 19:44:00 +0100
Message-Id: <20211110182003.416780824@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110182002.964190708@linuxfoundation.org>
References: <20211110182002.964190708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 907767da8f3a925b060c740e0b5c92ea7dbec440 upstream.

The driver uses endpoint-sized USB transfer buffers but had no sanity
checks on the sizes. This can lead to zero-size-pointer dereferences or
overflowed transfer buffers in ni6501_port_command() and
ni6501_counter_command() if a (malicious) device has smaller max-packet
sizes than expected (or when doing descriptor fuzz testing).

Add the missing sanity checks to probe().

Fixes: a03bb00e50ab ("staging: comedi: add NI USB-6501 support")
Cc: stable@vger.kernel.org      # 3.18
Cc: Luca Ellero <luca.ellero@brickedbrain.com>
Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20211027093529.30896-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_usb6501.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/staging/comedi/drivers/ni_usb6501.c
+++ b/drivers/staging/comedi/drivers/ni_usb6501.c
@@ -144,6 +144,10 @@ static const u8 READ_COUNTER_RESPONSE[]
 					   0x00, 0x00, 0x00, 0x02,
 					   0x00, 0x00, 0x00, 0x00};
 
+/* Largest supported packets */
+static const size_t TX_MAX_SIZE	= sizeof(SET_PORT_DIR_REQUEST);
+static const size_t RX_MAX_SIZE	= sizeof(READ_PORT_RESPONSE);
+
 enum commands {
 	READ_PORT,
 	WRITE_PORT,
@@ -501,6 +505,12 @@ static int ni6501_find_endpoints(struct
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
 


