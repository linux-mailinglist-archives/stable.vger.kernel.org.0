Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECF2E324DBB
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 11:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234385AbhBYKNt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 05:13:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234459AbhBYKLt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 05:11:49 -0500
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEDC4C061786
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 02:11:08 -0800 (PST)
Received: by mail-qt1-x849.google.com with SMTP id d11so3668405qth.3
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 02:11:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=vBBpst1OMUzDZ1yOin+fylRpaLZ9STOMqxTxMjduIFY=;
        b=JcK9/z+zT9oSop0FCQgSBg/hUneZRjXhGjqgMEYT+QlcdoQX2BQMTvVGpek9tBJe0a
         Or8b+1q2Rk6Ag+YrxGZ3XQu6L/AvMZorHrrUAyfzWpD4GHj1N8FAGoqPwO+Kdzcg1P5d
         IpauStK7/GOYz53aTXnrSOKeQ4/7ldXMBbkjQfrwtYvDbw0HEUL3xPTyEvkvoU03zajN
         HWex374eOSxZHU3A9E8xbeVXkYIeAjofdN825OXhY2+ESMJElS9lA6BcMjybEpGtGiaa
         7ieptaZPyA7U+aEMpdYjXco9pY/FGoOFfXxQwKze5AS2Es5q4uzPHOFcndlKtP0Z5Pxr
         IgRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=vBBpst1OMUzDZ1yOin+fylRpaLZ9STOMqxTxMjduIFY=;
        b=GVGuyLe+oknLrsuNHnxKASfzXUrDatCH76GgTGo7oCAhaTZvIlnwlswNrkAJ7BxIcr
         O3+4y1B/DeTXnAW1Jf6NL6ncRivUlhTwzvHsgCLzGtghPZH1rLut4afQOChPYMRV01rI
         mAwBuxMLieAyBfuX90FZXACYRu/ANI6cl6/25d9PWqwXCsdeDoJIfFYkVF6EgiM9hb2k
         Cj+SmP6sQkWvVHCZ2FSDpnGZ1NwomK0siuMxZvToJ4YV+7QKpIwPe+WTT2t5St2jLdc3
         rbHEOhVN+krM5Lqg1IkkBruwMbdqgkHXskJqBaxSVC6Lz/WPOKUZvuyQYvi8Q8QF8ITR
         XcYg==
X-Gm-Message-State: AOAM531uH06qx412eoVqPIO3hOdGl016sDBxDV3Pa237CCXlg/p0fYb2
        O16XuOoTMkxZMsjT0hSt/93VfLs/vx8=
X-Google-Smtp-Source: ABdhPJxKI3qDnB2QSxLoINqD738OBp/E37Knoi6YydQAekxCNJ3A0J7+vMwyRc429eifeOy+vewSIf9ELXY=
Sender: "badhri via sendgmr" <badhri@badhri.mtv.corp.google.com>
X-Received: from badhri.mtv.corp.google.com ([2620:15c:211:201:7dfb:417e:ab68:1efb])
 (user=badhri job=sendgmr) by 2002:a05:6214:1a4a:: with SMTP id
 fi10mr1814634qvb.5.1614247867926; Thu, 25 Feb 2021 02:11:07 -0800 (PST)
Date:   Thu, 25 Feb 2021 02:11:04 -0800
Message-Id: <20210225101104.1680697-1-badhri@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.617.g56c4b15f3c-goog
Subject: [PATCH v3] usb: typec: tcpm: Wait for vbus discharge to VSAFE0V
 before toggling
From:   Badhri Jagan Sridharan <badhri@google.com>
To:     Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyle Tso <kyletso@google.com>, stable@vger.kernel.org,
        Badhri Jagan Sridharan <badhri@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When vbus auto discharge is enabled, TCPM can sometimes be faster than
the TCPC i.e. TCPM can go ahead and move the port to unattached state
(involves disabling vbus auto discharge) before TCPC could effectively
discharge vbus to VSAFE0V. This leaves vbus with residual charge and
increases the decay time which prevents tsafe0v from being met.
This change makes TCPM waits for a maximum of tSafe0V(max) for vbus
to discharge to VSAFE0V before transitioning to unattached state
and re-enable toggling. If vbus discharges to vsafe0v sooner, then,
transition to unattached state
happens right away.

Also, while in SNK_READY, when auto discharge is enabled, drive
disconnect based on vbus turning off instead of Rp disappearing on
CC pins. Rp disappearing on CC pins is almost instanteous compared
to vbus decay.

Sink detach:
[  541.703058] CC1: 3 -> 0, CC2: 0 -> 0 [state SNK_READY, polarity 0, disconnected]
[  541.703331] Setting voltage/current limit 5000 mV 0 mA
[  541.727235] VBUS on
[  541.749650] VBUS off
[  541.749653] pending state change SNK_READY -> SNK_UNATTACHED @ 650 ms [rev3 NONE_AMS]
[  541.749944] VBUS VSAFE0V
[  541.749945] state change SNK_READY -> SNK_UNATTACHED [rev3 NONE_AMS]
[  541.750806] Disable vbus discharge ret:0
[  541.907345] Start toggling
[  541.922799] CC1: 0 -> 0, CC2: 0 -> 0 [state TOGGLING, polarity 0, disconnected]

Source detach:
[ 2555.310414] state change SRC_SEND_CAPABILITIES -> SRC_READY [rev3 POWER_NEGOTIATION]
[ 2555.310675] AMS POWER_NEGOTIATION finished
[ 2555.310679] cc:=3
[ 2593.645886] CC1: 0 -> 0, CC2: 2 -> 0 [state SRC_READY, polarity 1, disconnected]
[ 2593.645919] pending state change SRC_READY -> SNK_UNATTACHED @ 650 ms [rev3 NONE_AMS]
[ 2593.648419] VBUS off
[ 2593.648960] VBUS VSAFE0V
[ 2593.648965] state change SRC_READY -> SNK_UNATTACHED [rev3 NONE_AMS]
[ 2593.649962] Disable vbus discharge ret:0
[ 2593.890322] Start toggling
[ 2593.925663] CC1: 0 -> 0, CC2: 0 -> 0 [state TOGGLING, polarity 0,

Fixes: f321a02caebd ("usb: typec: tcpm: Implement enabling Auto
Discharge disconnect support")
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
---
Changes since V1:
- Add Fixes tag

Changes since V2:
- Remove VBUS_DISCHARGE state as preferred by Guenter Roeck
---
 drivers/usb/typec/tcpm/tcpm.c | 75 ++++++++++++++++++++++++++++++-----
 1 file changed, 65 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index be0b6469dd3d..8469c37a59e1 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -438,6 +438,9 @@ struct tcpm_port {
 	enum tcpm_ams next_ams;
 	bool in_ams;
 
+	/* Auto vbus discharge status */
+	bool auto_vbus_discharge_enabled;
+
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *dentry;
 	struct mutex logbuffer_lock;	/* log buffer access lock */
@@ -507,6 +510,9 @@ static const char * const pd_rev[] = {
 	(tcpm_port_is_sink(port) && \
 	((port)->cc1 == TYPEC_CC_RP_3_0 || (port)->cc2 == TYPEC_CC_RP_3_0))
 
+#define tcpm_wait_for_discharge(port) \
+	(((port)->auto_vbus_discharge_enabled && !(port)->vbus_vsafe0v) ? PD_T_SAFE_0V : 0)
+
 static enum tcpm_state tcpm_default_state(struct tcpm_port *port)
 {
 	if (port->port_type == TYPEC_PORT_DRP) {
@@ -3413,6 +3419,8 @@ static int tcpm_src_attach(struct tcpm_port *port)
 	if (port->tcpc->enable_auto_vbus_discharge) {
 		ret = port->tcpc->enable_auto_vbus_discharge(port->tcpc, true);
 		tcpm_log_force(port, "enable vbus discharge ret:%d", ret);
+		if (!ret)
+			port->auto_vbus_discharge_enabled = true;
 	}
 
 	ret = tcpm_set_roles(port, true, TYPEC_SOURCE, tcpm_data_role_for_source(port));
@@ -3495,6 +3503,8 @@ static void tcpm_reset_port(struct tcpm_port *port)
 	if (port->tcpc->enable_auto_vbus_discharge) {
 		ret = port->tcpc->enable_auto_vbus_discharge(port->tcpc, false);
 		tcpm_log_force(port, "Disable vbus discharge ret:%d", ret);
+		if (!ret)
+			port->auto_vbus_discharge_enabled = false;
 	}
 	port->in_ams = false;
 	port->ams = NONE_AMS;
@@ -3568,6 +3578,8 @@ static int tcpm_snk_attach(struct tcpm_port *port)
 		tcpm_set_auto_vbus_discharge_threshold(port, TYPEC_PWR_MODE_USB, false, VSAFE5V);
 		ret = port->tcpc->enable_auto_vbus_discharge(port->tcpc, true);
 		tcpm_log_force(port, "enable vbus discharge ret:%d", ret);
+		if (!ret)
+			port->auto_vbus_discharge_enabled = true;
 	}
 
 	ret = tcpm_set_roles(port, true, TYPEC_SINK, tcpm_data_role_for_sink(port));
@@ -4670,9 +4682,9 @@ static void _tcpm_cc_change(struct tcpm_port *port, enum typec_cc_status cc1,
 		if (tcpm_port_is_disconnected(port) ||
 		    !tcpm_port_is_source(port)) {
 			if (port->port_type == TYPEC_PORT_SRC)
-				tcpm_set_state(port, SRC_UNATTACHED, 0);
+				tcpm_set_state(port, SRC_UNATTACHED, tcpm_wait_for_discharge(port));
 			else
-				tcpm_set_state(port, SNK_UNATTACHED, 0);
+				tcpm_set_state(port, SNK_UNATTACHED, tcpm_wait_for_discharge(port));
 		}
 		break;
 	case SNK_UNATTACHED:
@@ -4703,7 +4715,23 @@ static void _tcpm_cc_change(struct tcpm_port *port, enum typec_cc_status cc1,
 			tcpm_set_state(port, SNK_DEBOUNCED, 0);
 		break;
 	case SNK_READY:
-		if (tcpm_port_is_disconnected(port))
+		/*
+		 * EXIT condition is based primarily on vbus disconnect and CC is secondary.
+		 * "A port that has entered into USB PD communications with the Source and
+		 * has seen the CC voltage exceed vRd-USB may monitor the CC pin to detect
+		 * cable disconnect in addition to monitoring VBUS.
+		 *
+		 * A port that is monitoring the CC voltage for disconnect (but is not in
+		 * the process of a USB PD PR_Swap or USB PD FR_Swap) shall transition to
+		 * Unattached.SNK within tSinkDisconnect after the CC voltage remains below
+		 * vRd-USB for tPDDebounce."
+		 *
+		 * When set_auto_vbus_discharge_threshold is enabled, CC pins go
+		 * away before vbus decays to disconnect threshold. Allow
+		 * disconnect to be driven by vbus disconnect when auto vbus
+		 * discharge is enabled.
+		 */
+		if (!port->auto_vbus_discharge_enabled && tcpm_port_is_disconnected(port))
 			tcpm_set_state(port, unattached_state(port), 0);
 		else if (!port->pd_capable &&
 			 (cc1 != old_cc1 || cc2 != old_cc2))
@@ -4802,9 +4830,13 @@ static void _tcpm_cc_change(struct tcpm_port *port, enum typec_cc_status cc1,
 		 * Ignore CC changes here.
 		 */
 		break;
-
 	default:
-		if (tcpm_port_is_disconnected(port))
+		/*
+		 * While acting as sink and auto vbus discharge is enabled, Allow disconnect
+		 * to be driven by vbus disconnect.
+		 */
+		if (tcpm_port_is_disconnected(port) && !(port->pwr_role == TYPEC_SINK &&
+							 port->auto_vbus_discharge_enabled))
 			tcpm_set_state(port, unattached_state(port), 0);
 		break;
 	}
@@ -4968,8 +5000,16 @@ static void _tcpm_pd_vbus_off(struct tcpm_port *port)
 	case SRC_TRANSITION_SUPPLY:
 	case SRC_READY:
 	case SRC_WAIT_NEW_CAPABILITIES:
-		/* Force to unattached state to re-initiate connection */
-		tcpm_set_state(port, SRC_UNATTACHED, 0);
+		/*
+		 * Force to unattached state to re-initiate connection.
+		 * DRP port should move to Unattached.SNK instead of Unattached.SRC if
+		 * sink removed. Although sink removal here is due to source's vbus collapse,
+		 * treat it the same way for consistency.
+		 */
+		if (port->port_type == TYPEC_PORT_SRC)
+			tcpm_set_state(port, SRC_UNATTACHED, tcpm_wait_for_discharge(port));
+		else
+			tcpm_set_state(port, SNK_UNATTACHED, tcpm_wait_for_discharge(port));
 		break;
 
 	case PORT_RESET:
@@ -4988,9 +5028,8 @@ static void _tcpm_pd_vbus_off(struct tcpm_port *port)
 		break;
 
 	default:
-		if (port->pwr_role == TYPEC_SINK &&
-		    port->attached)
-			tcpm_set_state(port, SNK_UNATTACHED, 0);
+		if (port->pwr_role == TYPEC_SINK && port->attached)
+			tcpm_set_state(port, SNK_UNATTACHED, tcpm_wait_for_discharge(port));
 		break;
 	}
 }
@@ -5012,7 +5051,23 @@ static void _tcpm_pd_vbus_vsafe0v(struct tcpm_port *port)
 			tcpm_set_state(port, tcpm_try_snk(port) ? SNK_TRY : SRC_ATTACHED,
 				       PD_T_CC_DEBOUNCE);
 		break;
+	case SRC_STARTUP:
+	case SRC_SEND_CAPABILITIES:
+	case SRC_SEND_CAPABILITIES_TIMEOUT:
+	case SRC_NEGOTIATE_CAPABILITIES:
+	case SRC_TRANSITION_SUPPLY:
+	case SRC_READY:
+	case SRC_WAIT_NEW_CAPABILITIES:
+		if (port->auto_vbus_discharge_enabled) {
+			if (port->port_type == TYPEC_PORT_SRC)
+				tcpm_set_state(port, SRC_UNATTACHED, 0);
+			else
+				tcpm_set_state(port, SNK_UNATTACHED, 0);
+		}
+		break;
 	default:
+		if (port->pwr_role == TYPEC_SINK && port->auto_vbus_discharge_enabled)
+			tcpm_set_state(port, SNK_UNATTACHED, 0);
 		break;
 	}
 }
-- 
2.30.0.617.g56c4b15f3c-goog

