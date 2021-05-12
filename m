Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 211B837C6A1
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234923AbhELPwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:52:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:52454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237227AbhELPs5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:48:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3715D619BF;
        Wed, 12 May 2021 15:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833098;
        bh=GkabpN6ru2FV8Y3JKR51ZKyYvxixVMjEy+KitpqgRlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JaUv9FqFdwvRzL5EiH8qUOFJejd8IeKRl+fh+2s5WTp1GB43mDfcJpfZW3GqhMCJn
         pJ09P/HL38y0ucRVQdfRgEpDwe9lQFQHRrmqMPmqGALQfkDb6K4WElfULe2f9XOuBj
         nLUE13RLzeoeeocABkdZMSwSZKUFadl6POFH+WuY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Badhri Jagan Sridharan <badhri@google.com>,
        Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.11 017/601] usb: typec: tcpm: Address incorrect values of tcpm psy for pps supply
Date:   Wed, 12 May 2021 16:41:34 +0200
Message-Id: <20210512144828.394675338@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Badhri Jagan Sridharan <badhri@google.com>

commit e3a0720224873587954b55d193d5b4abb14f0443 upstream.

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
 drivers/usb/typec/tcpm/tcpm.c |   88 +++++++++++++++++++++++++-----------------
 1 file changed, 53 insertions(+), 35 deletions(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -218,12 +218,27 @@ struct pd_mode_data {
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
@@ -1954,8 +1969,8 @@ static void tcpm_pd_ctrl_request(struct
 			break;
 		case SNK_NEGOTIATE_PPS_CAPABILITIES:
 			/* Revert data back from any requested PPS updates */
-			port->pps_data.out_volt = port->supply_voltage;
-			port->pps_data.op_curr = port->current_limit;
+			port->pps_data.req_out_volt = port->supply_voltage;
+			port->pps_data.req_op_curr = port->current_limit;
 			port->pps_status = (type == PD_CTRL_WAIT ?
 					    -EAGAIN : -EOPNOTSUPP);
 			tcpm_set_state(port, SNK_READY, 0);
@@ -1994,8 +2009,11 @@ static void tcpm_pd_ctrl_request(struct
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
@@ -2522,16 +2540,16 @@ static unsigned int tcpm_pd_select_pps_a
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
 
@@ -2659,10 +2677,10 @@ static int tcpm_pd_build_pps_request(str
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
@@ -2709,8 +2727,8 @@ static int tcpm_pd_build_pps_request(str
 	tcpm_log(port, "Requesting APDO %d: %u mV, %u mA",
 		 src_pdo_index, out_mv, op_ma);
 
-	port->pps_data.op_curr = op_ma;
-	port->pps_data.out_volt = out_mv;
+	port->pps_data.req_op_curr = op_ma;
+	port->pps_data.req_out_volt = out_mv;
 
 	return 0;
 }
@@ -4634,7 +4652,7 @@ static int tcpm_try_role(struct typec_po
 	return ret;
 }
 
-static int tcpm_pps_set_op_curr(struct tcpm_port *port, u16 op_curr)
+static int tcpm_pps_set_op_curr(struct tcpm_port *port, u16 req_op_curr)
 {
 	unsigned int target_mw;
 	int ret;
@@ -4652,22 +4670,22 @@ static int tcpm_pps_set_op_curr(struct t
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
 	}
 
 	/* Round down operating current to align with PPS valid steps */
-	op_curr = op_curr - (op_curr % RDO_PROG_CURR_MA_STEP);
+	req_op_curr = req_op_curr - (req_op_curr % RDO_PROG_CURR_MA_STEP);
 
 	reinit_completion(&port->pps_complete);
-	port->pps_data.op_curr = op_curr;
+	port->pps_data.req_op_curr = req_op_curr;
 	port->pps_status = 0;
 	port->pps_pending = true;
 	tcpm_set_state(port, SNK_NEGOTIATE_PPS_CAPABILITIES, 0);
@@ -4689,7 +4707,7 @@ swap_unlock:
 	return ret;
 }
 
-static int tcpm_pps_set_out_volt(struct tcpm_port *port, u16 out_volt)
+static int tcpm_pps_set_out_volt(struct tcpm_port *port, u16 req_out_volt)
 {
 	unsigned int target_mw;
 	int ret;
@@ -4707,23 +4725,23 @@ static int tcpm_pps_set_out_volt(struct
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
 	}
 
 	/* Round down output voltage to align with PPS valid steps */
-	out_volt = out_volt - (out_volt % RDO_PROG_VOLT_MV_STEP);
+	req_out_volt = req_out_volt - (req_out_volt % RDO_PROG_VOLT_MV_STEP);
 
 	reinit_completion(&port->pps_complete);
-	port->pps_data.out_volt = out_volt;
+	port->pps_data.req_out_volt = req_out_volt;
 	port->pps_status = 0;
 	port->pps_pending = true;
 	tcpm_set_state(port, SNK_NEGOTIATE_PPS_CAPABILITIES, 0);
@@ -4772,8 +4790,8 @@ static int tcpm_pps_activate(struct tcpm
 
 	/* Trigger PPS request or move back to standard PDO contract */
 	if (activate) {
-		port->pps_data.out_volt = port->supply_voltage;
-		port->pps_data.op_curr = port->current_limit;
+		port->pps_data.req_out_volt = port->supply_voltage;
+		port->pps_data.req_op_curr = port->current_limit;
 		tcpm_set_state(port, SNK_NEGOTIATE_PPS_CAPABILITIES, 0);
 	} else {
 		tcpm_set_state(port, SNK_NEGOTIATE_CAPABILITIES, 0);


