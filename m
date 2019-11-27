Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9EB10B771
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbfK0Udv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:33:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:33838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727010AbfK0Udv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:33:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FADD20866;
        Wed, 27 Nov 2019 20:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574886830;
        bh=j1as0qKzRucB6IDbVLDVONrGQprDEqzsCUQOpr7AmWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U/GkxTJKR0FOmWA0bxwyCTLNqlPBT4SCycBf5GhS1ePyioGjT6T/ifw6d1k5AycO+
         KozwkBseLjjvOJ5NSDxml/u+LGQ538sw5eGSbj2D0aZd13oiqAgxyPFc3VJFVsQ1mI
         raE9D0NcuC6AZj0mnl1ijjIPVaBzHWAWsbwVTmX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?= <jprvita@endlessm.com>,
        Mousou Yuu <guogaishiwo@gmail.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 010/132] asus-wmi: Add quirk_no_rfkill for the Asus U303LB
Date:   Wed, 27 Nov 2019 21:30:01 +0100
Message-Id: <20191127202908.342923892@linuxfoundation.org>
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

[ Upstream commit 02db9ff7af18f7ace60f430cbbaa1d846b350916 ]

The Asus U303LB has an airplane-mode indicator LED and the WMI WLAN user
bit set, so asus-wmi uses ASUS_WMI_DEVID_WLAN_LED (0x00010002) to store
the wlan state, which has a side-effect of driving the airplane mode
indicator LED in an inverted fashion. quirk_no_rfkill prevents asus-wmi
from registering RFKill switches at all for this laptop and allows
asus-wireless to drive the LED through the ASHS ACPI device.

Signed-off-by: João Paulo Rechi Vita <jprvita@endlessm.com>
Reported-by: Mousou Yuu <guogaishiwo@gmail.com>
Reviewed-by: Corentin Chary <corentin.chary@gmail.com>
Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-nb-wmi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index 0322b1cde825d..69e33c2772c11 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -342,6 +342,15 @@ static const struct dmi_system_id asus_quirks[] = {
 		},
 		.driver_data = &quirk_no_rfkill,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "ASUSTeK COMPUTER INC. U303LB",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "U303LB"),
+		},
+		.driver_data = &quirk_no_rfkill,
+	},
 	{},
 };
 
-- 
2.20.1



