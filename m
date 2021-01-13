Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D899B2F454B
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 08:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725774AbhAMHgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 02:36:01 -0500
Received: from mga07.intel.com ([134.134.136.100]:20971 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725773AbhAMHgB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Jan 2021 02:36:01 -0500
IronPort-SDR: TNdWSHV2JbGEdHO1NabWomeULgWmrj243HsvUzor6nAxO2q7Ek/0gq0TKfWQQAeEZq9xFvUJR7
 nwW+26exSAJw==
X-IronPort-AV: E=McAfee;i="6000,8403,9862"; a="242238101"
X-IronPort-AV: E=Sophos;i="5.79,343,1602572400"; 
   d="scan'208";a="242238101"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2021 23:35:19 -0800
IronPort-SDR: R7U7SOlxIAask0dFOPSZ+iv/4TSvK3885rmAPXftCa0I6o/KodFyfMs5MpYz6914ji5DT++mEY
 igedmqs3aGCA==
X-IronPort-AV: E=Sophos;i="5.79,343,1602572400"; 
   d="scan'208";a="400456436"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2021 23:35:15 -0800
Subject: [PATCH v3 0/6] mm: Fix pfn_to_online_page() with respect to
 ZONE_DEVICE
From:   Dan Williams <dan.j.williams@intel.com>
To:     linux-mm@kvack.org
Cc:     David Hildenbrand <david@redhat.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Ira Weiny <ira.weiny@intel.com>, stable@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>,
        Qian Cai <cai@lca.pw>, Michal Hocko <mhocko@kernel.org>,
        Oscar Salvador <osalvador@suse.de>,
        Michal Hocko <mhocko@suse.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
Date:   Tue, 12 Jan 2021 23:35:15 -0800
Message-ID: <161052331545.1805594.2356512831689786960.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Changes since v2 [1]:
- Collect some reviewed-by's from David and Oscar

- Rework subsection validity to include pfn_valid() gated by
  CONFIG_HAVE_ARCH_PFN_VALID (David, Oscar)

- Introduce pgmap_pfn_valid() to validate metadata vs data in a pgmap (David)

! Kill put_ref_page(): the extra "if (ref_page) put_page(ref_page)" still
  feels more cluttered than adding a tiny helper. (Oscar)

[1]: http://lore.kernel.org/r/161044407603.1482714.16630477578392768273.stgit@dwillia2-desk3.amr.corp.intel.com

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

2/ The libnvdimm sysfs attribute visibility code was failing to publish
   the resource base for memmap=ss!nn defined namespaces. This is needed
   for the regression test for soft_offline_page().

3/ memory_failure() uses get_dev_pagemap() to lookup ZONE_DEVICE pages,
   however that mapping may contain data pages and metadata raw pfns.
   Introduce pgmap_pfn_valid() to delineate the 2 types and fail the
   handling of raw metadata pfns.

---

Dan Williams (6):
      mm: Move pfn_to_online_page() out of line
      mm: Teach pfn_to_online_page() to consider subsection validity
      mm: Teach pfn_to_online_page() about ZONE_DEVICE section collisions
      mm: Fix page reference leak in soft_offline_page()
      mm: Fix memory_failure() handling of dax-namespace metadata
      libnvdimm/namespace: Fix visibility of namespace resource attribute


 drivers/nvdimm/namespace_devs.c |   10 +++---
 include/linux/memory_hotplug.h  |   17 +--------
 include/linux/memremap.h        |    6 +++
 include/linux/mmzone.h          |   22 ++++++++----
 mm/memory-failure.c             |   26 ++++++++++++--
 mm/memory_hotplug.c             |   70 +++++++++++++++++++++++++++++++++++++++
 mm/memremap.c                   |   15 ++++++++
 7 files changed, 134 insertions(+), 32 deletions(-)
