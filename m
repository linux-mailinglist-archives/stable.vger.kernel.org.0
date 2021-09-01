Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC6E23FDC78
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344904AbhIAMvC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:51:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:49978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345851AbhIAMsm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:48:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D21E961222;
        Wed,  1 Sep 2021 12:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630500051;
        bh=NloJrDL1ejwp/rlW88MAS7qGRk/Nlm6pJziuz8bSjjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gYCA0cUCvvNA2ac3sux9Kk3bPkZV7C9NOk3zKV5PVXP0uXmo18jh6NdOkXCN4rggN
         n/39rTKNtONtcJNkHj/7DWp7y2uVFavlY4nFXv6AYAww0eUofd8cHzMa9rNEIy0qxP
         s1WkcKG8wfPCQ52inA0VeQVL5s0/JJd0CuWpbnDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 083/113] platform/x86: asus-nb-wmi: Allow configuring SW_TABLET_MODE method with a module option
Date:   Wed,  1 Sep 2021 14:28:38 +0200
Message-Id: <20210901122304.750670669@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 7f45621c14a209b986cd636447bb53b7f6f881c3 ]

Unfortunately we have been unable to find a reliable way to detect if
and how SW_TABLET_MODE reporting is supported, so we are relying on
DMI quirks for this.

Add a module-option to specify the SW_TABLET_MODE method so that this can
be easily tested without needing to rebuild the kernel.

BugLink: https://gitlab.freedesktop.org/libinput/libinput/-/issues/639
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210812145513.39117-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-nb-wmi.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index 0cb927f0f301..9929eedf7dd8 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -41,6 +41,10 @@ static int wapf = -1;
 module_param(wapf, uint, 0444);
 MODULE_PARM_DESC(wapf, "WAPF value");
 
+static int tablet_mode_sw = -1;
+module_param(tablet_mode_sw, uint, 0444);
+MODULE_PARM_DESC(tablet_mode_sw, "Tablet mode detect: -1:auto 0:disable 1:kbd-dock 2:lid-flip");
+
 static struct quirk_entry *quirks;
 
 static bool asus_q500a_i8042_filter(unsigned char data, unsigned char str,
@@ -477,6 +481,21 @@ static void asus_nb_wmi_quirks(struct asus_wmi_driver *driver)
 	else
 		wapf = quirks->wapf;
 
+	switch (tablet_mode_sw) {
+	case 0:
+		quirks->use_kbd_dock_devid = false;
+		quirks->use_lid_flip_devid = false;
+		break;
+	case 1:
+		quirks->use_kbd_dock_devid = true;
+		quirks->use_lid_flip_devid = false;
+		break;
+	case 2:
+		quirks->use_kbd_dock_devid = false;
+		quirks->use_lid_flip_devid = true;
+		break;
+	}
+
 	if (quirks->i8042_filter) {
 		ret = i8042_install_filter(quirks->i8042_filter);
 		if (ret) {
-- 
2.30.2



