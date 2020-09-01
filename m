Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCB7C259518
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729584AbgIAPqZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:46:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:36078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731534AbgIAPqY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:46:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6ECCB2098B;
        Tue,  1 Sep 2020 15:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598975182;
        bh=l4focxuKvS5PXArvX2t0M5gdbzXy9qeIo+SGurkiYAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KwGOaB6y+A2731q66BrZYB1GstVSGPwFfA9UycNelFyWUgyxgvpZfWyJEe/GoRrTj
         ae3qOAMC16QVKPjRJu3Kq+NAFPpAzDjNVmw/vFY7EwDlQhKuYAJCllbO+PflkxIbOH
         4wCdqNC9do1rKaCLbh5dYUeF+jdSu0Z7VX8oO2Qw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.8 241/255] usb: typec: ucsi: Hold con->lock for the entire duration of ucsi_register_port()
Date:   Tue,  1 Sep 2020 17:11:37 +0200
Message-Id: <20200901151012.298868418@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

commit bed97b30968ba354035a020989df0623e52b5536 upstream.

Commit 081da1325d35 ("usb: typec: ucsi: displayport: Fix a potential race
during registration") made the ucsi code hold con->lock in
ucsi_register_displayport(). But we really don't want any interactions
with the connector to run before the port-registration process is fully
complete.

This commit moves the taking of con->lock from ucsi_register_displayport()
into ucsi_register_port() to achieve this.

Cc: stable@vger.kernel.org
Fixes: 081da1325d35 ("usb: typec: ucsi: displayport: Fix a potential race during registration")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20200809141904.4317-5-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/typec/ucsi/displayport.c |    9 +--------
 drivers/usb/typec/ucsi/ucsi.c        |   31 ++++++++++++++++++++++---------
 2 files changed, 23 insertions(+), 17 deletions(-)

--- a/drivers/usb/typec/ucsi/displayport.c
+++ b/drivers/usb/typec/ucsi/displayport.c
@@ -288,8 +288,6 @@ struct typec_altmode *ucsi_register_disp
 	struct typec_altmode *alt;
 	struct ucsi_dp *dp;
 
-	mutex_lock(&con->lock);
-
 	/* We can't rely on the firmware with the capabilities. */
 	desc->vdo |= DP_CAP_DP_SIGNALING | DP_CAP_RECEPTACLE;
 
@@ -298,15 +296,12 @@ struct typec_altmode *ucsi_register_disp
 	desc->vdo |= all_assignments << 16;
 
 	alt = typec_port_register_altmode(con->port, desc);
-	if (IS_ERR(alt)) {
-		mutex_unlock(&con->lock);
+	if (IS_ERR(alt))
 		return alt;
-	}
 
 	dp = devm_kzalloc(&alt->dev, sizeof(*dp), GFP_KERNEL);
 	if (!dp) {
 		typec_unregister_altmode(alt);
-		mutex_unlock(&con->lock);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -319,7 +314,5 @@ struct typec_altmode *ucsi_register_disp
 	alt->ops = &ucsi_displayport_ops;
 	typec_altmode_set_drvdata(alt, dp);
 
-	mutex_unlock(&con->lock);
-
 	return alt;
 }
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -898,12 +898,15 @@ static int ucsi_register_port(struct ucs
 	con->num = index + 1;
 	con->ucsi = ucsi;
 
+	/* Delay other interactions with the con until registration is complete */
+	mutex_lock(&con->lock);
+
 	/* Get connector capability */
 	command = UCSI_GET_CONNECTOR_CAPABILITY;
 	command |= UCSI_CONNECTOR_NUMBER(con->num);
 	ret = ucsi_send_command(ucsi, command, &con->cap, sizeof(con->cap));
 	if (ret < 0)
-		return ret;
+		goto out;
 
 	if (con->cap.op_mode & UCSI_CONCAP_OPMODE_DRP)
 		cap->data = TYPEC_PORT_DRD;
@@ -935,26 +938,32 @@ static int ucsi_register_port(struct ucs
 
 	ret = ucsi_register_port_psy(con);
 	if (ret)
-		return ret;
+		goto out;
 
 	/* Register the connector */
 	con->port = typec_register_port(ucsi->dev, cap);
-	if (IS_ERR(con->port))
-		return PTR_ERR(con->port);
+	if (IS_ERR(con->port)) {
+		ret = PTR_ERR(con->port);
+		goto out;
+	}
 
 	/* Alternate modes */
 	ret = ucsi_register_altmodes(con, UCSI_RECIPIENT_CON);
-	if (ret)
+	if (ret) {
 		dev_err(ucsi->dev, "con%d: failed to register alt modes\n",
 			con->num);
+		goto out;
+	}
 
 	/* Get the status */
 	command = UCSI_GET_CONNECTOR_STATUS | UCSI_CONNECTOR_NUMBER(con->num);
 	ret = ucsi_send_command(ucsi, command, &con->status, sizeof(con->status));
 	if (ret < 0) {
 		dev_err(ucsi->dev, "con%d: failed to get status\n", con->num);
-		return 0;
+		ret = 0;
+		goto out;
 	}
+	ret = 0; /* ucsi_send_command() returns length on success */
 
 	switch (UCSI_CONSTAT_PARTNER_TYPE(con->status.flags)) {
 	case UCSI_CONSTAT_PARTNER_TYPE_UFP:
@@ -979,17 +988,21 @@ static int ucsi_register_port(struct ucs
 
 	if (con->partner) {
 		ret = ucsi_register_altmodes(con, UCSI_RECIPIENT_SOP);
-		if (ret)
+		if (ret) {
 			dev_err(ucsi->dev,
 				"con%d: failed to register alternate modes\n",
 				con->num);
-		else
+			ret = 0;
+		} else {
 			ucsi_altmode_update_active(con);
+		}
 	}
 
 	trace_ucsi_register_port(con->num, &con->status);
 
-	return 0;
+out:
+	mutex_unlock(&con->lock);
+	return ret;
 }
 
 /**


