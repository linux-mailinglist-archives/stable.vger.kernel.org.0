Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB6A7364274
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237685AbhDSNJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:09:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:43744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239447AbhDSNI5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:08:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBA0261288;
        Mon, 19 Apr 2021 13:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837704;
        bh=echiII9LJeo6bGJlWY8pdQulXOUmVokpdL0zV8SpY3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cND7J/hWnjy7vPw/FXqjaMzlpg+pVuMVcg/+Xk98550LUW2fwWB2SJmY4y8JHivTZ
         npynaGlKMKJ0uD2Cjl50HotJgTTDpyilJOyPTIfWrtINyyluo3knwcKZoNjRzPA8w6
         EUM6LxjZfEiftlfSUZUq3ZD6pmUOVo2C1bFZmkMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 003/122] AMD_SFH: Add DMI quirk table for BIOS-es which dont set the activestatus bits
Date:   Mon, 19 Apr 2021 15:04:43 +0200
Message-Id: <20210419130530.287313574@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 25615e454a0ec198254f17d2ed79b607cb755d0e ]

Some BIOS-es do not initialize the activestatus bits of the AMD_P2C_MSG3
register. This cause the AMD_SFH driver to not register any sensors even
though the laptops in question do have sensors.

Add a DMI quirk-table for specifying sensor-mask overrides based on
DMI match, to make the sensors work OOTB on these laptop models.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=199715
BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1651886
Fixes: 4f567b9f8141 ("SFH: PCIe driver to add support of AMD sensor fusion hub")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Sandeep Singh <sandeep.singh@amd.com
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
index ab0a9443e252..ddecc84fd6f0 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
@@ -10,6 +10,7 @@
 #include <linux/bitops.h>
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
+#include <linux/dmi.h>
 #include <linux/interrupt.h>
 #include <linux/io-64-nonatomic-lo-hi.h>
 #include <linux/module.h>
@@ -77,11 +78,34 @@ void amd_stop_all_sensors(struct amd_mp2_dev *privdata)
 	writel(cmd_base.ul, privdata->mmio + AMD_C2P_MSG0);
 }
 
+static const struct dmi_system_id dmi_sensor_mask_overrides[] = {
+	{
+		.matches = {
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP ENVY x360 Convertible 13-ag0xxx"),
+		},
+		.driver_data = (void *)(ACEL_EN | MAGNO_EN),
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP ENVY x360 Convertible 15-cp0xxx"),
+		},
+		.driver_data = (void *)(ACEL_EN | MAGNO_EN),
+	},
+	{ }
+};
+
 int amd_mp2_get_sensor_num(struct amd_mp2_dev *privdata, u8 *sensor_id)
 {
 	int activestatus, num_of_sensors = 0;
+	const struct dmi_system_id *dmi_id;
 	u32 activecontrolstatus;
 
+	if (sensor_mask_override == -1) {
+		dmi_id = dmi_first_match(dmi_sensor_mask_overrides);
+		if (dmi_id)
+			sensor_mask_override = (long)dmi_id->driver_data;
+	}
+
 	if (sensor_mask_override >= 0) {
 		activestatus = sensor_mask_override;
 	} else {
-- 
2.30.2



