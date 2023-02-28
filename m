Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3FA46A550B
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 10:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbjB1JD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 04:03:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbjB1JD6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 04:03:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD499763
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 01:03:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677574992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sirfqygwoRQ697x8s2eJZOuvpqe/7SKCi+yX/4Aaiqw=;
        b=BlPXCrR+GDl4ERwGgqsSelakmaGlgB2COzUHPdxopqEQynFzEgTviPZZUHuCEn24zhmP3t
        HMgkKtYYfiqwBKdy2cmeZVGNYLpxICnONKhRqzkQOdaKuA+qlenbuJsslN7ndceGO704sj
        7TH/U9cIHZ4sxWJ43P4QKA1cBdyleR4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-618-csfzjiK4M_KF7a-7dT3fgg-1; Tue, 28 Feb 2023 04:03:08 -0500
X-MC-Unique: csfzjiK4M_KF7a-7dT3fgg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 70ECF857A94;
        Tue, 28 Feb 2023 09:03:08 +0000 (UTC)
Received: from shalem.redhat.com (unknown [10.39.194.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9B901492B0F;
        Tue, 28 Feb 2023 09:03:07 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 2/3] usb: ucsi: Fix ucsi->connector race
Date:   Tue, 28 Feb 2023 10:03:04 +0100
Message-Id: <20230228090305.9335-2-hdegoede@redhat.com>
In-Reply-To: <20230228090305.9335-1-hdegoede@redhat.com>
References: <20230228090305.9335-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ucsi_init() which runs from a workqueue sets ucsi->connector and
on an error will clear it again.

ucsi->connector gets dereferenced by both ucsi_connector_change() and
ucsi_resume(), both check for ucsi->connector being NULL in case
ucsi_init() has not finished yet; or in case ucsi_init() has failed.

ucsi_init() setting ucsi->connector and then clearing it again on
an error creates a race where the check in the consumers may pass,
only to have ucsi->connector free-ed underneath them when ucsi_init()
hits an error.

Fix this race by making ucsi_init() store the connector array in
a local variable and only assign it to ucsi->connector on success.

Fixes: bdc62f2bae8f ("usb: typec: ucsi: Simplified registration and I/O API")
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/typec/ucsi/ucsi.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index e762897cb25a..796ae230c60b 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1045,9 +1045,8 @@ static struct fwnode_handle *ucsi_find_fwnode(struct ucsi_connector *con)
 	return NULL;
 }
 
-static int ucsi_register_port(struct ucsi *ucsi, int index)
+static int ucsi_register_port(struct ucsi *ucsi, int index, struct ucsi_connector *con)
 {
-	struct ucsi_connector *con = &ucsi->connector[index];
 	struct typec_capability *cap = &con->typec_cap;
 	enum typec_accessory *accessory = cap->accessory;
 	enum usb_role u_role = USB_ROLE_NONE;
@@ -1210,7 +1209,7 @@ static int ucsi_register_port(struct ucsi *ucsi, int index)
  */
 static int ucsi_init(struct ucsi *ucsi)
 {
-	struct ucsi_connector *con;
+	struct ucsi_connector *con, *connector;
 	u64 command;
 	int ret;
 	int i;
@@ -1241,16 +1240,15 @@ static int ucsi_init(struct ucsi *ucsi)
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
+		ret = ucsi_register_port(ucsi, i, &connector[i]);
 		if (ret)
 			goto err_unregister;
 	}
@@ -1262,10 +1260,11 @@ static int ucsi_init(struct ucsi *ucsi)
 	if (ret < 0)
 		goto err_unregister;
 
+	ucsi->connector = connector;
 	return 0;
 
 err_unregister:
-	for (con = ucsi->connector; con->port; con++) {
+	for (con = connector; con->port; con++) {
 		ucsi_unregister_partner(con);
 		ucsi_unregister_altmodes(con, UCSI_RECIPIENT_CON);
 		ucsi_unregister_port_psy(con);
@@ -1274,10 +1273,7 @@ static int ucsi_init(struct ucsi *ucsi)
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

