Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE2F381618
	for <lists+stable@lfdr.de>; Sat, 15 May 2021 07:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234003AbhEOF1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 May 2021 01:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234079AbhEOF1g (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 May 2021 01:27:36 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73BEAC06175F
        for <stable@vger.kernel.org>; Fri, 14 May 2021 22:26:23 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id u9-20020a05620a4549b02902e956c2a3c8so850832qkp.20
        for <stable@vger.kernel.org>; Fri, 14 May 2021 22:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ZXfzyV1SAC8WulEy27PZeafZr1Rn8+SYm/SVQ8IYhss=;
        b=AZrkRH5ABB4TrDVgX5vEVQExMTnuqhFncS+qDgwPHfMvjgVaNrnhj2mx1agIXgBQJ8
         5ohP/e9R8PnKqIszhExOALNlqZFAjCdvPeqtfChAl5+n/enMDzJkxa2QO523VmJiuLiB
         OV52619uBflMz2njmKq4uBAAcT798NqmkhZRvF0zfpCwBLOYusOkMwFH53yGoCatHJow
         5njYeX/IX+qVr0ReOquvn8SR3N+0SX18IbPPC4c/Qao4JVrjalNB1bTtiSoLww+GwI39
         wi/nbw+AfGqZSqHbIzn1u7dEQViGjEOSfNkUNApsd2DE25sWMQRdmWrRXGuRqXyZ84Gk
         QTfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ZXfzyV1SAC8WulEy27PZeafZr1Rn8+SYm/SVQ8IYhss=;
        b=gvIy2v2Y6wrjMdWgeEzjew58CaNgzEPbzFufuJU2wYYcGOxy4KKTDjcec04BKwuqrq
         iBo6wdxFCKC6PfQIgsZA9tujw0Gr4Rm8Y2IuVnhEdm94o+ZCk8/sGy7XfQ/nM9Pdz0FH
         Rhio28vIlaZGirCzeKoaJRz+B7z7+iMu/VtPkW7NT/+tTrHVZA8rXpsrmtFPXrEHfGP8
         23bMzvtduB4hrdyF8W3EAHl4N0JuWqwLgTpVzHJuqVxivgn+Kcx8Oe76larfv/w66qh7
         aSSVAlZoiDzLeMAWiU02cFGqY5rDYZD/amKcyMmrnrbSy4/AMMXUmp/ygenZGKHSEVsV
         3jCQ==
X-Gm-Message-State: AOAM533098IyxwMl1J2cq6PmkLzzfVhb61wxPoUnt1g6t/3mLtPybTMr
        c1vo6F1OKBR+Vi9+7uV0a2KgJ6gloNk=
X-Google-Smtp-Source: ABdhPJz7doI6UsuQXaaJ0j5Oyde6ecjCblhaRZC0Z9pHySG1LNMP9E1cE/7fJHC1JYxDZId9S30KElmDarE=
X-Received: from badhri.mtv.corp.google.com ([2620:15c:211:201:6bd1:251e:e226:7071])
 (user=badhri job=sendgmr) by 2002:ad4:4523:: with SMTP id l3mr38600356qvu.45.1621056382423;
 Fri, 14 May 2021 22:26:22 -0700 (PDT)
Date:   Fri, 14 May 2021 22:26:12 -0700
In-Reply-To: <20210515052613.3261340-1-badhri@google.com>
Message-Id: <20210515052613.3261340-3-badhri@google.com>
Mime-Version: 1.0
References: <20210515052613.3261340-1-badhri@google.com>
X-Mailer: git-send-email 2.31.1.751.gd2f1c929bd-goog
Subject: [PATCH v1 3/4] usb: typec: tcpm: Move TCPC to APPLY_RC state during PR_SWAP
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

When vbus auto discharge is enabled, TCPCI based TCPC transitions
into Attached.SNK/Attached.SRC state. During PR_SWAP, TCPCI based
TCPC would disconnect when partner changes power roles. TCPC has
to be moved APPLY RC state during PR_SWAP. This is done by
ROLE_CONTROL.CC1 != ROLE_CONTROL.CC2 and
POWER_CONTROL.AutodischargeDisconnect is 0. Once the swap sequence
is done, AutoDischargeDisconnect is re-enabled.

Fixes: f321a02caebd ("usb: typec: tcpm: Implement enabling Auto Discharge disconnect support")
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
---
 drivers/usb/typec/tcpm/tcpm.c | 16 ++++++++++++++++
 include/linux/usb/tcpm.h      |  4 ++++
 2 files changed, 20 insertions(+)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index b475d9b9d38d..5bac4978efb3 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -786,6 +786,19 @@ static int tcpm_enable_auto_vbus_discharge(struct tcpm_port *port, bool enable)
 	return ret;
 }
 
+static void tcpm_apply_rc(struct tcpm_port *port)
+{
+	/*
+	 * TCPCI: Move to APPLY_RC state to prevent disconnect during PR_SWAP
+	 * when Vbus auto discharge on disconnect is enabled.
+	 */
+	if (port->tcpc->enable_auto_vbus_discharge) {
+		tcpm_log(port, "Apply_RC");
+		port->tcpc->apply_rc(port->tcpc, port->cc_req, port->polarity);
+		tcpm_enable_auto_vbus_discharge(port, false);
+	}
+}
+
 /*
  * Determine RP value to set based on maximum current supported
  * by a port if configured as source.
@@ -4428,6 +4441,7 @@ static void run_state_machine(struct tcpm_port *port)
 		tcpm_set_state(port, ready_state(port), 0);
 		break;
 	case PR_SWAP_START:
+		tcpm_apply_rc(port);
 		if (port->pwr_role == TYPEC_SOURCE)
 			tcpm_set_state(port, PR_SWAP_SRC_SNK_TRANSITION_OFF,
 				       PD_T_SRC_TRANSITION);
@@ -4467,6 +4481,7 @@ static void run_state_machine(struct tcpm_port *port)
 		tcpm_set_state(port, ERROR_RECOVERY, PD_T_PS_SOURCE_ON_PRS);
 		break;
 	case PR_SWAP_SRC_SNK_SINK_ON:
+		tcpm_enable_auto_vbus_discharge(port, true);
 		/* Set the vbus disconnect threshold for implicit contract */
 		tcpm_set_auto_vbus_discharge_threshold(port, TYPEC_PWR_MODE_USB, false, VSAFE5V);
 		tcpm_set_state(port, SNK_STARTUP, 0);
@@ -4483,6 +4498,7 @@ static void run_state_machine(struct tcpm_port *port)
 			       PD_T_PS_SOURCE_OFF);
 		break;
 	case PR_SWAP_SNK_SRC_SOURCE_ON:
+		tcpm_enable_auto_vbus_discharge(port, true);
 		tcpm_set_cc(port, tcpm_rp_cc(port));
 		tcpm_set_vbus(port, true);
 		/*
diff --git a/include/linux/usb/tcpm.h b/include/linux/usb/tcpm.h
index 42fcfbe10590..bffc8d3e14ad 100644
--- a/include/linux/usb/tcpm.h
+++ b/include/linux/usb/tcpm.h
@@ -66,6 +66,8 @@ enum tcpm_transmit_type {
  *		For example, some tcpcs may include BC1.2 charger detection
  *		and use that in this case.
  * @set_cc:	Called to set value of CC pins
+ * @apply_rc:	Optional; Needed to move TCPCI based chipset to APPLY_RC state
+ *		as stated by the TCPCI specification.
  * @get_cc:	Called to read current CC pin values
  * @set_polarity:
  *		Called to set polarity
@@ -120,6 +122,8 @@ struct tcpc_dev {
 	int (*get_vbus)(struct tcpc_dev *dev);
 	int (*get_current_limit)(struct tcpc_dev *dev);
 	int (*set_cc)(struct tcpc_dev *dev, enum typec_cc_status cc);
+	int (*apply_rc)(struct tcpc_dev *dev, enum typec_cc_status cc,
+			enum typec_cc_polarity polarity);
 	int (*get_cc)(struct tcpc_dev *dev, enum typec_cc_status *cc1,
 		      enum typec_cc_status *cc2);
 	int (*set_polarity)(struct tcpc_dev *dev,
-- 
2.31.1.751.gd2f1c929bd-goog

