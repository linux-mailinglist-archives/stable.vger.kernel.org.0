Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5B9141E51
	for <lists+stable@lfdr.de>; Sun, 19 Jan 2020 14:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgASNlS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jan 2020 08:41:18 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:52567 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726778AbgASNlS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Jan 2020 08:41:18 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id E7C4C4B5;
        Sun, 19 Jan 2020 08:41:17 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 19 Jan 2020 08:41:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ymm3PM
        6Z3UhIQo9OtfTP6kf3LI7nIuPL5IVb4QgTTt0=; b=ox6aCbaNq4PYwcFJ+G/p+q
        AlOfxs/7DXuh1CwgC8QBfryiX5yxBeltlzsWvOtUL3QWN2xp+3sqXGLZM7UTMPUZ
        /FWJdyRaV8qRzLdwgqumATJ3AdGwIJKMvMiraEWk1Y1uUqGEKXdFdTDfKBTrnOfJ
        YDX5LjFnfusWc0JgYdWtf0YBy2n9s7XUSkjSTvk8fAj34fsdq7mfKSTaS1munJ8l
        UZ/0z12vD4BraDNUSWZBgwGMhVVYFC9SIIalFQXugmLBHvWGxke5uQVJ0ps1fAjk
        j6uqv/YBN1Mna2itIyRvarcVduV6N6KeS+/M5W46oz+1BSOdXYsN0xGMZnp2VTqQ
        ==
X-ME-Sender: <xms:fVwkXi-Eyg9NC1awIOEQxAY_RoVtR5MRiJ112rj5C16nZZ7ZCtzxJQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefgdehgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeegrddvgedurdduleejrdeijeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepfe
X-ME-Proxy: <xmx:fVwkXo3dZxTSoktY51M9qNBNNiD2tmho1pZKFbkaYosWa5Q9w-YlWg>
    <xmx:fVwkXqgrrQry9TIiArOhWMpZn9i9jjqWTNtC5EVVFMIUchVCyP_9Kw>
    <xmx:fVwkXi37I2OmQLW6kulau9eFKLUQvGuGnaQGijke0ond0W8YsQwBLA>
    <xmx:fVwkXlOnDLrI7HL1J5N2hCvB80d3jAlUiKFcO0cj0titoJl-gQieWw>
Received: from localhost (unknown [84.241.197.67])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0FC8F30607B4;
        Sun, 19 Jan 2020 08:41:16 -0500 (EST)
Subject: FAILED: patch "[PATCH] USB: serial: keyspan: handle unbound ports" failed to apply to 4.4-stable tree
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 19 Jan 2020 14:41:15 +0100
Message-ID: <15794412755032@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3018dd3fa114b13261e9599ddb5656ef97a1fa17 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Fri, 17 Jan 2020 10:50:25 +0100
Subject: [PATCH] USB: serial: keyspan: handle unbound ports

Check for NULL port data in the control URB completion handlers to avoid
dereferencing a NULL pointer in the unlikely case where a port device
isn't bound to a driver (e.g. after an allocation failure on port
probe()).

Fixes: 0ca1268e109a ("USB Serial Keyspan: add support for USA-49WG & USA-28XG")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>

diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index e66a59ef43a1..aa3dbce22cfb 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -1058,6 +1058,8 @@ static void	usa49_glocont_callback(struct urb *urb)
 	for (i = 0; i < serial->num_ports; ++i) {
 		port = serial->port[i];
 		p_priv = usb_get_serial_port_data(port);
+		if (!p_priv)
+			continue;
 
 		if (p_priv->resend_cont) {
 			dev_dbg(&port->dev, "%s - sending setup\n", __func__);
@@ -1459,6 +1461,8 @@ static void usa67_glocont_callback(struct urb *urb)
 	for (i = 0; i < serial->num_ports; ++i) {
 		port = serial->port[i];
 		p_priv = usb_get_serial_port_data(port);
+		if (!p_priv)
+			continue;
 
 		if (p_priv->resend_cont) {
 			dev_dbg(&port->dev, "%s - sending setup\n", __func__);

