Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE10C30F8
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 12:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730244AbfJAKKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 06:10:37 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:15078 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729717AbfJAKKh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 06:10:37 -0400
X-IronPort-AV: E=Sophos;i="5.64,570,1559487600"; 
   d="scan'208";a="27788459"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 01 Oct 2019 19:10:34 +0900
Received: from localhost.localdomain (unknown [10.166.17.210])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 2DFE541F2F7A;
        Tue,  1 Oct 2019 19:10:34 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     balbi@kernel.org
Cc:     gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH 2/2] usb: renesas_usbhs: gadget: Fix usb_ep_set_{halt,wedge}() behavior
Date:   Tue,  1 Oct 2019 19:10:33 +0900
Message-Id: <1569924633-322-3-git-send-email-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1569924633-322-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
References: <1569924633-322-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

According to usb_ep_set_halt()'s description,
__usbhsg_ep_set_halt_wedge() should return -EAGAIN if the IN endpoint
has any queue or data. Otherwise, this driver is possible to cause
just STALL without sending a short packet data on g_mass_storage driver,
and then a few resetting a device happens on a host side during
a usb enumaration.

Fixes: 2f98382dcdfe ("usb: renesas_usbhs: Add Renesas USBHS Gadget")
Cc: <stable@vger.kernel.org> # v3.0+
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/usb/renesas_usbhs/common.h     |  1 +
 drivers/usb/renesas_usbhs/fifo.c       |  2 +-
 drivers/usb/renesas_usbhs/fifo.h       |  1 +
 drivers/usb/renesas_usbhs/mod_gadget.c | 16 +++++++++++++++-
 drivers/usb/renesas_usbhs/pipe.c       | 15 +++++++++++++++
 drivers/usb/renesas_usbhs/pipe.h       |  1 +
 6 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/renesas_usbhs/common.h b/drivers/usb/renesas_usbhs/common.h
index d1a0a35..0824099 100644
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
index 2a01ceb..86637cd 100644
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
index 88d1816..c3d3cc3 100644
--- a/drivers/usb/renesas_usbhs/fifo.h
+++ b/drivers/usb/renesas_usbhs/fifo.h
@@ -97,5 +97,6 @@ void usbhs_pkt_push(struct usbhs_pipe *pipe, struct usbhs_pkt *pkt,
 		    void *buf, int len, int zero, int sequence);
 struct usbhs_pkt *usbhs_pkt_pop(struct usbhs_pipe *pipe, struct usbhs_pkt *pkt);
 void usbhs_pkt_start(struct usbhs_pipe *pipe);
+struct usbhs_pkt *__usbhsf_pkt_get(struct usbhs_pipe *pipe);
 
 #endif /* RENESAS_USB_FIFO_H */
diff --git a/drivers/usb/renesas_usbhs/mod_gadget.c b/drivers/usb/renesas_usbhs/mod_gadget.c
index 2c7523a..e5ef569 100644
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
index c4922b9..9e5afdd 100644
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
index 3080423..3b13052 100644
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
2.7.4

