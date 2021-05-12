Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1772F37C698
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234787AbhELPwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:52:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237128AbhELPsX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:48:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC35C619B9;
        Wed, 12 May 2021 15:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833083;
        bh=cSZ6jiRIpM+rhiZPSBxSI5LFsMht5N/A96dcLv926n8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yhnyNKg8npy3sDXlLaaAlRGmzTiIkoPWz6v9JjBqFnjqHbZ1dtUHv1Vx1BPSMzs1m
         actDtCHid1f5JZSdGpc11vBfJnn2RRmZkChxCbTWpSdXvgcYiVVmnY2kt/q1758Qqc
         5Masd+nEdtN/TDdsu2V3BDn93XRrCvY3pzSdlzQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.11 011/601] USB: serial: ti_usb_3410_5052: fix TIOCSSERIAL permission check
Date:   Wed, 12 May 2021 16:41:28 +0200
Message-Id: <20210512144828.192450956@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit d370c90dcd64e427a79a093a070117a1571d4cd8 upstream.

Changing the port closing-wait parameter is a privileged operation so
make sure to return -EPERM if a regular user tries to change it.

Cc: stable@vger.kernel.org
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/ti_usb_3410_5052.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -1420,14 +1420,19 @@ static int ti_set_serial_info(struct tty
 	struct serial_struct *ss)
 {
 	struct usb_serial_port *port = tty->driver_data;
-	struct ti_port *tport = usb_get_serial_port_data(port);
+	struct tty_port *tport = &port->port;
 	unsigned cwait;
 
 	cwait = ss->closing_wait;
 	if (cwait != ASYNC_CLOSING_WAIT_NONE)
 		cwait = msecs_to_jiffies(10 * ss->closing_wait);
 
-	tport->tp_port->port.closing_wait = cwait;
+	if (!capable(CAP_SYS_ADMIN)) {
+		if (cwait != tport->closing_wait)
+			return -EPERM;
+	}
+
+	tport->closing_wait = cwait;
 
 	return 0;
 }


