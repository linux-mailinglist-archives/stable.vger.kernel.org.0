Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD816359FBC
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 15:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbhDINYD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 09:24:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:58758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231127AbhDINYB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 09:24:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E252761105;
        Fri,  9 Apr 2021 13:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617974628;
        bh=vm6sRSqDwLS2IfTkICVqUdgVJKMeiZ98DzbCWz0PyPI=;
        h=Subject:To:From:Date:From;
        b=MDrdQeBVIudeDm8cIVwbUWb+0yVsZYopGYXIaR9zjiwBH/Q36dZXAP+7+kfVMiWNt
         2es7yk5v9vyUu2A3HsIWNukKx0FAlKaGd41qjL87XzLY4OhBVJ+RSNQ7h0Ml5vPruk
         t//xrIHeOrqBsUXOWOwtar4m3PO2l/TXoYybrTq4=
Subject: patch "usb: typec: tcpm: Address incorrect values of tcpm psy for pps supply" added to usb-testing
To:     badhri@google.com, Adam.Thomson.Opensource@diasemi.com,
        gregkh@linuxfoundation.org, heikki.krogerus@linux.intel.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 09 Apr 2021 15:23:35 +0200
Message-ID: <1617974615115153@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: tcpm: Address incorrect values of tcpm psy for pps supply

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From e3a0720224873587954b55d193d5b4abb14f0443 Mon Sep 17 00:00:00 2001
From: Badhri Jagan Sridharan <badhri@google.com>
Date: Wed, 7 Apr 2021 13:07:19 -0700
Subject: usb: typec: tcpm: Address incorrect values of tcpm psy for pps supply

tcpm_pd_select_pps_apdo overwrites port->pps_data.min_volt,
port->pps_data.max_volt, port->pps_data.max_curr even before
port partner accepts the requests. This leaves incorrect values
in current_limit and supply_voltage that get exported by
"tcpm-source-psy-". Solving this problem by caching the request
values in req_min_volt, req_max_volt, req_max_curr, req_out_volt,
req_op_curr. min_volt, max_volt, max_curr gets updated once the
partner accepts the request. current_limit, supply_voltage gets updated
once local port's tcpm enters SNK_TRANSITION_SINK when the accepted
current_limit and supply_voltage is enforced.

Fixes: f2a8aa053c176 ("typec: tcpm: Represent source supply through power_supply")
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20210407200723.1914388-2-badhri@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c | 88 +++++++++++++++++++++--------------
 1 file changed, 53 insertions(+), 35 deletions(-)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index 4ea4b30ae885..b4a40099d7e9 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -268,12 +268,27 @@ struct pd_mode_data {
 	struct typec_altmode_desc altmode_desc[ALTMODE_DISCOVERY_MAX];
 };
 
+/*
+ * @min_volt: Actual min voltage at the local port
+ * @req_min_volt: Requested min voltage to the port partner
+ * @max_volt: Actual max voltage at the local port
+ * @req_max_volt: Requested max voltage to the port partner
+ * @max_curr: Actual max current at the local port
+ * @req_max_curr: Requested max current of the port partner
+ * @req_out_volt: Requested output voltage to the port partner
+ * @req_op_curr: Requested operating current to the port partner
+ * @supported: Parter has atleast one APDO hence supports PPS
+ * @active: PPS mode is active
+ */
 struct pd_pps_data {
 	u32 min_volt;
+	u32 req_min_volt;
 	u32 max_volt;
+	u32 req_max_volt;
 	u32 max_curr;
-	u32 out_volt;
-	u32 op_curr;
+	u32 req_max_curr;
+	u32 req_out_volt;
+	u32 req_op_curr;
 	bool supported;
 	bool active;
 };
@@ -2498,8 +2513,8 @@ static void tcpm_pd_ctrl_request(struct tcpm_port *port,
 			break;
 		case SNK_NEGOTIATE_PPS_CAPABILITIES:
 			/* Revert data back from any requested PPS updates */
-			port->pps_data.out_volt = port->supply_voltage;
-			port->pps_data.op_curr = port->current_limit;
+			port->pps_data.req_out_volt = port->supply_voltage;
+			port->pps_data.req_op_curr = port->current_limit;
 			port->pps_status = (type == PD_CTRL_WAIT ?
 					    -EAGAIN : -EOPNOTSUPP);
 
@@ -2548,8 +2563,11 @@ static void tcpm_pd_ctrl_request(struct tcpm_port *port,
 			break;
 		case SNK_NEGOTIATE_PPS_CAPABILITIES:
 			port->pps_data.active = true;
-			port->req_supply_voltage = port->pps_data.out_volt;
-			port->req_current_limit = port->pps_data.op_curr;
+			port->pps_data.min_volt = port->pps_data.req_min_volt;
+			port->pps_data.max_volt = port->pps_data.req_max_volt;
+			port->pps_data.max_curr = port->pps_data.req_max_curr;
+			port->req_supply_voltage = port->pps_data.req_out_volt;
+			port->req_current_limit = port->pps_data.req_op_curr;
 			tcpm_set_state(port, SNK_TRANSITION_SINK, 0);
 			break;
 		case SOFT_RESET_SEND:
@@ -3108,16 +3126,16 @@ static unsigned int tcpm_pd_select_pps_apdo(struct tcpm_port *port)
 		src = port->source_caps[src_pdo];
 		snk = port->snk_pdo[snk_pdo];
 
-		port->pps_data.min_volt = max(pdo_pps_apdo_min_voltage(src),
-					      pdo_pps_apdo_min_voltage(snk));
-		port->pps_data.max_volt = min(pdo_pps_apdo_max_voltage(src),
-					      pdo_pps_apdo_max_voltage(snk));
-		port->pps_data.max_curr = min_pps_apdo_current(src, snk);
-		port->pps_data.out_volt = min(port->pps_data.max_volt,
-					      max(port->pps_data.min_volt,
-						  port->pps_data.out_volt));
-		port->pps_data.op_curr = min(port->pps_data.max_curr,
-					     port->pps_data.op_curr);
+		port->pps_data.req_min_volt = max(pdo_pps_apdo_min_voltage(src),
+						  pdo_pps_apdo_min_voltage(snk));
+		port->pps_data.req_max_volt = min(pdo_pps_apdo_max_voltage(src),
+						  pdo_pps_apdo_max_voltage(snk));
+		port->pps_data.req_max_curr = min_pps_apdo_current(src, snk);
+		port->pps_data.req_out_volt = min(port->pps_data.max_volt,
+						  max(port->pps_data.min_volt,
+						      port->pps_data.req_out_volt));
+		port->pps_data.req_op_curr = min(port->pps_data.max_curr,
+						 port->pps_data.req_op_curr);
 		power_supply_changed(port->psy);
 	}
 
@@ -3245,10 +3263,10 @@ static int tcpm_pd_build_pps_request(struct tcpm_port *port, u32 *rdo)
 			tcpm_log(port, "Invalid APDO selected!");
 			return -EINVAL;
 		}
-		max_mv = port->pps_data.max_volt;
-		max_ma = port->pps_data.max_curr;
-		out_mv = port->pps_data.out_volt;
-		op_ma = port->pps_data.op_curr;
+		max_mv = port->pps_data.req_max_volt;
+		max_ma = port->pps_data.req_max_curr;
+		out_mv = port->pps_data.req_out_volt;
+		op_ma = port->pps_data.req_op_curr;
 		break;
 	default:
 		tcpm_log(port, "Invalid PDO selected!");
@@ -3295,8 +3313,8 @@ static int tcpm_pd_build_pps_request(struct tcpm_port *port, u32 *rdo)
 	tcpm_log(port, "Requesting APDO %d: %u mV, %u mA",
 		 src_pdo_index, out_mv, op_ma);
 
-	port->pps_data.op_curr = op_ma;
-	port->pps_data.out_volt = out_mv;
+	port->pps_data.req_op_curr = op_ma;
+	port->pps_data.req_out_volt = out_mv;
 
 	return 0;
 }
@@ -5429,7 +5447,7 @@ static int tcpm_try_role(struct typec_port *p, int role)
 	return ret;
 }
 
-static int tcpm_pps_set_op_curr(struct tcpm_port *port, u16 op_curr)
+static int tcpm_pps_set_op_curr(struct tcpm_port *port, u16 req_op_curr)
 {
 	unsigned int target_mw;
 	int ret;
@@ -5447,12 +5465,12 @@ static int tcpm_pps_set_op_curr(struct tcpm_port *port, u16 op_curr)
 		goto port_unlock;
 	}
 
-	if (op_curr > port->pps_data.max_curr) {
+	if (req_op_curr > port->pps_data.max_curr) {
 		ret = -EINVAL;
 		goto port_unlock;
 	}
 
-	target_mw = (op_curr * port->pps_data.out_volt) / 1000;
+	target_mw = (req_op_curr * port->supply_voltage) / 1000;
 	if (target_mw < port->operating_snk_mw) {
 		ret = -EINVAL;
 		goto port_unlock;
@@ -5466,10 +5484,10 @@ static int tcpm_pps_set_op_curr(struct tcpm_port *port, u16 op_curr)
 	}
 
 	/* Round down operating current to align with PPS valid steps */
-	op_curr = op_curr - (op_curr % RDO_PROG_CURR_MA_STEP);
+	req_op_curr = req_op_curr - (req_op_curr % RDO_PROG_CURR_MA_STEP);
 
 	reinit_completion(&port->pps_complete);
-	port->pps_data.op_curr = op_curr;
+	port->pps_data.req_op_curr = req_op_curr;
 	port->pps_status = 0;
 	port->pps_pending = true;
 	mutex_unlock(&port->lock);
@@ -5490,7 +5508,7 @@ static int tcpm_pps_set_op_curr(struct tcpm_port *port, u16 op_curr)
 	return ret;
 }
 
-static int tcpm_pps_set_out_volt(struct tcpm_port *port, u16 out_volt)
+static int tcpm_pps_set_out_volt(struct tcpm_port *port, u16 req_out_volt)
 {
 	unsigned int target_mw;
 	int ret;
@@ -5508,13 +5526,13 @@ static int tcpm_pps_set_out_volt(struct tcpm_port *port, u16 out_volt)
 		goto port_unlock;
 	}
 
-	if (out_volt < port->pps_data.min_volt ||
-	    out_volt > port->pps_data.max_volt) {
+	if (req_out_volt < port->pps_data.min_volt ||
+	    req_out_volt > port->pps_data.max_volt) {
 		ret = -EINVAL;
 		goto port_unlock;
 	}
 
-	target_mw = (port->pps_data.op_curr * out_volt) / 1000;
+	target_mw = (port->current_limit * req_out_volt) / 1000;
 	if (target_mw < port->operating_snk_mw) {
 		ret = -EINVAL;
 		goto port_unlock;
@@ -5528,10 +5546,10 @@ static int tcpm_pps_set_out_volt(struct tcpm_port *port, u16 out_volt)
 	}
 
 	/* Round down output voltage to align with PPS valid steps */
-	out_volt = out_volt - (out_volt % RDO_PROG_VOLT_MV_STEP);
+	req_out_volt = req_out_volt - (req_out_volt % RDO_PROG_VOLT_MV_STEP);
 
 	reinit_completion(&port->pps_complete);
-	port->pps_data.out_volt = out_volt;
+	port->pps_data.req_out_volt = req_out_volt;
 	port->pps_status = 0;
 	port->pps_pending = true;
 	mutex_unlock(&port->lock);
@@ -5589,8 +5607,8 @@ static int tcpm_pps_activate(struct tcpm_port *port, bool activate)
 
 	/* Trigger PPS request or move back to standard PDO contract */
 	if (activate) {
-		port->pps_data.out_volt = port->supply_voltage;
-		port->pps_data.op_curr = port->current_limit;
+		port->pps_data.req_out_volt = port->supply_voltage;
+		port->pps_data.req_op_curr = port->current_limit;
 	}
 	mutex_unlock(&port->lock);
 
-- 
2.31.1


