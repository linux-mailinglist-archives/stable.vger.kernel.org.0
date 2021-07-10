Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 482E83C37D9
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233155AbhGJXxK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:53:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232930AbhGJXwv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:52:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FC15613BF;
        Sat, 10 Jul 2021 23:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961006;
        bh=N1+fEPFvgMh4GNVbm02Xhsdh+/siHwT7YIZDgB4pkIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EAwVSmK/rW+Y8IKqZ9ZUO3SMT5nZk2r3p4j+Tr6MlcTxAGviylzfuUpFkZ3OWGcCH
         YQAbVkun3RvHX9nkx8qYWFvE/z84+ulXP7UYNyjWYHBFHHG1faq+oIYesiGe9uLl24
         WN9dXwCtvVyksYQo0VrDzrz69G4h3kpmMTl+AGEiv5DR597V4d3cy8ZWqoJVM8b+ac
         JtQygj8H+S7AW8vGcuF4+qGE3X6XbAaxh+AjPEJcE//ETfaiTn6CQgvfF4YaIEXbts
         QoJfNnd1qP7HKt0Tyxp0fswVO3mwAzDo78+gos4+STlwsV7GY+g6yHDKV1QMhXzHNt
         TGGOcCF0NxRmA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 36/43] ACPI: video: Add quirk for the Dell Vostro 3350
Date:   Sat, 10 Jul 2021 19:49:08 -0400
Message-Id: <20210710234915.3220342-36-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710234915.3220342-1-sashal@kernel.org>
References: <20210710234915.3220342-1-sashal@kernel.org>
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
index 2ea1781290cc..1b68d116d808 100644
--- a/drivers/acpi/acpi_video.c
+++ b/drivers/acpi/acpi_video.c
@@ -540,6 +540,15 @@ static const struct dmi_system_id video_dmi_table[] = {
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

