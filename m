Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 726AA2E3E38
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503263AbgL1OZl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:25:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:60270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503249AbgL1OZi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:25:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0196122B37;
        Mon, 28 Dec 2020 14:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165522;
        bh=NjSeWDMdCrHok4qJ7boYbzFBUsrNK4D5m6dFP64pb9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kbb08rF6co5KQ1ZSP9f13t1ACZuUIUiIqy2VAMRdpgSb5xN+StW/aBrXvcZsx3qQz
         krc/204l2fNv0vWaEOIDw0kz4Gdf/9awO6j6xlgbR/uh/ClXxBjFJJ77EMKzLhvjc3
         Y6/NdT3X21YWld4Nb1q+uJj9n7mmB/sDVhbHADWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
        Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>
Subject: [PATCH 5.10 561/717] ASoC: AMD Renoir - add DMI table to avoid the ACP mic probe (broken BIOS)
Date:   Mon, 28 Dec 2020 13:49:19 +0100
Message-Id: <20201228125047.800245046@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaroslav Kysela <perex@perex.cz>

commit 718c406e1ffaca4eac987b957bbb36ce1090797a upstream.

Users reported that some Lenovo AMD platforms do not have ACP microphone,
but the BIOS advertises it via ACPI.

This patch create a simple DMI table, where those machines with the broken
BIOS can be added. The DMI description for Lenovo IdeaPad 5 and
IdeaPad Flex 5 devices are added there.

Also describe the dmic_acpi_check kernel module parameter in a more
understandable way.

Cc: <stable@kernel.org>
Cc: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20201208171200.2737620-1-perex@perex.cz
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/amd/renoir/rn-pci-acp3x.c |   28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

--- a/sound/soc/amd/renoir/rn-pci-acp3x.c
+++ b/sound/soc/amd/renoir/rn-pci-acp3x.c
@@ -6,6 +6,7 @@
 
 #include <linux/pci.h>
 #include <linux/acpi.h>
+#include <linux/dmi.h>
 #include <linux/module.h>
 #include <linux/io.h>
 #include <linux/delay.h>
@@ -20,14 +21,13 @@ module_param(acp_power_gating, int, 0644
 MODULE_PARM_DESC(acp_power_gating, "Enable acp power gating");
 
 /**
- * dmic_acpi_check = -1 - Checks ACPI method to know DMIC hardware status runtime
- *                 = 0 - Skips the DMIC device creation and returns probe failure
- *                 = 1 - Assumes that platform has DMIC support and skips ACPI
- *                       method check
+ * dmic_acpi_check = -1 - Use ACPI/DMI method to detect the DMIC hardware presence at runtime
+ *                 =  0 - Skip the DMIC device creation and return probe failure
+ *                 =  1 - Force DMIC support
  */
 static int dmic_acpi_check = ACP_DMIC_AUTO;
 module_param(dmic_acpi_check, bint, 0644);
-MODULE_PARM_DESC(dmic_acpi_check, "checks Dmic hardware runtime");
+MODULE_PARM_DESC(dmic_acpi_check, "Digital microphone presence (-1=auto, 0=none, 1=force)");
 
 struct acp_dev_data {
 	void __iomem *acp_base;
@@ -163,6 +163,17 @@ static int rn_acp_deinit(void __iomem *a
 	return 0;
 }
 
+static const struct dmi_system_id rn_acp_quirk_table[] = {
+	{
+		/* Lenovo IdeaPad Flex 5 14ARE05, IdeaPad 5 15ARE05 */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_EXACT_MATCH(DMI_BOARD_NAME, "LNVNB161216"),
+		}
+	},
+	{}
+};
+
 static int snd_rn_acp_probe(struct pci_dev *pci,
 			    const struct pci_device_id *pci_id)
 {
@@ -172,6 +183,7 @@ static int snd_rn_acp_probe(struct pci_d
 	acpi_handle handle;
 	acpi_integer dmic_status;
 #endif
+	const struct dmi_system_id *dmi_id;
 	unsigned int irqflags;
 	int ret, index;
 	u32 addr;
@@ -232,6 +244,12 @@ static int snd_rn_acp_probe(struct pci_d
 			goto de_init;
 		}
 #endif
+		dmi_id = dmi_first_match(rn_acp_quirk_table);
+		if (dmi_id && !dmi_id->driver_data) {
+			dev_info(&pci->dev, "ACPI settings override using DMI (ACP mic is not present)");
+			ret = -ENODEV;
+			goto de_init;
+		}
 	}
 
 	adata->res = devm_kzalloc(&pci->dev,


