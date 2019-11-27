Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E07AB10BFCB
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727631AbfK0Uei (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:34:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:35152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727656AbfK0Uei (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:34:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE72520866;
        Wed, 27 Nov 2019 20:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574886877;
        bh=8q9dcV3zJeT9TGOcpWEkgv4nJWdnjder7C9wf0hTbsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pIoi5D3x3L4V23w3v85/RqkZiSAwjfxQqRxY5x99aISaKlNbEUeqzb9FMfVvkxuld
         MtwXIRW3bPm1rbGlzKj5wMuu5EbBJ2EL7Na+C8rReh6AVwGc7Onuz+cek3SaJAeNAB
         QomNE4LXuwVdimEHa0llT8FqnBj3dJ0je5lWVmy8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?= <jprvita@endlessm.com>,
        Carlo Caione <carlo@endlessm.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 008/132] asus-wmi: Add quirk_no_rfkill_wapf4 for the Asus X456UF
Date:   Wed, 27 Nov 2019 21:29:59 +0100
Message-Id: <20191127202906.126529081@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202857.270233486@linuxfoundation.org>
References: <20191127202857.270233486@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: João Paulo Rechi Vita <jprvita@gmail.com>

[ Upstream commit a961a285b479977fa21f12f71cd62f28adaba17c ]

The Asus X456UF has an airplane-mode indicator LED and the WMI WLAN user
bit set, so asus-wmi uses ASUS_WMI_DEVID_WLAN_LED (0x00010002) to store
the wlan state, which has a side-effect of driving the airplane mode
indicator LED in an inverted fashion.

quirk_no_rfkill prevents asus-wmi from registering RFKill switches at
all for this laptop and allows asus-wireless to drive the LED through
the ASHS ACPI device.  This laptop already has a quirk for setting
WAPF=4, so this commit creates a new quirk, quirk_no_rfkill_wapf4, which
both disables rfkill and sets WAPF=4.

Signed-off-by: João Paulo Rechi Vita <jprvita@endlessm.com>
Reported-by: Carlo Caione <carlo@endlessm.com>
Reviewed-by: Corentin Chary <corentin.chary@gmail.com>
Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-nb-wmi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index 5390846fa1e64..904f210327a1c 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -82,6 +82,11 @@ static struct quirk_entry quirk_no_rfkill = {
 	.no_rfkill = true,
 };
 
+static struct quirk_entry quirk_no_rfkill_wapf4 = {
+	.wapf = 4,
+	.no_rfkill = true,
+};
+
 static int dmi_matched(const struct dmi_system_id *dmi)
 {
 	quirks = dmi->driver_data;
@@ -164,7 +169,7 @@ static const struct dmi_system_id asus_quirks[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "X456UF"),
 		},
-		.driver_data = &quirk_asus_wapf4,
+		.driver_data = &quirk_no_rfkill_wapf4,
 	},
 	{
 		.callback = dmi_matched,
-- 
2.20.1



