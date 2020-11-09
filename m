Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 348402ABB89
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732147AbgKINKm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:10:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:35958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731398AbgKINKj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:10:39 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D87F420663;
        Mon,  9 Nov 2020 13:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927438;
        bh=hsC/FcjwnIkkaHCSmTzFKRF6otCFQ+C6OZJCYFpWabQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tqrCaoffRdZn5MMTlwXzbKU0cE6wyv2QsD7oD6wcQ7prOKS/QIKV6nUkmhcsLCCXD
         p92mpqZlrFhozvWdJ3+AxKkSTI95/a9B0n5jkz2smv1NR7CJhdfPLokBPgnymXLUrF
         sYHw8aSzOxXuV6pYnz7yqhWfaAf7t9hhGPDs4IFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 59/71] USB: serial: cyberjack: fix write-URB completion race
Date:   Mon,  9 Nov 2020 13:55:53 +0100
Message-Id: <20201109125022.685409114@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125019.906191744@linuxfoundation.org>
References: <20201109125019.906191744@linuxfoundation.org>
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
@@ -357,11 +357,12 @@ static void cyberjack_write_bulk_callbac
 	struct device *dev = &port->dev;
 	int status = urb->status;
 	unsigned long flags;
+	bool resubmitted = false;
 
-	set_bit(0, &port->write_urbs_free);
 	if (status) {
 		dev_dbg(dev, "%s - nonzero write bulk status received: %d\n",
 			__func__, status);
+		set_bit(0, &port->write_urbs_free);
 		return;
 	}
 
@@ -394,6 +395,8 @@ static void cyberjack_write_bulk_callbac
 			goto exit;
 		}
 
+		resubmitted = true;
+
 		dev_dbg(dev, "%s - priv->wrsent=%d\n", __func__, priv->wrsent);
 		dev_dbg(dev, "%s - priv->wrfilled=%d\n", __func__, priv->wrfilled);
 
@@ -410,6 +413,8 @@ static void cyberjack_write_bulk_callbac
 
 exit:
 	spin_unlock_irqrestore(&priv->lock, flags);
+	if (!resubmitted)
+		set_bit(0, &port->write_urbs_free);
 	usb_serial_port_softint(port);
 }
 


