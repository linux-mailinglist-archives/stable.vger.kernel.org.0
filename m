Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4426157B9
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbiKBChh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiKBChg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:37:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 116F8F5B7
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:37:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96AC5616DB
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:37:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37651C433D6;
        Wed,  2 Nov 2022 02:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667356654;
        bh=q9ZOdsNbZAtzjEmS5+jhGnATZh54N3efNrwal5b1PlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N08oW9F4ES46Ko5mCr/wEAfWX83TkMmZB5G0E+1jrja/DpfqtQYkeHBp42ligLz+f
         83cVzdbFqTK7a6gSDgbA5uJ5DOfY7rDGtVX00I3Miv5mooVZteGSuStfygmjwjJRHw
         pCqQCrM0BWKC7eJgTLFiYPGBObQd3CmYRZ3Yr1YM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.0 029/240] usb: typec: ucsi: Check the connection on resume
Date:   Wed,  2 Nov 2022 03:30:04 +0100
Message-Id: <20221102022112.062218232@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit 99f6d43611135bd6f211dec9e88bb41e4167e304 upstream.

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
 drivers/usb/typec/ucsi/ucsi.c |   42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -183,16 +183,6 @@ out:
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
@@ -744,6 +734,7 @@ static void ucsi_partner_change(struct u
 
 static int ucsi_check_connection(struct ucsi_connector *con)
 {
+	u8 prev_flags = con->status.flags;
 	u64 command;
 	int ret;
 
@@ -754,10 +745,13 @@ static int ucsi_check_connection(struct
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
@@ -1276,6 +1270,28 @@ err:
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


