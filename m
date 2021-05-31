Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84345395CFD
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbhEaNki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:40:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:44928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232427AbhEaNib (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:38:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B07A6145A;
        Mon, 31 May 2021 13:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467605;
        bh=0wnNBbANBsd6lkhX/vBcStC+7yViCufrQT0mTSnML20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NPDAkwGMM0tS+a/CviSeehZbYoz8nYSr1Ovi39yfzSXVQhAWnQlUUG1mGnJOIG0ez
         2SEphN/VRfcNly1bLM9PXB/b/JLmUa/exYrFyhOmRVnTTfPbMKEjFl74UbKYbgCahZ
         3iSN52dJiOtdcNA6a5gf09yR+HT2Dsh0f2blUsXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 12/79] net: hso: fix control-request directions
Date:   Mon, 31 May 2021 15:13:57 +0200
Message-Id: <20210531130636.400148323@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130636.002722319@linuxfoundation.org>
References: <20210531130636.002722319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 1a6e9a9c68c1f183872e4bcc947382111c2e04eb upstream.

The direction of the pipe argument must match the request-type direction
bit or control requests may fail depending on the host-controller-driver
implementation.

Fix the tiocmset and rfkill requests which erroneously used
usb_rcvctrlpipe().

Fixes: 72dc1c096c70 ("HSO: add option hso driver")
Cc: stable@vger.kernel.org      # 2.6.27
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/hso.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -1701,7 +1701,7 @@ static int hso_serial_tiocmset(struct tt
 	spin_unlock_irqrestore(&serial->serial_lock, flags);
 
 	return usb_control_msg(serial->parent->usb,
-			       usb_rcvctrlpipe(serial->parent->usb, 0), 0x22,
+			       usb_sndctrlpipe(serial->parent->usb, 0), 0x22,
 			       0x21, val, if_num, NULL, 0,
 			       USB_CTRL_SET_TIMEOUT);
 }
@@ -2449,7 +2449,7 @@ static int hso_rfkill_set_block(void *da
 	if (hso_dev->usb_gone)
 		rv = 0;
 	else
-		rv = usb_control_msg(hso_dev->usb, usb_rcvctrlpipe(hso_dev->usb, 0),
+		rv = usb_control_msg(hso_dev->usb, usb_sndctrlpipe(hso_dev->usb, 0),
 				       enabled ? 0x82 : 0x81, 0x40, 0, 0, NULL, 0,
 				       USB_CTRL_SET_TIMEOUT);
 	mutex_unlock(&hso_dev->mutex);


