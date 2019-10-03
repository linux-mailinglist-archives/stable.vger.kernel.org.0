Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A718DCA91A
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404549AbfJCQh2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:37:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404571AbfJCQh1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:37:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 495112133F;
        Thu,  3 Oct 2019 16:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120645;
        bh=NJRqgMFb42gdLNeJHVaCND2GhjGKkjOwcp7MoysuOtY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M+COesCVuQs+j4RsJlJjRxqHpMTWYMMfF3pkcnUrODJfQeUDH9ntSTJeEbB0pcqbv
         8H8ubI3gJrk0R8tAyO0Wbn0X8P2XUdrvdke5DwV6VscnpXEq8UekzYrugaPffGaZD/
         boV3F/RoN/a3NVOjCEfHJ+gvzowCpOb6CFtRqCB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Camuso <tcamuso@redhat.com>,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 5.2 300/313] ipmi: move message error checking to avoid deadlock
Date:   Thu,  3 Oct 2019 17:54:38 +0200
Message-Id: <20191003154602.721839595@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Camuso <tcamuso@redhat.com>

commit 383035211c79d4d98481a09ad429b31c7dbf22bd upstream.

V1->V2: in handle_one_rcv_msg, if data_size > 2, set requeue to zero and
        goto out instead of calling ipmi_free_msg.
        Kosuke Tatsukawa <tatsu@ab.jp.nec.com>

In the source stack trace below, function set_need_watch tries to
take out the same si_lock that was taken earlier by ipmi_thread.

ipmi_thread() [drivers/char/ipmi/ipmi_si_intf.c:995]
 smi_event_handler() [drivers/char/ipmi/ipmi_si_intf.c:765]
  handle_transaction_done() [drivers/char/ipmi/ipmi_si_intf.c:555]
   deliver_recv_msg() [drivers/char/ipmi/ipmi_si_intf.c:283]
    ipmi_smi_msg_received() [drivers/char/ipmi/ipmi_msghandler.c:4503]
     intf_err_seq() [drivers/char/ipmi/ipmi_msghandler.c:1149]
      smi_remove_watch() [drivers/char/ipmi/ipmi_msghandler.c:999]
       set_need_watch() [drivers/char/ipmi/ipmi_si_intf.c:1066]

Upstream commit e1891cffd4c4896a899337a243273f0e23c028df adds code to
ipmi_smi_msg_received() to call smi_remove_watch() via intf_err_seq()
and this seems to be causing the deadlock.

commit e1891cffd4c4896a899337a243273f0e23c028df
Author: Corey Minyard <cminyard@mvista.com>
Date:   Wed Oct 24 15:17:04 2018 -0500
    ipmi: Make the smi watcher be disabled immediately when not needed

The fix is to put all messages in the queue and move the message
checking code out of ipmi_smi_msg_received and into handle_one_recv_msg,
which processes the message checking after ipmi_thread releases its
locks.

Additionally,Kosuke Tatsukawa <tatsu@ab.jp.nec.com> reported that
handle_new_recv_msgs calls ipmi_free_msg when handle_one_rcv_msg returns
zero, so that the call to ipmi_free_msg in handle_one_rcv_msg introduced
another panic when "ipmitool sensor list" was run in a loop. He
submitted this part of the patch.

+free_msg:
+               requeue = 0;
+               goto out;

Reported by: Osamu Samukawa <osa-samukawa@tg.jp.nec.com>
Characterized by: Kosuke Tatsukawa <tatsu@ab.jp.nec.com>
Signed-off-by: Tony Camuso <tcamuso@redhat.com>
Fixes: e1891cffd4c4 ("ipmi: Make the smi watcher be disabled immediately when not needed")
Cc: stable@vger.kernel.org # 5.1
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/ipmi/ipmi_msghandler.c |  114 ++++++++++++++++++------------------
 1 file changed, 57 insertions(+), 57 deletions(-)

--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -4215,7 +4215,53 @@ static int handle_one_recv_msg(struct ip
 	int chan;
 
 	ipmi_debug_msg("Recv:", msg->rsp, msg->rsp_size);
-	if (msg->rsp_size < 2) {
+
+	if ((msg->data_size >= 2)
+	    && (msg->data[0] == (IPMI_NETFN_APP_REQUEST << 2))
+	    && (msg->data[1] == IPMI_SEND_MSG_CMD)
+	    && (msg->user_data == NULL)) {
+
+		if (intf->in_shutdown)
+			goto free_msg;
+
+		/*
+		 * This is the local response to a command send, start
+		 * the timer for these.  The user_data will not be
+		 * NULL if this is a response send, and we will let
+		 * response sends just go through.
+		 */
+
+		/*
+		 * Check for errors, if we get certain errors (ones
+		 * that mean basically we can try again later), we
+		 * ignore them and start the timer.  Otherwise we
+		 * report the error immediately.
+		 */
+		if ((msg->rsp_size >= 3) && (msg->rsp[2] != 0)
+		    && (msg->rsp[2] != IPMI_NODE_BUSY_ERR)
+		    && (msg->rsp[2] != IPMI_LOST_ARBITRATION_ERR)
+		    && (msg->rsp[2] != IPMI_BUS_ERR)
+		    && (msg->rsp[2] != IPMI_NAK_ON_WRITE_ERR)) {
+			int ch = msg->rsp[3] & 0xf;
+			struct ipmi_channel *chans;
+
+			/* Got an error sending the message, handle it. */
+
+			chans = READ_ONCE(intf->channel_list)->c;
+			if ((chans[ch].medium == IPMI_CHANNEL_MEDIUM_8023LAN)
+			    || (chans[ch].medium == IPMI_CHANNEL_MEDIUM_ASYNC))
+				ipmi_inc_stat(intf, sent_lan_command_errs);
+			else
+				ipmi_inc_stat(intf, sent_ipmb_command_errs);
+			intf_err_seq(intf, msg->msgid, msg->rsp[2]);
+		} else
+			/* The message was sent, start the timer. */
+			intf_start_seq_timer(intf, msg->msgid);
+free_msg:
+		requeue = 0;
+		goto out;
+
+	} else if (msg->rsp_size < 2) {
 		/* Message is too small to be correct. */
 		dev_warn(intf->si_dev,
 			 "BMC returned too small a message for netfn %x cmd %x, got %d bytes\n",
@@ -4472,62 +4518,16 @@ void ipmi_smi_msg_received(struct ipmi_s
 	unsigned long flags = 0; /* keep us warning-free. */
 	int run_to_completion = intf->run_to_completion;
 
-	if ((msg->data_size >= 2)
-	    && (msg->data[0] == (IPMI_NETFN_APP_REQUEST << 2))
-	    && (msg->data[1] == IPMI_SEND_MSG_CMD)
-	    && (msg->user_data == NULL)) {
-
-		if (intf->in_shutdown)
-			goto free_msg;
-
-		/*
-		 * This is the local response to a command send, start
-		 * the timer for these.  The user_data will not be
-		 * NULL if this is a response send, and we will let
-		 * response sends just go through.
-		 */
-
-		/*
-		 * Check for errors, if we get certain errors (ones
-		 * that mean basically we can try again later), we
-		 * ignore them and start the timer.  Otherwise we
-		 * report the error immediately.
-		 */
-		if ((msg->rsp_size >= 3) && (msg->rsp[2] != 0)
-		    && (msg->rsp[2] != IPMI_NODE_BUSY_ERR)
-		    && (msg->rsp[2] != IPMI_LOST_ARBITRATION_ERR)
-		    && (msg->rsp[2] != IPMI_BUS_ERR)
-		    && (msg->rsp[2] != IPMI_NAK_ON_WRITE_ERR)) {
-			int ch = msg->rsp[3] & 0xf;
-			struct ipmi_channel *chans;
-
-			/* Got an error sending the message, handle it. */
-
-			chans = READ_ONCE(intf->channel_list)->c;
-			if ((chans[ch].medium == IPMI_CHANNEL_MEDIUM_8023LAN)
-			    || (chans[ch].medium == IPMI_CHANNEL_MEDIUM_ASYNC))
-				ipmi_inc_stat(intf, sent_lan_command_errs);
-			else
-				ipmi_inc_stat(intf, sent_ipmb_command_errs);
-			intf_err_seq(intf, msg->msgid, msg->rsp[2]);
-		} else
-			/* The message was sent, start the timer. */
-			intf_start_seq_timer(intf, msg->msgid);
-
-free_msg:
-		ipmi_free_smi_msg(msg);
-	} else {
-		/*
-		 * To preserve message order, we keep a queue and deliver from
-		 * a tasklet.
-		 */
-		if (!run_to_completion)
-			spin_lock_irqsave(&intf->waiting_rcv_msgs_lock, flags);
-		list_add_tail(&msg->link, &intf->waiting_rcv_msgs);
-		if (!run_to_completion)
-			spin_unlock_irqrestore(&intf->waiting_rcv_msgs_lock,
-					       flags);
-	}
+	/*
+	 * To preserve message order, we keep a queue and deliver from
+	 * a tasklet.
+	 */
+	if (!run_to_completion)
+		spin_lock_irqsave(&intf->waiting_rcv_msgs_lock, flags);
+	list_add_tail(&msg->link, &intf->waiting_rcv_msgs);
+	if (!run_to_completion)
+		spin_unlock_irqrestore(&intf->waiting_rcv_msgs_lock,
+				       flags);
 
 	if (!run_to_completion)
 		spin_lock_irqsave(&intf->xmit_msgs_lock, flags);


