Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 999892B6597
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730727AbgKQN47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:56:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:54232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730763AbgKQNUq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:20:46 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E16C024248;
        Tue, 17 Nov 2020 13:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619245;
        bh=VA5SZyo0Z8SFLkqcGfxNL8fP++Eeshs2aTA2ESgMpzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gM609q/tyP8dim7+cd6cwCsWIFV9YapLFTis3Z7rFHx9YtIP5S7AYBx2k0srYlhxv
         BOXJ8aNRckTfNLqtvv+xVJp9SdnwgrpGDn5L18Y2Y3HzykBDu20O5SqfagdRuQ3UE5
         9BoFLji+6SPnJm9czAyceqnZQmqnpdj73YrWiuck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Hans de Goede <hdegoede@redhat.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 047/101] tpm_tis: Disable interrupts on ThinkPad T490s
Date:   Tue, 17 Nov 2020 14:05:14 +0100
Message-Id: <20201117122115.381486788@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122113.128215851@linuxfoundation.org>
References: <20201117122113.128215851@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerry Snitselaar <jsnitsel@redhat.com>

[ Upstream commit b154ce11ead925de6a94feb3b0317fafeefa0ebc ]

There is a misconfiguration in the bios of the gpio pin used for the
interrupt in the T490s. When interrupts are enabled in the tpm_tis
driver code this results in an interrupt storm. This was initially
reported when we attempted to enable the interrupt code in the tpm_tis
driver, which previously wasn't setting a flag to enable it. Due to
the reports of the interrupt storm that code was reverted and we went back
to polling instead of using interrupts. Now that we know the T490s problem
is a firmware issue, add code to check if the system is a T490s and
disable interrupts if that is the case. This will allow us to enable
interrupts for everyone else. If the user has a fixed bios they can
force the enabling of interrupts with tpm_tis.interrupts=1 on the
kernel command line.

Cc: Peter Huewe <peterhuewe@gmx.de>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
Reviewed-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_tis.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index f08949a5f6785..5a3a4f0953910 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -31,6 +31,7 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/kernel.h>
+#include <linux/dmi.h>
 #include "tpm.h"
 #include "tpm_tis_core.h"
 
@@ -53,8 +54,8 @@ static inline struct tpm_tis_tcg_phy *to_tpm_tis_tcg_phy(struct tpm_tis_data *da
 	return container_of(data, struct tpm_tis_tcg_phy, priv);
 }
 
-static bool interrupts = true;
-module_param(interrupts, bool, 0444);
+static int interrupts = -1;
+module_param(interrupts, int, 0444);
 MODULE_PARM_DESC(interrupts, "Enable interrupts");
 
 static bool itpm;
@@ -67,6 +68,28 @@ module_param(force, bool, 0444);
 MODULE_PARM_DESC(force, "Force device probe rather than using ACPI entry");
 #endif
 
+static int tpm_tis_disable_irq(const struct dmi_system_id *d)
+{
+	if (interrupts == -1) {
+		pr_notice("tpm_tis: %s detected: disabling interrupts.\n", d->ident);
+		interrupts = 0;
+	}
+
+	return 0;
+}
+
+static const struct dmi_system_id tpm_tis_dmi_table[] = {
+	{
+		.callback = tpm_tis_disable_irq,
+		.ident = "ThinkPad T490s",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T490s"),
+		},
+	},
+	{}
+};
+
 #if defined(CONFIG_PNP) && defined(CONFIG_ACPI)
 static int has_hid(struct acpi_device *dev, const char *hid)
 {
@@ -196,6 +219,8 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info)
 	int irq = -1;
 	int rc;
 
+	dmi_check_system(tpm_tis_dmi_table);
+
 	rc = check_acpi_tpm2(dev);
 	if (rc)
 		return rc;
-- 
2.27.0



