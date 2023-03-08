Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 729E06B0D3F
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 16:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbjCHPpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 10:45:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbjCHPpE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 10:45:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A85C32529C
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 07:43:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678290180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TSWG9DFcmaHYhC7dIu4qV+c+MWuYP7IP2kkl0lMkChA=;
        b=PkfG9jeqJXvrDSEyPxRWLqhk/A1Ov/QT2HxA2UlTOD7OVyIzVhZcRWD8wcGTeb9E4A6Eo3
        GQmPpCUNsH4Tif4FBoxZyijOb6R0y3g0xbDA4NuLoD99E/5UfDTlsoKvxNt6Kl32YglquL
        ulFZgrePoOWqBJLAl69t/tzEWz2GwpA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-plEZV9wLP3iyWqQyYZpgdA-1; Wed, 08 Mar 2023 10:42:56 -0500
X-MC-Unique: plEZV9wLP3iyWqQyYZpgdA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A0305802D38;
        Wed,  8 Mar 2023 15:42:55 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.195.179])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C1324492B04;
        Wed,  8 Mar 2023 15:42:54 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v4 2/3] usb: ucsi: Fix ucsi->connector race
Date:   Wed,  8 Mar 2023 16:42:43 +0100
Message-Id: <20230308154244.722337-3-hdegoede@redhat.com>
In-Reply-To: <20230308154244.722337-1-hdegoede@redhat.com>
References: <20230308154244.722337-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ucsi_init() which runs from a workqueue sets ucsi->connector and
on an error will clear it again.

ucsi->connector gets dereferenced by ucsi_resume(), this checks for
ucsi->connector being NULL in case ucsi_init() has not finished yet;
or in case ucsi_init() has failed.

ucsi_init() setting ucsi->connector and then clearing it again on
an error creates a race where the check in ucsi_resume() may pass,
only to have ucsi->connector free-ed underneath it when ucsi_init()
hits an error.

Fix this race by making ucsi_init() store the connector array in
a local variable and only assign it to ucsi->connector on success.

Fixes: bdc62f2bae8f ("usb: typec: ucsi: Simplified registration and I/O API")
Cc: stable@vger.kernel.org
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
Changes in v4:
- Rebase on top of v6.3-rc1

Changes in v3:
- Assign connector[i].index before calling ucsi_register_port() instead of
  passing i to ucsi_register_port()
---
 drivers/usb/typec/ucsi/ucsi.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 0623861c597b..8d1baf28df55 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1125,12 +1125,11 @@ static struct fwnode_handle *ucsi_find_fwnode(struct ucsi_connector *con)
 	return NULL;
 }
 
-static int ucsi_register_port(struct ucsi *ucsi, int index)
+static int ucsi_register_port(struct ucsi *ucsi, struct ucsi_connector *con)
 {
 	struct usb_power_delivery_desc desc = { ucsi->cap.pd_version};
 	struct usb_power_delivery_capabilities_desc pd_caps;
 	struct usb_power_delivery_capabilities *pd_cap;
-	struct ucsi_connector *con = &ucsi->connector[index];
 	struct typec_capability *cap = &con->typec_cap;
 	enum typec_accessory *accessory = cap->accessory;
 	enum usb_role u_role = USB_ROLE_NONE;
@@ -1151,7 +1150,6 @@ static int ucsi_register_port(struct ucsi *ucsi, int index)
 	init_completion(&con->complete);
 	mutex_init(&con->lock);
 	INIT_LIST_HEAD(&con->partner_tasks);
-	con->num = index + 1;
 	con->ucsi = ucsi;
 
 	cap->fwnode = ucsi_find_fwnode(con);
@@ -1328,7 +1326,7 @@ static int ucsi_register_port(struct ucsi *ucsi, int index)
  */
 static int ucsi_init(struct ucsi *ucsi)
 {
-	struct ucsi_connector *con;
+	struct ucsi_connector *con, *connector;
 	u64 command, ntfy;
 	int ret;
 	int i;
@@ -1359,16 +1357,16 @@ static int ucsi_init(struct ucsi *ucsi)
 	}
 
 	/* Allocate the connectors. Released in ucsi_unregister() */
-	ucsi->connector = kcalloc(ucsi->cap.num_connectors + 1,
-				  sizeof(*ucsi->connector), GFP_KERNEL);
-	if (!ucsi->connector) {
+	connector = kcalloc(ucsi->cap.num_connectors + 1, sizeof(*connector), GFP_KERNEL);
+	if (!connector) {
 		ret = -ENOMEM;
 		goto err_reset;
 	}
 
 	/* Register all connectors */
 	for (i = 0; i < ucsi->cap.num_connectors; i++) {
-		ret = ucsi_register_port(ucsi, i);
+		connector[i].num = i + 1;
+		ret = ucsi_register_port(ucsi, &connector[i]);
 		if (ret)
 			goto err_unregister;
 	}
@@ -1380,11 +1378,12 @@ static int ucsi_init(struct ucsi *ucsi)
 	if (ret < 0)
 		goto err_unregister;
 
+	ucsi->connector = connector;
 	ucsi->ntfy = ntfy;
 	return 0;
 
 err_unregister:
-	for (con = ucsi->connector; con->port; con++) {
+	for (con = connector; con->port; con++) {
 		ucsi_unregister_partner(con);
 		ucsi_unregister_altmodes(con, UCSI_RECIPIENT_CON);
 		ucsi_unregister_port_psy(con);
@@ -1400,10 +1399,7 @@ static int ucsi_init(struct ucsi *ucsi)
 		typec_unregister_port(con->port);
 		con->port = NULL;
 	}
-
-	kfree(ucsi->connector);
-	ucsi->connector = NULL;
-
+	kfree(connector);
 err_reset:
 	memset(&ucsi->cap, 0, sizeof(ucsi->cap));
 	ucsi_reset_ppm(ucsi);
-- 
2.39.1

