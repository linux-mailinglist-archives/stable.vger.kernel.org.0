Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F098E3BBEF7
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbhGEPbJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:31:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231883AbhGEPbF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:31:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F0B36196A;
        Mon,  5 Jul 2021 15:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625498908;
        bh=rO/R9O6Nf0ZBXxZxkMffWHJCtxXIkGTKWnKSZx6gvX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ht8S9Jj5FmZ0a06KyxW8pkyZk0qliKkGExOC0dJ9untotQdFaVeLJi9wpY8A/0lUk
         B3nD2/R1vIXLy6dCGpAe5IDqJc9VpuP6908JwzBNAxN7nsKDZdEc2a3oxGqOzHNLTT
         7s4eEB+Aaxx8et4Aw5ifjKbY2jHdzCe+MvyVlmcg7/oK7wXbT5o3K2mhmhQhcT3Oeg
         9tF3u/ZEEABEMUpAlc5hm2ArIiD1TvkK3oWBSeVkn90bF2i+Ec8cwdcz16H+XE2775
         6teEdWFjYSAjGND5tY6x5CJvEfnW1FrG5MPuVxi+Zwrd9mx6V2pKsS01mhWm7mv8tY
         y/bmDafX72Bjg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 09/59] platform/x86: touchscreen_dmi: Add an extra entry for the upside down Goodix touchscreen on Teclast X89 tablets
Date:   Mon,  5 Jul 2021 11:27:25 -0400
Message-Id: <20210705152815.1520546-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705152815.1520546-1-sashal@kernel.org>
References: <20210705152815.1520546-1-sashal@kernel.org>
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
index b452865da2a1..8b9926a9db7e 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -1347,6 +1347,14 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
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

