Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C206D23FEC0
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 16:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgHIOTU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Aug 2020 10:19:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28704 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726352AbgHIOTU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Aug 2020 10:19:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596982758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NWuhdRNFsPxXU+Bf130T3sVhhKplhtrUijH7YH5SeWo=;
        b=QCKmPtpRlq6UEkQvumQ0idbVWkFdLh3y5lg9/wYr70V0EZ3t0NyqqHVRqZFT+cl5xkavkK
        PbE0vcgFgU0klAwXfVKbS6+AIb1IPTpqhwVDb9fj+eqQGhplTwRW9mIc0dvwz6Lp8f1EJ/
        81x8+5gHxJi/HtnN5Vn2i6O3kOq9+JQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-ooPjd17bN3mek-Oa8UqE8g-1; Sun, 09 Aug 2020 10:19:14 -0400
X-MC-Unique: ooPjd17bN3mek-Oa8UqE8g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3784F8015F0;
        Sun,  9 Aug 2020 14:19:13 +0000 (UTC)
Received: from x1.localdomain.com (ovpn-112-24.ams2.redhat.com [10.36.112.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F1A9589528;
        Sun,  9 Aug 2020 14:19:11 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 4/4] usb: typec: ucsi: Hold con->lock for the entire duration of ucsi_register_port()
Date:   Sun,  9 Aug 2020 16:19:04 +0200
Message-Id: <20200809141904.4317-5-hdegoede@redhat.com>
In-Reply-To: <20200809141904.4317-1-hdegoede@redhat.com>
References: <20200809141904.4317-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/usb/typec/ucsi/displayport.c |  9 +-------
 drivers/usb/typec/ucsi/ucsi.c        | 31 ++++++++++++++++++++--------
 2 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/typec/ucsi/displayport.c b/drivers/usb/typec/ucsi/displayport.c
index 048381c058a5..261131c9e37c 100644
--- a/drivers/usb/typec/ucsi/displayport.c
+++ b/drivers/usb/typec/ucsi/displayport.c
@@ -288,8 +288,6 @@ struct typec_altmode *ucsi_register_displayport(struct ucsi_connector *con,
 	struct typec_altmode *alt;
 	struct ucsi_dp *dp;
 
-	mutex_lock(&con->lock);
-
 	/* We can't rely on the firmware with the capabilities. */
 	desc->vdo |= DP_CAP_DP_SIGNALING | DP_CAP_RECEPTACLE;
 
@@ -298,15 +296,12 @@ struct typec_altmode *ucsi_register_displayport(struct ucsi_connector *con,
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
 
@@ -319,7 +314,5 @@ struct typec_altmode *ucsi_register_displayport(struct ucsi_connector *con,
 	alt->ops = &ucsi_displayport_ops;
 	typec_altmode_set_drvdata(alt, dp);
 
-	mutex_unlock(&con->lock);
-
 	return alt;
 }
diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 182e34aa65ed..2999217c8109 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -898,12 +898,15 @@ static int ucsi_register_port(struct ucsi *ucsi, int index)
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
@@ -935,26 +938,32 @@ static int ucsi_register_port(struct ucsi *ucsi, int index)
 
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
@@ -979,17 +988,21 @@ static int ucsi_register_port(struct ucsi *ucsi, int index)
 
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
-- 
2.26.2

