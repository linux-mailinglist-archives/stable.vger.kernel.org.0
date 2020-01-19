Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0885141E4F
	for <lists+stable@lfdr.de>; Sun, 19 Jan 2020 14:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgASNkd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jan 2020 08:40:33 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:47687 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726778AbgASNkd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Jan 2020 08:40:33 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 24031560;
        Sun, 19 Jan 2020 08:40:32 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 19 Jan 2020 08:40:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=9/3I6B
        x2tmHiUcU3n9qFyLw1t25n0WruWW3t15LQ9Dc=; b=LkC7A/P4ZxSFGaqBIcOFAR
        eGmmIkBxTEUa7BUYdDTBIDoumQwbm1mGYGg35lW4iJ33Mbd7o8ArgFKa/a9Zqg9F
        tVG9Zoo3LerseyLOEkdrrMJisEyVMc60X8cJdS3KZZEKcwPfyLOuqFShYxAQUFMA
        vyhtyD2ZL/nqnkmnscRCM125eNe8m/EzIVkWfWa4q41KjXMCpFcuPe3xss2iMesv
        /MdjOjVO5OwgZNzKZGs3ghxNCWegIISlx9OD3YJwu1FxJiY2Qp3DqDd8sakukEkN
        DO9uHFRnya+maD8aT4YjvATdfdnJJikEZ1bq9GKIJ+79x8+cz/5T9/LaEpmOXysg
        ==
X-ME-Sender: <xms:T1wkXgc-ljQyML3mAcu9d58QZkyIMEBhzkdbgY1iC-HwwBt9PgY8pA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefgdehgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeegrddvgedurdduleejrdeijeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:T1wkXuagIY-NMVkGpR9dlAUdkFTPvTxJqVhzUJrv66F71_yFOEGS_A>
    <xmx:T1wkXkbchmphvr680zKghDteD3WgUwGZ-okeaSnlE4KJqcT2fsTAqw>
    <xmx:T1wkXkmw3iXBKztN4iPGMazquzHjhggM97H-dVreJIqDho9qwXy4XA>
    <xmx:T1wkXg9GeAX9O5-G8pLz1aItHfPSyM2sCHeiPlZq-LFrKoP6QbPKeQ>
Received: from localhost (unknown [84.241.197.67])
        by mail.messagingengine.com (Postfix) with ESMTPA id 328823060ACE;
        Sun, 19 Jan 2020 08:40:31 -0500 (EST)
Subject: FAILED: patch "[PATCH] USB: serial: io_edgeport: handle unbound ports on URB" failed to apply to 4.4-stable tree
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 19 Jan 2020 14:40:27 +0100
Message-ID: <157944122793195@kroah.com>
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

