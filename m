Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82886612FC2
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 06:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiJaFj2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 01:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbiJaFj2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 01:39:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53670A186
        for <stable@vger.kernel.org>; Sun, 30 Oct 2022 22:39:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED47C60FA5
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 05:39:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 086E7C433D7;
        Mon, 31 Oct 2022 05:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667194766;
        bh=7IFbjFSXY2bvf4+r5uqHCOjUjViw8XPjvutA+wsgmSM=;
        h=Subject:To:Cc:From:Date:From;
        b=pfpPlFZr4rEXxMNjkXYEZ5kJ1lzU5To+UEvx6jpE8ZQOeoCWhOv0NZEmRIj8694HX
         UcJFY1jja2Rxzr8qpCiB02B7NZh796P+QilVac+6JvSsPxKrRfiWrWgHw1c4OfxVih
         rjfNYLyURea7WAvjX2si7Dah1AQaroQDXzccih14=
Subject: FAILED: patch "[PATCH] usb: typec: ucsi: Check the connection on resume" failed to apply to 5.15-stable tree
To:     heikki.krogerus@linux.intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Oct 2022 06:40:22 +0100
Message-ID: <16671948222947@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

99f6d4361113 ("usb: typec: ucsi: Check the connection on resume")
512df95b9432 ("usb: typec: ucsi: Better fix for missing unplug events issue")
bd19ac98f77e ("usb: typec: ucsi: Read the PDOs in separate work")
6cbe4b2d5a3f ("usb: typec: ucsi: Check the partner alt modes always if there is PD contract")
b9aa02ca39a4 ("usb: typec: ucsi: Add polling mechanism for partner tasks like alt mode checking")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 99f6d43611135bd6f211dec9e88bb41e4167e304 Mon Sep 17 00:00:00 2001
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Date: Fri, 7 Oct 2022 13:09:50 +0300
Subject: [PATCH] usb: typec: ucsi: Check the connection on resume

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

