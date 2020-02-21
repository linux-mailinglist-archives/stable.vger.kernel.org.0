Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 185071675FE
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730511AbgBUIcc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:32:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:47974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732797AbgBUIMQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:12:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0BF620722;
        Fri, 21 Feb 2020 08:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272735;
        bh=PCRHLSZbmJqJViTJ0dB1E8Xa4H57b8wOz/Mff5gZdes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YgJOhrcROnHoyABSAtFQsNAwhp3zn4wV3v0GebXOmuS4sC60auGgYcob3VgCbBdY4
         6zotinC2jVmAAaj6lV+2ftEVZl187/uvEHDxvojmSwIPIh9m5xgBufnEj0F7WpzO7m
         zVpWJ+KClb1JiBj+JIMz8WLgffAH/UyNIUeRBaH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pankaj Bansal <pankaj.bansal@nxp.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Will Deacon <will@kernel.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 254/344] ACPI/IORT: Fix Number of IDs handling in iort_id_map()
Date:   Fri, 21 Feb 2020 08:40:53 +0100
Message-Id: <20200221072412.606392874@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hanjun Guo <guohanjun@huawei.com>

[ Upstream commit 3c23b83a88d00383e1d498cfa515249aa2fe0238 ]

The IORT specification [0] (Section 3, table 4, page 9) defines the
'Number of IDs' as 'The number of IDs in the range minus one'.

However, the IORT ID mapping function iort_id_map() treats the 'Number
of IDs' field as if it were the full IDs mapping count, with the
following check in place to detect out of boundary input IDs:

InputID >= Input base + Number of IDs

This check is flawed in that it considers the 'Number of IDs' field as
the full number of IDs mapping and disregards the 'minus one' from
the IDs count.

The correct check in iort_id_map() should be implemented as:

InputID > Input base + Number of IDs

this implements the specification correctly but unfortunately it breaks
existing firmwares that erroneously set the 'Number of IDs' as the full
IDs mapping count rather than IDs mapping count minus one.

e.g.

PCI hostbridge mapping entry 1:
Input base:  0x1000
ID Count:    0x100
Output base: 0x1000
Output reference: 0xC4  //ITS reference

PCI hostbridge mapping entry 2:
Input base:  0x1100
ID Count:    0x100
Output base: 0x2000
Output reference: 0xD4  //ITS reference

Two mapping entries which the second entry's Input base = the first
entry's Input base + ID count, so for InputID 0x1100 and with the
correct InputID check in place in iort_id_map() the kernel would map
the InputID to ITS 0xC4 not 0xD4 as it would be expected.

Therefore, to keep supporting existing flawed firmwares, introduce a
workaround that instructs the kernel to use the old InputID range check
logic in iort_id_map(), so that we can support both firmwares written
with the flawed 'Number of IDs' logic and the correct one as defined in
the specifications.

[0]: http://infocenter.arm.com/help/topic/com.arm.doc.den0049d/DEN0049D_IO_Remapping_Table.pdf

Reported-by: Pankaj Bansal <pankaj.bansal@nxp.com>
Link: https://lore.kernel.org/linux-acpi/20191215203303.29811-1-pankaj.bansal@nxp.com/
Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Pankaj Bansal <pankaj.bansal@nxp.com>
Cc: Will Deacon <will@kernel.org>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/arm64/iort.c | 57 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 55 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/arm64/iort.c b/drivers/acpi/arm64/iort.c
index 5a7551d060f25..161b609e4cdfb 100644
--- a/drivers/acpi/arm64/iort.c
+++ b/drivers/acpi/arm64/iort.c
@@ -298,6 +298,59 @@ out:
 	return status;
 }
 
+struct iort_workaround_oem_info {
+	char oem_id[ACPI_OEM_ID_SIZE + 1];
+	char oem_table_id[ACPI_OEM_TABLE_ID_SIZE + 1];
+	u32 oem_revision;
+};
+
+static bool apply_id_count_workaround;
+
+static struct iort_workaround_oem_info wa_info[] __initdata = {
+	{
+		.oem_id		= "HISI  ",
+		.oem_table_id	= "HIP07   ",
+		.oem_revision	= 0,
+	}, {
+		.oem_id		= "HISI  ",
+		.oem_table_id	= "HIP08   ",
+		.oem_revision	= 0,
+	}
+};
+
+static void __init
+iort_check_id_count_workaround(struct acpi_table_header *tbl)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(wa_info); i++) {
+		if (!memcmp(wa_info[i].oem_id, tbl->oem_id, ACPI_OEM_ID_SIZE) &&
+		    !memcmp(wa_info[i].oem_table_id, tbl->oem_table_id, ACPI_OEM_TABLE_ID_SIZE) &&
+		    wa_info[i].oem_revision == tbl->oem_revision) {
+			apply_id_count_workaround = true;
+			pr_warn(FW_BUG "ID count for ID mapping entry is wrong, applying workaround\n");
+			break;
+		}
+	}
+}
+
+static inline u32 iort_get_map_max(struct acpi_iort_id_mapping *map)
+{
+	u32 map_max = map->input_base + map->id_count;
+
+	/*
+	 * The IORT specification revision D (Section 3, table 4, page 9) says
+	 * Number of IDs = The number of IDs in the range minus one, but the
+	 * IORT code ignored the "minus one", and some firmware did that too,
+	 * so apply a workaround here to keep compatible with both the spec
+	 * compliant and non-spec compliant firmwares.
+	 */
+	if (apply_id_count_workaround)
+		map_max--;
+
+	return map_max;
+}
+
 static int iort_id_map(struct acpi_iort_id_mapping *map, u8 type, u32 rid_in,
 		       u32 *rid_out)
 {
@@ -314,8 +367,7 @@ static int iort_id_map(struct acpi_iort_id_mapping *map, u8 type, u32 rid_in,
 		return -ENXIO;
 	}
 
-	if (rid_in < map->input_base ||
-	    (rid_in >= map->input_base + map->id_count))
+	if (rid_in < map->input_base || rid_in > iort_get_map_max(map))
 		return -ENXIO;
 
 	*rid_out = map->output_base + (rid_in - map->input_base);
@@ -1637,5 +1689,6 @@ void __init acpi_iort_init(void)
 		return;
 	}
 
+	iort_check_id_count_workaround(iort_table);
 	iort_init_platform_devices();
 }
-- 
2.20.1



