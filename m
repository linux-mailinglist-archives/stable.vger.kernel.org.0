Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C091059D22C
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 09:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240990AbiHWH3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 03:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241082AbiHWH2r (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 03:28:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39CEDE0B8
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 00:28:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D9B561521
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 07:28:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 307F6C433D6;
        Tue, 23 Aug 2022 07:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661239710;
        bh=YGmh1oLnttke3ZGRrO+ovvKC0KrFsckgzUz2BFUzs0Q=;
        h=Subject:To:From:Date:From;
        b=SvgdwlfXaqCHTwSiMd4G1mk0PUwNy49AV/w2IcjgnNBjEkLPKVBgFLRPZbFfS0iyj
         dbRs9YED1DUz21BeLK69Ch1Y+rLLeUfISPONRO+bbMofkdi7rUMIuZhl2rxZQbxoJC
         2dxs0c9tKUKTvufbwqiQbnfrD1HC31Wv0E1A3A38=
Subject: patch "Revert "usb: typec: ucsi: add a common function" added to usb-linus
To:     tiwai@suse.de, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Aug 2022 09:28:27 +0200
Message-ID: <16612397076532@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Revert "usb: typec: ucsi: add a common function

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 5f73aa2cf8bef4a39baa1591c3144ede4788826e Mon Sep 17 00:00:00 2001
From: Takashi Iwai <tiwai@suse.de>
Date: Tue, 23 Aug 2022 08:54:55 +0200
Subject: Revert "usb: typec: ucsi: add a common function
 ucsi_unregister_connectors()"

The recent commit 87d0e2f41b8c ("usb: typec: ucsi: add a common
function ucsi_unregister_connectors()") introduced a regression that
caused NULL dereference at reading the power supply sysfs.  It's a
stale sysfs entry that should have been removed but remains with NULL
ops.  The commit changed the error handling to skip the entries after
a NULL con->wq, and this leaves the power device unreleased.

For addressing the regression, the straight revert is applied here.
Further code improvements can be done from the scratch again.

Link: https://bugzilla.suse.com/show_bug.cgi?id=1202386
Link: https://lore.kernel.org/r/87r11cmbx0.wl-tiwai@suse.de
Fixes: 87d0e2f41b8c ("usb: typec: ucsi: add a common function ucsi_unregister_connectors()")
Cc: <stable@vger.kernel.org>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20220823065455.32579-1-tiwai@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c | 53 ++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 29 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 1aea46493b85..7f2624f42724 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1200,32 +1200,6 @@ static int ucsi_register_port(struct ucsi *ucsi, int index)
 	return ret;
 }
 
-static void ucsi_unregister_connectors(struct ucsi *ucsi)
-{
-	struct ucsi_connector *con;
-	int i;
-
-	if (!ucsi->connector)
-		return;
-
-	for (i = 0; i < ucsi->cap.num_connectors; i++) {
-		con = &ucsi->connector[i];
-
-		if (!con->wq)
-			break;
-
-		cancel_work_sync(&con->work);
-		ucsi_unregister_partner(con);
-		ucsi_unregister_altmodes(con, UCSI_RECIPIENT_CON);
-		ucsi_unregister_port_psy(con);
-		destroy_workqueue(con->wq);
-		typec_unregister_port(con->port);
-	}
-
-	kfree(ucsi->connector);
-	ucsi->connector = NULL;
-}
-
 /**
  * ucsi_init - Initialize UCSI interface
  * @ucsi: UCSI to be initialized
@@ -1234,6 +1208,7 @@ static void ucsi_unregister_connectors(struct ucsi *ucsi)
  */
 static int ucsi_init(struct ucsi *ucsi)
 {
+	struct ucsi_connector *con;
 	u64 command;
 	int ret;
 	int i;
@@ -1264,7 +1239,7 @@ static int ucsi_init(struct ucsi *ucsi)
 	}
 
 	/* Allocate the connectors. Released in ucsi_unregister() */
-	ucsi->connector = kcalloc(ucsi->cap.num_connectors,
+	ucsi->connector = kcalloc(ucsi->cap.num_connectors + 1,
 				  sizeof(*ucsi->connector), GFP_KERNEL);
 	if (!ucsi->connector) {
 		ret = -ENOMEM;
@@ -1288,7 +1263,15 @@ static int ucsi_init(struct ucsi *ucsi)
 	return 0;
 
 err_unregister:
-	ucsi_unregister_connectors(ucsi);
+	for (con = ucsi->connector; con->port; con++) {
+		ucsi_unregister_partner(con);
+		ucsi_unregister_altmodes(con, UCSI_RECIPIENT_CON);
+		ucsi_unregister_port_psy(con);
+		if (con->wq)
+			destroy_workqueue(con->wq);
+		typec_unregister_port(con->port);
+		con->port = NULL;
+	}
 
 err_reset:
 	memset(&ucsi->cap, 0, sizeof(ucsi->cap));
@@ -1402,6 +1385,7 @@ EXPORT_SYMBOL_GPL(ucsi_register);
 void ucsi_unregister(struct ucsi *ucsi)
 {
 	u64 cmd = UCSI_SET_NOTIFICATION_ENABLE;
+	int i;
 
 	/* Make sure that we are not in the middle of driver initialization */
 	cancel_delayed_work_sync(&ucsi->work);
@@ -1409,7 +1393,18 @@ void ucsi_unregister(struct ucsi *ucsi)
 	/* Disable notifications */
 	ucsi->ops->async_write(ucsi, UCSI_CONTROL, &cmd, sizeof(cmd));
 
-	ucsi_unregister_connectors(ucsi);
+	for (i = 0; i < ucsi->cap.num_connectors; i++) {
+		cancel_work_sync(&ucsi->connector[i].work);
+		ucsi_unregister_partner(&ucsi->connector[i]);
+		ucsi_unregister_altmodes(&ucsi->connector[i],
+					 UCSI_RECIPIENT_CON);
+		ucsi_unregister_port_psy(&ucsi->connector[i]);
+		if (ucsi->connector[i].wq)
+			destroy_workqueue(ucsi->connector[i].wq);
+		typec_unregister_port(ucsi->connector[i].port);
+	}
+
+	kfree(ucsi->connector);
 }
 EXPORT_SYMBOL_GPL(ucsi_unregister);
 
-- 
2.37.2


