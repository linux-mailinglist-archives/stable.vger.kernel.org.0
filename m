Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 598C0304B58
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbhAZErI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:47:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:58352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728685AbhAYSnn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:43:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51562224DF;
        Mon, 25 Jan 2021 18:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600200;
        bh=w1OnTU9k+cQiUb9aXuBJ2basIp27sxGyMU7OKMjUXmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rpWJ4NOeLrNJIlLYK7S76Ia5Fut8nWotkoofCAlXN+O0MSghJFYc7oYNXPI7ZmhN5
         Wg/IwOTkOXJEClalvB2YlkFBqlVlOLwXJro79CcdmHl9+hYGlUUcR3fySAxalURWd9
         7L0Wigs/OWwnzuakXBLTSxqbs4Ch6tXAPlLH3w+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.4 03/86] platform/x86: ideapad-laptop: Disable touchpad_switch for ELAN0634
Date:   Mon, 25 Jan 2021 19:38:45 +0100
Message-Id: <20210125183201.181510720@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183201.024962206@linuxfoundation.org>
References: <20210125183201.024962206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

commit f419e5940f1d9892ea6f45acdaca572b9e73ff39 upstream.

Newer ideapads (e.g.: Yoga 14s, 720S 14) come with ELAN0634 touchpad do not
use EC to switch touchpad.

Reading VPCCMD_R_TOUCHPAD will return zero thus touchpad may be blocked
unexpectedly.
Writing VPCCMD_W_TOUCHPAD may cause a spurious key press.

Add has_touchpad_switch to workaround these machines.

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: stable@vger.kernel.org # 5.4+
--
v2: Specify touchpad to ELAN0634
v3: Stupid missing ! in v2
v4: Correct acpi_dev_present usage (Hans)
Link: https://lore.kernel.org/r/20210107144438.12605-1-jiaxun.yang@flygoat.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/ideapad-laptop.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -92,6 +92,7 @@ struct ideapad_private {
 	struct dentry *debug;
 	unsigned long cfg;
 	bool has_hw_rfkill_switch;
+	bool has_touchpad_switch;
 	const char *fnesc_guid;
 };
 
@@ -535,7 +536,9 @@ static umode_t ideapad_is_visible(struct
 	} else if (attr == &dev_attr_fn_lock.attr) {
 		supported = acpi_has_method(priv->adev->handle, "HALS") &&
 			acpi_has_method(priv->adev->handle, "SALS");
-	} else
+	} else if (attr == &dev_attr_touchpad.attr)
+		supported = priv->has_touchpad_switch;
+	else
 		supported = true;
 
 	return supported ? attr->mode : 0;
@@ -867,6 +870,9 @@ static void ideapad_sync_touchpad_state(
 {
 	unsigned long value;
 
+	if (!priv->has_touchpad_switch)
+		return;
+
 	/* Without reading from EC touchpad LED doesn't switch state */
 	if (!read_ec_data(priv->adev->handle, VPCCMD_R_TOUCHPAD, &value)) {
 		/* Some IdeaPads don't really turn off touchpad - they only
@@ -989,6 +995,9 @@ static int ideapad_acpi_add(struct platf
 	priv->platform_device = pdev;
 	priv->has_hw_rfkill_switch = dmi_check_system(hw_rfkill_list);
 
+	/* Most ideapads with ELAN0634 touchpad don't use EC touchpad switch */
+	priv->has_touchpad_switch = !acpi_dev_present("ELAN0634", NULL, -1);
+
 	ret = ideapad_sysfs_init(priv);
 	if (ret)
 		return ret;
@@ -1006,6 +1015,10 @@ static int ideapad_acpi_add(struct platf
 	if (!priv->has_hw_rfkill_switch)
 		write_ec_cmd(priv->adev->handle, VPCCMD_W_RF, 1);
 
+	/* The same for Touchpad */
+	if (!priv->has_touchpad_switch)
+		write_ec_cmd(priv->adev->handle, VPCCMD_W_TOUCHPAD, 1);
+
 	for (i = 0; i < IDEAPAD_RFKILL_DEV_NUM; i++)
 		if (test_bit(ideapad_rfk_data[i].cfgbit, &priv->cfg))
 			ideapad_register_rfkill(priv, i);


