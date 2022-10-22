Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23AA2608C69
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 13:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbiJVLQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 07:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbiJVLPq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 07:15:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855D4160EF8
        for <stable@vger.kernel.org>; Sat, 22 Oct 2022 03:39:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05425B8077D
        for <stable@vger.kernel.org>; Sat, 22 Oct 2022 10:39:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69E9EC433D6;
        Sat, 22 Oct 2022 10:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666435152;
        bh=bs+Q17QP1WBehkzBKf/CWGf95z88KQfBoNP7prZwfZk=;
        h=Subject:To:From:Date:From;
        b=YftLVPaOzvFysEzAvR9hyuD1zhZFkADYbOV7xqTYvC0R8/bR5cmfb8gg/1vZth9EC
         qNKPcMBwwtMX3Il6JAhAsOssa3UEkfeL2lFHYYB7APqMNC+3rmL5tkIvhoDygcHzMo
         cOqQKX5LRAJv3av72k6m7d26M+5VVDKkVN9tsYlI=
Subject: patch "usb: typec: ucsi: Check the connection on resume" added to usb-linus
To:     heikki.krogerus@linux.intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 22 Oct 2022 12:39:10 +0200
Message-ID: <1666435150239198@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: ucsi: Check the connection on resume

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 99f6d43611135bd6f211dec9e88bb41e4167e304 Mon Sep 17 00:00:00 2001
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Date: Fri, 7 Oct 2022 13:09:50 +0300
Subject: usb: typec: ucsi: Check the connection on resume

Checking the connection status of every port on resume. This
fixes an issue where the partner device is not unregistered
properly after resume if it was unplugged while the system
was suspended.

The function ucsi_check_connection() is also modified so
that it can be used also for registering the connection on
top of unregistering it.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=210425
Fixes: a94ecde41f7e ("usb: typec: ucsi: ccg: enable runtime pm support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20221007100951.43798-2-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c | 42 ++++++++++++++++++++++++-----------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 74fb5a4c6f21..a7987fc764cc 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -183,16 +183,6 @@ int ucsi_send_command(struct ucsi *ucsi, u64 command,
 }
 EXPORT_SYMBOL_GPL(ucsi_send_command);
 
-int ucsi_resume(struct ucsi *ucsi)
-{
-	u64 command;
-
-	/* Restore UCSI notification enable mask after system resume */
-	command = UCSI_SET_NOTIFICATION_ENABLE | ucsi->ntfy;
-
-	return ucsi_send_command(ucsi, command, NULL, 0);
-}
-EXPORT_SYMBOL_GPL(ucsi_resume);
 /* -------------------------------------------------------------------------- */
 
 struct ucsi_work {
@@ -744,6 +734,7 @@ static void ucsi_partner_change(struct ucsi_connector *con)
 
 static int ucsi_check_connection(struct ucsi_connector *con)
 {
+	u8 prev_flags = con->status.flags;
 	u64 command;
 	int ret;
 
@@ -754,10 +745,13 @@ static int ucsi_check_connection(struct ucsi_connector *con)
 		return ret;
 	}
 
+	if (con->status.flags == prev_flags)
+		return 0;
+
 	if (con->status.flags & UCSI_CONSTAT_CONNECTED) {
-		if (UCSI_CONSTAT_PWR_OPMODE(con->status.flags) ==
-		    UCSI_CONSTAT_PWR_OPMODE_PD)
-			ucsi_partner_task(con, ucsi_check_altmodes, 30, 0);
+		ucsi_register_partner(con);
+		ucsi_pwr_opmode_change(con);
+		ucsi_partner_change(con);
 	} else {
 		ucsi_partner_change(con);
 		ucsi_port_psy_changed(con);
@@ -1276,6 +1270,28 @@ static int ucsi_init(struct ucsi *ucsi)
 	return ret;
 }
 
+int ucsi_resume(struct ucsi *ucsi)
+{
+	struct ucsi_connector *con;
+	u64 command;
+	int ret;
+
+	/* Restore UCSI notification enable mask after system resume */
+	command = UCSI_SET_NOTIFICATION_ENABLE | ucsi->ntfy;
+	ret = ucsi_send_command(ucsi, command, NULL, 0);
+	if (ret < 0)
+		return ret;
+
+	for (con = ucsi->connector; con->port; con++) {
+		mutex_lock(&con->lock);
+		ucsi_check_connection(con);
+		mutex_unlock(&con->lock);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ucsi_resume);
+
 static void ucsi_init_work(struct work_struct *work)
 {
 	struct ucsi *ucsi = container_of(work, struct ucsi, work.work);
-- 
2.38.1


