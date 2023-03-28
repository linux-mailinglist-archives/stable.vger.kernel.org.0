Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28F586CBE53
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 14:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbjC1MBi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 08:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232598AbjC1MBh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 08:01:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF721710
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 05:01:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87F38B81C24
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 12:01:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0314C433D2;
        Tue, 28 Mar 2023 12:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680004893;
        bh=LZS3l9X3bWUBaBdtY6Hrf1MtNdX4ZGdSs7uiOy0X7Rc=;
        h=Subject:To:Cc:From:Date:From;
        b=bNlYuGaX4pJvtGY9zQcdRQGjau2smLloeHLDzRoqdnf8+Pb2Pb1CJHBzG3BcN4neW
         hNF9D8r4ldA3JqNXUqrbAn/h0ui0Yop4o9608j++uUdcTC6oq3J+vnRXUrIYfWbin9
         sBVRrZ4erCriYmGQw7mEkfDKzEjo/XwRVXrrSx8M=
Subject: FAILED: patch "[PATCH] usb: ucsi: Fix ucsi->connector race" failed to apply to 5.10-stable tree
To:     hdegoede@redhat.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 28 Mar 2023 14:01:24 +0200
Message-ID: <1680004884147142@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.10.y
git checkout FETCH_HEAD
git cherry-pick -x 0482c34ec6f8557e06cd0f8e2d0e20e8ede6a22c
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1680004884147142@kroah.com' --subject-prefix 'PATCH 5.10.y' HEAD^..

Possible dependencies:

0482c34ec6f8 ("usb: ucsi: Fix ucsi->connector race")
f87fb985452a ("usb: ucsi: Fix NULL pointer deref in ucsi_connector_change()")
924fb3ec50f5 ("Merge 6.2-rc7 into usb-next")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0482c34ec6f8557e06cd0f8e2d0e20e8ede6a22c Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Wed, 8 Mar 2023 16:42:43 +0100
Subject: [PATCH] usb: ucsi: Fix ucsi->connector race

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
Link: https://lore.kernel.org/r/20230308154244.722337-3-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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

