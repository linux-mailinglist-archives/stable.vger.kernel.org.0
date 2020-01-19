Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA34141E52
	for <lists+stable@lfdr.de>; Sun, 19 Jan 2020 14:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgASNl2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jan 2020 08:41:28 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:37537 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726778AbgASNl2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Jan 2020 08:41:28 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id E6FE4338;
        Sun, 19 Jan 2020 08:41:27 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 19 Jan 2020 08:41:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=z6y9jJ
        x0KSJ6qxKhqgohmMFpFw8XNdunSGnmig4I7Bk=; b=h9qrkv+UHGx2RcImcFU9XI
        4JCqb3DqJk6y5zS9G6wLZ25lsMh1O3jqYkeq5xGsuXWmF4TVoLg7+w3Gf+on8HSE
        Po0KQlnpY2+OfT/A4KFSwMZV4beW95AlYb/hSNGVeRHCx7XcdhS5blbVxAHPHC1o
        Jk1TBxiSILNMSG6G0fHgjTwsQp4PYo8/nSdOsTwYea6KUf7+Fpj22L0fKdgBROaQ
        JntICOIpuuSGJKx1Tm0pq0IzNc/2M1tim++gZk8Eq3ClgNkAwDG3MPZhyKzg7mBO
        4hJ4fUzdgb04CBJlFyM008QbyyHSezXOvIxOeom+n7kJnG3NfpNv1AWnNrQ7BrGg
        ==
X-ME-Sender: <xms:h1wkXnYtDAO2GGmZaaR8OU-CuYfkIetIOFBxVRMyLF_hKQI2KxzQeA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefgdehgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeegrddvgedurdduleejrdeijeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepge
X-ME-Proxy: <xmx:h1wkXqpU9Br8jRJOTWWiQFqhdGczZm3iIYrVdF8gjgCBuPK9Td0FSQ>
    <xmx:h1wkXk-1ezghxY1JegTquMa0JsVYPuo3IBalvM3eFjcWLdwGSonVgg>
    <xmx:h1wkXh82ZOcLJvKPxDp8vPkrskRg1T_P7Mxh_UJBvgeknmzTSNyXBQ>
    <xmx:h1wkXpfACobMbWLavMQbW70c7JaF2nQub-3i6lnqr2Gzb0B3DTPSHw>
Received: from localhost (unknown [84.241.197.67])
        by mail.messagingengine.com (Postfix) with ESMTPA id DFE498005B;
        Sun, 19 Jan 2020 08:41:26 -0500 (EST)
Subject: FAILED: patch "[PATCH] USB: serial: keyspan: handle unbound ports" failed to apply to 4.9-stable tree
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 19 Jan 2020 14:41:16 +0100
Message-ID: <157944127621242@kroah.com>
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

