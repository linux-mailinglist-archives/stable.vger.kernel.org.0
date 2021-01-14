Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDC492F55FF
	for <lists+stable@lfdr.de>; Thu, 14 Jan 2021 02:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbhANA6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 19:58:18 -0500
Received: from mga17.intel.com ([192.55.52.151]:7769 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726996AbhANA5H (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Jan 2021 19:57:07 -0500
IronPort-SDR: yuqzCodrUONpkeA0J2IogJHSfr3RIlzyqCsak7G6INk/dufrLXfyubBtpjaGEfGbqsw3gYLBFM
 WZCB9SYHafhA==
X-IronPort-AV: E=McAfee;i="6000,8403,9863"; a="158064366"
X-IronPort-AV: E=Sophos;i="5.79,345,1602572400"; 
   d="scan'208";a="158064366"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2021 16:43:11 -0800
IronPort-SDR: wzoTb6hc9d6sqSJukVWSRq9IMAjmL767ApWlY5EtFShw7qgNK9ZWF4BfFWxVMzbhr+x2kbIecu
 b0GJ+8ILSuOg==
X-IronPort-AV: E=Sophos;i="5.79,345,1602572400"; 
   d="scan'208";a="465080679"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2021 16:43:10 -0800
Subject: [PATCH v4 0/5] mm: Fix pfn_to_online_page() with respect to
 ZONE_DEVICE
From:   Dan Williams <dan.j.williams@intel.com>
To:     akpm@linux-foundation.org
Cc:     David Hildenbrand <david@redhat.com>, stable@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>,
        Qian Cai <cai@lca.pw>, Michal Hocko <mhocko@kernel.org>,
        Oscar Salvador <osalvador@suse.de>,
        Michal Hocko <mhocko@suse.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>, linux-mm@kvack.org,
        linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
Date:   Wed, 13 Jan 2021 16:43:10 -0800
Message-ID: <161058499000.1840162.702316708443239771.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Changes since v3 [1]:
- Switch to "if (IS_ENABLED(CONFIG_HAVE_ARCH_PFN_VALID) &&
  !pfn_valid(pfn))" (David)
- Finish collecting reviewed-bys across all patches in the series
- Drop the libnvdimm fixup, to be merged through nvdimm.git not -mm

[1]: http://lore.kernel.org/r/161052331545.1805594.2356512831689786960.stgit@dwillia2-desk3.amr.corp.intel.com

---

Andrew,

All patches in this series have been reviewed and the kbuild-robot
reports a build-success over 172 configs. They pass an updated version
of the nvdimm unit tests to exercise corner cases of
pfn_to_online_page() and get_dev_pagemap() [2], and apply cleanly to
current -next.

Please apply, thanks.

[2]: http://lore.kernel.org/r/161052209289.1804207.11599120961607513911.stgit@dwillia2-desk3.amr.corp.intel.com

---

Michal reminds that the discussion about how to ensure pfn-walkers do
not get confused by ZONE_DEVICE pages never resolved. A pfn-walker that
uses pfn_to_online_page() may inadvertently translate a pfn as online
and in the page allocator, when it is offline managed by a ZONE_DEVICE
mapping (details in Patch 3: ("mm: Teach pfn_to_online_page() about
ZONE_DEVICE section collisions")).

The 2 proposals under consideration are teach pfn_to_online_page() to be
precise in the presence of mixed-zone sections, or teach the memory-add
code to drop the System RAM associated with ZONE_DEVICE collisions. In
order to not regress memory capacity by a few 10s to 100s of MiB the
approach taken in this set is to add precision to pfn_to_online_page().

In the course of validating pfn_to_online_page() a couple other fixes
fell out:

1/ soft_offline_page() fails to drop the reference taken in the
   madvise(..., MADV_SOFT_OFFLINE) case.

2/ memory_failure() uses get_dev_pagemap() to lookup ZONE_DEVICE pages,
   however that mapping may contain data pages and metadata raw pfns.
   Introduce pgmap_pfn_valid() to delineate the 2 types and fail the
   handling of raw metadata pfns.

---

Dan Williams (5):
      mm: Move pfn_to_online_page() out of line
      mm: Teach pfn_to_online_page() to consider subsection validity
      mm: Teach pfn_to_online_page() about ZONE_DEVICE section collisions
      mm: Fix page reference leak in soft_offline_page()
      mm: Fix memory_failure() handling of dax-namespace metadata


 include/linux/memory_hotplug.h |   17 +---------
 include/linux/memremap.h       |    6 +++
 include/linux/mmzone.h         |   22 +++++++++----
 mm/memory-failure.c            |   26 +++++++++++++--
 mm/memory_hotplug.c            |   69 ++++++++++++++++++++++++++++++++++++++++
 mm/memremap.c                  |   15 +++++++++
 6 files changed, 128 insertions(+), 27 deletions(-)
