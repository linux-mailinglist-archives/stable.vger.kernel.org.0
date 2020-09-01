Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2082595AC
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731943AbgIAPye (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:54:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:36172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730490AbgIAPq0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:46:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 095E820BED;
        Tue,  1 Sep 2020 15:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598975185;
        bh=zAPsgRXR/ow4nZHr2W8zICzNiPtKALjZlua3Etnbt+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AVvNYRD4BBcpLpamEifdM8H8qUiRL4I7dkmhs3roN74PbBqzRGb8lRIzUUPDXNdOx
         w8Y3l0CIzqYOfh4W22WdW3oSuEUmjCrrMFquBoDc52cyj/olJQGRNpx/VnYsxJnF8y
         hBN2xEVPdx2DHG1LogU3MYe/kJa1q3VkPhcjrGIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Badhri Jagan Sridharan <badhri@google.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        stable <stable@kernel.org>
Subject: [PATCH 5.8 242/255] usb: typec: tcpm: Fix Fix source hard reset response for TDA 2.3.1.1 and TDA 2.3.1.2 failures
Date:   Tue,  1 Sep 2020 17:11:38 +0200
Message-Id: <20200901151012.346859801@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Badhri Jagan Sridharan <badhri@google.com>

commit 23e26d0577535f5ffe4ff8ed6d06e009553c0bca upstream.

The patch addresses the compliance test failures while running  TDA
2.3.1.1 and  TDA 2.3.1.2 of the "PD Communications Engine USB PD
Compliance MOI" test plan published in https://www.usb.org/usbc.
For a product to be Type-C compliant, it's expected that these tests
are run on usb.org certified Type-C compliance tester as mentioned in
https://www.usb.org/usbc.

While the purpose of TDA 2.3.1.1 and  TDA 2.3.1.2 is to verify that
the static and dynamic electrical capabilities of a Source meet the
requirements for each PDO offered,  while doing so, the tests also
monitor that the timing of the VBUS waveform versus the messages meets
the requirements for Hard Reset defined in PROT-PROC-HR-TSTR as
mentioned in step 11 of TDA.2.3.1.1 and step 15 of TDA.2.3.1.2.

TDB.2.2.13.1: PROT-PROC-HR-TSTR Procedure and Checks for Tester
Originated Hard Reset
Purpose: To perform the appropriate protocol checks relating to any
circumstance in which the Hard Reset signal is sent by the Tester.

UUT is behaving as source:
The Tester sends a Hard Reset signal.
1. Check VBUS stays within present valid voltage range for
tPSHardReset min (25ms) after last bit of Hard Reset signal.
[PROT_PROC_HR_TSTR_1]
2. Check that VBUS starts to fall below present valid voltage range by
tPSHardReset max (35ms). [PROT_PROC_HR_TSTR_2]
3. Check that VBUS reaches vSafe0V within tSafe0v max (650 ms).
[PROT_PROC_HR_TSTR_3]
4. Check that VBUS starts rising to vSafe5V after a delay of
tSrcRecover (0.66s - 1s) from reaching vSafe0V. [PROT_PROC_HR_TSTR_4]
5. Check that VBUS reaches vSafe5V within tSrcTurnOn max (275ms) of
rising above vSafe0v max (0.8V). [PROT_PROC_HR_TSTR_5] Power Delivery
Compliance Plan 139 6. Check that Source Capabilities are finished
sending within tFirstSourceCap max (250ms) of VBUS reaching vSafe5v
min. [PROT_PROC_HR_TSTR_6].

This is in line with 7.1.5 Response to Hard Resets of the USB Power
Delivery Specification Revision 3.0, Version 1.2,
"Hard Reset Signaling indicates a communication failure has occurred
and the Source Shall stop driving VCONN, Shall remove Rp from the
VCONN pin and Shall drive VBUS to vSafe0V as shown in Figure 7-9. The
USB connection May reset during a Hard Reset since the VBUS voltage
will be less than vSafe5V for an extended period of time. After
establishing the vSafe0V voltage condition on VBUS, the Source Shall
wait tSrcRecover before re-applying VCONN and restoring VBUS to
vSafe5V. A Source Shall conform to the VCONN timing as specified in
[USB Type-C 1.3]."

With the above guidelines from the spec in mind, TCPM does not turn
off VCONN while entering SRC_HARD_RESET_VBUS_OFF. The patch makes TCPM
turn off VCONN while entering SRC_HARD_RESET_VBUS_OFF and turn it back
on while entering SRC_HARD_RESET_VBUS_ON along with vbus instead of
having VCONN on through hardreset.

Also, the spec clearly states that "After establishing the vSafe0V
voltage condition on VBUS",  the Source Shall wait tSrcRecover before
re-applying VCONN and restoring VBUS to vSafe5V.
TCPM does not conform to this requirement. If the TCPC driver calls
tcpm_vbus_change with vbus off signal, TCPM right away enters
SRC_HARD_RESET_VBUS_ON without waiting for tSrcRecover.
For TCPC's which are buggy/does not call tcpm_vbus_change, TCPM
assumes that the vsafe0v is instantaneous as TCPM only waits
tSrcRecover instead of waiting for tSafe0v + tSrcRecover.
This patch also fixes this behavior by making sure that TCPM waits for
tSrcRecover before transitioning into SRC_HARD_RESET_VBUS_ON when
tcpm_vbus_change is called by TCPC.
When TCPC does not call tcpm_vbus_change, TCPM assumes the worst case
i.e.  tSafe0v + tSrcRecover before transitioning into
SRC_HARD_RESET_VBUS_ON.

Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20200817184601.1899929-1-badhri@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/typec/tcpm/tcpm.c |   28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -3321,13 +3321,31 @@ static void run_state_machine(struct tcp
 			tcpm_set_state(port, SNK_HARD_RESET_SINK_OFF, 0);
 		break;
 	case SRC_HARD_RESET_VBUS_OFF:
-		tcpm_set_vconn(port, true);
+		/*
+		 * 7.1.5 Response to Hard Resets
+		 * Hard Reset Signaling indicates a communication failure has occurred and the
+		 * Source Shall stop driving VCONN, Shall remove Rp from the VCONN pin and Shall
+		 * drive VBUS to vSafe0V as shown in Figure 7-9.
+		 */
+		tcpm_set_vconn(port, false);
 		tcpm_set_vbus(port, false);
 		tcpm_set_roles(port, port->self_powered, TYPEC_SOURCE,
 			       tcpm_data_role_for_source(port));
-		tcpm_set_state(port, SRC_HARD_RESET_VBUS_ON, PD_T_SRC_RECOVER);
+		/*
+		 * If tcpc fails to notify vbus off, TCPM will wait for PD_T_SAFE_0V +
+		 * PD_T_SRC_RECOVER before turning vbus back on.
+		 * From Table 7-12 Sequence Description for a Source Initiated Hard Reset:
+		 * 4. Policy Engine waits tPSHardReset after sending Hard Reset Signaling and then
+		 * tells the Device Policy Manager to instruct the power supply to perform a
+		 * Hard Reset. The transition to vSafe0V Shall occur within tSafe0V (t2).
+		 * 5. After tSrcRecover the Source applies power to VBUS in an attempt to
+		 * re-establish communication with the Sink and resume USB Default Operation.
+		 * The transition to vSafe5V Shall occur within tSrcTurnOn(t4).
+		 */
+		tcpm_set_state(port, SRC_HARD_RESET_VBUS_ON, PD_T_SAFE_0V + PD_T_SRC_RECOVER);
 		break;
 	case SRC_HARD_RESET_VBUS_ON:
+		tcpm_set_vconn(port, true);
 		tcpm_set_vbus(port, true);
 		port->tcpc->set_pd_rx(port->tcpc, true);
 		tcpm_set_attached_state(port, true);
@@ -3887,7 +3905,11 @@ static void _tcpm_pd_vbus_off(struct tcp
 		tcpm_set_state(port, SNK_HARD_RESET_WAIT_VBUS, 0);
 		break;
 	case SRC_HARD_RESET_VBUS_OFF:
-		tcpm_set_state(port, SRC_HARD_RESET_VBUS_ON, 0);
+		/*
+		 * After establishing the vSafe0V voltage condition on VBUS, the Source Shall wait
+		 * tSrcRecover before re-applying VCONN and restoring VBUS to vSafe5V.
+		 */
+		tcpm_set_state(port, SRC_HARD_RESET_VBUS_ON, PD_T_SRC_RECOVER);
 		break;
 	case HARD_RESET_SEND:
 		break;


