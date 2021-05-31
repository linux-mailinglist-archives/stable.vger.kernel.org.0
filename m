Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2983D395B2E
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbhEaNSM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:18:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231539AbhEaNSI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:18:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E952F6136D;
        Mon, 31 May 2021 13:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622466987;
        bh=nSPxMGueoan15cqTgN2FSxdGVBhwNcyfBM02WQWe3pc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PRx0e9AkB10A7BFlpLV+kYuPqkIIuRmErw6hdeLdxq3GTtGFeOn1EltLaoP1G1vb6
         IUWQcxQ7P2QGF1R/it00wySxsglPSoSHbJb36SDk/8FeDKfHdYgveqq1kI/ACzCaMS
         HHuvpBPyQ2NMSR7IZxSxhw4h5Y3bzkmnm5Zs3bqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 05/54] net: hso: fix control-request directions
Date:   Mon, 31 May 2021 15:13:31 +0200
Message-Id: <20210531130635.243555317@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130635.070310929@linuxfoundation.org>
References: <20210531130635.070310929@linuxfoundation.org>
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
@@ -1710,7 +1710,7 @@ static int hso_serial_tiocmset(struct tt
 	spin_unlock_irqrestore(&serial->serial_lock, flags);
 
 	return usb_control_msg(serial->parent->usb,
-			       usb_rcvctrlpipe(serial->parent->usb, 0), 0x22,
+			       usb_sndctrlpipe(serial->parent->usb, 0), 0x22,
 			       0x21, val, if_num, NULL, 0,
 			       USB_CTRL_SET_TIMEOUT);
 }
@@ -2461,7 +2461,7 @@ static int hso_rfkill_set_block(void *da
 	if (hso_dev->usb_gone)
 		rv = 0;
 	else
-		rv = usb_control_msg(hso_dev->usb, usb_rcvctrlpipe(hso_dev->usb, 0),
+		rv = usb_control_msg(hso_dev->usb, usb_sndctrlpipe(hso_dev->usb, 0),
 				       enabled ? 0x82 : 0x81, 0x40, 0, 0, NULL, 0,
 				       USB_CTRL_SET_TIMEOUT);
 	mutex_unlock(&hso_dev->mutex);


