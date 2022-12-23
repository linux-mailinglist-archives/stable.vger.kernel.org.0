Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A498654BF2
	for <lists+stable@lfdr.de>; Fri, 23 Dec 2022 05:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiLWEWO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 23:22:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiLWEWM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 23:22:12 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C34201B4;
        Thu, 22 Dec 2022 20:22:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671769332; x=1703305332;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TGsft6eGoWyuHs8y1eP8FVvpAbbkc9Q7zlt+87+msuw=;
  b=mpI6zDva3jBnwMW40ZKC2k811RkJ7KFtkTW3f3PcwOUKtYn+VxKqMOUs
   DYu33YBwDw+wQ1W7hTbykEeTpkvMhQcWYiADZd0rgzDGFXepguTlQjVzH
   qMh32SaILNUpv8/rpEgKZPTgNxS5Jvtu2ccVKgyNvWZLkav0qnUR2qLml
   7hvlFvM7k/vl/WmgVdZx5gMgsr/Uz4wZnvA99dgve21cUeabEOEDIkRJT
   9bQfc0IRFPsnNw8ndlAU6Wfx6oUwSdLqymwlB6B/Vkf1bWm0ptmh/VzEl
   mIWNDxm7BgH3IJBFrTod32qC95EHme4t3YncW8xgOB6UhSFq8K7LrtQP3
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10569"; a="303743151"
X-IronPort-AV: E=Sophos;i="5.96,267,1665471600"; 
   d="scan'208";a="303743151"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2022 20:22:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10569"; a="794355987"
X-IronPort-AV: E=Sophos;i="5.96,267,1665471600"; 
   d="scan'208";a="794355987"
Received: from uhpatel-desk4.jf.intel.com ([10.23.15.157])
  by fmsmga001.fm.intel.com with ESMTP; 22 Dec 2022 20:22:10 -0800
From:   Utkarsh Patel <utkarsh.h.patel@intel.com>
To:     mika.westerberg@linux.intel.com, michael.jamet@intel.com,
        andreas.noever@gmail.com, YehezkelShB@gmail.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Cc:     rajmohan.mani@intel.com, Utkarsh Patel <utkarsh.h.patel@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] thunderbolt: Do not report errors if on-board retimers are found
Date:   Thu, 22 Dec 2022 20:22:46 -0800
Message-Id: <20221223042246.3355450-1-utkarsh.h.patel@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

tb_retimer_scan() returns error even when on-board retimers are found.

Fixes: 1e56c88adecc ("thunderbolt: Runtime resume USB4 port when retimers are scanned")
Cc: stable@vger.kernel.org
Signed-off-by: Utkarsh Patel <utkarsh.h.patel@intel.com>
---
Changes in V2:
1. Removed extra line between the Fixes tag and signed-off.
2. Added the tag for stable tree.
---

 drivers/thunderbolt/retimer.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/thunderbolt/retimer.c b/drivers/thunderbolt/retimer.c
index 81252e31014a..6ebe7a2886ec 100644
--- a/drivers/thunderbolt/retimer.c
+++ b/drivers/thunderbolt/retimer.c
@@ -471,10 +471,9 @@ int tb_retimer_scan(struct tb_port *port, bool add)
 			break;
 	}
 
-	if (!last_idx) {
-		ret = 0;
+	ret = 0;
+	if (!last_idx)
 		goto out;
-	}
 
 	/* Add on-board retimers if they do not exist already */
 	for (i = 1; i <= last_idx; i++) {
-- 
2.25.1

