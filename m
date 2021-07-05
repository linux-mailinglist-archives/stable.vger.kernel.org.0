Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A440B3BBFCD
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbhGEPdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:33:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232546AbhGEPcr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:32:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9162619C8;
        Mon,  5 Jul 2021 15:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499010;
        bh=VKOJSyVDFgfKJRBNIrvLF5o2jZGSt9PNpLQ8gcEGNQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ruAZ5xlqNVrEy/u6ZeSItd4D07hmXmvNvsOCstN1nki8LlqWuEZuDTNO/0iad+C98
         h4q/oC6H8xxvT6NkGpKIgepxBX+T/IvN0W7usMjQkgIWgqoIqqlzDJf2+K2vcio+7U
         eSs8YfLS6vZjMzqnHTxy+8kLb0o0inVYsY2yDbiQtFcFZ8J4J7A0Wk5hxLGmramjYQ
         5f9v3ja8mGtJUNh4iHFz9CCxPpFlLT8c4fISgmO5US0YKYSDdFkk7QrYwQj9yXmuId
         PmDH7D/mRvuYEfFAAgIvoocaC22HGuHyyFAvWAzbP/rVEvZjpyOY7B9IZ6FKRjJm/2
         OW5G0Dh5GgBtQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 07/41] platform/x86: touchscreen_dmi: Add an extra entry for the upside down Goodix touchscreen on Teclast X89 tablets
Date:   Mon,  5 Jul 2021 11:29:27 -0400
Message-Id: <20210705153001.1521447-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705153001.1521447-1-sashal@kernel.org>
References: <20210705153001.1521447-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit a22e3803f2a4d947ff0083a9448a169269ea0f62 ]

Teclast X89 tablets come in 2 versions, with Windows pre-installed and with
Android pre-installed. These 2 versions have different DMI strings.

Add a match for the DMI strings used by the Android version BIOS.

Note the Android version BIOS has a bug in the DSDT where no IRQ is
provided, so for the touchscreen to work a DSDT override fixing this
is necessary as well.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210504185746.175461-4-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/touchscreen_dmi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/platform/x86/touchscreen_dmi.c b/drivers/platform/x86/touchscreen_dmi.c
index e52ff09b81de..ebae21b78327 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -1285,6 +1285,14 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "X3 Plus"),
 		},
 	},
+	{
+		/* Teclast X89 (Android version / BIOS) */
+		.driver_data = (void *)&gdix1001_00_upside_down_data,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "WISKY"),
+			DMI_MATCH(DMI_BOARD_NAME, "3G062i"),
+		},
+	},
 	{
 		/* Teclast X89 (Windows version / BIOS) */
 		.driver_data = (void *)&gdix1001_01_upside_down_data,
-- 
2.30.2

