Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 582CD618D30
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 01:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbiKDAaW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 20:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiKDAaV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 20:30:21 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE74511C29;
        Thu,  3 Nov 2022 17:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667521819; x=1699057819;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=31HIjmDubpir3KwQIxF1wIPC/ZlwVQf87LvCi9i0Nrs=;
  b=HBqETeRaPqDOpvQAacVGRGqXFxkAlrf12GL2uJpdODmh0Om9ISl3eyET
   avuCjA6iG3+ZHObI8nwpH3Wn+YwLz1YDGi3kCHMtINtYXZW41o3i/VlRE
   WB49KwjNsycDJ6+7+7IkJYVrGTq4UzpFslChSplISJbyZn2NG+8BO3e2T
   NlTyo7iH5UZ4itIUhRkkTw8+HnWpWYnWR+nLvVdfEhx8WodBCfmB7s3Ux
   h+mvbDWdGuh4XVzQcFNgjHcLAe7TAR7B9/KXdSPAMoGn3a1yYuN3JFB04
   1slPyqoPDvMbITVutxpGR8qWl1Uv/EDQiAtnBLDlB9HkrZpNscaQfIA/y
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="290230962"
X-IronPort-AV: E=Sophos;i="5.96,135,1665471600"; 
   d="scan'208";a="290230962"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2022 17:30:19 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="740421840"
X-IronPort-AV: E=Sophos;i="5.96,135,1665471600"; 
   d="scan'208";a="740421840"
Received: from arunvasu-mobl2.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.53.48])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2022 17:30:18 -0700
Subject: [PATCH 0/7] CXL region creation fixes for 6.1
From:   Dan Williams <dan.j.williams@intel.com>
To:     linux-cxl@vger.kernel.org
Cc:     Ben Widawsky <bwidawsk@kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        stable@vger.kernel.org, Bobo WL <lmw.bobo@gmail.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        vishal.l.verma@intel.com, alison.schofield@intel.com,
        ira.weiny@intel.com, dave.jiang@intel.com
Date:   Thu, 03 Nov 2022 17:30:17 -0700
Message-ID: <166752181697.947915.744835334283138352.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On the way to fixing and regression testing Jonathan's report of CXL
region creation failure on a single-port host bridge configuration [1],
several other fixes fell out. Details in the individual commits, but the
fixes mostly revolve around leaked references and other bugs in the
region creation failure case. All but the last fix are tagged for
-stable. The final fix is cosmetic, but leaving it unfixed gives the
appearance of another memory leak condition.

Lastly, the problematic configuration is added to cxl_test to allow for
regression testing it going forward.

[1]: http://lore.kernel.org/r/20221010172057.00001559@huawei.com

---

Dan Williams (7):
      cxl/region: Fix region HPA ordering validation
      cxl/region: Fix cxl_region leak, cleanup targets at region delete
      cxl/pmem: Fix cxl_pmem_region and cxl_memdev leak
      tools/testing/cxl: Fix some error exits
      tools/testing/cxl: Add a single-port host-bridge regression config
      cxl/region: Fix 'distance' calculation with passthrough ports
      cxl/region: Recycle region ids


 drivers/cxl/core/pmem.c      |    2 
 drivers/cxl/core/port.c      |   11 +-
 drivers/cxl/core/region.c    |   43 ++++++
 drivers/cxl/cxl.h            |    4 -
 drivers/cxl/pmem.c           |  100 +++++++++-----
 tools/testing/cxl/test/cxl.c |  301 +++++++++++++++++++++++++++++++++++++++---
 6 files changed, 400 insertions(+), 61 deletions(-)

base-commit: 4f1aa35f1fb7d51b125487c835982af792697ecb
