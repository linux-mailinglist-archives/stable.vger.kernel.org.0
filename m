Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5345A3F8834
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 14:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241738AbhHZNAL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 09:00:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:34118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232667AbhHZNAK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Aug 2021 09:00:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A761B60F39;
        Thu, 26 Aug 2021 12:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629982763;
        bh=9yTU2pjRUyhaiPZLbWuwnvPDIzpBf5ZVDV0QU+h1v50=;
        h=Subject:To:From:Date:From;
        b=J4mtv1RvX9Wk1hZyXfsb8s8afH7soP8HwyBPkFb+0LCnli+EMQg6HRcFPcS2ci+JN
         nlKfYtyvFasAo/7XP2rwE+Lu4KKD6sl6zmlIRCym4y4yzj+ljM+trtvI+eMydiN4FE
         EWKWExNXgLX17DCF2JnAXoemGoAbrcVuP9Rm1FEU=
Subject: patch "usb: typec: tcpm: Raise vdm_sm_running flag only when VDM SM is" added to usb-linus
To:     kyletso@google.com, badhri@google.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, linux@roeck-us.net,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 26 Aug 2021 14:59:19 +0200
Message-ID: <162998275982177@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: tcpm: Raise vdm_sm_running flag only when VDM SM is

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From ef52b4a9fcc24e17e81cc60357e6107ae4e9c48e Mon Sep 17 00:00:00 2001
From: Kyle Tso <kyletso@google.com>
Date: Thu, 26 Aug 2021 20:42:01 +0800
Subject: usb: typec: tcpm: Raise vdm_sm_running flag only when VDM SM is
 running

If the port is going to send Discover_Identity Message, vdm_sm_running
flag was intentionally set before entering Ready States in order to
avoid the conflict because the port and the port partner might start
AMS at almost the same time after entering Ready States.

However, the original design has a problem. When the port is doing
DR_SWAP from Device to Host, it raises the flag. Later in the
tcpm_send_discover_work, the flag blocks the procedure of sending the
Discover_Identity and it might never be cleared until disconnection.

Since there exists another flag send_discover representing that the port
is going to send Discover_Identity or not, it is enough to use that flag
to prevent the conflict. Also change the timing of the set/clear of
vdm_sm_running to indicate whether the VDM SM is actually running or
not.

Fixes: c34e85fa69b9 ("usb: typec: tcpm: Send DISCOVER_IDENTITY from dedicated work")
Cc: stable <stable@vger.kernel.org>
Cc: Badhri Jagan Sridharan <badhri@google.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Kyle Tso <kyletso@google.com>
Link: https://lore.kernel.org/r/20210826124201.1562502-1-kyletso@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c | 81 ++++++++++++++++-------------------
 1 file changed, 38 insertions(+), 43 deletions(-)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index f4079b5cb26d..5d05de666597 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -341,6 +341,7 @@ struct tcpm_port {
 	bool vbus_source;
 	bool vbus_charge;
 
+	/* Set to true when Discover_Identity Command is expected to be sent in Ready states. */
 	bool send_discover;
 	bool op_vsafe5v;
 
@@ -370,6 +371,7 @@ struct tcpm_port {
 	struct hrtimer send_discover_timer;
 	struct kthread_work send_discover_work;
 	bool state_machine_running;
+	/* Set to true when VDM State Machine has following actions. */
 	bool vdm_sm_running;
 
 	struct completion tx_complete;
@@ -1431,6 +1433,7 @@ static void tcpm_queue_vdm(struct tcpm_port *port, const u32 header,
 	/* Set ready, vdm state machine will actually send */
 	port->vdm_retries = 0;
 	port->vdm_state = VDM_STATE_READY;
+	port->vdm_sm_running = true;
 
 	mod_vdm_delayed_work(port, 0);
 }
@@ -1673,7 +1676,6 @@ static int tcpm_pd_svdm(struct tcpm_port *port, struct typec_altmode *adev,
 				rlen = 1;
 			} else {
 				tcpm_register_partner_altmodes(port);
-				port->vdm_sm_running = false;
 			}
 			break;
 		case CMD_ENTER_MODE:
@@ -1721,14 +1723,12 @@ static int tcpm_pd_svdm(struct tcpm_port *port, struct typec_altmode *adev,
 				      (VDO_SVDM_VERS(svdm_version));
 			break;
 		}
-		port->vdm_sm_running = false;
 		break;
 	default:
 		response[0] = p[0] | VDO_CMDT(CMDT_RSP_NAK);
 		rlen = 1;
 		response[0] = (response[0] & ~VDO_SVDM_VERS_MASK) |
 			      (VDO_SVDM_VERS(svdm_version));
-		port->vdm_sm_running = false;
 		break;
 	}
 
@@ -1769,6 +1769,20 @@ static void tcpm_handle_vdm_request(struct tcpm_port *port,
 	}
 
 	if (PD_VDO_SVDM(p[0]) && (adev || tcpm_vdm_ams(port) || port->nr_snk_vdo)) {
+		/*
+		 * Here a SVDM is received (INIT or RSP or unknown). Set the vdm_sm_running in
+		 * advance because we are dropping the lock but may send VDMs soon.
+		 * For the cases of INIT received:
+		 *  - If no response to send, it will be cleared later in this function.
+		 *  - If there are responses to send, it will be cleared in the state machine.
+		 * For the cases of RSP received:
+		 *  - If no further INIT to send, it will be cleared later in this function.
+		 *  - Otherwise, it will be cleared in the state machine if timeout or it will go
+		 *    back here until no further INIT to send.
+		 * For the cases of unknown type received:
+		 *  - We will send NAK and the flag will be cleared in the state machine.
+		 */
+		port->vdm_sm_running = true;
 		rlen = tcpm_pd_svdm(port, adev, p, cnt, response, &adev_action);
 	} else {
 		if (port->negotiated_rev >= PD_REV30)
@@ -1837,6 +1851,8 @@ static void tcpm_handle_vdm_request(struct tcpm_port *port,
 
 	if (rlen > 0)
 		tcpm_queue_vdm(port, response[0], &response[1], rlen - 1);
+	else
+		port->vdm_sm_running = false;
 }
 
 static void tcpm_send_vdm(struct tcpm_port *port, u32 vid, int cmd,
@@ -1902,8 +1918,10 @@ static void vdm_run_state_machine(struct tcpm_port *port)
 		 * if there's traffic or we're not in PDO ready state don't send
 		 * a VDM.
 		 */
-		if (port->state != SRC_READY && port->state != SNK_READY)
+		if (port->state != SRC_READY && port->state != SNK_READY) {
+			port->vdm_sm_running = false;
 			break;
+		}
 
 		/* TODO: AMS operation for Unstructured VDM */
 		if (PD_VDO_SVDM(vdo_hdr) && PD_VDO_CMDT(vdo_hdr) == CMDT_INIT) {
@@ -2556,10 +2574,6 @@ static void tcpm_pd_ctrl_request(struct tcpm_port *port,
 								       TYPEC_PWR_MODE_PD,
 								       port->pps_data.active,
 								       port->supply_voltage);
-				/* Set VDM running flag ASAP */
-				if (port->data_role == TYPEC_HOST &&
-				    port->send_discover)
-					port->vdm_sm_running = true;
 				tcpm_set_state(port, SNK_READY, 0);
 			} else {
 				/*
@@ -2597,14 +2611,10 @@ static void tcpm_pd_ctrl_request(struct tcpm_port *port,
 		switch (port->state) {
 		case SNK_NEGOTIATE_CAPABILITIES:
 			/* USB PD specification, Figure 8-43 */
-			if (port->explicit_contract) {
+			if (port->explicit_contract)
 				next_state = SNK_READY;
-				if (port->data_role == TYPEC_HOST &&
-				    port->send_discover)
-					port->vdm_sm_running = true;
-			} else {
+			else
 				next_state = SNK_WAIT_CAPABILITIES;
-			}
 
 			/* Threshold was relaxed before sending Request. Restore it back. */
 			tcpm_set_auto_vbus_discharge_threshold(port, TYPEC_PWR_MODE_PD,
@@ -2619,10 +2629,6 @@ static void tcpm_pd_ctrl_request(struct tcpm_port *port,
 			port->pps_status = (type == PD_CTRL_WAIT ?
 					    -EAGAIN : -EOPNOTSUPP);
 
-			if (port->data_role == TYPEC_HOST &&
-			    port->send_discover)
-				port->vdm_sm_running = true;
-
 			/* Threshold was relaxed before sending Request. Restore it back. */
 			tcpm_set_auto_vbus_discharge_threshold(port, TYPEC_PWR_MODE_PD,
 							       port->pps_data.active,
@@ -2698,10 +2704,6 @@ static void tcpm_pd_ctrl_request(struct tcpm_port *port,
 			}
 			break;
 		case DR_SWAP_SEND:
-			if (port->data_role == TYPEC_DEVICE &&
-			    port->send_discover)
-				port->vdm_sm_running = true;
-
 			tcpm_set_state(port, DR_SWAP_CHANGE_DR, 0);
 			break;
 		case PR_SWAP_SEND:
@@ -2739,7 +2741,7 @@ static void tcpm_pd_ctrl_request(struct tcpm_port *port,
 					   PD_MSG_CTRL_NOT_SUPP,
 					   NONE_AMS);
 		} else {
-			if (port->vdm_sm_running) {
+			if (port->send_discover) {
 				tcpm_queue_message(port, PD_MSG_CTRL_WAIT);
 				break;
 			}
@@ -2755,7 +2757,7 @@ static void tcpm_pd_ctrl_request(struct tcpm_port *port,
 					   PD_MSG_CTRL_NOT_SUPP,
 					   NONE_AMS);
 		} else {
-			if (port->vdm_sm_running) {
+			if (port->send_discover) {
 				tcpm_queue_message(port, PD_MSG_CTRL_WAIT);
 				break;
 			}
@@ -2764,7 +2766,7 @@ static void tcpm_pd_ctrl_request(struct tcpm_port *port,
 		}
 		break;
 	case PD_CTRL_VCONN_SWAP:
-		if (port->vdm_sm_running) {
+		if (port->send_discover) {
 			tcpm_queue_message(port, PD_MSG_CTRL_WAIT);
 			break;
 		}
@@ -4480,18 +4482,20 @@ static void run_state_machine(struct tcpm_port *port)
 	/* DR_Swap states */
 	case DR_SWAP_SEND:
 		tcpm_pd_send_control(port, PD_CTRL_DR_SWAP);
+		if (port->data_role == TYPEC_DEVICE || port->negotiated_rev > PD_REV20)
+			port->send_discover = true;
 		tcpm_set_state_cond(port, DR_SWAP_SEND_TIMEOUT,
 				    PD_T_SENDER_RESPONSE);
 		break;
 	case DR_SWAP_ACCEPT:
 		tcpm_pd_send_control(port, PD_CTRL_ACCEPT);
-		/* Set VDM state machine running flag ASAP */
-		if (port->data_role == TYPEC_DEVICE && port->send_discover)
-			port->vdm_sm_running = true;
+		if (port->data_role == TYPEC_DEVICE || port->negotiated_rev > PD_REV20)
+			port->send_discover = true;
 		tcpm_set_state_cond(port, DR_SWAP_CHANGE_DR, 0);
 		break;
 	case DR_SWAP_SEND_TIMEOUT:
 		tcpm_swap_complete(port, -ETIMEDOUT);
+		port->send_discover = false;
 		tcpm_ams_finish(port);
 		tcpm_set_state(port, ready_state(port), 0);
 		break;
@@ -4503,7 +4507,6 @@ static void run_state_machine(struct tcpm_port *port)
 		} else {
 			tcpm_set_roles(port, true, port->pwr_role,
 				       TYPEC_HOST);
-			port->send_discover = true;
 		}
 		tcpm_ams_finish(port);
 		tcpm_set_state(port, ready_state(port), 0);
@@ -4646,8 +4649,6 @@ static void run_state_machine(struct tcpm_port *port)
 		break;
 	case VCONN_SWAP_SEND_TIMEOUT:
 		tcpm_swap_complete(port, -ETIMEDOUT);
-		if (port->data_role == TYPEC_HOST && port->send_discover)
-			port->vdm_sm_running = true;
 		tcpm_set_state(port, ready_state(port), 0);
 		break;
 	case VCONN_SWAP_START:
@@ -4663,14 +4664,10 @@ static void run_state_machine(struct tcpm_port *port)
 	case VCONN_SWAP_TURN_ON_VCONN:
 		tcpm_set_vconn(port, true);
 		tcpm_pd_send_control(port, PD_CTRL_PS_RDY);
-		if (port->data_role == TYPEC_HOST && port->send_discover)
-			port->vdm_sm_running = true;
 		tcpm_set_state(port, ready_state(port), 0);
 		break;
 	case VCONN_SWAP_TURN_OFF_VCONN:
 		tcpm_set_vconn(port, false);
-		if (port->data_role == TYPEC_HOST && port->send_discover)
-			port->vdm_sm_running = true;
 		tcpm_set_state(port, ready_state(port), 0);
 		break;
 
@@ -4678,8 +4675,6 @@ static void run_state_machine(struct tcpm_port *port)
 	case PR_SWAP_CANCEL:
 	case VCONN_SWAP_CANCEL:
 		tcpm_swap_complete(port, port->swap_status);
-		if (port->data_role == TYPEC_HOST && port->send_discover)
-			port->vdm_sm_running = true;
 		if (port->pwr_role == TYPEC_SOURCE)
 			tcpm_set_state(port, SRC_READY, 0);
 		else
@@ -5029,9 +5024,6 @@ static void _tcpm_pd_vbus_on(struct tcpm_port *port)
 	switch (port->state) {
 	case SNK_TRANSITION_SINK_VBUS:
 		port->explicit_contract = true;
-		/* Set the VDM flag ASAP */
-		if (port->data_role == TYPEC_HOST && port->send_discover)
-			port->vdm_sm_running = true;
 		tcpm_set_state(port, SNK_READY, 0);
 		break;
 	case SNK_DISCOVERY:
@@ -5426,15 +5418,18 @@ static void tcpm_send_discover_work(struct kthread_work *work)
 	if (!port->send_discover)
 		goto unlock;
 
+	if (port->data_role == TYPEC_DEVICE && port->negotiated_rev < PD_REV30) {
+		port->send_discover = false;
+		goto unlock;
+	}
+
 	/* Retry if the port is not idle */
 	if ((port->state != SRC_READY && port->state != SNK_READY) || port->vdm_sm_running) {
 		mod_send_discover_delayed_work(port, SEND_DISCOVER_RETRY_MS);
 		goto unlock;
 	}
 
-	/* Only send the Message if the port is host for PD rev2.0 */
-	if (port->data_role == TYPEC_HOST || port->negotiated_rev > PD_REV20)
-		tcpm_send_vdm(port, USB_SID_PD, CMD_DISCOVER_IDENT, NULL, 0);
+	tcpm_send_vdm(port, USB_SID_PD, CMD_DISCOVER_IDENT, NULL, 0);
 
 unlock:
 	mutex_unlock(&port->lock);
-- 
2.32.0


