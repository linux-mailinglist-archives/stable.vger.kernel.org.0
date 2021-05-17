Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7576B383D26
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 21:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232960AbhEQTWh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 15:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232515AbhEQTWg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 15:22:36 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6D03C061756
        for <stable@vger.kernel.org>; Mon, 17 May 2021 12:21:19 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id b66-20020a25cb450000b02905076ea039f1so9689515ybg.1
        for <stable@vger.kernel.org>; Mon, 17 May 2021 12:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3ZBMym5AurysGIW0Fwet/rBzMLRVIo4cf6ykZqhV7jo=;
        b=pi/vYI0EukHl/lVCJaK0Iq2fyoHmEUVDnV76OUtJhXtlJy+WuSJk76gU9XhjKDa9fi
         cwX5G7wLwCZxkMAzC5MmPZg+/3p5X0/TvUbCiwiRLn05qet8zBXRB8FwSsBGGNJKmBej
         Mq8ub33YMLGwpj2ymL8PDTVMwhFvbC2xj8r0rD5WgG1oPDkyRn5K2RCovJ9MY+zv47Gt
         hV1ubrcLrh5vopQH8o3C5WnjqFSZi1PvLN9nW4cV6nnIlB/b8MvX0lufXlTHItTBKXdN
         ksHnkroxXaESg1+0ENKAYtujDUnun1p+BCgHFTBl4w+O7Cqiqw5rgnn6NUoO//cr8VcP
         GCag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3ZBMym5AurysGIW0Fwet/rBzMLRVIo4cf6ykZqhV7jo=;
        b=Hqkgqqn7zo4/23ObVkSKL5NPh77tD61n8ZF3fAIuGWaFHRT+AZY5cw240UCMJZL3/V
         nczlul/49LjfKsQAQ0WizgpRP+qLKIBWTl49a5qXn6sEE+SshMeczM9O/iAvQlDDg0ie
         VjvviJuk05evn92q/zdgQc6K3GpYo1SwQ0jS4ubD3OdfrPCVZJ9e3c4g7wbGzVYZ1tL2
         dYXK+VyRadMQUfclBYq1k9IY7pG3sst419XaFOJNtIiOz9s5cfq16Iv38MlP6Q2Vw0hL
         l6GzZzubGWykck1EXZTU2BqyNNqzavzdyPR2PdHO9ZGJ/6hmoqnHhv5jaA98Qav2rqak
         I7HA==
X-Gm-Message-State: AOAM532279l92K/yhpoO6q4Sg4gNmr5xMEuYViIuDK/SIqa8aQs5cnr2
        021FsDhMa51suOMqtWR8onysc44BesM=
X-Google-Smtp-Source: ABdhPJybeffhQ48nSBUZO52Uz1YYC3DdbLzkxsa/XHbCA3vs/73qCVaMt/S5YSnHgX2MtFUuptmUC7Oj1fU=
X-Received: from badhri.mtv.corp.google.com ([2620:15c:211:201:b562:7011:fe35:1c9e])
 (user=badhri job=sendgmr) by 2002:a25:dc8:: with SMTP id 191mr2026244ybn.102.1621279278992;
 Mon, 17 May 2021 12:21:18 -0700 (PDT)
Date:   Mon, 17 May 2021 12:21:10 -0700
In-Reply-To: <20210517192112.40934-1-badhri@google.com>
Message-Id: <20210517192112.40934-2-badhri@google.com>
Mime-Version: 1.0
References: <20210517192112.40934-1-badhri@google.com>
X-Mailer: git-send-email 2.31.1.751.gd2f1c929bd-goog
Subject: [PATCH v2 2/4] usb: typec: tcpm: Refactor logic to enable/disable
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
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
---
Changes since V1:
- Added Reviewed-by: Guenter Roeck <linux@roeck-us.net>
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

