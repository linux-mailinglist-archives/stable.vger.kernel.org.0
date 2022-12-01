Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22FA463FA42
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 23:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiLAWDq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 17:03:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbiLAWD2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 17:03:28 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AACBEBC582;
        Thu,  1 Dec 2022 14:03:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669932205; x=1701468205;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=G87j60lcFOm0XsAJRAjlLp3GM7+SMlxSvtRmCcnF0xk=;
  b=RwF2EIAqmzuYcQW8ZCW0467v8A+629B4bTcIFa7y3oBjzN7L7OECfH2Y
   AZ34g7iszzec+L1D+IoLkHAN9DHgaVoc9NE6JSW91dfWJJlqtUtxJup11
   ifpnQVDw3TqwEU15bGvXyE55NfOPXfORDsF6qd1j48P/pJQt7ta86aykc
   zOLP7/G0fmzi1KamOsaUmukmwwzsRhGUM4HsRSksfUY1H/i+iMSzRSvXJ
   xDy5GCMQuIgJWskaKvUP5FcRielM+FMP19q+9JG1oEL1m/v3hUJYC5F3T
   eWH0tXuHV49h+4bZC/EIhyWDNFVOcPs1tRSuMZLio1GIkqSb1tIqgZZE3
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="295503656"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="295503656"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 14:03:25 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="638545015"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="638545015"
Received: from navarrof-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.177.235])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 14:03:24 -0800
Subject: [PATCH 2/5] cxl/region: Fix missing probe failure
From:   Dan Williams <dan.j.williams@intel.com>
To:     linux-cxl@vger.kernel.org
Cc:     stable@vger.kernel.org, Jonathan.Cameron@huawei.com,
        dave.jiang@intel.com, nvdimm@lists.linux.dev, dave@stgolabs.net
Date:   Thu, 01 Dec 2022 14:03:24 -0800
Message-ID: <166993220462.1995348.1698008475198427361.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166993219354.1995348.12912519920112533797.stgit@dwillia2-xfh.jf.intel.com>
References: <166993219354.1995348.12912519920112533797.stgit@dwillia2-xfh.jf.intel.com>
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

cxl_region_probe() allows for regions not in the 'commit' state to be
enabled. Fail probe when the region is not committed otherwise the
kernel may indicate that an address range is active when none of the
decoders are active.

Fixes: 8d48817df6ac ("cxl/region: Add region driver boiler plate")
Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/region.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index f9ae5ad284ff..1bc2ebefa2a5 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -1923,6 +1923,9 @@ static int cxl_region_probe(struct device *dev)
 	 */
 	up_read(&cxl_region_rwsem);
 
+	if (rc)
+		return rc;
+
 	switch (cxlr->mode) {
 	case CXL_DECODER_PMEM:
 		return devm_cxl_add_pmem_region(cxlr);

