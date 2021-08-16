Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0113ED60C
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237309AbhHPNQf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:16:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:39178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240277AbhHPNPD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:15:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67447632DC;
        Mon, 16 Aug 2021 13:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119528;
        bh=qgDWIwZb8QP5dz6TuZUfkfjVg0xnYx9m25+qSSJBEQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0aCWuwv5gE7tCCvawQqKRae5/qULzLVBs/KtmoLlcBnk/ZyofXqgJWNM8hmAqHhHU
         4siRsIfyp+zsuBVG1MmHrcMLGZGKrJL6mAMst0waoj2SFvqORmbGqnIFSYP5NTEb0+
         w/2+c5218sUgFph+VXd+jRNUwJte9a5RVX8+405k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacek Zloch <jacek.zloch@intel.com>,
        Lukasz Sobieraj <lukasz.sobieraj@intel.com>,
        "Lee, Chun-Yi" <jlee@suse.com>,
        Krzysztof Rusocki <krzysztof.rusocki@intel.com>,
        Damian Bassa <damian.bassa@intel.com>,
        Jeff Moyer <jmoyer@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 5.13 028/151] ACPI: NFIT: Fix support for virtual SPA ranges
Date:   Mon, 16 Aug 2021 15:00:58 +0200
Message-Id: <20210816125445.003580090@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

commit b93dfa6bda4d4e88e5386490f2b277a26958f9d3 upstream.

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
critical difference between virtual ranges and UUID_PERSISTENT_MEMORY,
is that virtual do not support associations with Region Mapping
Structures.  For this reason the "index" value of virtual SPA Range
Structures is allowed to be 0. If a platform BIOS decides to represent
NVDIMMs with disconnected "Region Mapping Structures" (range-index ==
0), the kernel may falsely associate them with standalone ranges where
the "SPA Range Structure Index" is also zero. When this happens the
driver may falsely require labels where "virtual disks" are expected to
be label-less. I.e. "label-less" is where the namespace-range ==
region-range and the pmem driver attaches with no user action to create
a namespace.

Cc: Jacek Zloch <jacek.zloch@intel.com>
Cc: Lukasz Sobieraj <lukasz.sobieraj@intel.com>
Cc: "Lee, Chun-Yi" <jlee@suse.com>
Cc: <stable@vger.kernel.org>
Fixes: c2f32acdf848 ("acpi, nfit: treat virtual ramdisk SPA as pmem region")
Reported-by: Krzysztof Rusocki <krzysztof.rusocki@intel.com>
Reported-by: Damian Bassa <damian.bassa@intel.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Link: https://lore.kernel.org/r/162870796589.2521182.1240403310175570220.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/nfit/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -3021,6 +3021,9 @@ static int acpi_nfit_register_region(str
 		struct acpi_nfit_memory_map *memdev = nfit_memdev->memdev;
 		struct nd_mapping_desc *mapping;
 
+		/* range index 0 == unmapped in SPA or invalid-SPA */
+		if (memdev->range_index == 0 || spa->range_index == 0)
+			continue;
 		if (memdev->range_index != spa->range_index)
 			continue;
 		if (count >= ND_MAX_MAPPINGS) {


