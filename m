Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 730B5499B25
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574655AbiAXVuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:50:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377401AbiAXVh2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:37:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53BD6C05A19B;
        Mon, 24 Jan 2022 12:23:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E50D161491;
        Mon, 24 Jan 2022 20:23:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA5B8C340E5;
        Mon, 24 Jan 2022 20:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055805;
        bh=3POvJJyTnUSsgYbLhRzcncXzFxDB1opYPXtwcY0P3l8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f+OcBSmXqdeCHCBvL1hgTYSFvJuxVYyr7lX+9BphnXaX94b5yLXX8Rgd1izDv8/sJ
         ptmiYkuS1WrHfBNnaCvJdi6F9cDjxX4lWYGLrz+lRZQk3MHJw6dLCXTkFLIfwUkZVm
         b2KnXdtW1NoAykqGjLtaQRDDRwZXp6uG8uEfpvV8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 272/846] iwlwifi: mvm: perform 6GHz passive scan after suspend
Date:   Mon, 24 Jan 2022 19:36:29 +0100
Message-Id: <20220124184110.314861809@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit f4745cbb17572209a7fa27a6796ed70e7ada860b ]

The 6GHz passive scan is performed only once every 50 minutes.
However, in case of suspend/resume, the regulatory information
is reset, so 6GHz channels may become disabled.
Fix it by performing a 6GHz passive scan within 60 seconds after
suspend/resume even if the 50 minutes timeout did not expire yet.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Fixes: e8fe3b41c3a3 ("iwlwifi: mvm: Add support for 6GHz passive scan")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20211219121514.6d5c043372cf.I251dd5618a3f0b8febbcca788eb861f1cd6039bc@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 21 ++++++++-----------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index d78e436fa8b53..d4d562779d0a2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -1924,22 +1924,19 @@ static void iwl_mvm_scan_6ghz_passive_scan(struct iwl_mvm *mvm,
 	}
 
 	/*
-	 * 6GHz passive scan is allowed while associated in a defined time
-	 * interval following HW reset or resume flow
+	 * 6GHz passive scan is allowed in a defined time interval following HW
+	 * reset or resume flow, or while not associated and a large interval
+	 * has passed since the last 6GHz passive scan.
 	 */
-	if (vif->bss_conf.assoc &&
+	if ((vif->bss_conf.assoc ||
+	     time_after(mvm->last_6ghz_passive_scan_jiffies +
+			(IWL_MVM_6GHZ_PASSIVE_SCAN_TIMEOUT * HZ), jiffies)) &&
 	    (time_before(mvm->last_reset_or_resume_time_jiffies +
 			 (IWL_MVM_6GHZ_PASSIVE_SCAN_ASSOC_TIMEOUT * HZ),
 			 jiffies))) {
-		IWL_DEBUG_SCAN(mvm, "6GHz passive scan: associated\n");
-		return;
-	}
-
-	/* No need for 6GHz passive scan if not enough time elapsed */
-	if (time_after(mvm->last_6ghz_passive_scan_jiffies +
-		       (IWL_MVM_6GHZ_PASSIVE_SCAN_TIMEOUT * HZ), jiffies)) {
-		IWL_DEBUG_SCAN(mvm,
-			       "6GHz passive scan: timeout did not expire\n");
+		IWL_DEBUG_SCAN(mvm, "6GHz passive scan: %s\n",
+			       vif->bss_conf.assoc ? "associated" :
+			       "timeout did not expire");
 		return;
 	}
 
-- 
2.34.1



