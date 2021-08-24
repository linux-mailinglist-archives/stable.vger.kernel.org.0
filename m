Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA763F5477
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 02:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234117AbhHXAzP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 20:55:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233782AbhHXAy4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 20:54:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1458361406;
        Tue, 24 Aug 2021 00:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629766452;
        bh=h4u0Bx6aeNoGpapTXM+eifytyobrG/LQIW8hVQOGC7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FLKLXO1BGbM3zrBFRJT1bm++GW9YTqMRXJ+bN0sWjudEMNWMPWdMmmiaSQlSV1VlB
         NXXkBSlXUvdY/yUJutLhy2IS7iSUxw/IYXPdvjRl7lEbm5H280fMC9Igj+a8ymJDcl
         cAU8ySjQVdKErOip0Fq1MG7Q16WyLrbuqdSpY94fdFQMXBuk1/nb1DwZiUJiFyguhr
         QdybZiSQW6fvGVQ31CbyPpdte9sgGiGjjPs5dXm4WalI77IjkLhuwTdwHosFhiIl25
         cc5Y5gdcMy+sB2e4EUYjuQwwDikvmCfTUwLhm5vR/qVF0YQqFx+FVT1w6Th6jT683a
         dYkjVbVkiFRiQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 12/26] platform/x86: asus-nb-wmi: Add tablet_mode_sw=lid-flip quirk for the TP200s
Date:   Mon, 23 Aug 2021 20:53:42 -0400
Message-Id: <20210824005356.630888-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824005356.630888-1-sashal@kernel.org>
References: <20210824005356.630888-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 73fcbad691110ece47a487c9e584822070e3626f ]

The Asus TP200s / E205SA 360 degree hinges 2-in-1 supports reporting
SW_TABLET_MODE info through the ASUS_WMI_DEVID_LID_FLIP WMI device-id.
Add a quirk to enable this.

BugLink: https://gitlab.freedesktop.org/libinput/libinput/-/issues/639
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210812145513.39117-2-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-nb-wmi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index 9929eedf7dd8..a81dc4b191b7 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -462,6 +462,15 @@ static const struct dmi_system_id asus_quirks[] = {
 		},
 		.driver_data = &quirk_asus_use_lid_flip_devid,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "ASUS TP200s / E205SA",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "E205SA"),
+		},
+		.driver_data = &quirk_asus_use_lid_flip_devid,
+	},
 	{},
 };
 
-- 
2.30.2

