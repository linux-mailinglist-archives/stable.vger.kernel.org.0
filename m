Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6792ABC20
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730042AbgKINei (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:34:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:58534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730915AbgKINFo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:05:44 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA31F20789;
        Mon,  9 Nov 2020 13:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927143;
        bh=Q1sRCMBXDUGCSrwBBfw2+4HfaojHiRbvZygFs4rhdBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bky1uDcKr9gUHyQsHP9aIBG+33fnkdFe09YWH8KlHi90gWWo7K+qCl1RfnpQ6hVmP
         zmIeR5C+SaoTh/jh3cBs4Ra9dyOrdsMMyakOc02mmtAoPvx7+e++mvFzIzpXkfocbz
         9HKUwqBRxjIWAMBj80+DwF2MXAATSQ/qDC0ApXMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.9 112/117] USB: serial: cyberjack: fix write-URB completion race
Date:   Mon,  9 Nov 2020 13:55:38 +0100
Message-Id: <20201109125031.012382267@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125025.630721781@linuxfoundation.org>
References: <20201109125025.630721781@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 985616f0457d9f555fff417d0da56174f70cc14f upstream.

The write-URB busy flag was being cleared before the completion handler
was done with the URB, something which could lead to corrupt transfers
due to a racing write request if the URB is resubmitted.

Fixes: 507ca9bc0476 ("[PATCH] USB: add ability for usb-serial drivers to determine if their write urb is currently being used.")
Cc: stable <stable@vger.kernel.org>     # 2.6.13
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/cyberjack.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/cyberjack.c
+++ b/drivers/usb/serial/cyberjack.c
@@ -367,11 +367,12 @@ static void cyberjack_write_bulk_callbac
 	struct cyberjack_private *priv = usb_get_serial_port_data(port);
 	struct device *dev = &port->dev;
 	int status = urb->status;
+	bool resubmitted = false;
 
-	set_bit(0, &port->write_urbs_free);
 	if (status) {
 		dev_dbg(dev, "%s - nonzero write bulk status received: %d\n",
 			__func__, status);
+		set_bit(0, &port->write_urbs_free);
 		return;
 	}
 
@@ -404,6 +405,8 @@ static void cyberjack_write_bulk_callbac
 			goto exit;
 		}
 
+		resubmitted = true;
+
 		dev_dbg(dev, "%s - priv->wrsent=%d\n", __func__, priv->wrsent);
 		dev_dbg(dev, "%s - priv->wrfilled=%d\n", __func__, priv->wrfilled);
 
@@ -420,6 +423,8 @@ static void cyberjack_write_bulk_callbac
 
 exit:
 	spin_unlock(&priv->lock);
+	if (!resubmitted)
+		set_bit(0, &port->write_urbs_free);
 	usb_serial_port_softint(port);
 }
 


