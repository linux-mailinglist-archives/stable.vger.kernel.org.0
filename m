Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4C5C31F63A
	for <lists+stable@lfdr.de>; Fri, 19 Feb 2021 10:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbhBSJHu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Feb 2021 04:07:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbhBSJEy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Feb 2021 04:04:54 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BA2C061786
        for <stable@vger.kernel.org>; Fri, 19 Feb 2021 01:04:14 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id s184so3112990qke.18
        for <stable@vger.kernel.org>; Fri, 19 Feb 2021 01:04:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=CGR9fL8lkODALH6tI/Lf41dYAe2vopzjhEaC221RUXI=;
        b=kjOGxDOu4NduoHkNZJ5LhJIo1OQZSg66MwJ6dXv4ytV/830xQDy3BxpsODu1gi82lt
         Es2tAr6/Y61r3MG6prqQ0CeCon+3j9sNa8VWol2ZZHJbyB+/o+v0dZdbZnk/tpl84WAN
         /Jb0SBvJzS5lIxRB/zcxb+5YKxmPGtUEo4fj5377N9PJCsx3oqC+rcuHshQLBd2Vq0Ff
         drXKtsV53PYZQkbZfKQ0X4cNfu9QZab5kW+BgOmoPjznv1hvdQ9uW0VXma60ccTwrnXX
         XP1cFxXULULLtbfrSXAezmhzqKx75LNxU6YA+XzWZZra4c2UOM6fTV6tyPaEBL1eURR8
         dVuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=CGR9fL8lkODALH6tI/Lf41dYAe2vopzjhEaC221RUXI=;
        b=II54VmHzlVEbLBV+QeeuGeLcNOHayqZjdCoEEqv1NmGBnGVwqj8N/L+6xZcTQZcxou
         bk4P2wXY2Lgy3qbw+k9o+MXMO95pCb1HJ5+m/HDSYfpeCwu1eWHs9XJ7ZazEjVx93WzS
         D0Ojbv3XsAtwMHuK/i1qVCOdS81uvUkyVW25NyZavZM7QQ79/FrttNUzgheYZFSWOg6h
         p/QPcakN/tUV4KALRBQkR5VJX3XvgKyQpYR5PcytQdoyIIJ1oTqggy6wvEV/m94imqOt
         VdY++aBF+uedOUp8KpwF4jqRFs/e5IuZwc6LMmaDf3gJWGok2Ex9cAvS6lp92Ke2mWsc
         ISZA==
X-Gm-Message-State: AOAM532+4VDyfEb/Nid2YCEDvnDbxy8u8viriUvtKQhhLFMTOWiXXBf0
        wnZn6jErs4LFcEY5CglXbc7gRv1UpFw=
X-Google-Smtp-Source: ABdhPJwaEYLuteNjKI4wu29MPPChLxdzE3fnRY8NmQMFADSE1kd+ZCIMilia0Dl9PJK8+BdokCGT0PpotBo=
Sender: "badhri via sendgmr" <badhri@badhri.mtv.corp.google.com>
X-Received: from badhri.mtv.corp.google.com ([2620:15c:211:201:4940:ba9e:2dc2:a4ce])
 (user=badhri job=sendgmr) by 2002:a0c:8e8f:: with SMTP id x15mr8372883qvb.21.1613725452961;
 Fri, 19 Feb 2021 01:04:12 -0800 (PST)
Date:   Fri, 19 Feb 2021 01:04:09 -0800
Message-Id: <20210219090409.325492-1-badhri@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.617.g56c4b15f3c-goog
Subject: [PATCH v2] usb: typec: tcpm: Wait for vbus discharge to VSAFE0V
 before toggling
From:   Badhri Jagan Sridharan <badhri@google.com>
To:     Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kyle Tso <kyletso@google.com>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Badhri Jagan Sridharan <badhri@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When vbus auto discharge is enabled, TCPM can sometimes be faster than
the TCPC i.e. TCPM can go ahead and move the port to unattached state
(involves disabling vbus auto discharge) before TCPC could effectively
discharge vbus to VSAFE0V. This leaves vbus with residual charge and
increases the decay time which prevents tsafe0v from being met.
This change introduces a new state VBUS_DISCHARGE where the TCPM waits
for a maximum of tSafe0V(max) for vbus to discharge to VSAFE0V before
transitioning to unattached state and re-enable toggling. If vbus
discharges to vsafe0v sooner, then, transition to unattached state
happens right away.

Also, while in SNK_READY, when auto discharge is enabled, drive
disconnect based on vbus turning off instead of Rp disappearing on
CC pins. Rp disappearing on CC pins is almost instanteous compared
to vbus decay.

Fixes: f321a02caebd ("usb: typec: tcpm: Implement enabling Auto
Discharge disconnect support")
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
---
Changes since V1:
- Add Fixes tag
---
 drivers/usb/typec/tcpm/tcpm.c | 60 +++++++++++++++++++++++++++++++----
 1 file changed, 53 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index be0b6469dd3d..0ed71725980f 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -62,6 +62,8 @@
 	S(SNK_TRANSITION_SINK_VBUS),		\
 	S(SNK_READY),				\
 						\
+	S(VBUS_DISCHARGE),			\
+						\
 	S(ACC_UNATTACHED),			\
 	S(DEBUG_ACC_ATTACHED),			\
 	S(AUDIO_ACC_ATTACHED),			\
@@ -438,6 +440,9 @@ struct tcpm_port {
 	enum tcpm_ams next_ams;
 	bool in_ams;
 
+	/* Auto vbus discharge state */
+	bool auto_vbus_discharge_enabled;
+
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *dentry;
 	struct mutex logbuffer_lock;	/* log buffer access lock */
@@ -3413,6 +3418,8 @@ static int tcpm_src_attach(struct tcpm_port *port)
 	if (port->tcpc->enable_auto_vbus_discharge) {
 		ret = port->tcpc->enable_auto_vbus_discharge(port->tcpc, true);
 		tcpm_log_force(port, "enable vbus discharge ret:%d", ret);
+		if (!ret)
+			port->auto_vbus_discharge_enabled = true;
 	}
 
 	ret = tcpm_set_roles(port, true, TYPEC_SOURCE, tcpm_data_role_for_source(port));
@@ -3495,6 +3502,8 @@ static void tcpm_reset_port(struct tcpm_port *port)
 	if (port->tcpc->enable_auto_vbus_discharge) {
 		ret = port->tcpc->enable_auto_vbus_discharge(port->tcpc, false);
 		tcpm_log_force(port, "Disable vbus discharge ret:%d", ret);
+		if (!ret)
+			port->auto_vbus_discharge_enabled = false;
 	}
 	port->in_ams = false;
 	port->ams = NONE_AMS;
@@ -3568,6 +3577,8 @@ static int tcpm_snk_attach(struct tcpm_port *port)
 		tcpm_set_auto_vbus_discharge_threshold(port, TYPEC_PWR_MODE_USB, false, VSAFE5V);
 		ret = port->tcpc->enable_auto_vbus_discharge(port->tcpc, true);
 		tcpm_log_force(port, "enable vbus discharge ret:%d", ret);
+		if (!ret)
+			port->auto_vbus_discharge_enabled = true;
 	}
 
 	ret = tcpm_set_roles(port, true, TYPEC_SINK, tcpm_data_role_for_sink(port));
@@ -3684,6 +3695,12 @@ static void run_state_machine(struct tcpm_port *port)
 	switch (port->state) {
 	case TOGGLING:
 		break;
+	case VBUS_DISCHARGE:
+		if (port->port_type == TYPEC_PORT_SRC)
+			tcpm_set_state(port, SRC_UNATTACHED, PD_T_SAFE_0V);
+		else
+			tcpm_set_state(port, SNK_UNATTACHED, PD_T_SAFE_0V);
+		break;
 	/* SRC states */
 	case SRC_UNATTACHED:
 		if (!port->non_pd_role_swap)
@@ -4669,7 +4686,9 @@ static void _tcpm_cc_change(struct tcpm_port *port, enum typec_cc_status cc1,
 	case SRC_READY:
 		if (tcpm_port_is_disconnected(port) ||
 		    !tcpm_port_is_source(port)) {
-			if (port->port_type == TYPEC_PORT_SRC)
+			if (port->auto_vbus_discharge_enabled && !port->vbus_vsafe0v)
+				tcpm_set_state(port, VBUS_DISCHARGE, 0);
+			else if (port->port_type == TYPEC_PORT_SRC)
 				tcpm_set_state(port, SRC_UNATTACHED, 0);
 			else
 				tcpm_set_state(port, SNK_UNATTACHED, 0);
@@ -4703,7 +4722,18 @@ static void _tcpm_cc_change(struct tcpm_port *port, enum typec_cc_status cc1,
 			tcpm_set_state(port, SNK_DEBOUNCED, 0);
 		break;
 	case SNK_READY:
-		if (tcpm_port_is_disconnected(port))
+		/*
+		 * When set_auto_vbus_discharge_threshold is enabled, CC pins go
+		 * away before vbus decays to disconnect threshold. Allow
+		 * disconnect to be driven by vbus disconnect when auto vbus
+		 * discharge is enabled.
+		 *
+		 * EXIT condition is based primarily on vbus disconnect and CC is secondary.
+		 * "A port that has entered into USB PD communications with the Source and
+		 * has seen the CC voltage exceed vRd-USB may monitor the CC pin to detect
+		 * cable disconnect in addition to monitoring VBUS.
+		 */
+		if (!port->auto_vbus_discharge_enabled && tcpm_port_is_disconnected(port))
 			tcpm_set_state(port, unattached_state(port), 0);
 		else if (!port->pd_capable &&
 			 (cc1 != old_cc1 || cc2 != old_cc2))
@@ -4803,9 +4833,16 @@ static void _tcpm_cc_change(struct tcpm_port *port, enum typec_cc_status cc1,
 		 */
 		break;
 
+	case VBUS_DISCHARGE:
+		/* Do nothing. Waiting for vsafe0v signal */
+		break;
 	default:
-		if (tcpm_port_is_disconnected(port))
-			tcpm_set_state(port, unattached_state(port), 0);
+		if (tcpm_port_is_disconnected(port)) {
+			if (port->auto_vbus_discharge_enabled && !port->vbus_vsafe0v)
+				tcpm_set_state(port, VBUS_DISCHARGE, 0);
+			else
+				tcpm_set_state(port, unattached_state(port), 0);
+		}
 		break;
 	}
 }
@@ -4988,9 +5025,12 @@ static void _tcpm_pd_vbus_off(struct tcpm_port *port)
 		break;
 
 	default:
-		if (port->pwr_role == TYPEC_SINK &&
-		    port->attached)
-			tcpm_set_state(port, SNK_UNATTACHED, 0);
+		if (port->pwr_role == TYPEC_SINK && port->attached) {
+			if (port->auto_vbus_discharge_enabled && !port->vbus_vsafe0v)
+				tcpm_set_state(port, VBUS_DISCHARGE, 0);
+			else
+				tcpm_set_state(port, SNK_UNATTACHED, 0);
+		}
 		break;
 	}
 }
@@ -5012,6 +5052,12 @@ static void _tcpm_pd_vbus_vsafe0v(struct tcpm_port *port)
 			tcpm_set_state(port, tcpm_try_snk(port) ? SNK_TRY : SRC_ATTACHED,
 				       PD_T_CC_DEBOUNCE);
 		break;
+	case VBUS_DISCHARGE:
+		if (port->port_type == TYPEC_PORT_SRC)
+			tcpm_set_state(port, SRC_UNATTACHED, 0);
+		else
+			tcpm_set_state(port, SNK_UNATTACHED, 0);
+		break;
 	default:
 		break;
 	}
-- 
2.30.0.617.g56c4b15f3c-goog

