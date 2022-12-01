Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9D763FA43
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 23:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbiLAWDq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 17:03:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiLAWDQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 17:03:16 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55CA8A9584;
        Thu,  1 Dec 2022 14:03:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669932195; x=1701468195;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0vOMv3xZrUGSG8yx8x5xFZRScujGgHolIBh7HmRNCKw=;
  b=Zjzdyeg3RfXgkjV4vgezsVWc9P21m+tpoXxY7y9FrgqotUCuVFvY0Z7U
   ex2gbZVi1y2y0NqUUpcTfUVa1oUqFaLZKLIQGrgU3wkf/QE5y05rCzk0r
   YEkIZ+RXqRYloCJO2vVRjGX6TDxBrH81VFBZc0BNByrdnfnTzAagMkTzJ
   NWoaDYrxE3MJmfbFpvSBHBZ+QcY6uL6bbj4XYOehkMSKVZBOco2xefkV0
   nale68u2ehNbk2FAJoIUiyC8Sc3IoNmcCQg+3EeOe8oyITCd4pYSlbJEv
   qoAu40FMWFPFyIXU+tMudVYp3R3ZBvioeRr27jyk/E+5Bkg4dO/01i5tb
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="295503631"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="295503631"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 14:03:14 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="638544952"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="638544952"
Received: from navarrof-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.177.235])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 14:03:13 -0800
Subject: [PATCH 0/5] cxl, nvdimm: Move CPU cache management to region drivers
From:   Dan Williams <dan.j.williams@intel.com>
To:     linux-cxl@vger.kernel.org
Cc:     Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Dave Jiang <dave.jiang@intel.com>, stable@vger.kernel.org,
        Jonathan.Cameron@huawei.com, dave.jiang@intel.com,
        nvdimm@lists.linux.dev, dave@stgolabs.net
Date:   Thu, 01 Dec 2022 14:03:13 -0800
Message-ID: <166993219354.1995348.12912519920112533797.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is incremental to Dave's recent "[PATCH v7 00/20] Introduce
security commands for CXL pmem device" [1], starting after patch 17 [2].
I.e. I want to drop patch 18, 19, and 20 from that series and replace
them with these.  It was prompted by Davidlohr's concerns about
cxl_invalidate_memregion().

The insight is that now that cpu_cache_invalidate_memregion() has a
default implementation for all architectures, the cache management can
move from the intel-pmem-specific security operations to the generic
NVDIMM core. This relieves the new CXL security ops from needing to
open-code their own cache flushing.

Also prompted by Davidlohr's concerns is what do about cache flushing
for scenarios outside of the PMEM security operations. For that "[PATCH
5/5] cxl/region: Manage CPU caches relative to DPA invalidation events"
proposes to handle that management at region activation time. This does
mean that dynamic CXL region provisioning is limited to environments
where cpu_cache_has_invalidate_memregion() is true. A new
CONFIG_CXL_REGION_INVALIDATION_TEST is added to bypass that data
integrity enforcement.

Lastly this includes some fixups, one for the fact that
cxl_region_probe() was ignoring some errors, another to enforce that
PMEM security operations originate through LIBNVDIMM, and lastly a
cleanup to move a string formatting failure condition from runtime to
compile-time in cxl_nvdimm_alloc().

[1]: http://lore.kernel.org/r/166983606451.2734609.4050644229630259452.stgit@djiang5-desk3.ch.intel.com
[2]: https://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl.git/log/?h=for-6.2/cxl-security

---

Dan Williams (4):
      cxl/region: Fix missing probe failure
      cxl/pmem: Enforce keyctl ABI for PMEM security
      nvdimm/region: Move cache management to the region driver
      cxl/region: Manage CPU caches relative to DPA invalidation events

Dave Jiang (1):
      cxl: add dimm_id support for __nvdimm_create()


 drivers/acpi/nfit/intel.c    |   25 ---------------------
 drivers/cxl/Kconfig          |   18 +++++++++++++++
 drivers/cxl/core/mbox.c      |   10 +++++++++
 drivers/cxl/core/pmem.c      |    7 ++++++
 drivers/cxl/core/region.c    |   34 +++++++++++++++++++++++++++++
 drivers/cxl/cxl.h            |   11 +++++++++
 drivers/cxl/pmem.c           |    3 ++-
 drivers/cxl/security.c       |   14 ------------
 drivers/nvdimm/region.c      |   11 +++++++++
 drivers/nvdimm/region_devs.c |   49 +++++++++++++++++++++++++++++++++++++++++-
 drivers/nvdimm/security.c    |    6 +++++
 include/linux/libnvdimm.h    |    5 ++++
 12 files changed, 152 insertions(+), 41 deletions(-)

base-commit: 15a8348707ffd2a37516db9bede88cc0bb467e0b
