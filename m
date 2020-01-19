Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7DD141E50
	for <lists+stable@lfdr.de>; Sun, 19 Jan 2020 14:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgASNkf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jan 2020 08:40:35 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:41005 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726778AbgASNkf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Jan 2020 08:40:35 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 8C4C6544;
        Sun, 19 Jan 2020 08:40:34 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 19 Jan 2020 08:40:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=TxggUX
        kHCMDTmH5BYut7JC9Ipswx8ob0hZtbUj9tuvs=; b=Kjmbhaxo9/EzxXjKnwOZY/
        XkpckAWXoIZ1u+NZlSJiiXzVvWMOwu3Hxj//Bp2O4bJQbTMeJmlDxxPWVPfjF2Qb
        AXW+h8+Ic6TrvZBFftt0xn8GQcC5uf9JZvIvV/O33P5AdplbSd2q/8V7shuebgA6
        u18kkjzQbH5BfB14eT8cYkT5fUtr4NGHvgRdUDry1IhuaIif1gcEqRhnizGJWY4h
        O6agMJGrOPJDD5/l4qAIHGJuBAk5Qb/TvoU+ANWuWkFavtClbYDDlBWLxrcld3ol
        IWl2MoCqSnJJm39cfsbzke9iqjI7Au7Lez104tPgvRNM2kCBT1F85+GB9JZd4C/A
        ==
X-ME-Sender: <xms:UlwkXlgccMLJ06e1rU84Gdz7lJRTEeWwoJoVfFtRzBsVLxB7HnT5Bg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefgdehgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeegrddvgedurdduleejrdeijeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:UlwkXrQCAfJbpA5OXkxi9xwlDN4LeEb8FJtkLWZODUGjkG2ozgm3Kg>
    <xmx:UlwkXt8x78W1xbup2crvJxc4qwQkgPMB8hf3VNne_fmy3RO7RSh3GQ>
    <xmx:UlwkXhSA9W1BbeZZT-Z0ad49R6JNWjbuRtulxnx8zmknq0UaTJiXRA>
    <xmx:UlwkXht1ihsqubmpPBtC0K2btI_kWnxG5AfXKcBR9MCflbLiwr9_0Q>
Received: from localhost (unknown [84.241.197.67])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8FA128005B;
        Sun, 19 Jan 2020 08:40:33 -0500 (EST)
Subject: FAILED: patch "[PATCH] USB: serial: io_edgeport: handle unbound ports on URB" failed to apply to 4.14-stable tree
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 19 Jan 2020 14:40:29 +0100
Message-ID: <15794412294018@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

