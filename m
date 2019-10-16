Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF68FD9FF7
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392130AbfJPWG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:06:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:52202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438177AbfJPV6c (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:58:32 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB95621A49;
        Wed, 16 Oct 2019 21:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263111;
        bh=KJeaUX9OZHIh7PetQFr3dApcgZNl+G9DEPPwQcylEo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NXK5fruazsVN0mMear4djh/b+WojUswg91MjOMefPpaFkmm0LtD9clsiGSt0CzHs/
         pUEvW0K7XDm76fq/aZFqJrgbwHTHm3iVt3PSu5e3AnLuXncG+zNS5uNvKvOheCbEqr
         uTLqR0Rm0qU0PhmNJdW3GC0WpuiDZ4ApEQSs0kIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH 5.3 035/112] usb: renesas_usbhs: gadget: Fix usb_ep_set_{halt,wedge}() behavior
Date:   Wed, 16 Oct 2019 14:50:27 -0700
Message-Id: <20191016214853.635369099@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

commit 4d599cd3a097a85a5c68a2c82b9a48cddf9953ec upstream.

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
 drivers/usb/renesas_usbhs/common.h     |    1 +
 drivers/usb/renesas_usbhs/fifo.c       |    2 +-
 drivers/usb/renesas_usbhs/fifo.h       |    1 +
 drivers/usb/renesas_usbhs/mod_gadget.c |   16 +++++++++++++++-
 drivers/usb/renesas_usbhs/pipe.c       |   15 +++++++++++++++
 drivers/usb/renesas_usbhs/pipe.h       |    1 +
 6 files changed, 34 insertions(+), 2 deletions(-)

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
--- a/drivers/usb/renesas_usbhs/fifo.c
+++ b/drivers/usb/renesas_usbhs/fifo.c
@@ -89,7 +89,7 @@ static void __usbhsf_pkt_del(struct usbh
 	list_del_init(&pkt->node);
 }
 
-static struct usbhs_pkt *__usbhsf_pkt_get(struct usbhs_pipe *pipe)
+struct usbhs_pkt *__usbhsf_pkt_get(struct usbhs_pipe *pipe)
 {
 	return list_first_entry_or_null(&pipe->list, struct usbhs_pkt, node);
 }
--- a/drivers/usb/renesas_usbhs/fifo.h
+++ b/drivers/usb/renesas_usbhs/fifo.h
@@ -97,5 +97,6 @@ void usbhs_pkt_push(struct usbhs_pipe *p
 		    void *buf, int len, int zero, int sequence);
 struct usbhs_pkt *usbhs_pkt_pop(struct usbhs_pipe *pipe, struct usbhs_pkt *pkt);
 void usbhs_pkt_start(struct usbhs_pipe *pipe);
+struct usbhs_pkt *__usbhsf_pkt_get(struct usbhs_pipe *pipe);
 
 #endif /* RENESAS_USB_FIFO_H */
--- a/drivers/usb/renesas_usbhs/mod_gadget.c
+++ b/drivers/usb/renesas_usbhs/mod_gadget.c
@@ -722,6 +722,7 @@ static int __usbhsg_ep_set_halt_wedge(st
 	struct usbhs_priv *priv = usbhsg_gpriv_to_priv(gpriv);
 	struct device *dev = usbhsg_gpriv_to_dev(gpriv);
 	unsigned long flags;
+	int ret = 0;
 
 	dev_dbg(dev, "set halt %d (pipe %d)\n",
 		halt, usbhs_pipe_number(pipe));
@@ -729,6 +730,18 @@ static int __usbhsg_ep_set_halt_wedge(st
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
@@ -739,10 +752,11 @@ static int __usbhsg_ep_set_halt_wedge(st
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
@@ -277,6 +277,21 @@ int usbhs_pipe_is_accessible(struct usbh
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
@@ -83,6 +83,7 @@ void usbhs_pipe_clear(struct usbhs_pipe
 void usbhs_pipe_clear_without_sequence(struct usbhs_pipe *pipe,
 				       int needs_bfre, int bfre_enable);
 int usbhs_pipe_is_accessible(struct usbhs_pipe *pipe);
+bool usbhs_pipe_contains_transmittable_data(struct usbhs_pipe *pipe);
 void usbhs_pipe_enable(struct usbhs_pipe *pipe);
 void usbhs_pipe_disable(struct usbhs_pipe *pipe);
 void usbhs_pipe_stall(struct usbhs_pipe *pipe);


