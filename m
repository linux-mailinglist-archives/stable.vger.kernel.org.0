Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8A5381614
	for <lists+stable@lfdr.de>; Sat, 15 May 2021 07:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234102AbhEOF1g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 May 2021 01:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234003AbhEOF1d (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 May 2021 01:27:33 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D48CC06174A
        for <stable@vger.kernel.org>; Fri, 14 May 2021 22:26:20 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id c9-20020a2580c90000b02904f86395a96dso1859935ybm.19
        for <stable@vger.kernel.org>; Fri, 14 May 2021 22:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=bTPswpk0akuXBvppl1rK6ylc4XjQRVDSR+CWbyIJ8R0=;
        b=k+1nYC7AfjyDzebPwV02klldD0WK5NuHGwOTI92ajmoY/H50D79Db2MK+AlgUzUOEt
         3rn7OmDjsroF2l3HFNgux/FbE8E0UtqoSeHspI7gcDQnNP/piazGgjZ9yArBzV7/SZiH
         TwYkCP/dGppXuWsUc4z9UOz3jpORFGJWMwIrFP+jDB+wATZt09m8KTXav67fxmJMtGDO
         SSRrd1gERDlg+2PqVC/KMAE51vKdvQzmGpwgMWJsfr8S33FzCq70Z8GKp5yEOeHzK3TY
         qDXAT/z9u1AG50S/xkm+MdBCbhHjVpov8PvXyBeVd9lGObwBCDmCEZhlL72+uv/nnLXt
         /pmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bTPswpk0akuXBvppl1rK6ylc4XjQRVDSR+CWbyIJ8R0=;
        b=HOW7nkWBW6l0L72otNaShwLz+DEfq7n15xTq9mPf2Y3Yq/ZpzLFFjSmgf1iLGRXhtp
         t6WrhTWulVgGzW1OlyQ6OIV0JcoOvjbBTR3WFtHKH/+SStzJCr8Vd/gPxjPreTyb25OE
         u2tv+xz2MZGW2kkqpG682mpdZ7+0xU/6gAAdOaYALG/GInpf7Yfl42m6aJynu+j/ftNp
         Ju+0OVDLorMvAPs6tFGLjRMSSbpcoH1tLnb0n/LYv7bIc2YHg+uhTggKfmqD8MJC58vt
         ybm5HhW0WjjvsvvUQf3mv8Yuci+HwPrKznjkHiihdmOLBI9VdWe+41DA83EIg/hv7gWh
         sTfQ==
X-Gm-Message-State: AOAM531/QXcErDojaJs8OV2HH49WaEQHOdbH4YX5IIeUbhB/FvC8dc1n
        1Cb2T4lnBnT11WoTmDTSvF5A7TP6Cxk=
X-Google-Smtp-Source: ABdhPJwBjPn+Vci5sBFcE4dI3IBlEGpIkiIcuAqrB1B8Zzk/N00HSiugvk3U8iXRPbkl7WSkqFuUUXCdSDk=
X-Received: from badhri.mtv.corp.google.com ([2620:15c:211:201:6bd1:251e:e226:7071])
 (user=badhri job=sendgmr) by 2002:a5b:b46:: with SMTP id b6mr1211609ybr.66.1621056379879;
 Fri, 14 May 2021 22:26:19 -0700 (PDT)
Date:   Fri, 14 May 2021 22:26:11 -0700
In-Reply-To: <20210515052613.3261340-1-badhri@google.com>
Message-Id: <20210515052613.3261340-2-badhri@google.com>
Mime-Version: 1.0
References: <20210515052613.3261340-1-badhri@google.com>
X-Mailer: git-send-email 2.31.1.751.gd2f1c929bd-goog
Subject: [PATCH v1 2/4] usb: typec: tcpm: Refactor logic to enable/disable
 auto vbus dicharge
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

The logic to enable vbus auto discharge on disconnect is used in
more than one place. Since this is repetitive code, moving this into
its own method.

Fixes: f321a02caebd ("usb: typec: tcpm: Implement enabling Auto Discharge disconnect support")
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
---
 drivers/usb/typec/tcpm/tcpm.c | 39 ++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 21 deletions(-)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index b93c4c8d7b15..b475d9b9d38d 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -771,6 +771,21 @@ static void tcpm_set_cc(struct tcpm_port *port, enum typec_cc_status cc)
 	port->tcpc->set_cc(port->tcpc, cc);
 }
 
+static int tcpm_enable_auto_vbus_discharge(struct tcpm_port *port, bool enable)
+{
+	int ret = 0;
+
+	if (port->tcpc->enable_auto_vbus_discharge) {
+		ret = port->tcpc->enable_auto_vbus_discharge(port->tcpc, enable);
+		tcpm_log_force(port, "%s vbus discharge ret:%d", enable ? "enable" : "disable",
+			       ret);
+		if (!ret)
+			port->auto_vbus_discharge_enabled = enable;
+	}
+
+	return ret;
+}
+
 /*
  * Determine RP value to set based on maximum current supported
  * by a port if configured as source.
@@ -3445,12 +3460,7 @@ static int tcpm_src_attach(struct tcpm_port *port)
 	if (ret < 0)
 		return ret;
 
-	if (port->tcpc->enable_auto_vbus_discharge) {
-		ret = port->tcpc->enable_auto_vbus_discharge(port->tcpc, true);
-		tcpm_log_force(port, "enable vbus discharge ret:%d", ret);
-		if (!ret)
-			port->auto_vbus_discharge_enabled = true;
-	}
+	tcpm_enable_auto_vbus_discharge(port, true);
 
 	ret = tcpm_set_roles(port, true, TYPEC_SOURCE, tcpm_data_role_for_source(port));
 	if (ret < 0)
@@ -3527,14 +3537,7 @@ static void tcpm_set_partner_usb_comm_capable(struct tcpm_port *port, bool capab
 
 static void tcpm_reset_port(struct tcpm_port *port)
 {
-	int ret;
-
-	if (port->tcpc->enable_auto_vbus_discharge) {
-		ret = port->tcpc->enable_auto_vbus_discharge(port->tcpc, false);
-		tcpm_log_force(port, "Disable vbus discharge ret:%d", ret);
-		if (!ret)
-			port->auto_vbus_discharge_enabled = false;
-	}
+	tcpm_enable_auto_vbus_discharge(port, false);
 	port->in_ams = false;
 	port->ams = NONE_AMS;
 	port->vdm_sm_running = false;
@@ -3602,13 +3605,7 @@ static int tcpm_snk_attach(struct tcpm_port *port)
 	if (ret < 0)
 		return ret;
 
-	if (port->tcpc->enable_auto_vbus_discharge) {
-		tcpm_set_auto_vbus_discharge_threshold(port, TYPEC_PWR_MODE_USB, false, VSAFE5V);
-		ret = port->tcpc->enable_auto_vbus_discharge(port->tcpc, true);
-		tcpm_log_force(port, "enable vbus discharge ret:%d", ret);
-		if (!ret)
-			port->auto_vbus_discharge_enabled = true;
-	}
+	tcpm_enable_auto_vbus_discharge(port, true);
 
 	ret = tcpm_set_roles(port, true, TYPEC_SINK, tcpm_data_role_for_sink(port));
 	if (ret < 0)
-- 
2.31.1.751.gd2f1c929bd-goog

