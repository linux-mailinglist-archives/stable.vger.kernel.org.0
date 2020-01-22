Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 311B8144FB9
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733064AbgAVJkf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:40:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:59492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729830AbgAVJke (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:40:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C1A824680;
        Wed, 22 Jan 2020 09:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579686034;
        bh=4xSggBom71ZWppoMRXV5xVbze0sm9tnLQ1xiq8TZmv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O5MJG71eGtHfxmo4ceACdBVGxNzeI5n7d9j+6MgR9S31cyfSb/U+7em8txlcMWDKC
         mLDJEUShCrhswF47LFquuFfg1y4bDUq0IaJF8sIARCNe9hhuWFBD0CsV5fhTkWuPQi
         OQBVH3wGwh8z0N9npTO+ZPvcIICeDqW5dyYGgtzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 017/103] USB: serial: quatech2: handle unbound ports
Date:   Wed, 22 Jan 2020 10:28:33 +0100
Message-Id: <20200122092806.279006595@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092803.587683021@linuxfoundation.org>
References: <20200122092803.587683021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 9715a43eea77e42678a1002623f2d9a78f5b81a1 upstream.

Check for NULL port data in the modem- and line-status handlers to avoid
dereferencing a NULL pointer in the unlikely case where a port device
isn't bound to a driver (e.g. after an allocation failure on port
probe).

Note that the other (stubbed) event handlers qt2_process_xmit_empty()
and qt2_process_flush() would need similar sanity checks in case they
are ever implemented.

Fixes: f7a33e608d9a ("USB: serial: add quatech2 usb to serial driver")
Cc: stable <stable@vger.kernel.org>     # 3.5
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/quatech2.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/serial/quatech2.c
+++ b/drivers/usb/serial/quatech2.c
@@ -864,7 +864,10 @@ static void qt2_update_msr(struct usb_se
 	u8 newMSR = (u8) *ch;
 	unsigned long flags;
 
+	/* May be called from qt2_process_read_urb() for an unbound port. */
 	port_priv = usb_get_serial_port_data(port);
+	if (!port_priv)
+		return;
 
 	spin_lock_irqsave(&port_priv->lock, flags);
 	port_priv->shadowMSR = newMSR;
@@ -892,7 +895,10 @@ static void qt2_update_lsr(struct usb_se
 	unsigned long flags;
 	u8 newLSR = (u8) *ch;
 
+	/* May be called from qt2_process_read_urb() for an unbound port. */
 	port_priv = usb_get_serial_port_data(port);
+	if (!port_priv)
+		return;
 
 	if (newLSR & UART_LSR_BI)
 		newLSR &= (u8) (UART_LSR_OE | UART_LSR_BI);


