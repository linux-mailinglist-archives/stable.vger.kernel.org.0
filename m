Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85A02CBA90
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 14:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729034AbfJDMgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 08:36:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:53932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730150AbfJDMgu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 08:36:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6D4F20862;
        Fri,  4 Oct 2019 12:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570192609;
        bh=BOfXRCnRA4/btJtWiup9B7LnRmKDkNHbhg/ZYJ1ZNM0=;
        h=Subject:To:From:Date:From;
        b=2Qbvofdf8u7EGdfJhBA0dGtQUkbZciEL+DKPGfGNDGS0xJqpK2hdeqCBNyjZGxPiO
         c3G//C0BKOgdj0iC7J457HQ0z6brWxX3Vt3/bpxiMn+g7Rx31tMpBQga4DiSmmavgq
         kHIrR2NyBzsFeMQkh1rwBkhknO1j/HsX8KouWppA=
Subject: patch "usb: renesas_usbhs: gadget: Fix usb_ep_set_{halt,wedge}() behavior" added to usb-linus
To:     yoshihiro.shimoda.uh@renesas.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Oct 2019 14:36:38 +0200
Message-ID: <15701925984179@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: renesas_usbhs: gadget: Fix usb_ep_set_{halt,wedge}() behavior

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 4d599cd3a097a85a5c68a2c82b9a48cddf9953ec Mon Sep 17 00:00:00 2001
From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Date: Tue, 1 Oct 2019 19:10:33 +0900
Subject: usb: renesas_usbhs: gadget: Fix usb_ep_set_{halt,wedge}() behavior

According to usb_ep_set_halt()'s description,
__usbhsg_ep_set_halt_wedge() should return -EAGAIN if the IN endpoint
has any queue or data. Otherwise, this driver is possible to cause
just STALL without sending a short packet data on g_mass_storage driver,
and then a few resetting a device happens on a host side during
a usb enumaration.

Fixes: 2f98382dcdfe ("usb: renesas_usbhs: Add Renesas USBHS Gadget")
Cc: <stable@vger.kernel.org> # v3.0+
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/1569924633-322-3-git-send-email-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/renesas_usbhs/common.h     |  1 +
 drivers/usb/renesas_usbhs/fifo.c       |  2 +-
 drivers/usb/renesas_usbhs/fifo.h       |  1 +
 drivers/usb/renesas_usbhs/mod_gadget.c | 16 +++++++++++++++-
 drivers/usb/renesas_usbhs/pipe.c       | 15 +++++++++++++++
 drivers/usb/renesas_usbhs/pipe.h       |  1 +
 6 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/renesas_usbhs/common.h b/drivers/usb/renesas_usbhs/common.h
index d1a0a35ecfff..0824099b905e 100644
--- a/drivers/usb/renesas_usbhs/common.h
+++ b/drivers/usb/renesas_usbhs/common.h
@@ -211,6 +211,7 @@ struct usbhs_priv;
 /* DCPCTR */
 #define BSTS		(1 << 15)	/* Buffer Status */
 #define SUREQ		(1 << 14)	/* Sending SETUP Token */
+#define INBUFM		(1 << 14)	/* (PIPEnCTR) Transfer Buffer Monitor */
 #define CSSTS		(1 << 12)	/* CSSTS Status */
 #define	ACLRM		(1 << 9)	/* Buffer Auto-Clear Mode */
 #define SQCLR		(1 << 8)	/* Toggle Bit Clear */
diff --git a/drivers/usb/renesas_usbhs/fifo.c b/drivers/usb/renesas_usbhs/fifo.c
index 2a01ceb71641..86637cd066cf 100644
--- a/drivers/usb/renesas_usbhs/fifo.c
+++ b/drivers/usb/renesas_usbhs/fifo.c
@@ -89,7 +89,7 @@ static void __usbhsf_pkt_del(struct usbhs_pkt *pkt)
 	list_del_init(&pkt->node);
 }
 
-static struct usbhs_pkt *__usbhsf_pkt_get(struct usbhs_pipe *pipe)
+struct usbhs_pkt *__usbhsf_pkt_get(struct usbhs_pipe *pipe)
 {
 	return list_first_entry_or_null(&pipe->list, struct usbhs_pkt, node);
 }
diff --git a/drivers/usb/renesas_usbhs/fifo.h b/drivers/usb/renesas_usbhs/fifo.h
index 88d1816bcda2..c3d3cc35cee0 100644
--- a/drivers/usb/renesas_usbhs/fifo.h
+++ b/drivers/usb/renesas_usbhs/fifo.h
@@ -97,5 +97,6 @@ void usbhs_pkt_push(struct usbhs_pipe *pipe, struct usbhs_pkt *pkt,
 		    void *buf, int len, int zero, int sequence);
 struct usbhs_pkt *usbhs_pkt_pop(struct usbhs_pipe *pipe, struct usbhs_pkt *pkt);
 void usbhs_pkt_start(struct usbhs_pipe *pipe);
+struct usbhs_pkt *__usbhsf_pkt_get(struct usbhs_pipe *pipe);
 
 #endif /* RENESAS_USB_FIFO_H */
diff --git a/drivers/usb/renesas_usbhs/mod_gadget.c b/drivers/usb/renesas_usbhs/mod_gadget.c
index 2c7523a211c0..e5ef56991dba 100644
--- a/drivers/usb/renesas_usbhs/mod_gadget.c
+++ b/drivers/usb/renesas_usbhs/mod_gadget.c
@@ -722,6 +722,7 @@ static int __usbhsg_ep_set_halt_wedge(struct usb_ep *ep, int halt, int wedge)
 	struct usbhs_priv *priv = usbhsg_gpriv_to_priv(gpriv);
 	struct device *dev = usbhsg_gpriv_to_dev(gpriv);
 	unsigned long flags;
+	int ret = 0;
 
 	dev_dbg(dev, "set halt %d (pipe %d)\n",
 		halt, usbhs_pipe_number(pipe));
@@ -729,6 +730,18 @@ static int __usbhsg_ep_set_halt_wedge(struct usb_ep *ep, int halt, int wedge)
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
@@ -739,10 +752,11 @@ static int __usbhsg_ep_set_halt_wedge(struct usb_ep *ep, int halt, int wedge)
 	else
 		usbhsg_status_clr(gpriv, USBHSG_STATUS_WEDGE);
 
+out:
 	usbhs_unlock(priv, flags);
 	/********************  spin unlock ******************/
 
-	return 0;
+	return ret;
 }
 
 static int usbhsg_ep_set_halt(struct usb_ep *ep, int value)
diff --git a/drivers/usb/renesas_usbhs/pipe.c b/drivers/usb/renesas_usbhs/pipe.c
index c4922b96c93b..9e5afdde1adb 100644
--- a/drivers/usb/renesas_usbhs/pipe.c
+++ b/drivers/usb/renesas_usbhs/pipe.c
@@ -277,6 +277,21 @@ int usbhs_pipe_is_accessible(struct usbhs_pipe *pipe)
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
diff --git a/drivers/usb/renesas_usbhs/pipe.h b/drivers/usb/renesas_usbhs/pipe.h
index 3080423e600c..3b130529408b 100644
--- a/drivers/usb/renesas_usbhs/pipe.h
+++ b/drivers/usb/renesas_usbhs/pipe.h
@@ -83,6 +83,7 @@ void usbhs_pipe_clear(struct usbhs_pipe *pipe);
 void usbhs_pipe_clear_without_sequence(struct usbhs_pipe *pipe,
 				       int needs_bfre, int bfre_enable);
 int usbhs_pipe_is_accessible(struct usbhs_pipe *pipe);
+bool usbhs_pipe_contains_transmittable_data(struct usbhs_pipe *pipe);
 void usbhs_pipe_enable(struct usbhs_pipe *pipe);
 void usbhs_pipe_disable(struct usbhs_pipe *pipe);
 void usbhs_pipe_stall(struct usbhs_pipe *pipe);
-- 
2.23.0


