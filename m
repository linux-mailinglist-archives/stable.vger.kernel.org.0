Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5EED4CBB47
	for <lists+stable@lfdr.de>; Thu,  3 Mar 2022 11:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232326AbiCCK0Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Mar 2022 05:26:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232320AbiCCK0O (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Mar 2022 05:26:14 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 326DF179A11;
        Thu,  3 Mar 2022 02:25:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646303129; x=1677839129;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pGg06ebsLiDfXkPxKDe4uB84T4FY/Ti+rqN2epFlSGc=;
  b=nFcj5ISeGeaF3r1794ibstGcCewDpRinsJDo0lF5yrnOSjZNHPqejGGQ
   8RbbOkXXdokJGnAPBectHeCNK8iNvGlxuv0+HNxZWxir9pjp5P0mvSJ+9
   OmwV0o7FDkZ+FEEDX25E09dcaCGlpJPd88fyHiadRBWuK9PfXwHCc4TJt
   KThGyJdJZ1oBU5xtAVEHYoKs/jVk2c5tBTDNWp4qzr8JmLBIq7n8BDn9c
   yYvcdqz8J6UU8uRMxAfGERrMT+j51hnW72R9JxZFAH8aIlaqABcDWKzAs
   Rf1yiaXdk/2siSPQ0tR071kJ45XloAx1tGTHdWMdQ64TDy0Q+FYr+quAn
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="253567126"
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="253567126"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2022 02:25:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="535773314"
Received: from mattu-haswell.fi.intel.com ([10.237.72.199])
  by orsmga007.jf.intel.com with ESMTP; 03 Mar 2022 02:25:27 -0800
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Anssi Hannula <anssi.hannula@bitwise.fi>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 3/9] xhci: fix uninitialized string returned by xhci_decode_ctrl_ctx()
Date:   Thu,  3 Mar 2022 12:26:50 +0200
Message-Id: <20220303102656.1661407-4-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220303102656.1661407-1-mathias.nyman@linux.intel.com>
References: <20220303102656.1661407-1-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anssi Hannula <anssi.hannula@bitwise.fi>

xhci_decode_ctrl_ctx() returns the untouched buffer as-is if both "drop"
and "add" parameters are zero.

Fix the function to return an empty string in that case.

It was not immediately clear from the possible call chains whether this
issue is currently actually triggerable or not.

Note that before commit 4843b4b5ec64 ("xhci: fix even more unsafe memory
Cc: stable@vger.kernel.org
usage in xhci tracing") the result effect in the failure case was different
as a static buffer was used here, but the code still worked incorrectly.

Fixes: 90d6d5731da7 ("xhci: Add tracing for input control context")
Signed-off-by: Anssi Hannula <anssi.hannula@bitwise.fi>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 4843b4b5ec64 ("xhci: fix even more unsafe memory usage in xhci tracing")
---
 drivers/usb/host/xhci.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 1d83ddace482..473a33ce299e 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -2468,6 +2468,8 @@ static inline const char *xhci_decode_ctrl_ctx(char *str,
 	unsigned int	bit;
 	int		ret = 0;
 
+	str[0] = '\0';
+
 	if (drop) {
 		ret = sprintf(str, "Drop:");
 		for_each_set_bit(bit, &drop, 32)
-- 
2.25.1

