Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42C671220F6
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfLQA7X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:59:23 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34752 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726729AbfLQAvg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:36 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15H-0003KX-EW; Tue, 17 Dec 2019 00:51:31 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15G-0005Tr-Dh; Tue, 17 Dec 2019 00:51:30 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Yoshihiro Shimoda" <yoshihiro.shimoda.uh@renesas.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date:   Tue, 17 Dec 2019 00:46:06 +0000
Message-ID: <lsq.1576543535.291854581@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 032/136] usb: renesas_usbhs: gadget: Fix
 usb_ep_set_{halt,wedge}() behavior
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

commit 4d599cd3a097a85a5c68a2c82b9a48cddf9953ec upstream.

According to usb_ep_set_halt()'s description,
__usbhsg_ep_set_halt_wedge() should return -EAGAIN if the IN endpoint
has any queue or data. Otherwise, this driver is possible to cause
just STALL without sending a short packet data on g_mass_storage driver,
and then a few resetting a device happens on a host side during
a usb enumaration.

Fixes: 2f98382dcdfe ("usb: renesas_usbhs: Add Renesas USBHS Gadget")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/1569924633-322-3-git-send-email-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/renesas_usbhs/common.h     |  1 +
 drivers/usb/renesas_usbhs/fifo.c       |  2 +-
 drivers/usb/renesas_usbhs/fifo.h       |  1 +
 drivers/usb/renesas_usbhs/mod_gadget.c | 16 +++++++++++++++-
 drivers/usb/renesas_usbhs/pipe.c       | 15 +++++++++++++++
 drivers/usb/renesas_usbhs/pipe.h       |  1 +
 6 files changed, 34 insertions(+), 2 deletions(-)

--- a/drivers/usb/renesas_usbhs/common.h
+++ b/drivers/usb/renesas_usbhs/common.h
@@ -207,6 +207,7 @@ struct usbhs_priv;
 /* DCPCTR */
 #define BSTS		(1 << 15)	/* Buffer Status */
 #define SUREQ		(1 << 14)	/* Sending SETUP Token */
+#define INBUFM		(1 << 14)	/* (PIPEnCTR) Transfer Buffer Monitor */
 #define CSSTS		(1 << 12)	/* CSSTS Status */
 #define	ACLRM		(1 << 9)	/* Buffer Auto-Clear Mode */
 #define SQCLR		(1 << 8)	/* Toggle Bit Clear */
--- a/drivers/usb/renesas_usbhs/fifo.c
+++ b/drivers/usb/renesas_usbhs/fifo.c
@@ -100,7 +100,7 @@ static void __usbhsf_pkt_del(struct usbh
 	list_del_init(&pkt->node);
 }
 
-static struct usbhs_pkt *__usbhsf_pkt_get(struct usbhs_pipe *pipe)
+struct usbhs_pkt *__usbhsf_pkt_get(struct usbhs_pipe *pipe)
 {
 	if (list_empty(&pipe->list))
 		return NULL;
--- a/drivers/usb/renesas_usbhs/fifo.h
+++ b/drivers/usb/renesas_usbhs/fifo.h
@@ -98,5 +98,6 @@ void usbhs_pkt_push(struct usbhs_pipe *p
 		    void *buf, int len, int zero, int sequence);
 struct usbhs_pkt *usbhs_pkt_pop(struct usbhs_pipe *pipe, struct usbhs_pkt *pkt);
 void usbhs_pkt_start(struct usbhs_pipe *pipe);
+struct usbhs_pkt *__usbhsf_pkt_get(struct usbhs_pipe *pipe);
 
 #endif /* RENESAS_USB_FIFO_H */
--- a/drivers/usb/renesas_usbhs/mod_gadget.c
+++ b/drivers/usb/renesas_usbhs/mod_gadget.c
@@ -704,6 +704,7 @@ static int __usbhsg_ep_set_halt_wedge(st
 	struct usbhs_priv *priv = usbhsg_gpriv_to_priv(gpriv);
 	struct device *dev = usbhsg_gpriv_to_dev(gpriv);
 	unsigned long flags;
+	int ret = 0;
 
 	dev_dbg(dev, "set halt %d (pipe %d)\n",
 		halt, usbhs_pipe_number(pipe));
@@ -711,6 +712,18 @@ static int __usbhsg_ep_set_halt_wedge(st
 	/********************  spin lock ********************/
 	usbhs_lock(priv, flags);
 
+	/*
+	 * According to usb_ep_set_halt()'s description, this function should
+	 * return -EAGAIN if the IN endpoint has any queue or data. Note
+	 * that the usbhs_pipe_is_dir_in() returns false if the pipe is an
+	 * IN endpoint in the gadget mode.
+	 */
+	if (!usbhs_pipe_is_dir_in(pipe) && (__usbhsf_pkt_get(pipe) ||
+	    usbhs_pipe_contains_transmittable_data(pipe))) {
+		ret = -EAGAIN;
+		goto out;
+	}
+
 	if (halt)
 		usbhs_pipe_stall(pipe);
 	else
@@ -721,10 +734,11 @@ static int __usbhsg_ep_set_halt_wedge(st
 	else
 		usbhsg_status_clr(gpriv, USBHSG_STATUS_WEDGE);
 
+out:
 	usbhs_unlock(priv, flags);
 	/********************  spin unlock ******************/
 
-	return 0;
+	return ret;
 }
 
 static int usbhsg_ep_set_halt(struct usb_ep *ep, int value)
--- a/drivers/usb/renesas_usbhs/pipe.c
+++ b/drivers/usb/renesas_usbhs/pipe.c
@@ -263,6 +263,21 @@ int usbhs_pipe_is_accessible(struct usbh
 	return -EBUSY;
 }
 
+bool usbhs_pipe_contains_transmittable_data(struct usbhs_pipe *pipe)
+{
+	u16 val;
+
+	/* Do not support for DCP pipe */
+	if (usbhs_pipe_is_dcp(pipe))
+		return false;
+
+	val = usbhsp_pipectrl_get(pipe);
+	if (val & INBUFM)
+		return true;
+
+	return false;
+}
+
 /*
  *		PID ctrl
  */
--- a/drivers/usb/renesas_usbhs/pipe.h
+++ b/drivers/usb/renesas_usbhs/pipe.h
@@ -85,6 +85,7 @@ void usbhs_pipe_init(struct usbhs_priv *
 int usbhs_pipe_get_maxpacket(struct usbhs_pipe *pipe);
 void usbhs_pipe_clear(struct usbhs_pipe *pipe);
 int usbhs_pipe_is_accessible(struct usbhs_pipe *pipe);
+bool usbhs_pipe_contains_transmittable_data(struct usbhs_pipe *pipe);
 void usbhs_pipe_enable(struct usbhs_pipe *pipe);
 void usbhs_pipe_disable(struct usbhs_pipe *pipe);
 void usbhs_pipe_stall(struct usbhs_pipe *pipe);

