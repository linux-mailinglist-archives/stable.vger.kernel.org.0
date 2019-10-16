Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2893DA141
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404665AbfJPWVQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:21:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:42624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437549AbfJPVxg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:53:36 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 013A821A49;
        Wed, 16 Oct 2019 21:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262816;
        bh=hAWu+T6xxZSWJW9eHpxIcsjfQTaROh8QsWgjRda+Fzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JhPVKora1rOUyG7ZNcqPtns7FOeP1w24uwn07ruOkZkOGyhEi6laU8EorBKL4ShBE
         TIl6TCkoZMBITemVjvpVVxHz0otKhvaM//JJSdZRGXyUY1b15b+Yu85C6XIqP6yLbb
         myuCMQIyh3j7nPlSCo1+hKRf9dqDNXIPPxDtcavc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH 4.4 58/79] usb: renesas_usbhs: gadget: Fix usb_ep_set_{halt,wedge}() behavior
Date:   Wed, 16 Oct 2019 14:50:33 -0700
Message-Id: <20191016214820.824426376@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214729.758892904@linuxfoundation.org>
References: <20191016214729.758892904@linuxfoundation.org>
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
@@ -213,6 +213,7 @@ struct usbhs_priv;
 /* DCPCTR */
 #define BSTS		(1 << 15)	/* Buffer Status */
 #define SUREQ		(1 << 14)	/* Sending SETUP Token */
+#define INBUFM		(1 << 14)	/* (PIPEnCTR) Transfer Buffer Monitor */
 #define CSSTS		(1 << 12)	/* CSSTS Status */
 #define	ACLRM		(1 << 9)	/* Buffer Auto-Clear Mode */
 #define SQCLR		(1 << 8)	/* Toggle Bit Clear */
--- a/drivers/usb/renesas_usbhs/fifo.c
+++ b/drivers/usb/renesas_usbhs/fifo.c
@@ -98,7 +98,7 @@ static void __usbhsf_pkt_del(struct usbh
 	list_del_init(&pkt->node);
 }
 
-static struct usbhs_pkt *__usbhsf_pkt_get(struct usbhs_pipe *pipe)
+struct usbhs_pkt *__usbhsf_pkt_get(struct usbhs_pipe *pipe)
 {
 	if (list_empty(&pipe->list))
 		return NULL;
--- a/drivers/usb/renesas_usbhs/fifo.h
+++ b/drivers/usb/renesas_usbhs/fifo.h
@@ -106,5 +106,6 @@ void usbhs_pkt_push(struct usbhs_pipe *p
 		    void *buf, int len, int zero, int sequence);
 struct usbhs_pkt *usbhs_pkt_pop(struct usbhs_pipe *pipe, struct usbhs_pkt *pkt);
 void usbhs_pkt_start(struct usbhs_pipe *pipe);
+struct usbhs_pkt *__usbhsf_pkt_get(struct usbhs_pipe *pipe);
 
 #endif /* RENESAS_USB_FIFO_H */
--- a/drivers/usb/renesas_usbhs/mod_gadget.c
+++ b/drivers/usb/renesas_usbhs/mod_gadget.c
@@ -731,6 +731,7 @@ static int __usbhsg_ep_set_halt_wedge(st
 	struct usbhs_priv *priv = usbhsg_gpriv_to_priv(gpriv);
 	struct device *dev = usbhsg_gpriv_to_dev(gpriv);
 	unsigned long flags;
+	int ret = 0;
 
 	dev_dbg(dev, "set halt %d (pipe %d)\n",
 		halt, usbhs_pipe_number(pipe));
@@ -738,6 +739,18 @@ static int __usbhsg_ep_set_halt_wedge(st
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
@@ -748,10 +761,11 @@ static int __usbhsg_ep_set_halt_wedge(st
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
@@ -279,6 +279,21 @@ int usbhs_pipe_is_accessible(struct usbh
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
@@ -89,6 +89,7 @@ void usbhs_pipe_init(struct usbhs_priv *
 int usbhs_pipe_get_maxpacket(struct usbhs_pipe *pipe);
 void usbhs_pipe_clear(struct usbhs_pipe *pipe);
 int usbhs_pipe_is_accessible(struct usbhs_pipe *pipe);
+bool usbhs_pipe_contains_transmittable_data(struct usbhs_pipe *pipe);
 void usbhs_pipe_enable(struct usbhs_pipe *pipe);
 void usbhs_pipe_disable(struct usbhs_pipe *pipe);
 void usbhs_pipe_stall(struct usbhs_pipe *pipe);


