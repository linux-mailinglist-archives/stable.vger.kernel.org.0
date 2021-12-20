Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F72247AB71
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233837AbhLTOgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:36:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbhLTOgk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:36:40 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E625BC061751;
        Mon, 20 Dec 2021 06:36:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4265ECE10C2;
        Mon, 20 Dec 2021 14:36:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EBBEC36AE8;
        Mon, 20 Dec 2021 14:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640010996;
        bh=GVO5Gu+xnLDqK37U9kZFddBpwXRBzuylmk9VoVj15uI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gfDZ2TKEO+rYnmSdVAcgFPEvOBhzVwn5oVKQOqbmzArU90O3kOrnRTlpu406Mgeke
         Mk77Ggd/dYmT2OT/Jny5uTGwshec8B99ABKHHdbmVBEqLQZNfpBWHYAfUBf2yJq7G8
         Hfln58bjlBYDNw+P2q/AsQztpgiPwo7i2/jeuO8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: [PATCH 4.4 22/23] xen/console: harden hvc_xen against event channel storms
Date:   Mon, 20 Dec 2021 15:34:23 +0100
Message-Id: <20211220143018.562600705@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143017.842390782@linuxfoundation.org>
References: <20211220143017.842390782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit fe415186b43df0db1f17fa3a46275fd92107fe71 upstream.

The Xen console driver is still vulnerable for an attack via excessive
number of events sent by the backend. Fix that by using a lateeoi event
channel.

For the normal domU initial console this requires the introduction of
bind_evtchn_to_irq_lateeoi() as there is no xenbus device available
at the time the event channel is bound to the irq.

As the decision whether an interrupt was spurious or not requires to
test for bytes having been read from the backend, move sending the
event into the if statement, as sending an event without having found
any bytes to be read is making no sense at all.

This is part of XSA-391

Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/hvc/hvc_xen.c |   30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

--- a/drivers/tty/hvc/hvc_xen.c
+++ b/drivers/tty/hvc/hvc_xen.c
@@ -49,6 +49,8 @@ struct xencons_info {
 	struct xenbus_device *xbdev;
 	struct xencons_interface *intf;
 	unsigned int evtchn;
+	XENCONS_RING_IDX out_cons;
+	unsigned int out_cons_same;
 	struct hvc_struct *hvc;
 	int irq;
 	int vtermno;
@@ -150,6 +152,8 @@ static int domU_read_console(uint32_t vt
 	XENCONS_RING_IDX cons, prod;
 	int recv = 0;
 	struct xencons_info *xencons = vtermno_to_xencons(vtermno);
+	unsigned int eoiflag = 0;
+
 	if (xencons == NULL)
 		return -EINVAL;
 	intf = xencons->intf;
@@ -169,7 +173,27 @@ static int domU_read_console(uint32_t vt
 	mb();			/* read ring before consuming */
 	intf->in_cons = cons;
 
-	notify_daemon(xencons);
+	/*
+	 * When to mark interrupt having been spurious:
+	 * - there was no new data to be read, and
+	 * - the backend did not consume some output bytes, and
+	 * - the previous round with no read data didn't see consumed bytes
+	 *   (we might have a race with an interrupt being in flight while
+	 *   updating xencons->out_cons, so account for that by allowing one
+	 *   round without any visible reason)
+	 */
+	if (intf->out_cons != xencons->out_cons) {
+		xencons->out_cons = intf->out_cons;
+		xencons->out_cons_same = 0;
+	}
+	if (recv) {
+		notify_daemon(xencons);
+	} else if (xencons->out_cons_same++ > 1) {
+		eoiflag = XEN_EOI_FLAG_SPURIOUS;
+	}
+
+	xen_irq_lateeoi(xencons->irq, eoiflag);
+
 	return recv;
 }
 
@@ -391,7 +415,7 @@ static int xencons_connect_backend(struc
 	if (ret)
 		return ret;
 	info->evtchn = evtchn;
-	irq = bind_evtchn_to_irq(evtchn);
+	irq = bind_interdomain_evtchn_to_irq_lateeoi(dev->otherend_id, evtchn);
 	if (irq < 0)
 		return irq;
 	info->irq = irq;
@@ -555,7 +579,7 @@ static int __init xen_hvc_init(void)
 			return r;
 
 		info = vtermno_to_xencons(HVC_COOKIE);
-		info->irq = bind_evtchn_to_irq(info->evtchn);
+		info->irq = bind_evtchn_to_irq_lateeoi(info->evtchn);
 	}
 	if (info->irq < 0)
 		info->irq = 0; /* NO_IRQ */


