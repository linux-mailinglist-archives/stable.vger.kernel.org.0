Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48D17141E4E
	for <lists+stable@lfdr.de>; Sun, 19 Jan 2020 14:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgASNka (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jan 2020 08:40:30 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:42347 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726778AbgASNka (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Jan 2020 08:40:30 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 40D66544;
        Sun, 19 Jan 2020 08:40:29 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 19 Jan 2020 08:40:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=yzulsE
        52YV33yRppOiIjc+9z5fFdxcOVyvb6Luh1ymc=; b=jrKnv4AYMR5ueXeFbIxz/D
        YrI5/DNcA/gbXCQrYLWLWENlZn/saHywKGVpO8biKr8xQin07D1DU4WFZUsVHJvk
        D36a/jixyWlhabTmh3zlkIOhzCj6kYkpVuTABjCIBt5QVU+9udA9FI8f8Dz2OYpo
        KLUTUDH8ocM9ZP274aCrmmPXFv9ZDeCPhoatr233c7LtF0R9modQTtvxfjqFV9Jm
        pvFT+mll/cxCM6RY1sebNkGYdtkWapvwxI/woi+Gu2iGI0jues/91GvYeirEWexg
        Fi+Yduglt2sn0BigjPPSFjwcvC6kLxe8lk6JIUzSvcPbCSmXd022SQHr1oS/n6TQ
        ==
X-ME-Sender: <xms:TFwkXsfBchByV5LjqOEaCjeqo5PKYGIpDaBwpScJgzaWY57u-L6RGA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefgdehgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeegrddvgedurdduleejrdeijeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:TFwkXlMMmLMCuVvbWsS4vUI82cAO5YBwnGdmxbQpOqqQfmttOyI0Ug>
    <xmx:TFwkXijfPddxFvkrb_qis2TcDv2fvf21fttY6-YY8pE2hl3uqS0zAw>
    <xmx:TFwkXg0C1n1xd03xBcEY4rS7zA3dBFAi1FC2bVTUk3tzw6vnLx1ztg>
    <xmx:TFwkXjMYweUSnQ24rzketuNV1EhfMMl4gvBveFlR0KQNNjmF5kWMFQ>
Received: from localhost (unknown [84.241.197.67])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2E3A48005B;
        Sun, 19 Jan 2020 08:40:28 -0500 (EST)
Subject: FAILED: patch "[PATCH] USB: serial: io_edgeport: handle unbound ports on URB" failed to apply to 4.9-stable tree
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 19 Jan 2020 14:40:26 +0100
Message-ID: <157944122699135@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e37d1aeda737a20b1846a91a3da3f8b0f00cf690 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Fri, 17 Jan 2020 10:50:23 +0100
Subject: [PATCH] USB: serial: io_edgeport: handle unbound ports on URB
 completion

Check for NULL port data in the shared interrupt and bulk completion
callbacks to avoid dereferencing a NULL pointer in case a device sends
data for a port device which isn't bound to a driver (e.g. due to a
malicious device having unexpected endpoints or after an allocation
failure on port probe).

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>

diff --git a/drivers/usb/serial/io_edgeport.c b/drivers/usb/serial/io_edgeport.c
index 9690a5f4b9d6..0582d78bdb1d 100644
--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -716,7 +716,7 @@ static void edge_interrupt_callback(struct urb *urb)
 			if (txCredits) {
 				port = edge_serial->serial->port[portNumber];
 				edge_port = usb_get_serial_port_data(port);
-				if (edge_port->open) {
+				if (edge_port && edge_port->open) {
 					spin_lock_irqsave(&edge_port->ep_lock,
 							  flags);
 					edge_port->txCredits += txCredits;
@@ -1825,7 +1825,7 @@ static void process_rcvd_data(struct edgeport_serial *edge_serial,
 				port = edge_serial->serial->port[
 							edge_serial->rxPort];
 				edge_port = usb_get_serial_port_data(port);
-				if (edge_port->open) {
+				if (edge_port && edge_port->open) {
 					dev_dbg(dev, "%s - Sending %d bytes to TTY for port %d\n",
 						__func__, rxLen,
 						edge_serial->rxPort);

