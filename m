Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 375006A7328
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 19:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbjCASNQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 13:13:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbjCASNP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 13:13:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1BCE1BD5
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 10:13:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F012B810C3
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:13:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3C3C433EF;
        Wed,  1 Mar 2023 18:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677694392;
        bh=PM7yIo6WWB961FSKIHXPIaFJQdskuFJ+i7dppETSpr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=usJln/tkFuXKslAHVZvsF3BUEV4vI/orRc5txGmdkHbNulo1RSNvb0vggtjNgwHwG
         b6lhmUlQ1RCrPUNPRF8ifK1QP4/AHu7I4csfGxNc5P8FdBdNKCiA/abksmx92YxCR0
         CiW+9zbZUsSxjmUEfRPeFUpbwlDuCkUh7RXyGnC8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable <stable@kernel.org>,
        Prashanth K <quic_prashk@quicinc.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.1 32/42] usb: gadget: u_serial: Add null pointer check in gserial_resume
Date:   Wed,  1 Mar 2023 19:08:53 +0100
Message-Id: <20230301180658.507070710@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>
References: <20230301180657.003689969@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prashanth K <quic_prashk@quicinc.com>

commit 5ec63fdbca604568890c577753c6f66c5b3ef0b5 upstream.

Consider a case where gserial_disconnect has already cleared
gser->ioport. And if a wakeup interrupt triggers afterwards,
gserial_resume gets called, which will lead to accessing of
gser->ioport and thus causing null pointer dereference.Add
a null pointer check to prevent this.

Added a static spinlock to prevent gser->ioport from becoming
null after the newly added check.

Fixes: aba3a8d01d62 ("usb: gadget: u_serial: add suspend resume callbacks")
Cc: stable <stable@kernel.org>
Signed-off-by: Prashanth K <quic_prashk@quicinc.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/1676309438-14922-1-git-send-email-quic_prashk@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/u_serial.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

--- a/drivers/usb/gadget/function/u_serial.c
+++ b/drivers/usb/gadget/function/u_serial.c
@@ -81,6 +81,9 @@
 #define WRITE_BUF_SIZE		8192		/* TX only */
 #define GS_CONSOLE_BUF_SIZE	8192
 
+/* Prevents race conditions while accessing gser->ioport */
+static DEFINE_SPINLOCK(serial_port_lock);
+
 /* console info */
 struct gs_console {
 	struct console		console;
@@ -1374,8 +1377,10 @@ void gserial_disconnect(struct gserial *
 	if (!port)
 		return;
 
+	spin_lock_irqsave(&serial_port_lock, flags);
+
 	/* tell the TTY glue not to do I/O here any more */
-	spin_lock_irqsave(&port->port_lock, flags);
+	spin_lock(&port->port_lock);
 
 	gs_console_disconnect(port);
 
@@ -1390,7 +1395,8 @@ void gserial_disconnect(struct gserial *
 			tty_hangup(port->port.tty);
 	}
 	port->suspended = false;
-	spin_unlock_irqrestore(&port->port_lock, flags);
+	spin_unlock(&port->port_lock);
+	spin_unlock_irqrestore(&serial_port_lock, flags);
 
 	/* disable endpoints, aborting down any active I/O */
 	usb_ep_disable(gser->out);
@@ -1424,10 +1430,19 @@ EXPORT_SYMBOL_GPL(gserial_suspend);
 
 void gserial_resume(struct gserial *gser)
 {
-	struct gs_port *port = gser->ioport;
+	struct gs_port *port;
 	unsigned long	flags;
 
-	spin_lock_irqsave(&port->port_lock, flags);
+	spin_lock_irqsave(&serial_port_lock, flags);
+	port = gser->ioport;
+
+	if (!port) {
+		spin_unlock_irqrestore(&serial_port_lock, flags);
+		return;
+	}
+
+	spin_lock(&port->port_lock);
+	spin_unlock(&serial_port_lock);
 	port->suspended = false;
 	if (!port->start_delayed) {
 		spin_unlock_irqrestore(&port->port_lock, flags);


