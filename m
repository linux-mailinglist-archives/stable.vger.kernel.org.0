Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F36283A78
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgJEPec (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:34:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:35026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728284AbgJEPeZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:34:25 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25D0920637;
        Mon,  5 Oct 2020 15:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601912064;
        bh=18npA7w4VSeRmm9y4PfQ1qhhwA/Ks81gsuc8dhfFd/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n8Ts3D7ajZNymX9IoJy9k7nByjWNMdXjeEEB/l/QzNF4s7K3BeT4bn98sbls3abKx
         c82b8LHaD4on1MetBHyeNv7sC1mfYgLMJx8FrMw44vnwRFBw4UGz91G31/UZrDxqkT
         OAihRFjNy4r3z/huWhVfKiIrbs3KrI8Kyz8epBmc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Huang <ahuang12@lenovo.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>, Baoquan He <bhe@redhat.com>
Subject: [PATCH 5.8 75/85] iommu/amd: Fix the overwritten field in IVMD header
Date:   Mon,  5 Oct 2020 17:27:11 +0200
Message-Id: <20201005142118.339603182@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Huang <ahuang12@lenovo.com>

[ Upstream commit 0bbe4ced53e36786eafc2ecbf9a1761f55b4a82e ]

Commit 387caf0b759a ("iommu/amd: Treat per-device exclusion
ranges as r/w unity-mapped regions") accidentally overwrites
the 'flags' field in IVMD (struct ivmd_header) when the I/O
virtualization memory definition is associated with the
exclusion range entry. This leads to the corrupted IVMD table
(incorrect checksum). The kdump kernel reports the invalid checksum:

ACPI BIOS Warning (bug): Incorrect checksum in table [IVRS] - 0x5C, should be 0x60 (20200717/tbprint-177)
AMD-Vi: [Firmware Bug]: IVRS invalid checksum

Fix the above-mentioned issue by modifying the 'struct unity_map_entry'
member instead of the IVMD header.

Cleanup: The *exclusion_range* functions are not used anymore, so
get rid of them.

Fixes: 387caf0b759a ("iommu/amd: Treat per-device exclusion ranges as r/w unity-mapped regions")
Reported-and-tested-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Adrian Huang <ahuang12@lenovo.com>
Cc: Jerry Snitselaar <jsnitsel@redhat.com>
Link: https://lore.kernel.org/r/20200926102602.19177-1-adrianhuang0701@gmail.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/init.c | 56 +++++++---------------------------------
 1 file changed, 10 insertions(+), 46 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index bf45f8e2c7edd..016e35d3d6c86 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -1110,25 +1110,6 @@ static int __init add_early_maps(void)
 	return 0;
 }
 
-/*
- * Reads the device exclusion range from ACPI and initializes the IOMMU with
- * it
- */
-static void __init set_device_exclusion_range(u16 devid, struct ivmd_header *m)
-{
-	if (!(m->flags & IVMD_FLAG_EXCL_RANGE))
-		return;
-
-	/*
-	 * Treat per-device exclusion ranges as r/w unity-mapped regions
-	 * since some buggy BIOSes might lead to the overwritten exclusion
-	 * range (exclusion_start and exclusion_length members). This
-	 * happens when there are multiple exclusion ranges (IVMD entries)
-	 * defined in ACPI table.
-	 */
-	m->flags = (IVMD_FLAG_IW | IVMD_FLAG_IR | IVMD_FLAG_UNITY_MAP);
-}
-
 /*
  * Takes a pointer to an AMD IOMMU entry in the ACPI table and
  * initializes the hardware and our data structures with it.
@@ -2080,30 +2061,6 @@ static void __init free_unity_maps(void)
 	}
 }
 
-/* called when we find an exclusion range definition in ACPI */
-static int __init init_exclusion_range(struct ivmd_header *m)
-{
-	int i;
-
-	switch (m->type) {
-	case ACPI_IVMD_TYPE:
-		set_device_exclusion_range(m->devid, m);
-		break;
-	case ACPI_IVMD_TYPE_ALL:
-		for (i = 0; i <= amd_iommu_last_bdf; ++i)
-			set_device_exclusion_range(i, m);
-		break;
-	case ACPI_IVMD_TYPE_RANGE:
-		for (i = m->devid; i <= m->aux; ++i)
-			set_device_exclusion_range(i, m);
-		break;
-	default:
-		break;
-	}
-
-	return 0;
-}
-
 /* called for unity map ACPI definition */
 static int __init init_unity_map_range(struct ivmd_header *m)
 {
@@ -2114,9 +2071,6 @@ static int __init init_unity_map_range(struct ivmd_header *m)
 	if (e == NULL)
 		return -ENOMEM;
 
-	if (m->flags & IVMD_FLAG_EXCL_RANGE)
-		init_exclusion_range(m);
-
 	switch (m->type) {
 	default:
 		kfree(e);
@@ -2140,6 +2094,16 @@ static int __init init_unity_map_range(struct ivmd_header *m)
 	e->address_end = e->address_start + PAGE_ALIGN(m->range_length);
 	e->prot = m->flags >> 1;
 
+	/*
+	 * Treat per-device exclusion ranges as r/w unity-mapped regions
+	 * since some buggy BIOSes might lead to the overwritten exclusion
+	 * range (exclusion_start and exclusion_length members). This
+	 * happens when there are multiple exclusion ranges (IVMD entries)
+	 * defined in ACPI table.
+	 */
+	if (m->flags & IVMD_FLAG_EXCL_RANGE)
+		e->prot = (IVMD_FLAG_IW | IVMD_FLAG_IR) >> 1;
+
 	DUMP_printk("%s devid_start: %02x:%02x.%x devid_end: %02x:%02x.%x"
 		    " range_start: %016llx range_end: %016llx flags: %x\n", s,
 		    PCI_BUS_NUM(e->devid_start), PCI_SLOT(e->devid_start),
-- 
2.25.1



