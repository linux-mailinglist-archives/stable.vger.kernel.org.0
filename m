Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF662CA7DA
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388975AbfJCQ5X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:57:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405866AbfJCQtw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:49:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D54032086A;
        Thu,  3 Oct 2019 16:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121391;
        bh=lx1Y0pfDUEwiqhs7oUO14XYU//xDyG5LDm4+Z39ZEwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N0WZGxD6SjFg5qtqSuErkSNpdGN8PiMoSRPaeyqmFF3v/PfGmi/jdWqw6ftq93mKB
         y6NQ76EtJ2AzOf+/Aqlqg7Uz9boy4HefQy7w0MEHUp0nrN+BmUQf7Fe5FTMzVJhROd
         5X/yI+MNQ7eo4t3KJEysxmwQR3vuQ854eNM/pkc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 226/344] iommu/amd: Override wrong IVRS IOAPIC on Raven Ridge systems
Date:   Thu,  3 Oct 2019 17:53:11 +0200
Message-Id: <20191003154602.668568020@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit 93d051550ee02eaff9a2541d825605a7bd778027 ]

Raven Ridge systems may have malfunction touchpad or hang at boot if
incorrect IVRS IOAPIC is provided by BIOS.

Users already found correct "ivrs_ioapic=" values, let's put them inside
kernel to workaround buggy BIOS.

BugLink: https://bugs.launchpad.net/bugs/1795292
BugLink: https://bugs.launchpad.net/bugs/1837688
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/Makefile           |  2 +-
 drivers/iommu/amd_iommu.h        | 14 +++++
 drivers/iommu/amd_iommu_init.c   |  5 +-
 drivers/iommu/amd_iommu_quirks.c | 92 ++++++++++++++++++++++++++++++++
 4 files changed, 111 insertions(+), 2 deletions(-)
 create mode 100644 drivers/iommu/amd_iommu.h
 create mode 100644 drivers/iommu/amd_iommu_quirks.c

diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index f13f36ae1af65..c6a277e698484 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -10,7 +10,7 @@ obj-$(CONFIG_IOMMU_IO_PGTABLE_LPAE) += io-pgtable-arm.o
 obj-$(CONFIG_IOMMU_IOVA) += iova.o
 obj-$(CONFIG_OF_IOMMU)	+= of_iommu.o
 obj-$(CONFIG_MSM_IOMMU) += msm_iommu.o
-obj-$(CONFIG_AMD_IOMMU) += amd_iommu.o amd_iommu_init.o
+obj-$(CONFIG_AMD_IOMMU) += amd_iommu.o amd_iommu_init.o amd_iommu_quirks.o
 obj-$(CONFIG_AMD_IOMMU_DEBUGFS) += amd_iommu_debugfs.o
 obj-$(CONFIG_AMD_IOMMU_V2) += amd_iommu_v2.o
 obj-$(CONFIG_ARM_SMMU) += arm-smmu.o
diff --git a/drivers/iommu/amd_iommu.h b/drivers/iommu/amd_iommu.h
new file mode 100644
index 0000000000000..12d540d9b59b0
--- /dev/null
+++ b/drivers/iommu/amd_iommu.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef AMD_IOMMU_H
+#define AMD_IOMMU_H
+
+int __init add_special_device(u8 type, u8 id, u16 *devid, bool cmd_line);
+
+#ifdef CONFIG_DMI
+void amd_iommu_apply_ivrs_quirks(void);
+#else
+static void amd_iommu_apply_ivrs_quirks(void) { }
+#endif
+
+#endif
diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 4413aa67000e5..568c52317757c 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -32,6 +32,7 @@
 #include <asm/irq_remapping.h>
 
 #include <linux/crash_dump.h>
+#include "amd_iommu.h"
 #include "amd_iommu_proto.h"
 #include "amd_iommu_types.h"
 #include "irq_remapping.h"
@@ -1002,7 +1003,7 @@ static void __init set_dev_entry_from_acpi(struct amd_iommu *iommu,
 	set_iommu_for_device(iommu, devid);
 }
 
-static int __init add_special_device(u8 type, u8 id, u16 *devid, bool cmd_line)
+int __init add_special_device(u8 type, u8 id, u16 *devid, bool cmd_line)
 {
 	struct devid_map *entry;
 	struct list_head *list;
@@ -1153,6 +1154,8 @@ static int __init init_iommu_from_acpi(struct amd_iommu *iommu,
 	if (ret)
 		return ret;
 
+	amd_iommu_apply_ivrs_quirks();
+
 	/*
 	 * First save the recommended feature enable bits from ACPI
 	 */
diff --git a/drivers/iommu/amd_iommu_quirks.c b/drivers/iommu/amd_iommu_quirks.c
new file mode 100644
index 0000000000000..c235f79b7a200
--- /dev/null
+++ b/drivers/iommu/amd_iommu_quirks.c
@@ -0,0 +1,92 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+/*
+ * Quirks for AMD IOMMU
+ *
+ * Copyright (C) 2019 Kai-Heng Feng <kai.heng.feng@canonical.com>
+ */
+
+#ifdef CONFIG_DMI
+#include <linux/dmi.h>
+
+#include "amd_iommu.h"
+
+#define IVHD_SPECIAL_IOAPIC		1
+
+struct ivrs_quirk_entry {
+	u8 id;
+	u16 devid;
+};
+
+enum {
+	DELL_INSPIRON_7375 = 0,
+	DELL_LATITUDE_5495,
+	LENOVO_IDEAPAD_330S_15ARR,
+};
+
+static const struct ivrs_quirk_entry ivrs_ioapic_quirks[][3] __initconst = {
+	/* ivrs_ioapic[4]=00:14.0 ivrs_ioapic[5]=00:00.2 */
+	[DELL_INSPIRON_7375] = {
+		{ .id = 4, .devid = 0xa0 },
+		{ .id = 5, .devid = 0x2 },
+		{}
+	},
+	/* ivrs_ioapic[4]=00:14.0 */
+	[DELL_LATITUDE_5495] = {
+		{ .id = 4, .devid = 0xa0 },
+		{}
+	},
+	/* ivrs_ioapic[32]=00:14.0 */
+	[LENOVO_IDEAPAD_330S_15ARR] = {
+		{ .id = 32, .devid = 0xa0 },
+		{}
+	},
+	{}
+};
+
+static int __init ivrs_ioapic_quirk_cb(const struct dmi_system_id *d)
+{
+	const struct ivrs_quirk_entry *i;
+
+	for (i = d->driver_data; i->id != 0 && i->devid != 0; i++)
+		add_special_device(IVHD_SPECIAL_IOAPIC, i->id, (u16 *)&i->devid, 0);
+
+	return 0;
+}
+
+static const struct dmi_system_id ivrs_quirks[] __initconst = {
+	{
+		.callback = ivrs_ioapic_quirk_cb,
+		.ident = "Dell Inspiron 7375",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 7375"),
+		},
+		.driver_data = (void *)&ivrs_ioapic_quirks[DELL_INSPIRON_7375],
+	},
+	{
+		.callback = ivrs_ioapic_quirk_cb,
+		.ident = "Dell Latitude 5495",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude 5495"),
+		},
+		.driver_data = (void *)&ivrs_ioapic_quirks[DELL_LATITUDE_5495],
+	},
+	{
+		.callback = ivrs_ioapic_quirk_cb,
+		.ident = "Lenovo ideapad 330S-15ARR",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "81FB"),
+		},
+		.driver_data = (void *)&ivrs_ioapic_quirks[LENOVO_IDEAPAD_330S_15ARR],
+	},
+	{}
+};
+
+void __init amd_iommu_apply_ivrs_quirks(void)
+{
+	dmi_check_system(ivrs_quirks);
+}
+#endif
-- 
2.20.1



