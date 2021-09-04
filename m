Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFB1840094B
	for <lists+stable@lfdr.de>; Sat,  4 Sep 2021 04:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236244AbhIDCVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 22:21:47 -0400
Received: from mga18.intel.com ([134.134.136.126]:21537 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231389AbhIDCVr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Sep 2021 22:21:47 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10096"; a="206678291"
X-IronPort-AV: E=Sophos;i="5.85,267,1624345200"; 
   d="scan'208";a="206678291"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2021 19:20:46 -0700
X-IronPort-AV: E=Sophos;i="5.85,267,1624345200"; 
   d="scan'208";a="500751317"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2021 19:20:45 -0700
Subject: [PATCH 2/6] cxl/pci: Fix lockdown level
From:   Dan Williams <dan.j.williams@intel.com>
To:     linux-cxl@vger.kernel.org
Cc:     Ben Widawsky <ben.widawsky@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        stable@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>,
        Paul Moore <paul@paul-moore.com>, alison.schofield@intel.com,
        ben.widawsky@intel.com, Jonathan.Cameron@huawei.com
Date:   Fri, 03 Sep 2021 19:20:45 -0700
Message-ID: <163072204525.2250120.16615792476976546735.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <163072203373.2250120.8373702699578427249.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <163072203373.2250120.8373702699578427249.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A proposed rework of security_locked_down() users identified that the
cxl_pci driver was passing the wrong lockdown_reason. Update
cxl_mem_raw_command_allowed() to fail raw command access when raw pci
access is also disabled.

Fixes: 13237183c735 ("cxl/mem: Add a "RAW" send command")
Cc: Ben Widawsky <ben.widawsky@intel.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: <stable@vger.kernel.org>
Cc: Ondrej Mosnacek <omosnace@redhat.com>
Cc: Paul Moore <paul@paul-moore.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index 651e8d4ec974..37903259ee79 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -575,7 +575,7 @@ static bool cxl_mem_raw_command_allowed(u16 opcode)
 	if (!IS_ENABLED(CONFIG_CXL_MEM_RAW_COMMANDS))
 		return false;
 
-	if (security_locked_down(LOCKDOWN_NONE))
+	if (security_locked_down(LOCKDOWN_PCI_ACCESS))
 		return false;
 
 	if (cxl_raw_allow_all)

