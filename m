Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093D63CE542
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345315AbhGSPs1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:48:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:45840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349348AbhGSPo7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:44:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5D6161283;
        Mon, 19 Jul 2021 16:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711877;
        bh=N1+fEPFvgMh4GNVbm02Xhsdh+/siHwT7YIZDgB4pkIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f+8I+7JrTWb9bPdBFjDB6a/E2Oiwq06DNiuyMq3MPb+VKczOx8N+BG1J0SrN6a4DA
         Cdu0gJhVniUXllyA5QPFQqKF3/1jGCwKolnJi1UigLgwPBTqEiovJNpOP6OBH1ZFvW
         TiuKrm1p5p2BUnq+eUCrS54uxFYFWLba/8ShdY+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 166/292] ACPI: video: Add quirk for the Dell Vostro 3350
Date:   Mon, 19 Jul 2021 16:53:48 +0200
Message-Id: <20210719144947.948612638@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



