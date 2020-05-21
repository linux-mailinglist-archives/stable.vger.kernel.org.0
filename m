Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C38F71DDB52
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729434AbgEUXxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:53:55 -0400
Received: from mga14.intel.com ([192.55.52.115]:53196 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728635AbgEUXxz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 May 2020 19:53:55 -0400
IronPort-SDR: SS0OWioYMWTVz8H1awwrzsnKi79zjkyQJqY7al1eSz6sQUv4KFALCWPmHwBVs2b03ON+PC7kGf
 z9JcDdxilzCw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 16:53:55 -0700
IronPort-SDR: JMIYIhvwr2LzMHHuLeqgYccfVUvVqKlCgWp57Fou0WddADd/4N6lH/617OAvx9Dyb1hpoh6k98
 jfmSJgWJJVWg==
X-IronPort-AV: E=Sophos;i="5.73,419,1583222400"; 
   d="scan'208";a="467110968"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 16:53:54 -0700
Subject: [5.4-stable PATCH 0/7] libnvdimm: Cross-arch compatible namespace
 alignment
From:   Dan Williams <dan.j.williams@intel.com>
To:     stable@vger.kernel.org
Cc:     Oliver O'Halloran <oohall@gmail.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Christoph Hellwig <hch@lst.de>, Jeff Moyer <jmoyer@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        linux-nvdimm@lists.01.org
Date:   Thu, 21 May 2020 16:37:43 -0700
Message-ID: <159010426294.1062454.8853083370975871627.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello stable team,

These patches have been shipping in mainline since v5.7-rc1 with no
reported issues. They address long standing problems in libnvdimm's
handling of namespace provisioning relative to alignment constraints
including crashes trying to even load the driver on some PowerPC
configurations.

I did fold one build fix [1] into "libnvdimm/region: Introduce an 'align'
attribute" so as to not convey the bisection breakage to -stable.

Please consider them for v5.4-stable. They do pass the latest
version of the ndctl unit tests.

[1]: 04ff4863e126 libnvdimm/region: Fix build error


---

Original cover letter for the series:

Aneesh reports that PowerPC requires 16MiB alignment for the address
range passed to devm_memremap_pages(), and Jeff reports that it is
possible to create a misaligned namespace which blocks future namespace
creation in that region. Both of these issues require namespace
alignment to be managed at the region level rather than padding at the
namespace level which has been a broken approach to date.

Introduce memremap_compat_align() to indicate the hard requirements of
an arch's memremap_pages() implementation. Use the maximum known
memremap_compat_align() to set the default namespace alignment for
libnvdimm. Consult that alignment when allocating free space. Finally,
allow the default region alignment to be overridden to maintain the same
namespace creation capability as previous kernels (modulo dax operation
not being supported with a non-zero start_pad).

---

Aneesh Kumar K.V (1):
      libnvdimm/pfn_dev: Don't clear device memmap area during generic namespace probe

Dan Williams (6):
      mm/memremap_pages: Kill unused __devm_memremap_pages()
      mm/memremap_pages: Introduce memremap_compat_align()
      libnvdimm/pfn: Prevent raw mode fallback if pfn-infoblock valid
      libnvdimm/namespace: Enforce memremap_compat_align()
      libnvdimm/region: Introduce NDD_LABELING
      libnvdimm/region: Introduce an 'align' attribute


 arch/powerpc/Kconfig                      |    1 
 arch/powerpc/mm/ioremap.c                 |   21 +++++
 arch/powerpc/platforms/pseries/papr_scm.c |    2 
 drivers/acpi/nfit/core.c                  |    4 +
 drivers/nvdimm/dimm.c                     |    2 
 drivers/nvdimm/dimm_devs.c                |   95 +++++++++++++++++----
 drivers/nvdimm/namespace_devs.c           |   28 ++++++
 drivers/nvdimm/nd.h                       |    3 -
 drivers/nvdimm/pfn.h                      |   12 +++
 drivers/nvdimm/pfn_devs.c                 |   48 +++++++++--
 drivers/nvdimm/region_devs.c              |  130 ++++++++++++++++++++++++++---
 include/linux/io.h                        |    2 
 include/linux/libnvdimm.h                 |    2 
 include/linux/memremap.h                  |    8 ++
 include/linux/mmzone.h                    |    1 
 lib/Kconfig                               |    3 +
 mm/memremap.c                             |   23 +++++
 17 files changed, 335 insertions(+), 50 deletions(-)

base-commit: 1cdaf895c99d319c0007d0b62818cf85fc4b087f
