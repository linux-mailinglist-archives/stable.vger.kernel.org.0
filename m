Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA8B2686DFA
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 19:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbjBASc3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 13:32:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231569AbjBASc0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 13:32:26 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D6E62BEF0;
        Wed,  1 Feb 2023 10:32:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675276345; x=1706812345;
  h=from:to:cc:subject:date:message-id:mime-version:reply-to:
   content-transfer-encoding;
  bh=UclNVWFvqIPe9hClgldAXJmUDe82JxeqnIRpO7uqdR0=;
  b=n83o5CEDJKnGoWCI6ttm9CV+a57Tb2wkjJzqqHqBgCfDdmnlJCjS1gIB
   E5nyIzE4vW0d2YrhsGc75EZl4J+D7JqSWdS/rGaPe9mFqju0w+gbBLsn1
   AvLtgnfzHqJLSqcsIpGdu8SoGZtK3esEH3Bw88FtralSqE2GgWzZ2pCP6
   ptzAARW9tHqU2EorQj7pUYHjWunhkMEFgvM+9qYYzxwEuscUt3t5VWZn9
   QV2Bq7Qucg6FrS2ntDUzHBld4F4/gmgW9z12dpcfSP42xLlMYnxCsoeok
   WxKtaLcP6/0z4oajIARlnYIwZzMAnbW2dQmV9aPVuDMGdTPtteH/ygS3q
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="390626521"
X-IronPort-AV: E=Sophos;i="5.97,265,1669104000"; 
   d="scan'208";a="390626521"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 10:32:21 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="697374361"
X-IronPort-AV: E=Sophos;i="5.97,265,1669104000"; 
   d="scan'208";a="697374361"
Received: from earamire-mobl1.amr.corp.intel.com (HELO lenb-desk1.amr.corp.intel.com) ([10.212.85.96])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 10:32:17 -0800
From:   Len Brown <len.brown@intel.com>
To:     rafael@kernel.org
Cc:     kvalo@codeaurora.org, linux-pm@vger.kernel.org,
        linux-wireless@vger.kernel.org, Len Brown <len.brown@intel.com>,
        Carl Huang <cjhuang@codeaurora.org>, stable@vger.kernel.org
Subject: [PATCH] ath11k: allow system suspend to survive ath11k
Date:   Wed,  1 Feb 2023 12:32:01 -0600
Message-Id: <20230201183201.14431-1-len.brown@intel.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When ath11k runs into internal errors upon suspend,
it returns an error code to pci_pm_suspend, which
aborts the entire system suspend.

The driver should not abort system suspend, but should
keep its internal errors to itself, and allow the system
to suspend.  Otherwise, a user can suspend a laptop
by closing the lid and sealing it into a case, assuming
that is will suspend, rather than heating up and draining
the battery when in transit.

In practice, the ath11k device seems to have plenty of transient
errors, and subsequent suspend cycles after this failure
often succeed.

https://bugzilla.kernel.org/show_bug.cgi?id=216968

Fixes: d1b0c33850d29 ("ath11k: implement suspend for QCA6390 PCI devices")

Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Carl Huang <cjhuang@codeaurora.org>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: stable@vger.kernel.org
---
 drivers/net/wireless/ath/ath11k/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/pci.c b/drivers/net/wireless/ath/ath11k/pci.c
index 99cf3357c66e..3c6005ab9a71 100644
--- a/drivers/net/wireless/ath/ath11k/pci.c
+++ b/drivers/net/wireless/ath/ath11k/pci.c
@@ -979,7 +979,7 @@ static __maybe_unused int ath11k_pci_pm_suspend(struct device *dev)
 	if (ret)
 		ath11k_warn(ab, "failed to suspend core: %d\n", ret);
 
-	return ret;
+	return 0;
 }
 
 static __maybe_unused int ath11k_pci_pm_resume(struct device *dev)
-- 
2.37.2

