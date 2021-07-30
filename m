Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4BA93DBD3F
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 18:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhG3QqF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 12:46:05 -0400
Received: from mga05.intel.com ([192.55.52.43]:61645 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229773AbhG3QqE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Jul 2021 12:46:04 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10061"; a="298717470"
X-IronPort-AV: E=Sophos;i="5.84,282,1620716400"; 
   d="scan'208";a="298717470"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2021 09:45:59 -0700
X-IronPort-AV: E=Sophos;i="5.84,282,1620716400"; 
   d="scan'208";a="508283326"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2021 09:45:59 -0700
Subject: [PATCH] ACPI: NFIT: Fix support for virtual SPA ranges
From:   Dan Williams <dan.j.williams@intel.com>
To:     nvdimm@lists.linux.dev
Cc:     Jacek Zloch <jacek.zloch@intel.com>,
        Lukasz Sobieraj <lukasz.sobieraj@intel.com>,
        "Lee, Chun-Yi" <jlee@suse.com>, stable@vger.kernel.org,
        Krzysztof Rusocki <krzysztof.rusocki@intel.com>,
        Damian Bassa <damian.bassa@intel.com>, vishal.l.verma@intel.com
Date:   Fri, 30 Jul 2021 09:45:58 -0700
Message-ID: <162766355874.3223041.9582643895337437921.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix the NFIT parsing code to treat a 0 index in a SPA Range Structure as
a special case and not match Region Mapping Structures that use 0 to
indicate that they are not mapped. Without this fix some platform BIOS
descriptions of "virtual disk" ranges do not result in the pmem driver
attaching to the range.

Details:
In addition to typical persistent memory ranges, the ACPI NFIT may also
convey "virtual" ranges. These ranges are indicated by a UUID in the SPA
Range Structure of UUID_VOLATILE_VIRTUAL_DISK, UUID_VOLATILE_VIRTUAL_CD,
UUID_PERSISTENT_VIRTUAL_DISK, or UUID_PERSISTENT_VIRTUAL_CD. The
critical difference between virtual ranges and UUID_PERSISTENT_MEMORY, is
that virtual do not support associations with Region Mapping Structures.
For this reason the "index" value of virtual SPA Range Structures is
allowed to be 0. If a platform BIOS decides to represent unmapped
NVDIMMs with a 0 index in their "SPA Range Structure Index" the driver
falsely matches them and may falsely require labels where "virtual
disks" are expected to be label-less. I.e. label-less is where the
namespace-range == region-range and the pmem driver attaches with no
user action to create a namespace.

Cc: Jacek Zloch <jacek.zloch@intel.com>
Cc: Lukasz Sobieraj <lukasz.sobieraj@intel.com>
Cc: "Lee, Chun-Yi" <jlee@suse.com>
Cc: <stable@vger.kernel.org>
Fixes: c2f32acdf848 ("acpi, nfit: treat virtual ramdisk SPA as pmem region")
Reported-by: Krzysztof Rusocki <krzysztof.rusocki@intel.com>
Reported-by: Damian Bassa <damian.bassa@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 23d9a09d7060..6f15e56ef955 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -3021,6 +3021,8 @@ static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 		struct acpi_nfit_memory_map *memdev = nfit_memdev->memdev;
 		struct nd_mapping_desc *mapping;
 
+		if (memdev->range_index == 0 || spa->range_index == 0)
+			continue;
 		if (memdev->range_index != spa->range_index)
 			continue;
 		if (count >= ND_MAX_MAPPINGS) {

