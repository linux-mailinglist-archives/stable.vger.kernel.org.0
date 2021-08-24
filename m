Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B90443F66EF
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239627AbhHXR2q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:28:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240105AbhHXR0p (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:26:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40D0F61B47;
        Tue, 24 Aug 2021 17:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824704;
        bh=k8LWtFNWTOBE9dh4NNpRe9OQfT5EPwhu5gmckkYV/FA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PZsl2kc6xF//ZlUXe0NNvfY7FRSJzl+8SYJdT0sulO2GVzlzN446eHG/deKXRfGux
         8oy43rKetQeBeqinMAaysE/so7TI+wMStamrOHLW5adwvso7lLUHJHpBTWXFZxOBK6
         MuRPLxHHFV5LZTwe5TFp0Ex7rpuAgqmUaQUdnk3zldF/k7IBOC5JGflpYsR1f2+nBT
         CwoO52gUxgxKqIF6Q41L2R20GvpwX23bxvW8rEPMPTvzGOFzplfZ5IZSxLIN8HqKqa
         l4pjkkoXQPtsD3ppK8ItYYiZbgdRVbxyRFgqc2fvwI+ZtSJM8ugeRiyaSkOYYZpCe+
         PndWbBsGG29kA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Jacek Zloch <jacek.zloch@intel.com>,
        Lukasz Sobieraj <lukasz.sobieraj@intel.com>,
        "Lee, Chun-Yi" <jlee@suse.com>,
        Krzysztof Rusocki <krzysztof.rusocki@intel.com>,
        Damian Bassa <damian.bassa@intel.com>,
        Jeff Moyer <jmoyer@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 05/64] ACPI: NFIT: Fix support for virtual SPA ranges
Date:   Tue, 24 Aug 2021 13:03:58 -0400
Message-Id: <20210824170457.710623-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170457.710623-1-sashal@kernel.org>
References: <20210824170457.710623-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.245-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.245-rc1
X-KernelTest-Deadline: 2021-08-26T17:04+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
 drivers/acpi/nfit/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 20fd197ef74c..bfa163e9d6c3 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -2454,6 +2454,9 @@ static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 		struct acpi_nfit_memory_map *memdev = nfit_memdev->memdev;
 		struct nd_mapping_desc *mapping;
 
+		/* range index 0 == unmapped in SPA or invalid-SPA */
+		if (memdev->range_index == 0 || spa->range_index == 0)
+			continue;
 		if (memdev->range_index != spa->range_index)
 			continue;
 		if (count >= ND_MAX_MAPPINGS) {
-- 
2.30.2

