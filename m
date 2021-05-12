Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B545137CACD
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236152AbhELQcS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:32:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:41570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241165AbhELQ0q (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:26:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A535C61DC0;
        Wed, 12 May 2021 15:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834605;
        bh=S04EQrgtECeoZrHMs+nwqVe6h32HeztyAUbNvXZ17pw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pnfPH5zRFtGxwcFexSHaAJv8/yMTBgEBD073ujpZFffhx1wGYFAgJrMKwYseA6Qd9
         cxW2fjsbV3M0Mv8yiy8bvODbY9kQfCPprzq13I44xkXfROpaEvfGj66GHcbFCv8zCG
         vxChMAacrAAcI/afEAJOKMd4NDFqkVPAMWbZizLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.12 011/677] USB: serial: usb_wwan: fix TIOCSSERIAL jiffies conversions
Date:   Wed, 12 May 2021 16:40:57 +0200
Message-Id: <20210512144837.601495226@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 3d732690d2267f4d0e19077b178dffbedafdf0c9 upstream.

The port close_delay and closing_wait parameters set by TIOCSSERIAL are
specified in jiffies and not milliseconds.

Add the missing conversions so that the TIOCSSERIAL works as expected
also when HZ is not 1000.

Fixes: 02303f73373a ("usb-wwan: implement TIOCGSERIAL and TIOCSSERIAL to avoid blocking close(2)")
Cc: stable@vger.kernel.org      # 2.6.38
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/usb_wwan.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -140,10 +140,10 @@ int usb_wwan_get_serial_info(struct tty_
 	ss->line            = port->minor;
 	ss->port            = port->port_number;
 	ss->baud_base       = tty_get_baud_rate(port->port.tty);
-	ss->close_delay	    = port->port.close_delay / 10;
+	ss->close_delay	    = jiffies_to_msecs(port->port.close_delay) / 10;
 	ss->closing_wait    = port->port.closing_wait == ASYNC_CLOSING_WAIT_NONE ?
 				 ASYNC_CLOSING_WAIT_NONE :
-				 port->port.closing_wait / 10;
+				 jiffies_to_msecs(port->port.closing_wait) / 10;
 	return 0;
 }
 EXPORT_SYMBOL(usb_wwan_get_serial_info);
@@ -155,9 +155,10 @@ int usb_wwan_set_serial_info(struct tty_
 	unsigned int closing_wait, close_delay;
 	int retval = 0;
 
-	close_delay = ss->close_delay * 10;
+	close_delay = msecs_to_jiffies(ss->close_delay * 10);
 	closing_wait = ss->closing_wait == ASYNC_CLOSING_WAIT_NONE ?
-			ASYNC_CLOSING_WAIT_NONE : ss->closing_wait * 10;
+			ASYNC_CLOSING_WAIT_NONE :
+			msecs_to_jiffies(ss->closing_wait * 10);
 
 	mutex_lock(&port->port.mutex);
 


