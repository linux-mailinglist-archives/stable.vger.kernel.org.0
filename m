Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11A593C3907
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232821AbhGJX5U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:57:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234105AbhGJX4G (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:56:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BEDB61411;
        Sat, 10 Jul 2021 23:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961128;
        bh=Ao1qYX8JU74wE9zwxrJnNbD+VZyalj9H4iia9SWC/3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WQiijKT2iHlTDW0dgnqZEzKQWstE7pUqGsnlnWzn7Lrj7tmJamJKRQQhOKUiCF4ry
         zcHTxhkdSjR9fk/nbk+0KIDk1FBH4XD2dID57Re9lJ7sS6BCaMUQaspHflhbEkArT7
         XgVCUUpuXjpedNSmN0lbkDHZsXjAIbrtkfdXto69iXClVPEMwJ/5GtIh1AgXUj+pk3
         rzz1AO/g1ijBFg/DcW45Z+7jRbE+tNHf/7MvvJgju+q3UlCHuLuQV/6WnGwSqak7mS
         EbuhdnaXg82ZwnyU8wCLqDvgD9H16KVmE4Gxqf3aHiimlXwP2oPSTe1HhHlc7qRhxv
         fF0bFBXVTy4/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 19/22] ACPI: video: Add quirk for the Dell Vostro 3350
Date:   Sat, 10 Jul 2021 19:51:40 -0400
Message-Id: <20210710235143.3222129-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235143.3222129-1-sashal@kernel.org>
References: <20210710235143.3222129-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 9249c32ec9197e8d34fe5179c9e31668a205db04 ]

The Dell Vostro 3350 ACPI video-bus device reports spurious
ACPI_VIDEO_NOTIFY_CYCLE events resulting in spurious KEY_SWITCHVIDEOMODE
events being reported to userspace (and causing trouble there).

Add a quirk setting the report_key_events mask to
REPORT_BRIGHTNESS_KEY_EVENTS so that the ACPI_VIDEO_NOTIFY_CYCLE
events will be ignored, while still reporting brightness up/down
hotkey-presses to userspace normally.

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1911763
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_video.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/acpi/acpi_video.c b/drivers/acpi/acpi_video.c
index 1a23e7aa74df..ac54fc03cf81 100644
--- a/drivers/acpi/acpi_video.c
+++ b/drivers/acpi/acpi_video.c
@@ -556,6 +556,15 @@ static const struct dmi_system_id video_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "Vostro V131"),
 		},
 	},
+	{
+	 .callback = video_set_report_key_events,
+	 .driver_data = (void *)((uintptr_t)REPORT_BRIGHTNESS_KEY_EVENTS),
+	 .ident = "Dell Vostro 3350",
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "Vostro 3350"),
+		},
+	},
 	/*
 	 * Some machines change the brightness themselves when a brightness
 	 * hotkey gets pressed, despite us telling them not to. In this case
-- 
2.30.2

