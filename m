Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 626EC3AC3E6
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 08:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbhFRGcx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 02:32:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:38782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231461AbhFRGcw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Jun 2021 02:32:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA56C60C41;
        Fri, 18 Jun 2021 06:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623997843;
        bh=f8updBMLl7SAVHi1DSMwz/g7znKja7vQu+z56xZiJMs=;
        h=Subject:To:From:Date:From;
        b=flHwlaIz6kyp0Hj2wGpfWDNp3zb4tSW6idRHgIaUgO72eAISCGFig8b0rV9aePX1S
         5KEuCHqQqZe8C8KQEj8UJ0Ek/ENZrQNbHZ2KiH3QBNzCbQi1DXx758Z4O5wJr5DBxy
         FXUjiHD/SRMc9mkluEkzocj4pNUqWggexJNHljVU=
Subject: patch "usb: typec: tcpm: Relax disconnect threshold during power negotiation" added to usb-next
To:     kyletso@google.com, badhri@google.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 18 Jun 2021 08:30:23 +0200
Message-ID: <1623997823189227@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: tcpm: Relax disconnect threshold during power negotiation

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 2b537cf877eae6d2f2f102052290676e40b74a1d Mon Sep 17 00:00:00 2001
From: Kyle Tso <kyletso@google.com>
Date: Wed, 16 Jun 2021 17:01:02 +0800
Subject: usb: typec: tcpm: Relax disconnect threshold during power negotiation

If the voltage is being decreased in power negotiation, the Source will
set the power supply to operate at the new voltage level before sending
PS_RDY. Relax the threshold before sending Request Message so that it
will not race with Source which begins to adjust the voltage right after
it sends Accept Message (PPS) or tSrcTransition (25~35ms) after it sends
Accept Message (non-PPS).

The real threshold will be set after Sink receives PS_RDY Message.

Fixes: f321a02caebd ("usb: typec: tcpm: Implement enabling Auto Discharge disconnect support")
Cc: stable <stable@vger.kernel.org>
Cc: Badhri Jagan Sridharan <badhri@google.com>
Reviewed-by: Badhri Jagan Sridharan <badhri@google.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Kyle Tso <kyletso@google.com>
Link: https://lore.kernel.org/r/20210616090102.1897674-1-kyletso@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index e11e9227107d..5b22a1c931a9 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -2604,6 +2604,11 @@ static void tcpm_pd_ctrl_request(struct tcpm_port *port,
 			} else {
 				next_state = SNK_WAIT_CAPABILITIES;
 			}
+
+			/* Threshold was relaxed before sending Request. Restore it back. */
+			tcpm_set_auto_vbus_discharge_threshold(port, TYPEC_PWR_MODE_PD,
+							       port->pps_data.active,
+							       port->supply_voltage);
 			tcpm_set_state(port, next_state, 0);
 			break;
 		case SNK_NEGOTIATE_PPS_CAPABILITIES:
@@ -2617,6 +2622,11 @@ static void tcpm_pd_ctrl_request(struct tcpm_port *port,
 			    port->send_discover)
 				port->vdm_sm_running = true;
 
+			/* Threshold was relaxed before sending Request. Restore it back. */
+			tcpm_set_auto_vbus_discharge_threshold(port, TYPEC_PWR_MODE_PD,
+							       port->pps_data.active,
+							       port->supply_voltage);
+
 			tcpm_set_state(port, SNK_READY, 0);
 			break;
 		case DR_SWAP_SEND:
@@ -3336,6 +3346,12 @@ static int tcpm_pd_send_request(struct tcpm_port *port)
 	if (ret < 0)
 		return ret;
 
+	/*
+	 * Relax the threshold as voltage will be adjusted after Accept Message plus tSrcTransition.
+	 * It is safer to modify the threshold here.
+	 */
+	tcpm_set_auto_vbus_discharge_threshold(port, TYPEC_PWR_MODE_USB, false, 0);
+
 	memset(&msg, 0, sizeof(msg));
 	msg.header = PD_HEADER_LE(PD_DATA_REQUEST,
 				  port->pwr_role,
@@ -3433,6 +3449,9 @@ static int tcpm_pd_send_pps_request(struct tcpm_port *port)
 	if (ret < 0)
 		return ret;
 
+	/* Relax the threshold as voltage will be adjusted right after Accept Message. */
+	tcpm_set_auto_vbus_discharge_threshold(port, TYPEC_PWR_MODE_USB, false, 0);
+
 	memset(&msg, 0, sizeof(msg));
 	msg.header = PD_HEADER_LE(PD_DATA_REQUEST,
 				  port->pwr_role,
@@ -4196,6 +4215,10 @@ static void run_state_machine(struct tcpm_port *port)
 		port->hard_reset_count = 0;
 		ret = tcpm_pd_send_request(port);
 		if (ret < 0) {
+			/* Restore back to the original state */
+			tcpm_set_auto_vbus_discharge_threshold(port, TYPEC_PWR_MODE_PD,
+							       port->pps_data.active,
+							       port->supply_voltage);
 			/* Let the Source send capabilities again. */
 			tcpm_set_state(port, SNK_WAIT_CAPABILITIES, 0);
 		} else {
@@ -4206,6 +4229,10 @@ static void run_state_machine(struct tcpm_port *port)
 	case SNK_NEGOTIATE_PPS_CAPABILITIES:
 		ret = tcpm_pd_send_pps_request(port);
 		if (ret < 0) {
+			/* Restore back to the original state */
+			tcpm_set_auto_vbus_discharge_threshold(port, TYPEC_PWR_MODE_PD,
+							       port->pps_data.active,
+							       port->supply_voltage);
 			port->pps_status = ret;
 			/*
 			 * If this was called due to updates to sink
-- 
2.32.0


