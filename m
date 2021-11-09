Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBE6444B6CA
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344264AbhKIWaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:30:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:50128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344296AbhKIW2K (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:28:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AB9F61A64;
        Tue,  9 Nov 2021 22:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496411;
        bh=fiSCtKs2E9uPDYpjkML7x9c0vekPxaZTUiEET0nQK7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Co5YuRWZ0XAPa4S2aW2u/s93QmjzY7sB0edE/TYO2uMnhakSeqWh+hRPqcWUZLB1r
         vkTGtfN4Vs6d/ifelVIXfdClrYhC2OuLG0zUGTbzJzHsSAoKZTBPl7cR9iEoI7xue+
         nX0d3NWphfF7dNL0HiQwI5vMJNsG7/PJq05GC7RocteR3IPNeiEraMJPQ0gWoZUR6U
         HHbJxBLEpaJBI4wJlXVeu6SaofsBU0vDjaqj3goDREHAhzN6ZgGAStfADwJad3GAjF
         /hDId8/vs+haKfNn4I3UM/NkM6htxtBRpEtvnaqss/ivpwAVsBlJrrlj27qcITbF+u
         QCvX2HDe0QvOw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.14 39/75] ASoC: nau8824: Add DMI quirk mechanism for active-high jack-detect
Date:   Tue,  9 Nov 2021 17:18:29 -0500
Message-Id: <20211109221905.1234094-39-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221905.1234094-1-sashal@kernel.org>
References: <20211109221905.1234094-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 92d3360108f1839ca40451bad20ff67dd24a1964 ]

Add a quirk mechanism to allow specifying that active-high jack-detection
should be used on platforms where this info is not available in devicetree.

And add an entry for the Cyberbook T116 tablet to the DMI table, so that
jack-detection will work properly on this tablet.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20211002211459.110124-2-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/nau8824.c | 40 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/sound/soc/codecs/nau8824.c b/sound/soc/codecs/nau8824.c
index f946ef65a4c19..f7018f2dd21fd 100644
--- a/sound/soc/codecs/nau8824.c
+++ b/sound/soc/codecs/nau8824.c
@@ -8,6 +8,7 @@
 
 #include <linux/module.h>
 #include <linux/delay.h>
+#include <linux/dmi.h>
 #include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/regmap.h>
@@ -27,6 +28,12 @@
 
 #include "nau8824.h"
 
+#define NAU8824_JD_ACTIVE_HIGH			BIT(0)
+
+static int nau8824_quirk;
+static int quirk_override = -1;
+module_param_named(quirk, quirk_override, uint, 0444);
+MODULE_PARM_DESC(quirk, "Board-specific quirk override");
 
 static int nau8824_config_sysclk(struct nau8824 *nau8824,
 	int clk_id, unsigned int freq);
@@ -1845,6 +1852,34 @@ static int nau8824_read_device_properties(struct device *dev,
 	return 0;
 }
 
+/* Please keep this list alphabetically sorted */
+static const struct dmi_system_id nau8824_quirk_table[] = {
+	{
+		/* Cyberbook T116 rugged tablet */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "Default string"),
+			DMI_EXACT_MATCH(DMI_BOARD_NAME, "Cherry Trail CR"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "20170531"),
+		},
+		.driver_data = (void *)(NAU8824_JD_ACTIVE_HIGH),
+	},
+	{}
+};
+
+static void nau8824_check_quirks(void)
+{
+	const struct dmi_system_id *dmi_id;
+
+	if (quirk_override != -1) {
+		nau8824_quirk = quirk_override;
+		return;
+	}
+
+	dmi_id = dmi_first_match(nau8824_quirk_table);
+	if (dmi_id)
+		nau8824_quirk = (unsigned long)dmi_id->driver_data;
+}
+
 static int nau8824_i2c_probe(struct i2c_client *i2c,
 	const struct i2c_device_id *id)
 {
@@ -1869,6 +1904,11 @@ static int nau8824_i2c_probe(struct i2c_client *i2c,
 	nau8824->irq = i2c->irq;
 	sema_init(&nau8824->jd_sem, 1);
 
+	nau8824_check_quirks();
+
+	if (nau8824_quirk & NAU8824_JD_ACTIVE_HIGH)
+		nau8824->jkdet_polarity = 0;
+
 	nau8824_print_device_properties(nau8824);
 
 	ret = regmap_read(nau8824->regmap, NAU8824_REG_I2C_DEVICE_ID, &value);
-- 
2.33.0

