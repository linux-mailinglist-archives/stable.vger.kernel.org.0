Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 648E5383D29
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 21:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233086AbhEQTWj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 15:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233033AbhEQTWi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 15:22:38 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0150C061573
        for <stable@vger.kernel.org>; Mon, 17 May 2021 12:21:21 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id b1-20020a0c9b010000b02901c4bcfbaa53so5519591qve.19
        for <stable@vger.kernel.org>; Mon, 17 May 2021 12:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=e5jSU7HtuQFmdUmn7z8sqk1SHR5Y9aJ3zA7f8ysFgoo=;
        b=a6V5RUvZ6IccV9YrF0jHKsuPfOCPHA3SFlNLpX+8DEumop8ybL8n/3Skg4aYL135ym
         ad0qTqt/YQjFI4TA9f4fd/0N1notRWg63wD13VaYHetS1FTbxAKGAhggsnxry8iCdMIb
         R+NYBrchalfkIgjMgtBkvO3FRsktjFFy1vXAEbCpHHSpKMZ2thfSS8yk40yCWjT64x/9
         olZ587HXH56zdDANmNJQvL7UgoYwaL040P58iMjXH2n9Sf920yp4Qn1byxAda8jxMgTX
         XEeVygex5M0+Wf332Uo479i6nxzKYg366oxtIkKeK81qq4af9vQo/bPfbnkxO9zmwjEs
         vteA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=e5jSU7HtuQFmdUmn7z8sqk1SHR5Y9aJ3zA7f8ysFgoo=;
        b=cuj1rBTlCZmKEj9GrHkEycZg/ynZe6NNjGY/meulQapiR9iOgH0qBdarfAhM0wZme8
         rldrMlbfef3ab2LwIljPo7lQBiNXQV8PMTcNiijQ73EEU9KUt9WepQoVckwJ+al9zVto
         zGSSsbiXxxo0yVgCJofkIorSXLC7uMAwYEZa1FU5c95kW5HVgxl9sujQ9UwEdJ9CDiwe
         /ZD2gDc0RIR8End+qWvGP3NbvthuM4TJvg0TIxDE8LgSqOZ1kHSSj1wFSh430lV/+ptI
         pmgVvN/oLfF6qIzqidEL5jfp0q1ktdnSJ9qF2q8LlBlMfR/dIKY+FjIrhzYHGzKf2h1/
         W9YA==
X-Gm-Message-State: AOAM530iIe0nE7XOX24Rc9mWtVt8GB2mGcxzVK87lE8d519Az6Kj+fzY
        qix6m9PL2ov/OO1NfMuQSOd1x+PMf5I=
X-Google-Smtp-Source: ABdhPJyzfYar4dQS32Fxr25/WilFHq3sDKooGsdbKZunlsxRZZqE/gt08U57WOzkVQawtt5OhTH0IY12ebc=
X-Received: from badhri.mtv.corp.google.com ([2620:15c:211:201:b562:7011:fe35:1c9e])
 (user=badhri job=sendgmr) by 2002:ad4:4184:: with SMTP id e4mr1281838qvp.13.1621279281041;
 Mon, 17 May 2021 12:21:21 -0700 (PDT)
Date:   Mon, 17 May 2021 12:21:11 -0700
In-Reply-To: <20210517192112.40934-1-badhri@google.com>
Message-Id: <20210517192112.40934-3-badhri@google.com>
Mime-Version: 1.0
References: <20210517192112.40934-1-badhri@google.com>
X-Mailer: git-send-email 2.31.1.751.gd2f1c929bd-goog
Subject: [PATCH v2 3/4] usb: typec: tcpm: Move TCPC to APPLY_RC state during PR_SWAP
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
Changes since v1:
- Added additional check port->tcpc->apply_rc as suggested by Guenter
  Roeck
---
 drivers/usb/typec/tcpm/tcpm.c | 16 ++++++++++++++++
 include/linux/usb/tcpm.h      |  4 ++++
 2 files changed, 20 insertions(+)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index b475d9b9d38d..3c2cade986c9 100644
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
+	if (port->tcpc->enable_auto_vbus_discharge && port->tcpc->apply_rc) {
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

