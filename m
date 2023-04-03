Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC7846D4AF1
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234236AbjDCOvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234040AbjDCOvM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:51:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E454C29842
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:50:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D40CE61F98
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:50:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8699C433EF;
        Mon,  3 Apr 2023 14:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533433;
        bh=SL9vP91TiOgziN1DVY1wcM6XD1ldUcY0fMcRAXmAEH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2goRHzDIdlsSS27kpXqp8IYUfy+Br2MCEcEHU+Cx1HPhlFTUNDhkj1mONbgUGYUl4
         6Cyv7ekbT1qwKmCu/zaikk+YK+QjjcOpLFlZrYByE023aUoNx6mk0bW6jwjaOYse8Q
         jck8mH7O3SF8NeKJbYPw2dwo2XHORm4vZnOweBEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.2 152/187] platform/x86: ideapad-laptop: Stop sending KEY_TOUCHPAD_TOGGLE
Date:   Mon,  3 Apr 2023 16:09:57 +0200
Message-Id: <20230403140421.062354916@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit e3271a5917d1501089b1a224d702aa053e2877f4 upstream.

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
Link: https://lore.kernel.org/r/20230330194644.64628-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/ideapad-laptop.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -1170,7 +1170,6 @@ static const struct key_entry ideapad_ke
 	{ KE_KEY,  65, { KEY_PROG4 } },
 	{ KE_KEY,  66, { KEY_TOUCHPAD_OFF } },
 	{ KE_KEY,  67, { KEY_TOUCHPAD_ON } },
-	{ KE_KEY,  68, { KEY_TOUCHPAD_TOGGLE } },
 	{ KE_KEY, 128, { KEY_ESC } },
 
 	/*
@@ -1526,18 +1525,16 @@ static void ideapad_sync_touchpad_state(
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


