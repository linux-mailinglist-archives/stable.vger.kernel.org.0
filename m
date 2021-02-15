Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96EEF31BCEA
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbhBOPhe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:37:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:49602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230427AbhBOPfe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:35:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DA1164E31;
        Mon, 15 Feb 2021 15:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403089;
        bh=N22Zf85f0trjNoELs3GnoGMbbStZyq3DAIB/qb+HGCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wczrVnnPmO6fTtLhfXOGVGK7d7XhQOv45nFLYxiLVuEfu6M7+YKXpLFDlX8jWjrcT
         v/muB0BmlAcijHBwCM8NgFSviKXcba2qfVHHZVIojC8Tp5XFaHQv+rR/m6mBTGltbj
         Gw+1FOEbfFAoAiDo22mKw2rF34Fy27URf1XQbGkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Stefan=20Br=C3=BCns?= <stefan.bruens@rwth-aachen.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 023/104] platform/x86: hp-wmi: Disable tablet-mode reporting by default
Date:   Mon, 15 Feb 2021 16:26:36 +0100
Message-Id: <20210215152720.230412063@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 67fbe02a5cebc3c653610f12e3c0424e58450153 ]

Recently userspace has started making more use of SW_TABLET_MODE
(when an input-dev reports this).

Specifically recent GNOME3 versions will:

1.  When SW_TABLET_MODE is reported and is reporting 0:
1.1 Disable accelerometer-based screen auto-rotation
1.2 Disable automatically showing the on-screen keyboard when a
    text-input field is focussed

2.  When SW_TABLET_MODE is reported and is reporting 1:
2.1 Ignore input-events from the builtin keyboard and touchpad
    (this is for 360° hinges style 2-in-1s where the keyboard and
     touchpads are accessible on the back of the tablet when folded
     into tablet-mode)

This means that claiming to support SW_TABLET_MODE when it does not
actually work / reports correct values has bad side-effects.

The check in the hp-wmi code which is used to decide if the input-dev
should claim SW_TABLET_MODE support, only checks if the
HPWMI_HARDWARE_QUERY is supported. It does *not* check if the hardware
actually is capable of reporting SW_TABLET_MODE.

This leads to the hp-wmi input-dev claiming SW_TABLET_MODE support,
while in reality it will always report 0 as SW_TABLET_MODE value.
This has been seen on a "HP ENVY x360 Convertible 15-cp0xxx" and
this likely is the case on a whole lot of other HP models.

This problem causes both auto-rotation and on-screen keyboard
support to not work on affected x360 models.

There is no easy fix for this, but since userspace expects
SW_TABLET_MODE reporting to be reliable when advertised it is
better to not claim/report SW_TABLET_MODE support at all, then
to claim to support it while it does not work.

To avoid the mentioned problems, add a new enable_tablet_mode_sw
module-parameter which defaults to false.

Note I've made this an int using the standard -1=auto, 0=off, 1=on
triplett, with the hope that in the future we can come up with a
better way to detect SW_TABLET_MODE support. ATM the default
auto option just does the same as off.

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1918255
Cc: Stefan Brüns <stefan.bruens@rwth-aachen.de>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Mark Gross <mgross@linux.intel.com>
Link: https://lore.kernel.org/r/20210120124941.73409-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp-wmi.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index 18bf8aeb5f870..e94e59283ecb9 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -32,6 +32,10 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS("wmi:95F24279-4D7B-4334-9387-ACCDC67EF61C");
 MODULE_ALIAS("wmi:5FB7F034-2C63-45e9-BE91-3D44E2C707E4");
 
+static int enable_tablet_mode_sw = -1;
+module_param(enable_tablet_mode_sw, int, 0444);
+MODULE_PARM_DESC(enable_tablet_mode_sw, "Enable SW_TABLET_MODE reporting (-1=auto, 0=no, 1=yes)");
+
 #define HPWMI_EVENT_GUID "95F24279-4D7B-4334-9387-ACCDC67EF61C"
 #define HPWMI_BIOS_GUID "5FB7F034-2C63-45e9-BE91-3D44E2C707E4"
 
@@ -654,10 +658,12 @@ static int __init hp_wmi_input_setup(void)
 	}
 
 	/* Tablet mode */
-	val = hp_wmi_hw_state(HPWMI_TABLET_MASK);
-	if (!(val < 0)) {
-		__set_bit(SW_TABLET_MODE, hp_wmi_input_dev->swbit);
-		input_report_switch(hp_wmi_input_dev, SW_TABLET_MODE, val);
+	if (enable_tablet_mode_sw > 0) {
+		val = hp_wmi_hw_state(HPWMI_TABLET_MASK);
+		if (val >= 0) {
+			__set_bit(SW_TABLET_MODE, hp_wmi_input_dev->swbit);
+			input_report_switch(hp_wmi_input_dev, SW_TABLET_MODE, val);
+		}
 	}
 
 	err = sparse_keymap_setup(hp_wmi_input_dev, hp_wmi_keymap, NULL);
-- 
2.27.0



