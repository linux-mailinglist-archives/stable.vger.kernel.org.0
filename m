Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 030E56D0F46
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 21:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbjC3Tsa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 15:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbjC3Ts0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 15:48:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67ADE1042D
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 12:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680205620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Vanow7J+J1OaYA35NyY3GE3Voy18sopyES4Cj5nj10I=;
        b=GwheJPPMJEzIbEbXz1dbrhwjoaQHJVRNWFaFJw9GnB5r516ERQyZROMjnfXLcPwp7sPiNl
        7sQNIVPgLMioDQgolqFqKGY8hP7mUZWG9QeZxuUkAM5dIOvm/Jb9T48b6JkTG77cHRdkY2
        V3BPSskowlXaMS9bttky4YB/zkLpViE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-141-LA-IGvCqMU-dv92Fi2Sd8g-1; Thu, 30 Mar 2023 15:46:57 -0400
X-MC-Unique: LA-IGvCqMU-dv92Fi2Sd8g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 041DC88B7A1;
        Thu, 30 Mar 2023 19:46:56 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0D59F440D8;
        Thu, 30 Mar 2023 19:46:52 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Mark Gross <markgross@kernel.org>,
        Andy Shevchenko <andy@kernel.org>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        =?UTF-8?q?Barnab=C3=A1s=20P=C5=91cze?= <pobrn@protonmail.com>,
        Kai Heng Feng <kai.heng.feng@canonical.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>,
        GOESSEL Guillaume <g_goessel@outlook.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Manyi Li <limanyi@uniontech.com>,
        =?UTF-8?q?Eray=20Or=C3=A7unus?= <erayorcunus@gmail.com>,
        Philipp Jungkamp <p.jungkamp@gmx.net>,
        Arnav Rawat <arnavr3@illinois.edu>,
        Kelly Anderson <kelly@xilka.com>, Meng Dong <whenov@gmail.com>,
        Felix Eckhofer <felix@eckhofer.com>,
        Ike Panhc <ike.pan@canonical.com>,
        platform-driver-x86@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] platform/x86: ideapad-laptop: Stop sending KEY_TOUCHPAD_TOGGLE
Date:   Thu, 30 Mar 2023 21:46:44 +0200
Message-Id: <20230330194644.64628-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 5829f8a897e4 ("platform/x86: ideapad-laptop: Send
KEY_TOUCHPAD_TOGGLE on some models") made ideapad-laptop send
KEY_TOUCHPAD_TOGGLE when we receive an ACPI notify with VPC event bit 5 set
and the touchpad-state has not been changed by the EC itself already.

This was done under the assumption that this would be good to do to make
the touchpad-toggle hotkey work on newer models where the EC does not
toggle the touchpad on/off itself (because it is not routed through
the PS/2 controller, but uses I2C).

But it turns out that at least some models, e.g. the Yoga 7-15ITL5 the EC
triggers an ACPI notify with VPC event bit 5 set on resume, which would
now cause a spurious KEY_TOUCHPAD_TOGGLE on resume to which the desktop
environment responds by disabling the touchpad in software, breaking
the touchpad (until manually re-enabled) on resume.

It was never confirmed that sending KEY_TOUCHPAD_TOGGLE actually improves
things on new models and at least some new models like the Yoga 7-15ITL5
don't have a touchpad on/off toggle hotkey at all, while still sending
ACPI notify events with VPC event bit 5 set.

So it seems best to revert the change to send KEY_TOUCHPAD_TOGGLE when
receiving an ACPI notify events with VPC event bit 5 and the touchpad
state as reported by the EC has not changed.

Note this is not a full revert the code to cache the last EC touchpad
state is kept to avoid sending spurious KEY_TOUCHPAD_ON / _OFF events
on resume.

Fixes: 5829f8a897e4 ("platform/x86: ideapad-laptop: Send KEY_TOUCHPAD_TOGGLE on some models")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217234
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/platform/x86/ideapad-laptop.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index b5ef3452da1f..35c63cce0479 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -1170,7 +1170,6 @@ static const struct key_entry ideapad_keymap[] = {
 	{ KE_KEY,  65, { KEY_PROG4 } },
 	{ KE_KEY,  66, { KEY_TOUCHPAD_OFF } },
 	{ KE_KEY,  67, { KEY_TOUCHPAD_ON } },
-	{ KE_KEY,  68, { KEY_TOUCHPAD_TOGGLE } },
 	{ KE_KEY, 128, { KEY_ESC } },
 
 	/*
@@ -1526,18 +1525,16 @@ static void ideapad_sync_touchpad_state(struct ideapad_private *priv, bool send_
 	if (priv->features.ctrl_ps2_aux_port)
 		i8042_command(&param, value ? I8042_CMD_AUX_ENABLE : I8042_CMD_AUX_DISABLE);
 
-	if (send_events) {
-		/*
-		 * On older models the EC controls the touchpad and toggles it
-		 * on/off itself, in this case we report KEY_TOUCHPAD_ON/_OFF.
-		 * If the EC did not toggle, report KEY_TOUCHPAD_TOGGLE.
-		 */
-		if (value != priv->r_touchpad_val) {
-			ideapad_input_report(priv, value ? 67 : 66);
-			sysfs_notify(&priv->platform_device->dev.kobj, NULL, "touchpad");
-		} else {
-			ideapad_input_report(priv, 68);
-		}
+	/*
+	 * On older models the EC controls the touchpad and toggles it on/off
+	 * itself, in this case we report KEY_TOUCHPAD_ON/_OFF. Some models do
+	 * an acpi-notify with VPC bit 5 set on resume, so this function get
+	 * called with send_events=true on every resume. Therefor if the EC did
+	 * not toggle, do nothing to avoid sending spurious KEY_TOUCHPAD_TOGGLE.
+	 */
+	if (send_events && value != priv->r_touchpad_val) {
+		ideapad_input_report(priv, value ? 67 : 66);
+		sysfs_notify(&priv->platform_device->dev.kobj, NULL, "touchpad");
 	}
 
 	priv->r_touchpad_val = value;
-- 
2.39.1

